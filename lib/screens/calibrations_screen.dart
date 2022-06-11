import 'package:flutter/material.dart';

import '../widgets/calibrations_plot.dart';
import '../controllers/calibrations_screen_controller.dart';

class CalibrationsScreen extends StatefulWidget {
  final CalibrationsScreenController? controller;

  const CalibrationsScreen({Key? key, required this.controller})
      : super(key: key);

  @override
  _CalibrationsScreenState createState() => _CalibrationsScreenState();
}

class _CalibrationsScreenState extends State<CalibrationsScreen> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: widget.controller?.getDataFromBackend(),
      builder: (BuildContext ctx, AsyncSnapshot<List<dynamic>?> snapshot) {
        if (snapshot.data == null) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: CalibrationsPlot(
                  screenController: widget.controller,
                ),
              ),
            ],
          );
        }
      },
    );
  }
}
