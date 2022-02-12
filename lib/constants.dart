import 'package:flutter/material.dart';

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
