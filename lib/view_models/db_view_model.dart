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

  bool _isMmolL = true;
  bool get isMmolL => _isMmolL;

  Entry _lastEntry = Entry.defaultValues();
  Entry get lastEntry => _lastEntry;

  void updateUserSettings(int preferredDisplayInterval, bool isMmolL) {
    _preferredDisplayInterval = preferredDisplayInterval;
    _isMmolL = isMmolL;
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

  postNewTreatment(Treatment treatment) async {
    await postTreatment(treatment);
    await getDataFromDB();
  }

  undoLastTreatmentInApi() async {
    await undoLastTreatment();
    await getDataFromDB();
  }

  getLastEntryFromAPI() async {
    Entry retrievedLastEntry = await getLastEntry();
    _lastEntry = retrievedLastEntry;
    await handler.insertEntry(retrievedLastEntry);
  }

  //TODO split entries and treatments query for all functions and logic
  getDataFromDB() async {
    await getLastEntryFromAPI();
    _entries = await handler.retrieveEntries(DateTime.now()
        .subtract(
          Duration(hours: _preferredDisplayInterval),
        )
        .toUtc()
        .millisecondsSinceEpoch);

    _treatments = await getTreatmentsFromApi(
      afterTime: DateTime.now().subtract(
        Duration(hours: _preferredDisplayInterval),
      ),
    );

    _backendData = [_entries, _treatments].cast<List>();
    notifyListeners();
  }
}
