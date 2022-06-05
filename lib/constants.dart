import 'package:flutter/material.dart';
import '../model/calibration.dart';
import '../model/measured_blood_glucose.dart';

/// Preferences

const String kUnits = "mmol/L";

/// Plot

const double kMinimumPlotXAxis = 2.0;

/// Utilities

DateTime timeOfDayToDateTime(TimeOfDay timeOfDay) {
  final now = DateTime.now();
  return DateTime(
      now.year, now.month, now.day, timeOfDay.hour, timeOfDay.minute);
}

bool correspondsToCalibration({
  required Calibration calibration,
  required MeasuredBloodGlucose measuredBloodGlucose,
}) {
  if (calibration.date == measuredBloodGlucose.date) {
    return true;
  }
  return false;
}
