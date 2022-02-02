import 'package:shared_preferences/shared_preferences.dart';

class UserSettings {
  bool isMmolL;
  double lowLimit;
  double highLimit;
  int preferredDisplayInterval;

  UserSettings(
      {required this.isMmolL,
      required this.lowLimit,
      required this.highLimit,
      required this.preferredDisplayInterval});

  Future getSettingsFromUserDefaults() async {
    final prefs = await SharedPreferences.getInstance();

    isMmolL = (prefs.getBool('isMmolL') ?? true);
    lowLimit = (prefs.getDouble('lowLimit') ?? 3.9);
    highLimit = (prefs.getDouble('highLimit') ?? 7.0);
    preferredDisplayInterval = (prefs.getInt('preferredDisplayInterval') ?? 1);
  }

  void setPreferredDisplayAheadInterval({required int? hours}) async {
    final prefs = await SharedPreferences.getInstance();
    preferredDisplayInterval = hours ?? 1;
    prefs.setInt('preferredDisplayInterval', hours ?? 1);
  }

  void writeSettingsToUserDefaults(
      {required isMmolL,
      required lowLimit,
      required highLimit,
      required preferredDisplayInterval}) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('isMmolL', isMmolL);

    prefs.setDouble('lowLimit', lowLimit);
    prefs.setDouble('highLimit', highLimit);

    prefs.setInt('preferredDisplayInterval', preferredDisplayInterval ?? 1);
  }
}
