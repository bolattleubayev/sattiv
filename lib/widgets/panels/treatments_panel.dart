import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../../view_models/db_view_model.dart';
import '../../model/treatment.dart';

class TreatmentsPanel extends StatefulWidget {
  const TreatmentsPanel({
    Key? key,
  }) : super(key: key);

  @override
  State<TreatmentsPanel> createState() => _TreatmentsPanelState();
}

class _TreatmentsPanelState extends State<TreatmentsPanel> {
  DateTime _selectedTime = DateTime.now();
  final _insulinInjectionController = TextEditingController();
  final _noteTextController = TextEditingController();

  void _showTimePickerDialog(Widget child) {
    showCupertinoModalPopup<void>(
        context: context,
        builder: (BuildContext context) => Container(
              height: 216,
              padding: const EdgeInsets.only(top: 6.0),
              // The Bottom margin is provided to align the popup above the system navigation bar.
              margin: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              // Provide a background color for the popup.
              color: CupertinoColors.systemBackground.resolveFrom(context),
              // Use a SafeArea widget to avoid system overlaps.
              child: SafeArea(
                top: false,
                child: child,
              ),
            ));
  }

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
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Card(
                      child: TextField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: const BorderSide(
                              width: 0,
                              style: BorderStyle.none,
                            ),
                          ),
                          filled: true,
                          fillColor: const Color.fromRGBO(44, 44, 46, 1),
                          hintText: treatmentType == "insulin"
                              ? "Insulin amount"
                              : "Note",
                          isDense: true,
                        ),
                        controller: controller,
                        keyboardType: treatmentType == "insulin"
                            ? const TextInputType.numberWithOptions(
                                signed: false, decimal: true)
                            : null,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 6.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          const Icon(Icons.access_time_filled_outlined),
                          CupertinoButton(
                            onPressed: () => _showTimePickerDialog(
                              CupertinoTheme(
                                data: const CupertinoThemeData(
                                  brightness: Brightness.dark,
                                  textTheme: CupertinoTextThemeData(
                                    dateTimePickerTextStyle: TextStyle(
                                      color: CupertinoColors.white,
                                    ),
                                  ),
                                ),
                                child: CupertinoDatePicker(
                                  mode: CupertinoDatePickerMode.time,
                                  onDateTimeChanged: (value) async {
                                    setState(() {
                                      _selectedTime = value;
                                    });
                                  },
                                ),
                              ),
                            ),
                            child: Text(
                              DateFormat('kk:mm').format(_selectedTime),
                              style: Theme.of(context).textTheme.button,
                            ),
                          ),
                        ],
                      ),
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
                        lastEntry: viewModel.lastEntry,
                        insulinAmount: controller.text,
                        treatmentTime: _selectedTime,
                        unt: viewModel.isMmolL ? "mmol/L" : "mg/dL",
                      );
                      viewModel.postNewTreatment(treatment);
                    } else if (treatmentType == "note") {
                      Treatment treatment = Treatment.note(
                        lastEntry: viewModel.lastEntry,
                        note: controller.text,
                        treatmentTime: _selectedTime,
                        unt: viewModel.isMmolL ? "mmol/L" : "mg/dL",
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
                  title: 'Enter treatment',
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
