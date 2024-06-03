import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'home/home.dart';
import 'shared/theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarBrightness: Brightness.light,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
        systemNavigationBarDividerColor: Colors.transparent,
      ),
    );
    return MaterialApp(
      themeAnimationDuration: const Duration(milliseconds: 750),
      themeAnimationCurve: Curves.easeInOut,
      title: 'G-Chat',
      theme: appTheme,
      home: const HomePage(),
    );
  }
}
