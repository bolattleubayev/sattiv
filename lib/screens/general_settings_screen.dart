import 'package:flutter/material.dart';

import '../widgets/general_settings_form.dart';

class GeneralSettingsScreen extends StatelessWidget {
  const GeneralSettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("General settings"),
      ),
      body: const GeneralSettingsForm(),
    );
  }
}
