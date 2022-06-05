import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../managers/api_manager.dart';
import '../controllers/calibrations_screen_controller.dart';

import '../model/calibration_plot_datapoint.dart';
import '../model/user_settings.dart';
import '../model/wave_data_point.dart';
import '../model/measured_blood_glucose.dart';

import '../constants.dart';

class CalibrationsPlot extends StatefulWidget {
  final CalibrationsScreenController? screenController;

  const CalibrationsPlot({
    Key? key,
    required this.screenController,
  }) : super(key: key);

  @override
  _CalibrationsPlotState createState() => _CalibrationsPlotState();
}

class _CalibrationsPlotState extends State<CalibrationsPlot> {
  late ZoomPanBehavior _zoomPanBehavior;
  late UserSettings userSettings;
  late Duration timePlottedAhead;

  void getUserSettings() {
    userSettings = widget.screenController?.getUserSettings() ??
        UserSettings.defaultValues();
  }

  @override
  void initState() {
    getUserSettings();
    _zoomPanBehavior = ZoomPanBehavior(
      // Enables pinch zooming
      enablePinching: true,
      zoomMode: ZoomMode.x,
      enablePanning: true,
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    getUserSettings();
    return _buildDefaultScatterChart();
  }

  SfCartesianChart _buildDefaultScatterChart() {
    return SfCartesianChart(
      plotAreaBorderWidth: 0,
      primaryXAxis: NumericAxis(
        title: AxisTitle(
          text: 'Measured value',
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      primaryYAxis: NumericAxis(
        title: AxisTitle(
          text: 'Sensor value',
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      series: <ChartSeries>[
        // Renders scatter chart
        ..._getScatterSeries(),
      ],
    );
  }

  List<ScatterSeries<dynamic, double>> _getScatterSeries() {
    List<CalibrationPlotDatapoint> datapoints =
        widget.screenController?.getCalibrations() ?? [];

    ScatterSeries<CalibrationPlotDatapoint, double> _calibrations =
        ScatterSeries<CalibrationPlotDatapoint, double>(
            dataSource: datapoints,
            opacity: 1.0,
            color: Colors.blue,
            trendlines: <Trendline>[
              Trendline(
                type: TrendlineType.linear,
                color: Colors.green,
                opacity: 0.7,
              ),
            ],
            xValueMapper: (CalibrationPlotDatapoint entry, _) => userSettings
                    .isMmolL
                ? entry.measuredValue / 18
                : entry.measuredValue,
            yValueMapper: (CalibrationPlotDatapoint entry, _) =>
                userSettings.isMmolL
                    ? entry.sensorValue / 18
                    : entry.sensorValue,
            markerSettings: const MarkerSettings(
              height: 10,
              width: 10,
            ),
            dataLabelMapper: (CalibrationPlotDatapoint entry, _) =>
                entry.dateString,
            dataLabelSettings: DataLabelSettings(
              isVisible: true,
              textStyle:
                  Theme.of(context).textTheme.button ?? const TextStyle(),
            ),
            name: kUnits);
    return <ScatterSeries<dynamic, double>>[_calibrations];
  }
}
