import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/plots/bg_scatter_plot.dart';
import '../widgets/panels/bg_indicator_panel.dart';
import '../widgets/panels/delta_info_panel.dart';
import '../widgets/panels/time_interval_selection_panel.dart';
import '../widgets/panels/treatments_panel.dart';
import '../view_models/db_view_model.dart';
import '../view_models/user_settings_view_model.dart';
import '../constants.dart';

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
    userSettingsViewModel.loadDataFromUserDefaults().catchError((error) {
      showCupertinoAlertDialog(context, 'Error', error.toString());
    });

    final dbViewModel = Provider.of<DBViewModel>(context, listen: false);
    dbViewModel.initDB().catchError((error) {
      showCupertinoAlertDialog(context, 'Error', error.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const DeltaInfoPanel(),
          const BgValueIndicatorPanel(),
          Expanded(
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: const [
                    TimeIntervalSelectionPanel(),
                    TreatmentsPanel(),
                    BgScatterPlot(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
