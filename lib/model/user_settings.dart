class UserSettings {
  bool isMmolL;
  double lowLimit;
  double highLimit;
  int preferredDisplayInterval;

  UserSettings({
    required this.isMmolL,
    required this.lowLimit,
    required this.highLimit,
    required this.preferredDisplayInterval,
  });

  // Default initializer
  UserSettings.defaultValues()
      : isMmolL = true,
        lowLimit = 3.9,
        highLimit = 7.0,
        preferredDisplayInterval = 1;
}
