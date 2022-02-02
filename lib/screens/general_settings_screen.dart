import 'package:flutter/material.dart';

import '../widgets/general_settings_form.dart';
import '../widgets/custom_app_bar.dart';

class GeneralSettingsScreen extends StatelessWidget {
  const GeneralSettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: CustomAppBar(
        title: "General settings",
      ),
      body: GeneralSettingsForm(),
    );
  }
}
