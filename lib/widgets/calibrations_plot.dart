import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:provider/provider.dart';

import '../services/http_service.dart';
import '../controllers/calibrations_screen_controller.dart';
import '../view_models/calibrations_view_model.dart';

import '../model/calibration_plot_datapoint.dart';
import '../model/user_settings.dart';
import '../model/wave_data_point.dart';
import '../model/measured_blood_glucose.dart';

import '../constants.dart';

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
    // print(widget.viewModel.calibrations);
    // print(widget.viewModel.userSettings.isMmolL);
    // print(widget.viewModel.userSettings.highLimit);
    // print(widget.viewModel.userSettings.lowLimit);
    // print(widget.viewModel.userSettings.preferredDisplayInterval);
    _zoomPanBehavior = ZoomPanBehavior(
      // Enables pinch zooming
      enablePinching: true,
      enablePanning: true,
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CalibrationsViewModel>(
      builder: (context, viewModel, child) {
        return _buildDefaultScatterChart(viewModel);
      },
    );
  }

  SfCartesianChart _buildDefaultScatterChart(CalibrationsViewModel viewModel) {
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
        ..._getScatterSeries(viewModel),
      ],
    );
  }

  List<ScatterSeries<dynamic, double>> _getScatterSeries(
      CalibrationsViewModel viewModel) {
    List<CalibrationPlotDatapoint> datapoints = viewModel.calibrations;
    // print(datapoints);
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
            xValueMapper: (CalibrationPlotDatapoint entry, _) =>
                viewModel.userSettings.isMmolL
                    ? entry.measuredValue / 18
                    : entry.measuredValue,
            yValueMapper: (CalibrationPlotDatapoint entry, _) =>
                viewModel.userSettings.isMmolL
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
