import 'dart:async';

import 'package:flutter/material.dart';

import '../widgets/bg_scatter_plot.dart';
import '../widgets/bg_indicator.dart';
import '../widgets/delta_info_panel.dart';
import '../widgets/time_interval_selection_panel.dart';
import '../widgets/treatments_panel.dart';
import '../controllers/readings_screen_controller.dart';

class ReadingsScreen extends StatefulWidget {
  final ReadingsScreenController? controller;

  const ReadingsScreen({
    Key? key,
    required this.controller,
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
    return FutureBuilder(
      future: widget.controller?.getDataFromBackend(),
      builder: (BuildContext ctx, AsyncSnapshot<List<dynamic>?> snapshot) {
        if (snapshot.data?[0] == null || snapshot.data?[1] == null) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              DeltaInfoPanel(entries: snapshot.data?[0]),
              BgValueIndicator(entry: snapshot.data?[0].first),
              TimeIntervalSelectionPanel(
                screenController: widget.controller,
                onChanged: (int? value) {
                  setState(() {
                    widget.controller?.setDisplayInterval(hours: value);
                  });
                },
              ),
              TreatmentsPanel(
                screenController:
                    widget.controller ?? ReadingsScreenController(),
                lastEntry: snapshot.data?[0].first,
                insulinInjectionController: _insulinInjectionController,
                noteTextController: _noteTextController,
                timerResetCallback: _resetTimer,
                onComplete: () {
                  setState(() {});
                },
              ),
              Expanded(
                child: BgScatterPlot(
                  entries: snapshot.data?[0],
                  treatments: snapshot.data?[1],
                  screenController: widget.controller,
                ),
              ),
            ],
          );
        }
      },
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
