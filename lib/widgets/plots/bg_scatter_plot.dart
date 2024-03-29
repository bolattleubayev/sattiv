import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:provider/provider.dart';

import '../../view_models/db_view_model.dart';
import '../../view_models/user_settings_view_model.dart';

import '../../model/treatment.dart';
import '../../model/entry.dart';
import '../../model/wave_data_point.dart';
import '../../model/humalog_wave.dart';
import '../../model/cartesian.dart';
import '../../constants.dart';

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
    timePlottedAhead = const Duration(minutes: 15);
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
    return Consumer2<DBViewModel, UserSettingsViewModel>(
      builder: (context, readingsViewModel, userSettingsViewModel, child) {
        return Expanded(
          child: _buildDefaultScatterChart(
            readingsViewModel,
            userSettingsViewModel,
          ),
        );
      },
    );
  }

  /// Returns the default scatter chart.
  SfCartesianChart _buildDefaultScatterChart(
    DBViewModel readingsViewModel,
    UserSettingsViewModel userSettingsViewModel,
  ) {
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
        ..._getSplineSeries(readingsViewModel),
        ..._getScatterSeries(readingsViewModel, userSettingsViewModel),
        ..._getLines(readingsViewModel, userSettingsViewModel),
      ],
    );
  }

  /// Returns the list of chart series which need to render on the spline chart.
  List<SplineSeries<WaveDataPoint, DateTime>> _getSplineSeries(
      DBViewModel readingsViewModel) {
    List<Treatment> insulinInjections = readingsViewModel.treatments
        .where((element) => element.eventType == "insulin")
        .toList();
    List<SplineSeries<WaveDataPoint, DateTime>> returnSeries = [];

    for (Treatment treatment in insulinInjections) {
      returnSeries.add(
        SplineSeries<WaveDataPoint, DateTime>(
          color: kInsulinColor,
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
    DBViewModel readingsViewModel,
    UserSettingsViewModel userSettingsViewModel,
  ) {
    List<Entry> normalBgValues = readingsViewModel.entries.where((element) {
      if (readingsViewModel.isMmolL) {
        return (element.sgvMmolL >=
                userSettingsViewModel.userSettings.lowLimit &&
            element.sgvMmolL <= userSettingsViewModel.userSettings.highLimit);
      }
      return (element.sgv >= userSettingsViewModel.userSettings.lowLimit &&
          element.sgv <= userSettingsViewModel.userSettings.highLimit);
    }).toList();

    List<Entry> lowBgValues = readingsViewModel.entries.where((element) {
      if (readingsViewModel.isMmolL) {
        return (element.sgvMmolL < userSettingsViewModel.userSettings.lowLimit);
      }
      return (element.sgv < userSettingsViewModel.userSettings.lowLimit);
    }).toList();

    List<Entry> highBgValues = readingsViewModel.entries.where((element) {
      if (readingsViewModel.isMmolL) {
        return (element.sgvMmolL >
            userSettingsViewModel.userSettings.highLimit);
      }
      return (element.sgv > userSettingsViewModel.userSettings.highLimit);
    }).toList();

    ScatterSeries<Entry, DateTime> normalBloodGlucoseValues =
        ScatterSeries<Entry, DateTime>(
            dataSource: normalBgValues,
            opacity: 1.0,
            color: kNormalBGColor,
            xValueMapper: (Entry entry, _) => DateTime.parse(entry.dateString),
            yValueMapper: (Entry entry, _) =>
                readingsViewModel.isMmolL ? entry.sgvMmolL : entry.sgv,
            markerSettings: const MarkerSettings(
              height: 10,
              width: 10,
            ),
            name: userSettingsViewModel.userSettings.isMmolL
                ? 'mmol/L'
                : 'mg/dL');

    ScatterSeries<Entry, DateTime> lowBloodGlucoseValues =
        ScatterSeries<Entry, DateTime>(
            dataSource: lowBgValues,
            opacity: 1.0,
            color: kLowBGColor,
            xValueMapper: (Entry entry, _) => DateTime.parse(entry.dateString),
            yValueMapper: (Entry entry, _) =>
                readingsViewModel.isMmolL ? entry.sgvMmolL : entry.sgv,
            markerSettings: const MarkerSettings(
              height: 10,
              width: 10,
            ),
            name: userSettingsViewModel.userSettings.isMmolL
                ? 'mmol/L'
                : 'mg/dL');

    ScatterSeries<Entry, DateTime> highBloodGlucoseValues =
        ScatterSeries<Entry, DateTime>(
            dataSource: highBgValues,
            opacity: 1.0,
            color: kHighBGColor,
            xValueMapper: (Entry entry, _) => DateTime.parse(entry.dateString),
            yValueMapper: (Entry entry, _) =>
                readingsViewModel.isMmolL ? entry.sgvMmolL : entry.sgv,
            markerSettings: const MarkerSettings(
              height: 10,
              width: 10,
            ),
            name: userSettingsViewModel.userSettings.isMmolL
                ? 'mmol/L'
                : 'mg/dL');

    List<Treatment> notes = readingsViewModel.treatments
        .where((element) => element.eventType == "note")
        .toList();

    List<ScatterSeries<Treatment, DateTime>> notesValues = [];
    for (Treatment treatment in notes) {
      notesValues.add(
        ScatterSeries<Treatment, DateTime>(
          dataSource: notes,
          opacity: 1.0,
          color: kNotesColor,
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
    DBViewModel viewModel,
    UserSettingsViewModel userSettingsViewModel,
  ) {
    _highLimit = [
      _GlucoseLimits(
          DateTime.now()
              .subtract(Duration(minutes: ((viewModel.entries.length) * 5))),
          userSettingsViewModel.userSettings.highLimit),
      _GlucoseLimits(DateTime.now().add(timePlottedAhead),
          userSettingsViewModel.userSettings.highLimit),
    ];

    _lowLimit = [
      _GlucoseLimits(
          DateTime.now()
              .subtract(Duration(minutes: ((viewModel.entries.length) * 5))),
          userSettingsViewModel.userSettings.lowLimit),
      _GlucoseLimits(DateTime.now().add(timePlottedAhead),
          userSettingsViewModel.userSettings.lowLimit),
    ];

    return <LineSeries<_GlucoseLimits, DateTime>>[
      _buildLineSeries(
        dataSource: _highLimit,
        name: 'High limit',
        color: kLimitColor,
      ),
      _buildLineSeries(
        dataSource: _lowLimit,
        name: 'Low limit',
        color: kLimitColor,
      ),
    ];
  }
}

class _GlucoseLimits extends Cartesian {
  _GlucoseLimits(DateTime x, double y) : super(x, y);
}
