import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/entry.dart';
import '../model/treatment.dart';
import '../model/user_settings.dart';

import '../managers/api_manager.dart';

class ReadingsScreenController {
  UserSettings? userSettings = UserSettings(
    isMmolL: true,
    lowLimit: 3.9,
    highLimit: 7.0,
    preferredDisplayInterval: 1,
  );

  ReadingsScreenController({
    Key? key,
  });

  /// Getters

  int? getDisplayInterval() {
    return userSettings?.preferredDisplayInterval;
  }

  /// Setters

  void setDisplayInterval({required int? hours}) {
    userSettings?.setPreferredDisplayAheadInterval(hours: hours);
  }

  /// API

  Future loadData() async {
    await userSettings?.getSettingsFromUserDefaults();
  }

  void saveData() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt('preferredDisplayInterval',
        userSettings?.preferredDisplayInterval ?? 1);
  }

  Future<List<List<dynamic>>> getDataFromBackend() async {
    await loadData();
    return Future.wait([
      getEntries(
        afterTime: DateTime.now().subtract(
          Duration(hours: userSettings?.preferredDisplayInterval ?? 1),
        ),
      ),
      getTreatments(
        afterTime: DateTime.now().subtract(
          Duration(hours: userSettings?.preferredDisplayInterval ?? 1),
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
              child: treatmentType == "insulin"
                  ? TextField(
                      controller: controller,
                      keyboardType: TextInputType.number,
                    )
                  : TextField(
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
