import 'package:flutter/material.dart';

ThemeData appTheme = ThemeData(
  useMaterial3: true,
  primaryColor: Colors.white,
  colorScheme: ColorScheme(
    brightness: Brightness.light,
    primary: Colors.white,
    onPrimary: Colors.grey.shade300,
    secondary: Colors.white,
    onSecondary: Colors.grey.shade300,
    error: Colors.red,
    onError: Colors.redAccent,
    surface: Colors.white,
    onSurface: Colors.grey.shade300,
  ),
  scaffoldBackgroundColor: Colors.white,
  appBarTheme: AppBarTheme(
    elevation: 0,
    color: Colors.grey.shade300,
  ),
  dividerTheme: DividerThemeData(
    color: Colors.grey.shade800,
    thickness: 2,
    endIndent: 50,
    indent: 50,
  ),
);
