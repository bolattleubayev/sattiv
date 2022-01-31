import 'package:flutter/material.dart';

import 'package:sattiv/widgets/api_settings_form.dart';

class ApiSettingsScreen extends StatelessWidget {
  const ApiSettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("API settings"),
      ),
      body: const SettingsForm(),
    );
  }
}
