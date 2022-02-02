import 'package:flutter/material.dart';
import '../model/entry.dart';

class DeltaInfoPanel extends StatelessWidget {
  final List<Entry> entries;

  const DeltaInfoPanel({
    Key? key,
    required this.entries,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
        padding: const EdgeInsets.all(8.0),
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
        padding: const EdgeInsets.all(8.0),
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
  }
}
