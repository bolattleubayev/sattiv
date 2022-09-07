import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/plots/bg_scatter_plot.dart';
import '../widgets/panels/bg_indicator_panel.dart';
import '../widgets/panels/delta_info_panel.dart';
import '../widgets/panels/time_interval_selection_panel.dart';
import '../widgets/panels/treatments_panel.dart';
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
      children: const [
        DeltaInfoPanel(),
        BgValueIndicatorPanel(),
        TimeIntervalSelectionPanel(),
        TreatmentsPanel(),
        BgScatterPlot(),
      ],
    );
  }
}
