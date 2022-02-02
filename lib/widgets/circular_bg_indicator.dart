import 'package:flutter/material.dart';
import 'dart:math' as math;

import '../model/entry.dart';
import '../constants.dart';

class CircularBgIndicator extends StatelessWidget {
  final Entry entry;

  const CircularBgIndicator({
    Key? key,
    required this.entry,
  }) : super(key: key);

  Widget putArrow(Entry entry) {
    const double iconSize = 30;
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
    return Container(
      decoration: ShapeDecoration(
        color: Theme.of(context).primaryColor,
        shape: const CircleBorder(),
      ),
      child: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              // TODO: units
              (entry.sgv / 18).toStringAsFixed(1),
              style: Theme.of(context).textTheme.headline3,
            ),
            Text(
              kUnits,
              style: Theme.of(context).textTheme.bodyText1,
            ),
            putArrow(entry),
          ],
        ),
      ),
    );
  }
}
