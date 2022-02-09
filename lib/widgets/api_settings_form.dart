import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:crypto/crypto.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiSettingsForm extends StatefulWidget {
  const ApiSettingsForm({Key? key}) : super(key: key);

  @override
  _ApiSettingsFormState createState() => _ApiSettingsFormState();
}

class _ApiSettingsFormState extends State<ApiSettingsForm> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a GlobalKey<FormState>,
  // not a GlobalKey<MyCustomFormState>.
  final _formKey = GlobalKey<FormState>();

  final _baseUrlController = TextEditingController();
  final _apiSecretController = TextEditingController();

  String _baseUrl = "";
  String _apiSecret = "";

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  // Loading values on start
  void _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(
      () {
        _baseUrl = (prefs.getString('baseUrl') ?? "");
        _apiSecret = (prefs.getString('apiSecret') ?? "");

        _baseUrlController.text = _baseUrl;
        _apiSecretController.text = _apiSecret;
      },
    );
  }

  // Save data
  void _saveData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _baseUrl = _baseUrlController.text;
      _apiSecret = _apiSecretController.text;

      var _bytes = utf8.encode(_apiSecret); // data being hashed
      String _digest = sha1.convert(_bytes).toString();

      prefs.setString('baseUrl', _baseUrl);
      prefs.setString('apiSecret', _apiSecret);
      prefs.setString('apiSecretSha1', _digest);
    });
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    _baseUrlController.dispose();
    _apiSecretController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                TextFormField(
                  controller: _baseUrlController,
                  decoration: const InputDecoration(
                    icon: Icon(Icons.web_asset),
                    hintText: 'Your heroku app link',
                    labelText: 'Base URL',
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
                  controller: _apiSecretController,
                  decoration: const InputDecoration(
                    icon: Icon(Icons.password),
                    hintText: 'Your heroku app password',
                    labelText: 'API secret',
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
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: ElevatedButton(
                onPressed: () {
                  // Validate returns true if the form is valid, or false otherwise.
                  if (_formKey.currentState!.validate()) {
                    _saveData();
                    Navigator.pop(context);
                  }
                },
                child: const Text('Save'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
