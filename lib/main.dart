import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../screens/readings_screen.dart';
import '../screens/settings_screen.dart';
import '../screens/calibrations_screen.dart';
import '../custom_theme.dart';
import '../widgets/custom_app_bar.dart';
import '../controllers/readings_screen_controller.dart';
import '../controllers/calibrations_screen_controller.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: CustomTheme.darkTheme,
      home: const MyStatefulWidget(),
    );
  }
}

class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({Key? key}) : super(key: key);

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  // set up controllers for the reading screen
  ReadingsScreenController readingsScreenController =
      ReadingsScreenController();
  CalibrationsScreenController calibrationsScreenController =
      CalibrationsScreenController();

  // bottom app bar controls
  int _selectedIndex = 0;
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: "SattiV",
      ),
      body: Center(
        child: <Widget>[
          ReadingsScreen(
            controller: readingsScreenController,
          ),
          CalibrationsScreen(
            controller: calibrationsScreenController,
          ),
          const SettingsScreen(),
        ].elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.bloodtype),
            label: 'Readings',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.touch_app_rounded),
            label: 'Calibrations',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Theme.of(context).primaryColor,
        onTap: _onItemTapped,
      ),
    );
  }
}
