import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import 'package:sattiv/model/treatment.dart';
import 'package:sattiv/model/entry.dart';
import 'package:sattiv/constants.dart';

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

class WaveDataPoint {
  final double magnitude; // 0 to 1
  final DateTime timeInterval;

  WaveDataPoint({required this.magnitude, required this.timeInterval});
}

class HumalogWave {
  final double magnitude; // 0 to 1
  final DateTime injectionTime;
  static const double multiplier = 4.0;
  List<WaveDataPoint> get wave {
    List<WaveDataPoint> tmpWave = [];
    tmpWave.add(
      WaveDataPoint(
        magnitude: magnitude * multiplier * 0.0 + kMinimumPlotXAxis,
        timeInterval: injectionTime,
      ),
    );
    tmpWave.add(
      WaveDataPoint(
        magnitude: magnitude * multiplier * 1.0 + kMinimumPlotXAxis,
        timeInterval: injectionTime.add(
          const Duration(minutes: 60),
        ),
      ),
    );
    tmpWave.add(
      WaveDataPoint(
        magnitude: magnitude * multiplier * 0.25 + kMinimumPlotXAxis,
        timeInterval: injectionTime.add(
          const Duration(minutes: 120),
        ),
      ),
    );
    tmpWave.add(
      WaveDataPoint(
        magnitude: magnitude * multiplier * 0.0 + kMinimumPlotXAxis,
        timeInterval: injectionTime.add(
          const Duration(minutes: 180),
        ),
      ),
    );
    return tmpWave;
  }

  HumalogWave({
    required this.magnitude,
    required this.injectionTime,
  });
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
        majorGridLines: const MajorGridLines(width: 0),
      ),
      primaryYAxis: NumericAxis(
          minimum: kMinimumPlotXAxis,
          labelFormat: '{value}',
          axisLine: const AxisLine(width: 0),
          minorTickLines: const MinorTickLines(size: 0)),
      tooltipBehavior: TooltipBehavior(enable: true),
      series: <ChartSeries>[..._getSplineSeries(), ..._getScatterSeries()],
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
          dataSource: HumalogWave(
            magnitude: treatment.insulin,
            injectionTime: DateTime.parse(treatment.created_at),
          ).wave,
          xValueMapper: (WaveDataPoint dataPoint, _) => dataPoint.timeInterval,
          yValueMapper: (WaveDataPoint dataPoint, _) => dataPoint.magnitude,
          markerSettings: const MarkerSettings(isVisible: true),
          name: 'High',
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
            markerSettings: const MarkerSettings(height: 15, width: 15),
            name: kUnits);

    ScatterSeries<Treatment, DateTime> notesValues =
        ScatterSeries<Treatment, DateTime>(
            dataSource: widget.treatments
                .where((element) => element.eventType != "insulin")
                .toList(),
            opacity: 1.0,
            color: Colors.blue,
            xValueMapper: (Treatment treatment, _) =>
                DateTime.parse(treatment.created_at),
            yValueMapper: (Treatment treatment, _) => treatment.glucose,
            markerSettings: const MarkerSettings(height: 15, width: 15),
            name: "treatment");

    return <ScatterSeries<dynamic, DateTime>>[
      bloodGlucoseValues,
      notesValues,
    ];
  }
}
