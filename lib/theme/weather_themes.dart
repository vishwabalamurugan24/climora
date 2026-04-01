import 'package:flutter/material.dart';

class WeatherThemes {
  static ThemeData sunnyTheme = ThemeData(
    primaryColor: Colors.yellow,
    brightness: Brightness.light,
    scaffoldBackgroundColor: Colors.blue[100],
  );

  static ThemeData rainyTheme = ThemeData(
    primaryColor: Colors.blue,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: Colors.grey[800],
  );

  static ThemeData snowyTheme = ThemeData(
    primaryColor: Colors.white,
    brightness: Brightness.light,
    scaffoldBackgroundColor: Colors.blueGrey[50],
  );

  static ThemeData cloudyTheme = ThemeData(
    primaryColor: Colors.grey,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: Colors.grey[700],
  );
}