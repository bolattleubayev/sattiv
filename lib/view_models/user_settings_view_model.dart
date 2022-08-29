import 'package:flutter/material.dart';

import '../services/user_settings_service.dart';

import '../model/user_settings.dart';

class UserSettingsViewModel extends ChangeNotifier {
  UserSettings _userSettings = UserSettings.defaultValues();
  UserSettings get userSettings => _userSettings;

  loadDataFromUserDefaults() async {
    _userSettings = await getUserSettings();
    notifyListeners();
  }

  int getDisplayInterval() {
    return _userSettings.preferredDisplayInterval;
  }

  /// Setters
  void setDisplayInterval({required int? hours}) async {
    setPreferredDisplayAheadInterval(hours: hours);
    _userSettings = await getUserSettings();
    notifyListeners();
  }
}
