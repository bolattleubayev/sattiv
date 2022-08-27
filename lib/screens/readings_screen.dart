import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/bg_scatter_plot.dart';
import '../widgets/bg_indicator.dart';
import '../widgets/delta_info_panel.dart';
import '../widgets/time_interval_selection_panel.dart';
import '../widgets/treatments_panel.dart';
import '../view_models/readings_view_model.dart';

class ReadingsScreen extends StatefulWidget {
  const ReadingsScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<ReadingsScreen> createState() => _ReadingsScreenState();
}

class _ReadingsScreenState extends State<ReadingsScreen> {
  Timer? _refreshTimer;

  final _insulinInjectionController = TextEditingController();
  final _noteTextController = TextEditingController();

  @override
  void initState() {
    _resetTimer();
    super.initState();
    final readingsViewModel =
        Provider.of<ReadingsViewModel>(context, listen: false);
    readingsViewModel.getDataFromBackend();
  }

  void _resetTimer() {
    _refreshTimer?.cancel();
    _refreshTimer = Timer.periodic(
      const Duration(seconds: 300),
      (Timer t) => setState(() {}),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const DeltaInfoPanel(),
        const BgValueIndicator(),
        const TimeIntervalSelectionPanel(),
        // TODO: take out text editing controllers and timer
        TreatmentsPanel(
          insulinInjectionController: _insulinInjectionController,
          noteTextController: _noteTextController,
          timerResetCallback: _resetTimer,
          onComplete: () {
            setState(() {});
          },
        ),
        const Expanded(
          child: BgScatterPlot(),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    _noteTextController.dispose();
    _insulinInjectionController.dispose();
    super.dispose();
  }
}
