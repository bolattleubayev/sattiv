import 'package:flutter/material.dart';

import '../model/entry.dart';
import '../controllers/readings_screen_controller.dart';

class TreatmentsPanel extends StatelessWidget {
  final ReadingsScreenController screenController;
  final Entry lastEntry;
  final Function timerResetCallback;
  final Function onComplete;
  final TextEditingController insulinInjectionController;
  final TextEditingController noteTextController;

  const TreatmentsPanel({
    Key? key,
    required this.screenController,
    required this.lastEntry,
    required this.insulinInjectionController,
    required this.noteTextController,
    required this.timerResetCallback,
    required this.onComplete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        IconButton(
          icon: const Icon(Icons.refresh),
          onPressed: () {
            timerResetCallback();
          },
        ),
        IconButton(
          icon: const Icon(Icons.mode),
          onPressed: () {
            screenController.displayDialog(
              context: context,
              lastBgReading: lastEntry,
              treatmentType: "insulin",
              title: 'Enter insulin amount',
              controller: insulinInjectionController,
              onComplete: onComplete,
            );
          },
        ),
        IconButton(
          icon: const Icon(Icons.text_snippet),
          onPressed: () {
            screenController.displayDialog(
              context: context,
              lastBgReading: lastEntry,
              treatmentType: "note",
              title: 'Enter note',
              controller: noteTextController,
              onComplete: onComplete,
            );
          },
        ),
      ],
    );
  }
}
