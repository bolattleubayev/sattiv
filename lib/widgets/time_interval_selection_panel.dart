import 'package:flutter/material.dart';
import '../controllers/readings_screen_controller.dart';

class TimeIntervalSelectionPanel extends StatelessWidget {
  final ReadingsScreenController? screenController;
  final Function(int?) onChanged;

  const TimeIntervalSelectionPanel({
    Key? key,
    required this.screenController,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int? groupValue = screenController?.getDisplayInterval();
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          HourOption(
            hours: 1,
            groupValue: groupValue,
            onChanged: onChanged,
          ),
          HourOption(
            hours: 3,
            groupValue: groupValue,
            onChanged: onChanged,
          ),
          HourOption(
            hours: 6,
            groupValue: groupValue,
            onChanged: onChanged,
          ),
          HourOption(
            hours: 12,
            groupValue: groupValue,
            onChanged: onChanged,
          ),
          HourOption(
            hours: 24,
            groupValue: groupValue,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}

class HourOption extends StatelessWidget {
  final int hours;
  final int? groupValue;
  final Function(int?) onChanged;

  const HourOption({
    Key? key,
    required this.hours,
    this.groupValue,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Radio<int>(
          activeColor: Theme.of(context).primaryColor,
          value: hours,
          groupValue: groupValue,
          onChanged: onChanged,
        ),
        Text(
          "${hours}h",
          style: Theme.of(context).textTheme.bodyText1,
        ),
      ],
    );
  }
}
