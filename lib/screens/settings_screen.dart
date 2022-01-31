import 'package:flutter/material.dart';

import './general_settings_screen.dart';
import './api_settings_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        ListTile(
          title: const Text("General settings"),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const GeneralSettingsScreen(),
              ),
            );
          },
        ),
        ListTile(
          title: const Text("API settings"),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ApiSettingsScreen(),
              ),
            );
          },
        ),
      ],
    );
  }
}
