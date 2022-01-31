import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'package:sattiv/model/entry.dart';
import 'package:sattiv/constants.dart';

class CircularBgIndicator extends StatelessWidget {
  final Entry entry;

  const CircularBgIndicator({
    Key? key,
    required this.entry,
  }) : super(key: key);

  Widget putArrow(Entry entry) {
    const double iconSize = 30;
    const Color iconColor = Colors.black;
    if (entry.direction == "Flat") {
      return const Icon(
        Icons.arrow_forward_outlined,
        size: iconSize,
        color: iconColor,
      );
    } else if (entry.direction == "FortyFiveUp") {
      return Transform.rotate(
        angle: -45 * math.pi / 180,
        child: const Icon(
          Icons.arrow_forward_outlined,
          size: iconSize,
          color: iconColor,
        ),
      );
    } else if (entry.direction == "SingleUp") {
      return Transform.rotate(
        angle: -90 * math.pi / 180,
        child: const Icon(
          Icons.arrow_forward_outlined,
          size: iconSize,
          color: iconColor,
        ),
      );
    } else if (entry.direction == "FortyFiveDown") {
      return Transform.rotate(
        angle: 45 * math.pi / 180,
        child: const Icon(
          Icons.arrow_forward_outlined,
          size: iconSize,
          color: iconColor,
        ),
      );
    } else if (entry.direction == "SingleDown") {
      return Transform.rotate(
        angle: 90 * math.pi / 180,
        child: const Icon(
          Icons.arrow_forward_outlined,
          size: iconSize,
          color: Colors.black,
        ),
      );
    } else {
      return const Icon(
        Icons.cloud_off,
        size: 40,
        color: Colors.black,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const ShapeDecoration(
        color: Colors.green,
        shape: CircleBorder(),
      ),
      child: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              (entry.sgv / 18).toStringAsFixed(1),
              style: Theme.of(context).textTheme.headline3?.copyWith(
                    color: Colors.black,
                  ),
            ),
            Text(
              kUnits,
              style: Theme.of(context).textTheme.bodyText1?.copyWith(
                    color: Colors.black,
                  ),
            ),
            putArrow(entry),
          ],
        ),
      ),
    );
  }
}
