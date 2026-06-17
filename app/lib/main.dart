import 'package:flutter/material.dart';

import 'screens/welcome_interface.dart';
import 'themes/light_theme.dart';
import 'themes/dark_theme.dart';
import 'localization/app_text.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  static _MyAppState of(BuildContext context) {
    return context.findAncestorStateOfType<_MyAppState>()!;
  }

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isDarkMode = false;

  void toggleTheme() {
    setState(() {
      isDarkMode = !isDarkMode;
    });
  }

  void changeLanguage(bool arabic) {
    setState(() {
      AppText.isArabic = arabic;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      theme: LightTheme.theme,
      darkTheme: DarkTheme.theme,

      themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,

      home: const WelcomeInterface(),
    );
  }
}
