import 'dart:async';

import 'package:flutter/material.dart';

import '../services/database_service.dart';
import '../services/http_service.dart';

import '../model/calibration_plot_datapoint.dart';

final handler = DatabaseService();

class CalibrationsViewModel extends ChangeNotifier {
  final int _amountOfCalibrations = 5;

  List<CalibrationPlotDatapoint> _calibrations = [];
  List<CalibrationPlotDatapoint> get calibrations => _calibrations;

  initDB() async {
    await handler.initDB();
  }

  getLastCalibrationsFromAPI(int count) async {
    List<CalibrationPlotDatapoint> currCalibrations =
        await getCalibrationData(count: count);
    for (var i = 0; i < currCalibrations.length; i++) {
      await handler.insertCalibration(currCalibrations[i]);
    }
  }

  getCalibrations() async {
    await getLastCalibrationsFromAPI(_amountOfCalibrations);
    _calibrations = await handler.retrieveCalibrations(_amountOfCalibrations);
    notifyListeners();
  }
}
