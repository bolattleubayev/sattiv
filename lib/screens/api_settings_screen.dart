import 'package:flutter/material.dart';

import '../widgets/api_settings_form.dart';
import '../widgets/custom_app_bar.dart';

class ApiSettingsScreen extends StatelessWidget {
  const ApiSettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: CustomAppBar(
        title: "API settings",
      ),
      body: ApiSettingsForm(),
    );
  }
}
