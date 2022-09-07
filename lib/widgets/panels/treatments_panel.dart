import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../view_models/db_view_model.dart';
import '../../model/treatment.dart';

import '../../constants.dart';

class TreatmentsPanel extends StatefulWidget {
  const TreatmentsPanel({
    Key? key,
  }) : super(key: key);

  @override
  State<TreatmentsPanel> createState() => _TreatmentsPanelState();
}

class _TreatmentsPanelState extends State<TreatmentsPanel> {
  TimeOfDay _selectedTime = TimeOfDay.now();
  final _insulinInjectionController = TextEditingController();
  final _noteTextController = TextEditingController();

  displayDialog({
    required BuildContext context,
    required DBViewModel viewModel,
    required String title,
    required String treatmentType,
    required TextEditingController controller,
  }) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, setState) {
          return CupertinoAlertDialog(
            title: Text(
              title,
            ),
            content: Column(
              children: [
                Column(
                  children: [
                    Card(
                      child: TextField(
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          filled: true,
                          fillColor: Colors.white10,
                        ),
                        controller: controller,
                        keyboardType: treatmentType == "insulin"
                            ? const TextInputType.numberWithOptions(
                                signed: false, decimal: true)
                            : null,
                      ),
                    ),
                    // SizedBox(
                    //   height: 150,
                    //   child: CupertinoDatePicker(
                    //     mode: CupertinoDatePickerMode.time,
                    //     onDateTimeChanged: (value) async {
                    //       final TimeOfDay? timeOfDay = await showTimePicker(
                    //         context: context,
                    //         initialTime: _selectedTime,
                    //         initialEntryMode: TimePickerEntryMode.dial,
                    //       );
                    //       if (timeOfDay != null &&
                    //           timeOfDay != _selectedTime) {
                    //         setState(() {
                    //           _selectedTime = vlaue;
                    //         });
                    //       }
                    //     },
                    //     initialDateTime: DateTime.now(),
                    //   ),
                    // ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Icon(Icons.access_time_filled_outlined),
                        TextButton(
                          onPressed: () async {
                            final TimeOfDay? timeOfDay = await showTimePicker(
                              context: context,
                              initialTime: _selectedTime,
                              initialEntryMode: TimePickerEntryMode.input,
                            );
                            if (timeOfDay != null &&
                                timeOfDay != _selectedTime) {
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
                      ],
                    ),
                  ],
                ),
              ],
            ),
            actions: [
              CupertinoDialogAction(
                  child: const Text('Save'),
                  onPressed: () {
                    if (treatmentType == "insulin") {
                      Treatment treatment = Treatment.insulinInjection(
                        // TODO: handle null
                        lastEntry: viewModel.entries.first,
                        insulinAmount: controller.text,
                        treatmentTime: timeOfDayToDateTime(_selectedTime),
                        // TODO: units
                        unt: "mmol/L",
                      );
                      viewModel.postNewTreatment(treatment);
                    } else if (treatmentType == "note") {
                      Treatment treatment = Treatment.note(
                        // TODO: handle null
                        lastEntry: viewModel.entries.first,
                        note: controller.text,
                        treatmentTime: timeOfDayToDateTime(_selectedTime),
                        // TODO: units
                        unt: "mmol/L",
                      );
                      viewModel.postNewTreatment(treatment);
                    }
                    controller.text = "";
                    Navigator.pop(context);
                  }),
              CupertinoDialogAction(
                  child: const Text('Cancel'),
                  onPressed: () {
                    Navigator.pop(context);
                  }),
            ],
          );
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DBViewModel>(
      builder: (context, viewModel, child) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () {
                viewModel.getDataFromDB();
              },
            ),
            IconButton(
              icon: const Icon(Icons.undo),
              onPressed: () {
                // TODO: add safety on removal
                viewModel.undoLastTreatmentInApi();
              },
            ),
            IconButton(
              icon: const Icon(Icons.mode),
              onPressed: () {
                displayDialog(
                  context: context,
                  viewModel: viewModel,
                  treatmentType: "insulin",
                  title: 'Enter insulin amount',
                  controller: _insulinInjectionController,
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.text_snippet),
              onPressed: () {
                displayDialog(
                  context: context,
                  viewModel: viewModel,
                  treatmentType: "note",
                  title: 'Enter note',
                  controller: _noteTextController,
                );
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _noteTextController.dispose();
    _insulinInjectionController.dispose();
    super.dispose();
  }
}
