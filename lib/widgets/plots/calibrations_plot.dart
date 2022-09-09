import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:provider/provider.dart';

import '../../view_models/calibrations_view_model.dart';
import '../../view_models/user_settings_view_model.dart';

import '../../model/calibration_plot_datapoint.dart';

class CalibrationsPlot extends StatefulWidget {
  const CalibrationsPlot({
    Key? key,
  }) : super(key: key);

  @override
  _CalibrationsPlotState createState() => _CalibrationsPlotState();
}

class _CalibrationsPlotState extends State<CalibrationsPlot> {
  late ZoomPanBehavior _zoomPanBehavior;
  late Duration timePlottedAhead;

  @override
  void initState() {
    _zoomPanBehavior = ZoomPanBehavior(
      // Enables pinch zooming
      enablePinching: true,
      enablePanning: true,
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<CalibrationsViewModel, UserSettingsViewModel>(
      builder: (context, calibrationsViewModel, userSettingsViewModel, child) {
        return _buildDefaultScatterChart(
            calibrationsViewModel, userSettingsViewModel);
      },
    );
  }

  SfCartesianChart _buildDefaultScatterChart(
    CalibrationsViewModel calibrationsViewModel,
    UserSettingsViewModel userSettingsViewModel,
  ) {
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
        ..._getScatterSeries(calibrationsViewModel, userSettingsViewModel),
      ],
    );
  }

  List<ScatterSeries<dynamic, double>> _getScatterSeries(
    CalibrationsViewModel calibrationsViewModel,
    UserSettingsViewModel userSettingsViewModel,
  ) {
    List<CalibrationPlotDatapoint> datapoints =
        calibrationsViewModel.calibrations;
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
            xValueMapper:
                (CalibrationPlotDatapoint calibrationPlotDatapoint, _) =>
                    userSettingsViewModel.userSettings.isMmolL
                        ? calibrationPlotDatapoint.measuredValue / 18
                        : calibrationPlotDatapoint.measuredValue,
            yValueMapper:
                (CalibrationPlotDatapoint calibrationPlotDatapoint, _) =>
                    userSettingsViewModel.userSettings.isMmolL
                        ? calibrationPlotDatapoint.sensorValue / 18
                        : calibrationPlotDatapoint.sensorValue,
            markerSettings: const MarkerSettings(
              height: 10,
              width: 10,
            ),
            dataLabelMapper: (CalibrationPlotDatapoint entry, _) =>
                DateTime.parse(entry.dateString).toLocal().toString(),
            dataLabelSettings: DataLabelSettings(
              isVisible: true,
              textStyle:
                  Theme.of(context).textTheme.button ?? const TextStyle(),
            ),
            name: userSettingsViewModel.userSettings.isMmolL
                ? 'mmol/L'
                : 'mg/dL');
    return <ScatterSeries<dynamic, double>>[_calibrations];
  }
}
