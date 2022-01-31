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
      series: _getScatterSeries(),
    );
  }

  List<ScatterSeries<dynamic, DateTime>> _getScatterSeries() {
    ScatterSeries<Entry, DateTime> bloodGlucoseValues =
        ScatterSeries<Entry, DateTime>(
            dataSource: widget.entries,
            opacity: 1.0,
            color: Colors.lightGreenAccent,
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
      ScatterSeries<Treatment, DateTime>(
          dataSource: widget.treatments
              .where((element) => element.eventType == "insulin")
              .toList(),
          opacity: 1.0,
          color: Colors.red,
          xValueMapper: (Treatment treatment, _) =>
              DateTime.parse(treatment.created_at),
          yValueMapper: (Treatment treatment, _) => treatment.glucose,
          markerSettings: const MarkerSettings(height: 15, width: 15),
          name: "insulin"),
    ];
  }
}
