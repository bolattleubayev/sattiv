import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class CustomTheme {
  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: CupertinoColors.darkBackgroundGray,
      cardColor: CupertinoColors.systemFill,
      primaryColor: CupertinoColors.systemBlue,
      fontFamily: 'Montserrat',
      iconTheme: const IconThemeData(
        color: CupertinoColors.systemGrey6,
      ),
      textTheme: const TextTheme(
        headline1: TextStyle(
          color: CupertinoColors.systemGrey6,
        ),
        headline2: TextStyle(
          color: CupertinoColors.systemGrey6,
        ),
        headline3: TextStyle(
          color: CupertinoColors.systemGrey6,
        ),
        headline4: TextStyle(
          color: CupertinoColors.systemGrey6,
        ),
        headline5: TextStyle(
          color: CupertinoColors.systemGrey6,
        ),
        headline6: TextStyle(
          color: CupertinoColors.systemGrey6,
        ),
        bodyText1: TextStyle(
          color: CupertinoColors.systemGrey6,
        ),
        bodyText2: TextStyle(
          color: CupertinoColors.systemGrey6,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: CupertinoColors.systemBlue,
        ),
      ),
      buttonTheme: ButtonThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18.0),
        ),
        buttonColor: CupertinoColors.systemBlue,
      ),
    );
  }
}
