import 'package:flutter/material.dart';

import '../services/http_service.dart';
import '../services/user_settings_service.dart';

import '../model/calibration_plot_datapoint.dart';
import '../model/user_settings.dart';

class CalibrationsViewModel extends ChangeNotifier {
  final int _amountOfCalibrations = 5;

  List<CalibrationPlotDatapoint> _calibrations = [];
  List<CalibrationPlotDatapoint> get calibrations => _calibrations;

  UserSettings _userSettings = UserSettings.defaultValues();
  UserSettings get userSettings => _userSettings;

  loadDataFromUserDefaults() async {
    _userSettings = await getUserSettings();
    notifyListeners();
  }

  getCalibrations() async {
    await loadDataFromUserDefaults();
    _calibrations = await getCalibrationData(count: _amountOfCalibrations);
    notifyListeners();
  }
}
