import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../view_models/readings_view_model.dart';
import '../model/entry.dart';
import '../constants.dart';

class BgValueIndicator extends StatelessWidget {
  // final Entry entry;

  const BgValueIndicator({
    Key? key,
    // required this.entry,
  }) : super(key: key);

  Widget putArrow(Entry entry) {
    const double iconSize = 50;
    if (entry.direction == "Flat") {
      return const Icon(
        Icons.arrow_forward_outlined,
        size: iconSize,
      );
    } else if (entry.direction == "FortyFiveUp") {
      return Transform.rotate(
        angle: -45 * math.pi / 180,
        child: const Icon(
          Icons.arrow_forward_outlined,
          size: iconSize,
        ),
      );
    } else if (entry.direction == "SingleUp") {
      return Transform.rotate(
        angle: -90 * math.pi / 180,
        child: const Icon(
          Icons.arrow_forward_outlined,
          size: iconSize,
        ),
      );
    } else if (entry.direction == "FortyFiveDown") {
      return Transform.rotate(
        angle: 45 * math.pi / 180,
        child: const Icon(
          Icons.arrow_forward_outlined,
          size: iconSize,
        ),
      );
    } else if (entry.direction == "SingleDown") {
      return Transform.rotate(
        angle: 90 * math.pi / 180,
        child: const Icon(
          Icons.arrow_forward_outlined,
          size: iconSize,
        ),
      );
    } else {
      return const Icon(
        Icons.autorenew_rounded,
        size: 40,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ReadingsViewModel>(
      builder: (context, viewModel, child) {
        Entry entry = Entry.defaultValues();
        if (viewModel.entries.isNotEmpty) {
          entry = viewModel.entries.first;
        }
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                // TODO: units
                (entry.sgv / 18).toStringAsFixed(1),
                style: Theme.of(context).textTheme.headline1?.copyWith(
                      fontWeight: FontWeight.normal,
                    ),
              ),
              Column(
                children: [
                  Text(
                    kUnits,
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  putArrow(entry),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
