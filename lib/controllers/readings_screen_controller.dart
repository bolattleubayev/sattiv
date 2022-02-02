import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/entry.dart';
import '../model/treatment.dart';

import '../managers/api_manager.dart';

class ReadingsScreenController {
  int? _displayIntervalHours = 1;
  Timer? _refreshTimer;

  ReadingsScreenController({
    Key? key,
  });

  /// Getters

  int? getDisplayInterval() {
    return _displayIntervalHours;
  }

  /// Setters

  void setDisplayInterval({required int? hours}) {
    _displayIntervalHours = hours;
    saveData();
  }

  /// API

  Future loadData() async {
    final prefs = await SharedPreferences.getInstance();
    _displayIntervalHours = (prefs.getInt('preferredDisplayInterval') ?? 1);
  }

  void saveData() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt('preferredDisplayInterval', _displayIntervalHours ?? 1);
  }

  Future<List<List<dynamic>>> getDataFromBackend() async {
    await loadData();

    return Future.wait([
      getEntries(
        afterTime: DateTime.now().subtract(
          Duration(hours: _displayIntervalHours ?? 1),
        ),
      ),
      getTreatments(
        afterTime: DateTime.now().subtract(
          Duration(hours: _displayIntervalHours ?? 1),
        ),
      ),
    ]);
  }

  /// Element controllers

  displayDialog({
    required BuildContext context,
    required Entry lastBgReading,
    required String title,
    required String treatmentType,
    required TextEditingController controller,
    required Function onComplete,
  }) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: Text(title),
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: controller,
              ),
            ),
            Row(
              children: [
                SimpleDialogOption(
                  onPressed: () {
                    if (treatmentType == "insulin") {
                      Treatment treatment = Treatment.insulinInjection(
                        lastEntry: lastBgReading,
                        insulinAmount: controller.text,
                        // TODO: units
                        unt: "mmol/L",
                      );
                      postTreatment(treatment);
                    } else if (treatmentType == "note") {
                      Treatment treatment = Treatment.note(
                        lastEntry: lastBgReading,
                        note: controller.text,
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
                SimpleDialogOption(
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
      },
    );
    onComplete();
  }
}
