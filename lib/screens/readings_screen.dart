import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/bg_scatter_plot.dart';
import '../widgets/bg_indicator.dart';
import '../widgets/delta_info_panel.dart';
import '../widgets/time_interval_selection_panel.dart';
import '../widgets/treatments_panel.dart';
import '../view_models/readings_view_model.dart';
import '../controllers/readings_screen_controller.dart';

class ReadingsScreen extends StatefulWidget {
  // final ReadingsScreenController? controller;

  const ReadingsScreen({
    Key? key,
    // required this.controller,
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
        // TimeIntervalSelectionPanel(
        //   screenController: widget.controller,
        //   onChanged: (int? value) {
        //     setState(() {
        //       widget.controller?.setDisplayInterval(hours: value);
        //     });
        //   },
        // ),
        // TreatmentsPanel(
        //   screenController: widget.controller,
        //   insulinInjectionController: _insulinInjectionController,
        //   noteTextController: _noteTextController,
        //   timerResetCallback: _resetTimer,
        //   onComplete: () {
        //     setState(() {});
        //   },
        // ),
        // Expanded(
        //   child: BgScatterPlot(
        //     screenController: widget.controller,
        //   ),
        // ),
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
