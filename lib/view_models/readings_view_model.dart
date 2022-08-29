import 'dart:async';

import 'package:flutter/material.dart';

import '../services/http_service.dart';

import '../model/entry.dart';
import '../model/treatment.dart';

class ReadingsViewModel extends ChangeNotifier {
  List<List<dynamic>> _backendData = [];

  List<List<dynamic>> get backendData => _backendData;

  List<Entry> _entries = [];

  List<Entry> get entries => _entries;

  List<Treatment> _treatments = [];

  List<Treatment> get treatments => _treatments;

  int _preferredDisplayInterval = 3;

  void updateDisplayInterval(int preferredDisplayInterval) {
    _preferredDisplayInterval = preferredDisplayInterval;
    getDataFromBackend();
  }

  /// Timed self-refresh
  refresher() async {
    Timer.periodic(const Duration(seconds: 295), (t) async {
      await getDataFromBackend();
    });
  }

  /// Getters
  getDataFromBackend() async {
    _entries = await getEntriesFromApi(
      afterTime: DateTime.now().subtract(
        Duration(hours: _preferredDisplayInterval),
      ),
    );

    _treatments = await getTreatmentsFromApi(
      afterTime: DateTime.now().subtract(
        Duration(hours: _preferredDisplayInterval),
      ),
    );

    _backendData = [_entries, _treatments].cast<List>();
    notifyListeners();
  }
}
