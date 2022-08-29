class UserSettings {
  bool isMmolL;
  double lowLimit;
  double highLimit;
  int preferredDisplayInterval;
  String baseUrl;
  String apiSecret;

  UserSettings({
    required this.isMmolL,
    required this.lowLimit,
    required this.highLimit,
    required this.preferredDisplayInterval,
    required this.baseUrl,
    required this.apiSecret,
  });

  // Default initializer
  UserSettings.defaultValues()
      : isMmolL = true,
        lowLimit = 3.9,
        highLimit = 7.0,
        preferredDisplayInterval = 1,
        baseUrl = "",
        apiSecret = "";
}
