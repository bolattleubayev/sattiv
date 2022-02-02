import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../model/treatment.dart';
import '../model/entry.dart';
import '../model/wave_data_point.dart';
import '../model/humalog_wave.dart';
import '../constants.dart';

class BgScatterPlot extends StatefulWidget {
  final List<Entry> entries;
  final List<Treatment> treatments;

  const BgScatterPlot({
    Key? key,
    required this.entries,
    required this.treatments,
  }) : super(key: key);

  @override
  State<BgScatterPlot> createState() => _BgScatterPlotState();
}

class _BgScatterPlotState extends State<BgScatterPlot> {
  late ZoomPanBehavior _zoomPanBehavior;

  @override
  void initState() {
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
    return _buildDefaultScatterChart();
  }

  /// Returns the default scatter chart.
  SfCartesianChart _buildDefaultScatterChart() {
    return SfCartesianChart(
      zoomPanBehavior: _zoomPanBehavior,
      plotAreaBorderWidth: 0,
      primaryXAxis: DateTimeAxis(
        labelIntersectAction: AxisLabelIntersectAction.multipleRows,
        maximum: DateTime.now().add(kTimeAhead),
        majorGridLines: const MajorGridLines(width: 0),
      ),
      primaryYAxis: NumericAxis(
        minimum: kMinimumPlotXAxis,
        labelFormat: '{value}',
        axisLine: const AxisLine(width: 0),
        minorTickLines: const MinorTickLines(size: 0),
      ),
      tooltipBehavior: TooltipBehavior(enable: true),
      series: <ChartSeries>[
        ..._getSplineSeries(),
        ..._getScatterSeries(),
        ..._getLines(),
      ],
    );
  }

  /// Returns the list of chart series which need to render on the spline chart.
  List<SplineSeries<WaveDataPoint, DateTime>> _getSplineSeries() {
    List<Treatment> insulinInjections = widget.treatments
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
            injectionTime: DateTime.parse(treatment.created_at),
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

  List<ScatterSeries<dynamic, DateTime>> _getScatterSeries() {
    ScatterSeries<Entry, DateTime> bloodGlucoseValues =
        ScatterSeries<Entry, DateTime>(
            dataSource: widget.entries,
            opacity: 1.0,
            color: Colors.blue,
            xValueMapper: (Entry entry, _) => DateTime.parse(entry.dateString),
            yValueMapper: (Entry entry, _) => entry.sgv / 18,
            markerSettings: const MarkerSettings(
              height: 10,
              width: 10,
            ),
            name: kUnits);

    List<Treatment> notes = widget.treatments
        .where((element) => element.eventType == "note")
        .toList();

    List<ScatterSeries<Treatment, DateTime>> notesValues = [];
    for (Treatment treatment in notes) {
      notesValues.add(
        ScatterSeries<Treatment, DateTime>(
          dataSource: notes,
          opacity: 1.0,
          color: Colors.amber,
          xValueMapper: (Treatment treatment, _) =>
              DateTime.parse(treatment.created_at),
          yValueMapper: (Treatment treatment, _) => treatment.glucose,
          markerSettings: const MarkerSettings(
            height: 15,
            width: 15,
          ),
          name: treatment.notes,
        ),
      );
    }

    return <ScatterSeries<dynamic, DateTime>>[
      bloodGlucoseValues,
      ...notesValues,
    ];
  }

  List<_GlucoseLimits> _highLimit = [];
  List<_GlucoseLimits> _lowLimit = [];

  /// The method returns line series to chart.
  List<LineSeries<_GlucoseLimits, DateTime>> _getLines() {
    _highLimit = [
      _GlucoseLimits(DateTime.now().add(kTimeAhead), kHighLimit),
      _GlucoseLimits(
          DateTime.now().subtract(Duration(minutes: widget.entries.length * 5)),
          kHighLimit),
    ];
    _lowLimit = [
      _GlucoseLimits(DateTime.now().add(kTimeAhead), kLowLimit),
      _GlucoseLimits(
          DateTime.now().subtract(Duration(minutes: widget.entries.length * 5)),
          kLowLimit),
    ];

    return <LineSeries<_GlucoseLimits, DateTime>>[
      LineSeries<_GlucoseLimits, DateTime>(
        dashArray: <double>[5, 5],
        animationDuration: 2500,
        dataSource: _highLimit,
        xValueMapper: (_GlucoseLimits limits, _) => limits.x,
        yValueMapper: (_GlucoseLimits limits, _) => limits.y,
        width: 3,
        color: Colors.purple,
        name: 'High limit',
        markerSettings: const MarkerSettings(isVisible: false),
      ),
      LineSeries<_GlucoseLimits, DateTime>(
        dashArray: <double>[5, 5],
        animationDuration: 2500,
        dataSource: _lowLimit,
        xValueMapper: (_GlucoseLimits limits, _) => limits.x,
        yValueMapper: (_GlucoseLimits limits, _) => limits.y,
        width: 3,
        color: Colors.purple,
        name: 'Low limit',
        markerSettings: const MarkerSettings(isVisible: false),
      ),
    ];
  }
}

class _GlucoseLimits {
  _GlucoseLimits(this.x, this.y);
  final DateTime x;
  final double y;
}
