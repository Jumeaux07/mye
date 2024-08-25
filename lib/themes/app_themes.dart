import 'package:flutter/material.dart';

import 'app_style.dart';

class AppThemes {
  static ThemeData get light => ThemeData(
      fontFamily: "Poppins",
      primaryColor: mainColor,
      primarySwatch: mainColor,
      scaffoldBackgroundColor: Colors.white,
      appBarTheme: const AppBarTheme(backgroundColor: Colors.white),
      textTheme: const TextTheme(
          headlineLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
          headlineMedium: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          headlineSmall: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
          bodyLarge: TextStyle(fontSize: 14.5),
          bodyMedium: TextStyle(fontSize: 13.5),
          bodySmall: TextStyle(fontSize: 12)));
}
