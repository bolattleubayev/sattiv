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

  DateTime _fiveMinutesFromNow = DateTime.now();

  /// Gets data from local DB if 5 minutes from last entry have passed.
  getTheTimeToTriggerEvent() async {
    _fiveMinutesFromNow = DateTime.parse(_lastEntry.dateString)
        .toLocal()
        .add(const Duration(minutes: 5));
    if (DateTime.now().isAfter(_fiveMinutesFromNow)) {
      getDataFromDB();
    }
  }

  void updateUserSettings(int preferredDisplayInterval, bool isMmolL) {
    _preferredDisplayInterval = preferredDisplayInterval;
    _isMmolL = isMmolL;
    getDataFromDB();
  }

  /// Local DB initializer is called once in view.
  initDB() async {
    // Initialize local DB
    await handler.initDB();
    await _getLastEntryFromAPI();
    // Load last day's data from API and fill local DB
    await _initialDBFill();
    // Check whether DB needs to be synced with API
    Timer.periodic(const Duration(seconds: 60), (t) async {
      await getTheTimeToTriggerEvent();
    });
  }

  /// Posting last treatment in API and updating model.
  postNewTreatment(Treatment treatment) async {
    await postTreatment(treatment);
    await getDataFromDB();
  }

  /// Undoing last treatment in API and updating model.
  undoLastTreatmentInApi() async {
    await undoLastTreatment();
    await getDataFromDB();
  }

  /// Helper function to sync API and local DB with one entry at a time.
  _getLastEntryFromAPI() async {
    Entry retrievedLastEntry = await getLastEntry();
    _lastEntry = retrievedLastEntry;
    await handler.insertEntry(retrievedLastEntry);
  }

  /// Helper function to retrieve data from API on startup
  _initialDBFill() async {
    List<Entry> _retrievedEntries = await getEntriesFromApi(
        afterTime: DateTime.now().subtract(const Duration(days: 1)));
    for (var i = 0; i < _retrievedEntries.length; i++) {
      await handler.insertEntry(_retrievedEntries[i]);
    }
  }

  //TODO split entries and treatments query for all functions and logic
  /// Manages data retrieval from API and local DB.
  getDataFromDB() async {
    await _getLastEntryFromAPI();
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
