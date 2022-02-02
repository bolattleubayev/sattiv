import 'package:flutter/material.dart';
import '../controllers/readings_screen_controller.dart';

class TimeIntervalSelectionPanel extends StatelessWidget {
  final ReadingsScreenController screenController;
  final Function(int?) onChanged;

  const TimeIntervalSelectionPanel({
    Key? key,
    required this.screenController,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Row(
          children: [
            Radio<int>(
              activeColor: Theme.of(context).primaryColor,
              value: 1,
              groupValue: screenController.getDisplayInterval(),
              onChanged: onChanged,
            ),
            Text(
              '1h',
              style: Theme.of(context).textTheme.bodyText1,
            ),
          ],
        ),
        Row(
          children: [
            Radio<int>(
              activeColor: Theme.of(context).primaryColor,
              value: 3,
              groupValue: screenController.getDisplayInterval(),
              onChanged: onChanged,
            ),
            Text(
              '3h',
              style: Theme.of(context).textTheme.bodyText1,
            ),
          ],
        ),
        Row(
          children: [
            Radio<int>(
              activeColor: Theme.of(context).primaryColor,
              value: 6,
              groupValue: screenController.getDisplayInterval(),
              onChanged: onChanged,
            ),
            Text(
              '6h',
              style: Theme.of(context).textTheme.bodyText1,
            ),
          ],
        ),
        Row(
          children: [
            Radio<int>(
              activeColor: Theme.of(context).primaryColor,
              value: 12,
              groupValue: screenController.getDisplayInterval(),
              onChanged: onChanged,
            ),
            Text(
              '12h',
              style: Theme.of(context).textTheme.bodyText1,
            ),
          ],
        ),
        Row(
          children: [
            Radio<int>(
              activeColor: Theme.of(context).primaryColor,
              value: 24,
              groupValue: screenController.getDisplayInterval(),
              onChanged: onChanged,
            ),
            Text(
              '24h',
              style: Theme.of(context).textTheme.bodyText1,
            ),
          ],
        ),
      ],
    );
  }
}
