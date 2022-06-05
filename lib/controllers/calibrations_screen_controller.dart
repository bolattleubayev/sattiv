import 'dart:async';

import '../managers/api_manager.dart';

import '../model/entry.dart';
import '../model/calibration.dart';
import '../model/calibration_plot_datapoint.dart';
import '../model/measured_blood_glucose.dart';
import '../model/user_settings.dart';

import '../constants.dart';

class CalibrationsScreenController {
  /// App data
  List<CalibrationPlotDatapoint>? _calibrations;
  List<MeasuredBloodGlucose>? _measuredBloodGlucoseReadings;
  final UserSettings? _userSettings = UserSettings.defaultValues();

  UserSettings? getUserSettings() {
    return _userSettings;
  }

  List<CalibrationPlotDatapoint>? getCalibrations() {
    return _calibrations;
  }

  List<MeasuredBloodGlucose>? getMeasuredBloodGlucoseReadings() {
    return _measuredBloodGlucoseReadings;
  }

  /// API

  Future loadDataFromUserDefaults() async {
    await _userSettings?.getSettingsFromUserDefaults();
  }

  Future<List<dynamic>?> getDataFromBackend() async {
    await loadDataFromUserDefaults();
    int _amountOfCalibrations = 5;
    _calibrations = await getCalibrationData(count: _amountOfCalibrations);
    return _calibrations;
  }
}
