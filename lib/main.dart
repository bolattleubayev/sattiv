import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../screens/readings_screen.dart';
import '../screens/settings_screen.dart';
import '../screens/calibrations_screen.dart';
import '../custom_theme.dart';
import '../widgets/custom_app_bar.dart';
import '../view_models/calibrations_view_model.dart';
import '../view_models/user_settings_view_model.dart';
import '../view_models/db_view_model.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<UserSettingsViewModel>(
            create: (_) => UserSettingsViewModel()),
        ChangeNotifierProvider<CalibrationsViewModel>(
            create: (_) => CalibrationsViewModel()),
        // ChangeNotifierProvider<DBViewModel>(create: (_) => DBViewModel()),
        ChangeNotifierProxyProvider<UserSettingsViewModel, DBViewModel>(
          create: (_) => DBViewModel(),
          update: (_, userSettingsViewModel, readingsViewModel) =>
              readingsViewModel!
                ..updateUserSettings(
                    userSettingsViewModel.userSettings.preferredDisplayInterval,
                    userSettingsViewModel.userSettings.isMmolL),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: CustomTheme.darkTheme,
        home: const MyStatefulWidget(),
      ),
    );
  }
}

class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({Key? key}) : super(key: key);

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  // bottom app bar controls
  int _selectedIndex = 0;

  List<BottomNavigationBarItem> buildBottomNavBarItems() {
    return [
      const BottomNavigationBarItem(
        icon: Icon(Icons.bloodtype),
        label: 'Readings',
      ),
      const BottomNavigationBarItem(
        icon: Icon(Icons.touch_app_rounded),
        label: 'Calibrations',
      ),
      const BottomNavigationBarItem(
        icon: Icon(Icons.settings),
        label: 'Settings',
      ),
    ];
  }

  final PageController _pageController = PageController(
    initialPage: 0,
    keepPage: true,
  );

  void _pageChanged(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget _buildPageView() {
    return PageView(
      controller: _pageController,
      onPageChanged: (index) {
        _pageChanged(index);
      },
      children: const <Widget>[
        ReadingsScreen(),
        CalibrationsScreen(),
        SettingsScreen(),
      ],
    );
  }

  void _bottomTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _pageController.animateToPage(index,
          duration: const Duration(milliseconds: 500), curve: Curves.ease);
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
      // backgroundColor: CupertinoColors.darkBackgroundGray,
      appBar: const CustomAppBar(
        title: "SattiV",
      ),
      body: Center(
        child: _buildPageView(),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          _bottomTapped(index);
        },
        items: buildBottomNavBarItems(),
        selectedItemColor: Theme.of(context).primaryColor,
      ),
    );
  }
}
