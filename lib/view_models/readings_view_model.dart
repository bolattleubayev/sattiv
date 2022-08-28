import 'dart:async';

import 'package:flutter/material.dart';

import '../services/http_service.dart';
import '../services/user_settings_service.dart';

import '../model/entry.dart';
import '../model/treatment.dart';
import '../model/user_settings.dart';

class ReadingsViewModel extends ChangeNotifier {
  List<List<dynamic>> _backendData = [];
  List<List<dynamic>> get backendData => _backendData;

  List<Entry> _entries = [];
  List<Entry> get entries => _entries;

  List<Treatment> _treatments = [];
  List<Treatment> get treatments => _treatments;

  UserSettings _userSettings = UserSettings.defaultValues();
  UserSettings get userSettings => _userSettings;

  loadDataFromUserDefaults() async {
    _userSettings = await getUserSettings();
    notifyListeners();
  }

  /// Timed self-refresh
  refresher() async {
    Timer.periodic(const Duration(seconds: 295), (t) async {
      _entries = await getEntriesFromApi(
        afterTime: DateTime.now().subtract(
          Duration(hours: _userSettings.preferredDisplayInterval),
        ),
      );

      _treatments = await getTreatmentsFromApi(
        afterTime: DateTime.now().subtract(
          Duration(hours: _userSettings.preferredDisplayInterval),
        ),
      );

      _backendData = [_entries, _treatments].cast<List>();
      notifyListeners();
    });
  }

  /// Getters
  int getDisplayInterval() {
    return _userSettings.preferredDisplayInterval;
  }

  getDataFromBackend() async {
    await loadDataFromUserDefaults();

    _entries = await getEntriesFromApi(
      afterTime: DateTime.now().subtract(
        Duration(hours: _userSettings.preferredDisplayInterval),
      ),
    );

    _treatments = await getTreatmentsFromApi(
      afterTime: DateTime.now().subtract(
        Duration(hours: _userSettings.preferredDisplayInterval),
      ),
    );

    _backendData = [_entries, _treatments].cast<List>();
    notifyListeners();
  }

  /// Setters
  void setDisplayInterval({required int? hours}) async {
    setPreferredDisplayAheadInterval(hours: hours);
    await getDataFromBackend();
    _userSettings = await getUserSettings();
    notifyListeners();
  }
}
