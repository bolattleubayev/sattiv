import 'dart:async';

import 'package:flutter/material.dart';

import '../services/database_service.dart';
import '../services/http_service.dart';

import '../model/entry.dart';
import '../model/treatment.dart';

final handler = DatabaseService();

class DBViewModel with ChangeNotifier {
  List<List<dynamic>> _backendData = [];
  List<List<dynamic>> get backendData => _backendData;

  List<Entry> _entries = [];
  List<Entry> get entries => _entries;

  List<Treatment> _treatments = [];
  List<Treatment> get treatments => _treatments;

  int _preferredDisplayInterval = 3;

  void updateDisplayInterval(int preferredDisplayInterval) {
    _preferredDisplayInterval = preferredDisplayInterval;
    getDataFromDB();
  }

  initDB() async {
    await handler.initDB();
  }

  refresher() async {
    Timer.periodic(const Duration(seconds: 295), (t) async {
      await getDataFromDB();
    });
  }

  getLastEntryFromAPI() async {
    Entry lastEntry = await getLastEntry();
    await handler.insertEntry(lastEntry);
  }

  getDataFromDB() async {
    await getLastEntryFromAPI();
    _entries = await handler.retrieveEntries(DateTime.now()
        .subtract(
          Duration(hours: _preferredDisplayInterval),
        )
        .toUtc()
        .millisecondsSinceEpoch);

    // TODO: think of what to do with treatments
    // probably leave like that as it is querying small amounts of data
    _treatments = await getTreatmentsFromApi(
      afterTime: DateTime.now().subtract(
        Duration(hours: _preferredDisplayInterval),
      ),
    );

    _backendData = [_entries, _treatments].cast<List>();
    notifyListeners();
  }
}
