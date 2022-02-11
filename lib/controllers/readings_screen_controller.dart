import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/entry.dart';
import '../model/treatment.dart';
import '../model/user_settings.dart';

import '../managers/api_manager.dart';

class ReadingsScreenController {
  List<List<dynamic>>? _backendData;
  List<Entry>? _entries;
  List<Treatment>? _treatments;

  final UserSettings? _userSettings = UserSettings.defaultValues();

  /// Getters

  int? getDisplayInterval() {
    return _userSettings?.preferredDisplayInterval;
  }

  UserSettings? getUserSettings() {
    return _userSettings;
  }

  List<Entry>? getEntries() {
    return _entries;
  }

  List<Treatment>? getTreatments() {
    return _treatments;
  }

  /// Setters

  void setDisplayInterval({required int? hours}) {
    _userSettings?.setPreferredDisplayAheadInterval(hours: hours);
  }

  /// API

  Future loadData() async {
    await _userSettings?.getSettingsFromUserDefaults();
  }

  void saveData() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt('preferredDisplayInterval',
        _userSettings?.preferredDisplayInterval ?? 1);
  }

  Future<List<List<dynamic>>?> getDataFromBackend() async {
    await loadData();

    _entries = await getEntriesFromApi(
      afterTime: DateTime.now().subtract(
        Duration(hours: _userSettings?.preferredDisplayInterval ?? 1),
      ),
    );

    _treatments = await getTreatmentsFromApi(
      afterTime: DateTime.now().subtract(
        Duration(hours: _userSettings?.preferredDisplayInterval ?? 1),
      ),
    );

    _backendData = [_entries, _treatments].cast<List>();
    return _backendData;
  }

  /// Element controllers

  displayDialog({
    required BuildContext context,
    required String title,
    required String treatmentType,
    required TextEditingController controller,
    required Function onComplete,
  }) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: Text(
            title,
            style: Theme.of(context).textTheme.bodyText1,
          ),
          children: [
            Padding(
              padding: const EdgeInsets.all(15.0),
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    if (treatmentType == "insulin") {
                      Treatment treatment = Treatment.insulinInjection(
                        // TODO: handle null
                        lastEntry: _entries!.first,
                        insulinAmount: controller.text,
                        // TODO: units
                        unt: "mmol/L",
                      );
                      postTreatment(treatment);
                    } else if (treatmentType == "note") {
                      Treatment treatment = Treatment.note(
                        // TODO: handle null
                        lastEntry: _entries!.first,
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
      },
    );
    onComplete();
  }
}
