import 'package:flutter/material.dart';

import '../model/treatment.dart';

import '../managers/api_manager.dart';

import '../controllers/readings_screen_controller.dart';

import '../constants.dart';

// TODO this warning
//ignore: must_be_immutable
class TreatmentsPanel extends StatelessWidget {
  final ReadingsScreenController? screenController;
  final Function timerResetCallback;
  final Function onComplete;
  final TextEditingController insulinInjectionController;
  final TextEditingController noteTextController;
  TimeOfDay _selectedTime = TimeOfDay.now();

  TreatmentsPanel({
    Key? key,
    required this.screenController,
    required this.insulinInjectionController,
    required this.noteTextController,
    required this.timerResetCallback,
    required this.onComplete,
  }) : super(key: key);

  displayDialog(
      {required BuildContext context,
      required String title,
      required String treatmentType,
      required TextEditingController controller,
      required Function onComplete}) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, setState) {
          return SimpleDialog(
            title: Text(
              title,
              style: Theme.of(context).textTheme.bodyText1,
            ),
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    TextButton(
                      onPressed: () async {
                        final TimeOfDay? timeOfDay = await showTimePicker(
                          context: context,
                          initialTime: _selectedTime,
                          initialEntryMode: TimePickerEntryMode.dial,
                        );
                        if (timeOfDay != null && timeOfDay != _selectedTime) {
                          setState(() {
                            _selectedTime = timeOfDay;
                          });
                        }
                      },
                      child: Text(
                        _selectedTime.format(context),
                        style: Theme.of(context).textTheme.button,
                      ),
                    ),
                    Expanded(
                      child: TextField(
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                        ),
                        controller: controller,
                        keyboardType: treatmentType == "insulin"
                            ? const TextInputType.numberWithOptions(
                                signed: false, decimal: true)
                            : null,
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      if (treatmentType == "insulin") {
                        Treatment treatment = Treatment.insulinInjection(
                          // TODO: handle null
                          lastEntry: screenController!.getEntries()!.first,
                          insulinAmount: controller.text,
                          treatmentTime: timeOfDayToDateTime(_selectedTime),
                          // TODO: units
                          unt: "mmol/L",
                        );
                        postTreatment(treatment);
                      } else if (treatmentType == "note") {
                        Treatment treatment = Treatment.note(
                          // TODO: handle null
                          lastEntry: screenController!.getEntries()!.first,
                          note: controller.text,
                          treatmentTime: timeOfDayToDateTime(_selectedTime),
                          // TODO: units
                          unt: "mmol/L",
                        );
                        postTreatment(treatment);
                      }
                      controller.text = "";
                      Navigator.pop(context);
                    },
                    child: const Text('Save'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Cancel'),
                  ),
                ],
              ),
            ],
            elevation: 10,
          );
        });
      },
    );
    onComplete();
  }

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
          icon: const Icon(Icons.undo),
          onPressed: () {
            undoLastTreatment();
          },
        ),
        IconButton(
          icon: const Icon(Icons.mode),
          onPressed: () {
            displayDialog(
              context: context,
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
            displayDialog(
              context: context,
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
