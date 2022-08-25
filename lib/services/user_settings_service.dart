import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';

import '../model/user_settings.dart';

Future<UserSettings> getUserSettings() async {
  final prefs = await SharedPreferences.getInstance();
  UserSettings userSettings = UserSettings.defaultValues();

  userSettings.isMmolL = (prefs.getBool('isMmolL') ?? true);
  userSettings.lowLimit = (prefs.getDouble('lowLimit') ?? 3.9);
  userSettings.highLimit = (prefs.getDouble('highLimit') ?? 7.0);
  userSettings.preferredDisplayInterval =
      (prefs.getInt('preferredDisplayInterval') ?? 1);

  return userSettings;
}

void setPreferredDisplayAheadInterval({required int? hours}) async {
  final prefs = await SharedPreferences.getInstance();
  prefs.setInt('preferredDisplayInterval', hours ?? 1);
}
