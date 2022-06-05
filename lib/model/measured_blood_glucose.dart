class MeasuredBloodGlucose {
  final String type;
  final String dateString;
  final int date;
  final double mbg;
  final String device;
  final int utcOffset;
  final String sysTime;

  MeasuredBloodGlucose({
    required this.type,
    required this.dateString,
    required this.date,
    required this.mbg,
    required this.device,
    required this.utcOffset,
    required this.sysTime,
  });

  Map<String, dynamic> toMap() {
    return {
      'date': date,
      'type': type,
      'dateString': dateString,
      'mbg': mbg,
      'device': device,
      'utcOffset': utcOffset,
      'sysTime': sysTime,
    };
  }

  MeasuredBloodGlucose.fromMap(Map<String, dynamic> res)
      : date = res["date"],
        type = res["type"],
        dateString = res["dateString"],
        mbg = res["mbg"],
        device = res["device"],
        utcOffset = res["utcOffset"],
        sysTime = res["sysTime"];

  @override
  String toString() {
    return 'MeasuredBloodGlucose{date: $date, type: $type, dateString: $dateString, mbg: $mbg, device: $device, utcOffset: $utcOffset, sysTime: $sysTime}';
  }
}
