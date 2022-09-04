import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/bg_scatter_plot.dart';
import '../widgets/bg_indicator.dart';
import '../widgets/delta_info_panel.dart';
import '../widgets/time_interval_selection_panel.dart';
import '../widgets/treatments_panel.dart';
import '../view_models/db_view_model.dart';
import '../view_models/user_settings_view_model.dart';

class ReadingsScreen extends StatefulWidget {
  const ReadingsScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<ReadingsScreen> createState() => _ReadingsScreenState();
}

class _ReadingsScreenState extends State<ReadingsScreen> {
  final _insulinInjectionController = TextEditingController();
  final _noteTextController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final userSettingsViewModel =
        Provider.of<UserSettingsViewModel>(context, listen: false);
    userSettingsViewModel.loadDataFromUserDefaults();

    final dbViewModel = Provider.of<DBViewModel>(context, listen: false);
    dbViewModel.initDB();
    dbViewModel.refresher();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const DeltaInfoPanel(),
        const BgValueIndicator(),
        const TimeIntervalSelectionPanel(),
        TreatmentsPanel(
          insulinInjectionController: _insulinInjectionController,
          noteTextController: _noteTextController,
          onComplete: () {
            setState(() {});
          },
        ),
        const BgScatterPlot(),
      ],
    );
  }

  @override
  void dispose() {
    _noteTextController.dispose();
    _insulinInjectionController.dispose();
    super.dispose();
  }
}
