import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/calibrations_plot.dart';
import '../view_models/calibrations_view_model.dart';

class CalibrationsScreen extends StatefulWidget {
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
      children: const [
        Expanded(
          child: CalibrationsPlot(),
        ),
      ],
    );
  }
}
