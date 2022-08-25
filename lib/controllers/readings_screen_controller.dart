import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';

import '../model/entry.dart';
import '../model/treatment.dart';
import '../model/user_settings.dart';

import '../services/http_service.dart';

class ReadingsScreenController {
  /// App data
  List<List<dynamic>>? _backendData;
  List<Entry>? _entries;
  List<Treatment>? _treatments;
  final UserSettings? _userSettings = UserSettings.defaultValues();

  /// Getters

  int? getDisplayInterval() {
    return _userSettings?.preferredDisplayInterval;
  }

  UserSettings? getUserSettings() {
    return _userSettings;
  }

  List<Entry>? getEntries() {
    return _entries;
  }

  List<Treatment>? getTreatments() {
    return _treatments;
  }

  /// Setters

  // void setDisplayInterval({required int? hours}) {
  //   _userSettings?.setPreferredDisplayAheadInterval(hours: hours);
  // }

  /// API
  //
  // Future loadDataFromUserDefaults() async {
  //   await _userSettings?.getSettingsFromUserDefaults();
  // }

  void saveData() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt('preferredDisplayInterval',
        _userSettings?.preferredDisplayInterval ?? 1);
  }
  //
  // Future<List<List<dynamic>>?> getDataFromBackend() async {
  //   await loadDataFromUserDefaults();
  //
  //   _entries = await getEntriesFromApi(
  //     afterTime: DateTime.now().subtract(
  //       Duration(hours: _userSettings?.preferredDisplayInterval ?? 1),
  //     ),
  //   );
  //
  //   _treatments = await getTreatmentsFromApi(
  //     afterTime: DateTime.now().subtract(
  //       Duration(hours: _userSettings?.preferredDisplayInterval ?? 1),
  //     ),
  //   );
  //
  //   _backendData = [_entries, _treatments].cast<List>();
  //   return _backendData;
  // }

  /// Element controllers

}
