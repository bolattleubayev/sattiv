import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sattiv/model/treatment.dart';
import '../model/entry.dart';
import 'package:sattiv/widgets/bg_scatter_plot.dart';

import 'package:sattiv/widgets/circular_bg_indicator.dart';
import 'package:sattiv/api/api_manager.dart';

class ReadingsScreen extends StatefulWidget {
  const ReadingsScreen({Key? key}) : super(key: key);

  @override
  State<ReadingsScreen> createState() => _ReadingsScreenState();
}

class _ReadingsScreenState extends State<ReadingsScreen> {
  Timer? _refreshTimer;

  final _noteTextController = TextEditingController();

  @override
  void initState() {
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
                    postTreatment(treatment);
                    _noteTextController.text = "";
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

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FutureBuilder(
        future: Future.wait([
          getEntries(
            afterTime: DateTime.now().subtract(
              const Duration(hours: 3),
            ),
          ),
          getTreatments(
            afterTime: DateTime.now().subtract(
              const Duration(hours: 3),
            ),
          ),
        ]),
        builder: (BuildContext ctx, AsyncSnapshot<List<dynamic>> snapshot) {
          if (snapshot.data?[0] == null || snapshot.data?[1] == null) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return ListView(
              children: [
                Center(
                  child: CircularBgIndicator(entry: snapshot.data?[0].first),
                ),
                Center(
                  child: BgScatterPlot(
                    entries: snapshot.data?[0],
                    treatments: snapshot.data?[1],
                  ),
                ),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      _refreshTimer = Timer.periodic(
                          const Duration(seconds: 300),
                          (Timer t) => setState(() {}));
                      setState(() {});
                    },
                    child: const Text("Refresh"),
                  ),
                ),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      Entry lastEntry = snapshot.data?[0].first;

                      Treatment treatment = Treatment.insulinInjection(
                        lastEntry: lastEntry,
                        insulinAmount: _noteTextController.text,
                        unt: "mmol/L",
                      );

                      _displayDialog(
                        context: context,
                        lastBgReading: lastEntry,
                        title: 'Enter insulin amount',
                        treatment: treatment,
                      );
                    },
                    child: const Text("Add insulin note"),
                  ),
                ),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      Entry lastEntry = snapshot.data?[0].first;

                      Treatment treatment = Treatment.note(
                        lastEntry: lastEntry,
                        note: _noteTextController.text,
                        unt: "mmol/L",
                      );

                      _displayDialog(
                        context: context,
                        lastBgReading: lastEntry,
                        title: 'Enter note',
                        treatment: treatment,
                      );
                    },
                    child: const Text("Add text note"),
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    _noteTextController.dispose();
    super.dispose();
  }
}
