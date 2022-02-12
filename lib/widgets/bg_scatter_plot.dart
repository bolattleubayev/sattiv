import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../model/treatment.dart';
import '../model/entry.dart';
import '../model/wave_data_point.dart';
import '../model/humalog_wave.dart';
import '../model/user_settings.dart';
import '../controllers/readings_screen_controller.dart';
import '../constants.dart';

class BgScatterPlot extends StatefulWidget {
  final ReadingsScreenController? screenController;

  const BgScatterPlot({
    Key? key,
    required this.screenController,
  }) : super(key: key);

  @override
  State<BgScatterPlot> createState() => _BgScatterPlotState();
}

class _BgScatterPlotState extends State<BgScatterPlot> {
  late ZoomPanBehavior _zoomPanBehavior;
  late UserSettings userSettings;
  late Duration timePlottedAhead;

  void getUserSettings() {
    userSettings = widget.screenController?.getUserSettings() ??
        UserSettings.defaultValues();
    timePlottedAhead = Duration(hours: userSettings.preferredDisplayInterval);
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

  /// Returns the default scatter chart.
  SfCartesianChart _buildDefaultScatterChart() {
    return SfCartesianChart(
      zoomPanBehavior: _zoomPanBehavior,
      plotAreaBorderWidth: 0,
      primaryXAxis: DateTimeAxis(
        labelIntersectAction: AxisLabelIntersectAction.multipleRows,
        maximum: DateTime.now().add(timePlottedAhead),
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
    List<Treatment> insulinInjections = widget.screenController
            ?.getTreatments()
            ?.where((element) => element.eventType == "insulin")
            .toList() ??
        [];
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
    List<Entry> normalBgValues =
        widget.screenController?.getEntries()?.where((element) {
              if (userSettings.isMmolL) {
                return (element.sgv / 18 >= userSettings.lowLimit &&
                    element.sgv / 18 <= userSettings.highLimit);
              }
              return (element.sgv >= userSettings.lowLimit &&
                  element.sgv <= userSettings.highLimit);
            }).toList() ??
            [];

    List<Entry> lowBgValues =
        widget.screenController?.getEntries()?.where((element) {
              if (userSettings.isMmolL) {
                return (element.sgv / 18 < userSettings.lowLimit);
              }
              return (element.sgv < userSettings.lowLimit);
            }).toList() ??
            [];

    List<Entry> highBgValues =
        widget.screenController?.getEntries()?.where((element) {
              if (userSettings.isMmolL) {
                return (element.sgv / 18 > userSettings.highLimit);
              }
              return (element.sgv > userSettings.highLimit);
            }).toList() ??
            [];

    ScatterSeries<Entry, DateTime> normalBloodGlucoseValues =
        ScatterSeries<Entry, DateTime>(
            dataSource: normalBgValues,
            opacity: 1.0,
            color: Colors.blue,
            xValueMapper: (Entry entry, _) => DateTime.parse(entry.dateString),
            yValueMapper: (Entry entry, _) =>
                userSettings.isMmolL ? entry.sgv / 18 : entry.sgv,
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
                userSettings.isMmolL ? entry.sgv / 18 : entry.sgv,
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
                userSettings.isMmolL ? entry.sgv / 18 : entry.sgv,
            markerSettings: const MarkerSettings(
              height: 10,
              width: 10,
            ),
            name: kUnits);

    List<Treatment> notes = widget.screenController
            ?.getTreatments()
            ?.where((element) => element.eventType == "note")
            .toList() ??
        [];

    List<ScatterSeries<Treatment, DateTime>> notesValues = [];
    for (Treatment treatment in notes) {
      notesValues.add(
        ScatterSeries<Treatment, DateTime>(
          dataSource: notes,
          opacity: 1.0,
          color: Colors.lightGreen,
          xValueMapper: (Treatment treatment, _) =>
              DateTime.parse(treatment.created_at),
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
  List<LineSeries<_GlucoseLimits, DateTime>> _getLines() {
    _highLimit = [
      _GlucoseLimits(
          DateTime.now().subtract(Duration(
              minutes: widget.screenController?.getEntries()?.length ?? 0 * 5)),
          userSettings.highLimit),
      _GlucoseLimits(
          DateTime.now().add(timePlottedAhead), userSettings.highLimit),
    ];

    _lowLimit = [
      _GlucoseLimits(
          DateTime.now().subtract(Duration(
              minutes: widget.screenController?.getEntries()?.length ?? 0 * 5)),
          userSettings.lowLimit),
      _GlucoseLimits(
          DateTime.now().add(timePlottedAhead), userSettings.lowLimit),
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
