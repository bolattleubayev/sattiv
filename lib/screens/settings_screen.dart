import 'package:flutter/material.dart';

import './general_settings_screen.dart';
import './api_settings_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView(
        children: [
          Card(
            child: ListTile(
              leading: const Icon(Icons.settings),
              trailing: const Icon(Icons.arrow_forward_ios),
              title: Text(
                "General settings",
                style: Theme.of(context).textTheme.button,
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const GeneralSettingsScreen(),
                  ),
                );
              },
            ),
          ),
          Card(
            child: ListTile(
              leading: const Icon(Icons.cloud),
              trailing: const Icon(Icons.arrow_forward_ios),
              title: Text(
                "API settings",
                style: Theme.of(context).textTheme.button,
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ApiSettingsScreen(),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
