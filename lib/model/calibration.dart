class Calibration {
  final String type;
  final String dateString;
  final int date;
  final int scale;
  final double intercept;
  final int slope;
  final String sysTime;
  final String device;
  final int utcOffset;

  Calibration({
    required this.type,
    required this.dateString,
    required this.date,
    required this.scale,
    required this.intercept,
    required this.slope,
    required this.sysTime,
    required this.device,
    required this.utcOffset,
  });

  Map<String, dynamic> toMap() {
    return {
      'date': date,
      'type': type,
      'dateString': dateString,
      'scale': scale,
      'intercept': intercept,
      'slope': slope,
      'sysTime': sysTime,
      'device': device,
      'utcOffset': utcOffset,
    };
  }

  Calibration.fromMap(Map<String, dynamic> res)
      : date = res["date"],
        type = res["type"],
        dateString = res["dateString"],
        scale = res["scale"],
        intercept = res["intercept"],
        slope = res["slope"],
        sysTime = res["sysTime"],
        device = res["device"],
        utcOffset = res["utcOffset"];

  @override
  String toString() {
    return 'Calibration{date: $date, type: $type, dateString: $dateString, scale: $scale, intercept: $intercept, slope: $slope, sysTime: $sysTime, device: $device, utcOffset: $utcOffset}';
  }
}
