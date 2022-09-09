import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import '../model/calibration.dart';
import '../model/measured_blood_glucose.dart';

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

void showCupertinoAlertDialog(
  BuildContext context,
  String title,
  String content,
) {
  showCupertinoModalPopup<void>(
    context: context,
    builder: (BuildContext context) => CupertinoAlertDialog(
      title: Text(title),
      content: Text(content),
      actions: <CupertinoDialogAction>[
        CupertinoDialogAction(
          isDefaultAction: true,
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Okay'),
        ),
      ],
    ),
  );
}
