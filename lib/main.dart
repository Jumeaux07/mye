import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'screens/introdutions/main_intro.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme:
          ThemeData(fontFamily: "Poppins", colorSchemeSeed: Color(0xFFCBA948)),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          child: MainIntro(),
        ),
      ),
    );
  }
}
