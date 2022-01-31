import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GeneralSettingsForm extends StatefulWidget {
  const GeneralSettingsForm({Key? key}) : super(key: key);

  @override
  _GeneralSettingsFormState createState() => _GeneralSettingsFormState();
}

class _GeneralSettingsFormState extends State<GeneralSettingsForm> {
  bool? _isMmolL = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  //Loading values on start
  void _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(
      () {
        _isMmolL = (prefs.getBool('isMmolL') ?? true);
      },
    );
  }

  // Save data
  void _saveData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      prefs.setBool('isMmolL', _isMmolL ?? true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const Text("Units: "),
              Row(
                children: [
                  Radio<bool>(
                    value: true,
                    groupValue: _isMmolL,
                    onChanged: (bool? value) {
                      setState(() {
                        _isMmolL = value;
                      });
                    },
                  ),
                  const Text('mmol/L'),
                ],
              ),
              Row(
                children: [
                  Radio<bool>(
                    value: false,
                    groupValue: _isMmolL,
                    onChanged: (bool? value) {
                      setState(() {
                        _isMmolL = value;
                      });
                    },
                  ),
                  const Text('mg/dL'),
                ],
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: ElevatedButton(
              onPressed: () {
                _saveData();
                Navigator.pop(context);
              },
              child: const Text('Save'),
            ),
          ),
        ],
      ),
    );
  }
}
