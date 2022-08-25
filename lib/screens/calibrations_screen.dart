import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../widgets/calibrations_plot.dart';
// import '../controllers/calibrations_screen_controller.dart';
import '../view_models/calibrations_view_model.dart';

import '../model/calibration_plot_datapoint.dart';

import '../constants.dart';

class CalibrationsScreen extends StatefulWidget {
  // final CalibrationsScreenController? controller;

  const CalibrationsScreen({Key? key}) : super(key: key);

  @override
  _CalibrationsScreenState createState() => _CalibrationsScreenState();
}

class _CalibrationsScreenState extends State<CalibrationsScreen> {
  @override
  void initState() {
    super.initState();
    final calibrationsViewModel =
        Provider.of<CalibrationsViewModel>(context, listen: false);
    calibrationsViewModel.getCalibrations();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: CalibrationsPlot(),
        ),
      ],
    );
  }
}
