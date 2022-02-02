import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/treatment.dart';
import '../model/entry.dart';
import '../widgets/bg_scatter_plot.dart';
import '../widgets/circular_bg_indicator.dart';
import '../widgets/delta_info_panel.dart';
import '../managers/api_manager.dart';

class ReadingsScreen extends StatefulWidget {
  const ReadingsScreen({Key? key}) : super(key: key);

  @override
  State<ReadingsScreen> createState() => _ReadingsScreenState();
}

class _ReadingsScreenState extends State<ReadingsScreen> {
  Timer? _refreshTimer;

  final _noteTextController = TextEditingController();
  int? _displayIntervalHours = 1;

  @override
  void initState() {
    _refreshTimer?.cancel();
    _refreshTimer = Timer.periodic(
      const Duration(seconds: 300),
      (Timer t) => setState(
        () {
          getEntries(
            afterTime: DateTime.now().subtract(
              const Duration(hours: 3),
            ),
          );
        },
      ),
    );
    _loadData();
    super.initState();
  }

  _displayDialog({
    required BuildContext context,
    required Entry lastBgReading,
    required String title,
    required Treatment treatment,
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
                controller: _noteTextController,
              ),
            ),
            Row(
              children: [
                SimpleDialogOption(
                  onPressed: () {
                    // print(treatment.insulin);
                    postTreatment(treatment);
                    // _noteTextController.text = "";
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

    setState(() {});
  }

  //Loading values on start
  void _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(
      () {
        _displayIntervalHours = (prefs.getInt('preferredDisplayInterval') ?? 1);
      },
    );
  }

  void _saveData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      prefs.setInt('preferredDisplayInterval', _displayIntervalHours ?? 1);
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Future.wait([
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
      ]),
      builder: (BuildContext ctx, AsyncSnapshot<List<dynamic>> snapshot) {
        if (snapshot.data?[0] == null || snapshot.data?[1] == null) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: CircularBgIndicator(entry: snapshot.data?[0].first),
              ),
              DeltaInfoPanel(entries: snapshot.data?[0]),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Row(
                    children: [
                      Radio<int>(
                        activeColor: Theme.of(context).primaryColor,
                        value: 1,
                        groupValue: _displayIntervalHours,
                        onChanged: (int? value) {
                          setState(() {
                            _displayIntervalHours = value;
                          });
                          _saveData();
                        },
                      ),
                      const Text('1h'),
                    ],
                  ),
                  Row(
                    children: [
                      Radio<int>(
                        activeColor: Theme.of(context).primaryColor,
                        value: 3,
                        groupValue: _displayIntervalHours,
                        onChanged: (int? value) {
                          setState(() {
                            _displayIntervalHours = value;
                          });
                          _saveData();
                        },
                      ),
                      const Text('3h'),
                    ],
                  ),
                  Row(
                    children: [
                      Radio<int>(
                        activeColor: Theme.of(context).primaryColor,
                        value: 6,
                        groupValue: _displayIntervalHours,
                        onChanged: (int? value) {
                          setState(() {
                            _displayIntervalHours = value;
                          });
                          _saveData();
                        },
                      ),
                      const Text('6h'),
                    ],
                  ),
                  Row(
                    children: [
                      Radio<int>(
                        activeColor: Theme.of(context).primaryColor,
                        value: 12,
                        groupValue: _displayIntervalHours,
                        onChanged: (int? value) {
                          setState(() {
                            _displayIntervalHours = value;
                          });
                          _saveData();
                        },
                      ),
                      const Text('12h'),
                    ],
                  ),
                  Row(
                    children: [
                      Radio<int>(
                        activeColor: Theme.of(context).primaryColor,
                        value: 24,
                        groupValue: _displayIntervalHours,
                        onChanged: (int? value) {
                          setState(() {
                            _displayIntervalHours = value;
                          });
                          _saveData();
                        },
                      ),
                      const Text('24h'),
                    ],
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    icon: const Icon(Icons.refresh),
                    onPressed: () {
                      _refreshTimer?.cancel();
                      _refreshTimer = Timer.periodic(
                          const Duration(seconds: 300),
                          (Timer t) => setState(() {}));
                      setState(() {});
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.mode),
                    onPressed: () {
                      Entry lastEntry = snapshot.data?[0].first;

                      print(_noteTextController.text);
                      Treatment treatment = Treatment.insulinInjection(
                        lastEntry: lastEntry,
                        insulinAmount: _noteTextController.text,
                        // TODO: units
                        unt: "mmol/L",
                      );

                      _displayDialog(
                        context: context,
                        lastBgReading: lastEntry,
                        title: 'Enter insulin amount',
                        treatment: treatment,
                      );
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.text_snippet),
                    onPressed: () {
                      Entry lastEntry = snapshot.data?[0].first;

                      Treatment treatment = Treatment.note(
                        lastEntry: lastEntry,
                        note: _noteTextController.text,
                        // TODO: units
                        unt: "mmol/L",
                      );

                      _displayDialog(
                        context: context,
                        lastBgReading: lastEntry,
                        title: 'Enter note',
                        treatment: treatment,
                      );
                    },
                  ),
                ],
              ),
              Expanded(
                child: BgScatterPlot(
                  entries: snapshot.data?[0],
                  treatments: snapshot.data?[1],
                ),
              ),
            ],
          );
        }
      },
    );
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    _noteTextController.dispose();
    super.dispose();
  }
}
