import 'package:flutter/material.dart';

class CustomTheme {
  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: Colors.lightGreen,
      fontFamily: 'Montserrat',
      buttonTheme: ButtonThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18.0),
        ),
        buttonColor: Colors.amber,
      ),
    );
  }
}
