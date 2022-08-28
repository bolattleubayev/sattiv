import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:provider/provider.dart';

import '../view_models/readings_view_model.dart';
import '../model/treatment.dart';
import '../model/entry.dart';
import '../model/wave_data_point.dart';
import '../model/humalog_wave.dart';
import '../model/cartesian.dart';
import '../constants.dart';

class BgScatterPlot extends StatefulWidget {
  const BgScatterPlot({
    Key? key,
  }) : super(key: key);

  @override
  State<BgScatterPlot> createState() => _BgScatterPlotState();
}

class _BgScatterPlotState extends State<BgScatterPlot> {
  late ZoomPanBehavior _zoomPanBehavior;
  late Duration timePlottedAhead;

  LineSeries<T, K> _buildLineSeries<T extends Cartesian, K>({
    required List<T> dataSource,
    required String name,
    required Color color,
  }) {
    return LineSeries<T, K>(
      dashArray: <double>[5, 5],
      animationDuration: 2500,
      dataSource: dataSource,
      xValueMapper: (T limits, _) => limits.x as K,
      yValueMapper: (T limits, _) => limits.y,
      width: 3,
      color: color,
      name: name,
      markerSettings: const MarkerSettings(isVisible: false),
    );
  }

  @override
  void initState() {
    // TODO: Time plotted ahead
    timePlottedAhead = const Duration(hours: 1);
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
    return Consumer<ReadingsViewModel>(
      builder: (context, viewModel, child) {
        return Expanded(
          child: _buildDefaultScatterChart(viewModel),
        );
      },
    );
  }

  /// Returns the default scatter chart.
  SfCartesianChart _buildDefaultScatterChart(ReadingsViewModel viewModel) {
    return SfCartesianChart(
      zoomPanBehavior: _zoomPanBehavior,
      plotAreaBorderWidth: 0,
      primaryXAxis: DateTimeAxis(
        labelIntersectAction: AxisLabelIntersectAction.multipleRows,
        maximum: DateTime.now().add(timePlottedAhead),
        majorGridLines: const MajorGridLines(width: 0),
      ),
      primaryYAxis: LogarithmicAxis(
        minimum: kMinimumPlotXAxis,
        logBase: 1.065,
        labelFormat: '{value}',
        axisLine: const AxisLine(width: 0),
        minorTickLines: const MinorTickLines(size: 0),
      ),
      tooltipBehavior: TooltipBehavior(enable: true),
      series: <ChartSeries>[
        ..._getSplineSeries(viewModel),
        ..._getScatterSeries(viewModel),
        ..._getLines(viewModel),
      ],
    );
  }

  /// Returns the list of chart series which need to render on the spline chart.
  List<SplineSeries<WaveDataPoint, DateTime>> _getSplineSeries(
      ReadingsViewModel viewModel) {
    List<Treatment> insulinInjections = viewModel.treatments
        .where((element) => element.eventType == "insulin")
        .toList();
    List<SplineSeries<WaveDataPoint, DateTime>> returnSeries = [];

    for (Treatment treatment in insulinInjections) {
      returnSeries.add(
        SplineSeries<WaveDataPoint, DateTime>(
          color: Colors.green,
          width: 4,
          dataSource: HumalogWave(
            magnitude: treatment.insulin,
            injectionTime: DateTime.parse(treatment.id),
          ).wave,
          xValueMapper: (WaveDataPoint dataPoint, _) => dataPoint.timeInterval,
          yValueMapper: (WaveDataPoint dataPoint, _) => dataPoint.magnitude,
          markerSettings: const MarkerSettings(isVisible: true),
          name: 'insulin ${treatment.insulin}u',
        ),
      );
    }

    return returnSeries;
  }

  List<ScatterSeries<dynamic, DateTime>> _getScatterSeries(
      ReadingsViewModel viewModel) {
    List<Entry> normalBgValues = viewModel.entries.where((element) {
      if (viewModel.userSettings.isMmolL) {
        return (element.sgv / 18 >= viewModel.userSettings.lowLimit &&
            element.sgv / 18 <= viewModel.userSettings.highLimit);
      }
      return (element.sgv >= viewModel.userSettings.lowLimit &&
          element.sgv <= viewModel.userSettings.highLimit);
    }).toList();

    List<Entry> lowBgValues = viewModel.entries.where((element) {
      if (viewModel.userSettings.isMmolL) {
        return (element.sgv / 18 < viewModel.userSettings.lowLimit);
      }
      return (element.sgv < viewModel.userSettings.lowLimit);
    }).toList();

    List<Entry> highBgValues = viewModel.entries.where((element) {
      if (viewModel.userSettings.isMmolL) {
        return (element.sgv / 18 > viewModel.userSettings.highLimit);
      }
      return (element.sgv > viewModel.userSettings.highLimit);
    }).toList();

    ScatterSeries<Entry, DateTime> normalBloodGlucoseValues =
        ScatterSeries<Entry, DateTime>(
            dataSource: normalBgValues,
            opacity: 1.0,
            color: Colors.blue,
            xValueMapper: (Entry entry, _) => DateTime.parse(entry.dateString),
            yValueMapper: (Entry entry, _) =>
                viewModel.userSettings.isMmolL ? entry.sgv / 18 : entry.sgv,
            markerSettings: const MarkerSettings(
              height: 10,
              width: 10,
            ),
            name: kUnits);

    ScatterSeries<Entry, DateTime> lowBloodGlucoseValues =
        ScatterSeries<Entry, DateTime>(
            dataSource: lowBgValues,
            opacity: 1.0,
            color: Colors.redAccent,
            xValueMapper: (Entry entry, _) => DateTime.parse(entry.dateString),
            yValueMapper: (Entry entry, _) =>
                viewModel.userSettings.isMmolL ? entry.sgv / 18 : entry.sgv,
            markerSettings: const MarkerSettings(
              height: 10,
              width: 10,
            ),
            name: kUnits);

    ScatterSeries<Entry, DateTime> highBloodGlucoseValues =
        ScatterSeries<Entry, DateTime>(
            dataSource: highBgValues,
            opacity: 1.0,
            color: Colors.amber,
            xValueMapper: (Entry entry, _) => DateTime.parse(entry.dateString),
            yValueMapper: (Entry entry, _) =>
                viewModel.userSettings.isMmolL ? entry.sgv / 18 : entry.sgv,
            markerSettings: const MarkerSettings(
              height: 10,
              width: 10,
            ),
            name: kUnits);

    List<Treatment> notes = viewModel.treatments
        .where((element) => element.eventType == "note")
        .toList();

    List<ScatterSeries<Treatment, DateTime>> notesValues = [];
    for (Treatment treatment in notes) {
      notesValues.add(
        ScatterSeries<Treatment, DateTime>(
          dataSource: notes,
          opacity: 1.0,
          color: Colors.lightGreen,
          xValueMapper: (Treatment treatment, _) =>
              DateTime.parse(treatment.id),
          yValueMapper: (Treatment treatment, _) => treatment.glucose,
          markerSettings: const MarkerSettings(
            height: 15,
            width: 15,
          ),
          name: treatment.notes,
          dataLabelMapper: (Treatment treatment, _) => treatment.notes,
          dataLabelSettings: DataLabelSettings(
            isVisible: true,
            textStyle: Theme.of(context).textTheme.button ?? const TextStyle(),
          ),
        ),
      );
    }

    return <ScatterSeries<dynamic, DateTime>>[
      normalBloodGlucoseValues,
      lowBloodGlucoseValues,
      highBloodGlucoseValues,
      ...notesValues,
    ];
  }

  List<_GlucoseLimits> _highLimit = [];
  List<_GlucoseLimits> _lowLimit = [];

  /// The method returns line series to chart.
  List<LineSeries<_GlucoseLimits, DateTime>> _getLines(
      ReadingsViewModel viewModel) {
    _highLimit = [
      _GlucoseLimits(
          DateTime.now()
              .subtract(Duration(minutes: ((viewModel.entries.length) * 5))),
          viewModel.userSettings.highLimit),
      _GlucoseLimits(DateTime.now().add(timePlottedAhead),
          viewModel.userSettings.highLimit),
    ];

    _lowLimit = [
      _GlucoseLimits(
          DateTime.now()
              .subtract(Duration(minutes: ((viewModel.entries.length) * 5))),
          viewModel.userSettings.lowLimit),
      _GlucoseLimits(DateTime.now().add(timePlottedAhead),
          viewModel.userSettings.lowLimit),
    ];

    return <LineSeries<_GlucoseLimits, DateTime>>[
      _buildLineSeries(
        dataSource: _highLimit,
        name: 'High limit',
        color: Colors.purple,
      ),
      _buildLineSeries(
        dataSource: _lowLimit,
        name: 'Low limit',
        color: Colors.purple,
      ),
    ];
  }
}

class _GlucoseLimits extends Cartesian {
  _GlucoseLimits(DateTime x, double y) : super(x, y);
}
