import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../view_models/db_view_model.dart';

class DeltaInfoPanel extends StatefulWidget {
  const DeltaInfoPanel({
    Key? key,
  }) : super(key: key);

  @override
  State<DeltaInfoPanel> createState() => _DeltaInfoPanelState();
}

class _DeltaInfoPanelState extends State<DeltaInfoPanel> {
  Timer? _refreshTimer;

  void _resetTimer() {
    _refreshTimer?.cancel();
    _refreshTimer = Timer.periodic(
      const Duration(seconds: 60),
      (Timer t) => setState(() {}),
    );
  }

  @override
  void initState() {
    _resetTimer();
    super.initState();
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DBViewModel>(
      builder: (context, viewModel, child) {
        List<dynamic> entries = viewModel.entries;

        final bool _moreThanTwoEntries = entries.length > 1 ? true : false;
        if (_moreThanTwoEntries) {
          final Duration _lastReceived = DateTime.now().difference(
            DateTime.parse(entries[0].dateString),
          );
          final int _difference = entries[0].sgv - entries[1].sgv;
          String _diffString;
          // TODO: units
          if (_difference >= 0) {
            _diffString = "+${(_difference / 18).toStringAsFixed(2)}";
          } else {
            _diffString = (_difference / 18).toStringAsFixed(2);
          }

          return Padding(
            padding: const EdgeInsets.only(left: 8.0, top: 8.0, right: 8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "${_lastReceived.inMinutes} minutes ago",
                  style: Theme.of(context).textTheme.headline6,
                ),
                Text(
                  _diffString,
                  style: Theme.of(context).textTheme.headline6,
                ),
              ],
            ),
          );
        } else {
          return Padding(
            padding: const EdgeInsets.only(left: 8.0, top: 8.0, right: 8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "--",
                  style: Theme.of(context).textTheme.headline6,
                ),
                Text(
                  "--",
                  style: Theme.of(context).textTheme.headline6,
                ),
              ],
            ),
          );
        }
      },
    );
  }
}
