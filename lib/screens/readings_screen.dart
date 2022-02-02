import 'dart:async';

import 'package:flutter/material.dart';

import '../widgets/bg_scatter_plot.dart';
import '../widgets/circular_bg_indicator.dart';
import '../widgets/delta_info_panel.dart';
import '../widgets/time_interval_selection_panel.dart';
import '../widgets/treatments_panel.dart';
import '../controllers/readings_screen_controller.dart';

class ReadingsScreen extends StatefulWidget {
  const ReadingsScreen({Key? key}) : super(key: key);

  @override
  State<ReadingsScreen> createState() => _ReadingsScreenState();
}

class _ReadingsScreenState extends State<ReadingsScreen> {
  Timer? _refreshTimer;
  ReadingsScreenController? screenController;
  final _insulinInjectionController = TextEditingController();
  final _noteTextController = TextEditingController();

  @override
  void initState() {
    screenController = ReadingsScreenController();
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
      future: screenController?.getDataFromBackend(),
      builder: (BuildContext ctx, AsyncSnapshot<List<dynamic>> snapshot) {
        if (snapshot.data?[0] == null || snapshot.data?[1] == null) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: CircularBgIndicator(entry: snapshot.data?[0].first),
              ),
              DeltaInfoPanel(entries: snapshot.data?[0]),
              TimeIntervalSelectionPanel(
                screenController:
                    screenController ?? ReadingsScreenController(),
                onChanged: (int? value) {
                  setState(() {
                    screenController?.setDisplayInterval(hours: value);
                  });
                },
              ),
              TreatmentsPanel(
                screenController:
                    screenController ?? ReadingsScreenController(),
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
