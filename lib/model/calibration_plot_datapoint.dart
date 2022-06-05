class CalibrationPlotDatapoint {
  final String dateString;
  final int date;
  final double measuredValue;
  final int sensorValue;

  CalibrationPlotDatapoint(
      {required this.dateString,
      required this.date,
      required this.measuredValue,
      required this.sensorValue});

  Map<String, dynamic> toMap() {
    return {
      'date': date,
      'dateString': dateString,
      'measuredValue': measuredValue,
      'sensorValue': sensorValue
    };
  }

  CalibrationPlotDatapoint.fromMap(Map<String, dynamic> res)
      : date = res["date"],
        dateString = res["dateString"],
        measuredValue = res["measuredValue"],
        sensorValue = res["sensorValue"];

  @override
  String toString() {
    return 'CalibrationPlotDatapoint{date: $date, dateString: $dateString, measuredValue: $measuredValue, sensorValue: $sensorValue}';
  }
}
