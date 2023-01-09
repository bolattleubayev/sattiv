import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../view_models/user_settings_view_model.dart';

class TimeIntervalSelectionPanel extends StatelessWidget {
  const TimeIntervalSelectionPanel({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<UserSettingsViewModel>(
      builder: (context, viewModel, child) {
        int groupValue = viewModel.getDisplayInterval();
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            HourOption(
              hours: 3,
              groupValue: groupValue,
              onChanged: (int? value) {
                viewModel.setDisplayInterval(hours: value);
              },
            ),
            HourOption(
              hours: 6,
              groupValue: groupValue,
              onChanged: (int? value) {
                viewModel.setDisplayInterval(hours: value);
              },
            ),
            HourOption(
              hours: 12,
              groupValue: groupValue,
              onChanged: (int? value) {
                viewModel.setDisplayInterval(hours: value);
              },
            ),
            HourOption(
              hours: 24,
              groupValue: groupValue,
              onChanged: (int? value) {
                viewModel.setDisplayInterval(hours: value);
              },
            ),
          ],
        );
      },
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
