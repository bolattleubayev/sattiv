import 'package:flutter/material.dart';

import '../services/http_service.dart';

import '../model/calibration_plot_datapoint.dart';

class CalibrationsViewModel extends ChangeNotifier {
  final int _amountOfCalibrations = 5;

  List<CalibrationPlotDatapoint> _calibrations = [];
  List<CalibrationPlotDatapoint> get calibrations => _calibrations;

  getCalibrations() async {
    _calibrations = await getCalibrationData(count: _amountOfCalibrations);
    notifyListeners();
  }
}
