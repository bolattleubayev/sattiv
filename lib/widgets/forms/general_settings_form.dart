import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GeneralSettingsForm extends StatefulWidget {
  const GeneralSettingsForm({Key? key}) : super(key: key);

  @override
  _GeneralSettingsFormState createState() => _GeneralSettingsFormState();
}

class _GeneralSettingsFormState extends State<GeneralSettingsForm> {
  bool? _isMmolL = true;
  final _formKey = GlobalKey<FormState>();

  final _lowLimitController = TextEditingController();
  final _highLimitController = TextEditingController();

  double _lowLimit = 3.9;
  double _highLimit = 7.0;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    _lowLimitController.dispose();
    _highLimitController.dispose();
    super.dispose();
  }

  //Loading values on start
  void _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(
      () {
        _isMmolL = (prefs.getBool('isMmolL') ?? true);
        _lowLimit = (prefs.getDouble('lowLimit') ?? 3.9);
        _highLimit = (prefs.getDouble('highLimit') ?? 7.0);

        _lowLimitController.text = _lowLimit.toString();
        _highLimitController.text = _highLimit.toString();
      },
    );
  }

  // Save data
  void _saveData() async {
    final prefs = await SharedPreferences.getInstance();
    _lowLimit = double.parse(_lowLimitController.text);
    _highLimit = double.parse(_highLimitController.text);

    setState(() {
      prefs.setBool('isMmolL', _isMmolL ?? true);

      prefs.setDouble('lowLimit', _lowLimit);
      prefs.setDouble('highLimit', _highLimit);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFormField(
                        keyboardType: TextInputType.number,
                        controller: _lowLimitController,
                        decoration: const InputDecoration(
                          icon: Icon(Icons.download_sharp),
                          hintText: 'Insert low limit',
                          labelText: 'Low limit',
                        ),
                        // The validator receives the text that the user has entered.
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter some text';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        keyboardType: TextInputType.number,
                        controller: _highLimitController,
                        decoration: const InputDecoration(
                          icon: Icon(Icons.upload_sharp),
                          hintText: 'Insert high limit',
                          labelText: 'High limit',
                        ),
                        // The validator receives the text that the user has entered.
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter some text';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    "Units: ",
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                  Row(
                    children: [
                      Radio<bool>(
                        value: true,
                        activeColor: Theme.of(context).primaryColor,
                        groupValue: _isMmolL,
                        onChanged: (bool? value) {
                          setState(() {
                            _isMmolL = value;
                          });
                        },
                      ),
                      Text(
                        'mmol/L',
                        style: Theme.of(context).textTheme.subtitle1,
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Radio<bool>(
                        value: false,
                        activeColor: Theme.of(context).primaryColor,
                        groupValue: _isMmolL,
                        onChanged: (bool? value) {
                          setState(() {
                            _isMmolL = value;
                          });
                        },
                      ),
                      Text(
                        'mg/dL',
                        style: Theme.of(context).textTheme.subtitle1,
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _saveData();
                  Navigator.pop(context);
                }
              },
              child: const Text(
                'Save',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
