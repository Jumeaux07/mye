import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ThemeService {
  // Définition de la MaterialColor complète
  static const MaterialColor primaryColor = MaterialColor(
    0xFFCBA948,
    <int, Color>{
      50: Color(0xFFF7F2E2),
      100: Color(0xFFEBDFB6),
      200: Color(0xFFDECA86),
      300: Color(0xFFD1B556),
      400: Color(0xFFC7A532),
      500: Color(0xFFCBA948), // Votre couleur principale
      600: Color(0xFFBE9E3E),
      700: Color(0xFFB49235),
      800: Color(0xFFAA862D),
      900: Color(0xFF9B721F),
    },
  );

  // Thème clair
  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true, // Recommandé pour Material 3
    brightness: Brightness.light,
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: AppBarTheme(
      backgroundColor: primaryColor, // Utilisez votre couleur primaire
      elevation: 0,
      iconTheme: const IconThemeData(color: Colors.white),
      titleTextStyle: const TextStyle(
        color: Colors.white,
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    ),
    fontFamily: "Inter",
    colorScheme: ColorScheme.fromSeed(
      seedColor: primaryColor, // Utilisez votre couleur primaire
      brightness: Brightness.light,
    ),
    cardTheme: CardTheme(
      color: Colors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    ),
    iconTheme: IconThemeData(color: Colors.white),
  );

  // Thème sombre
  static final ThemeData darkTheme = ThemeData(
    useMaterial3: true, // Recommandé pour Material 3
    brightness: Brightness.dark,
    scaffoldBackgroundColor: Colors.grey[900],
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.grey[850],
      elevation: 0,
      iconTheme: const IconThemeData(color: Colors.white),
      titleTextStyle: const TextStyle(
        color: Colors.white,
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    ),
    fontFamily: "Inter",
    colorScheme: ColorScheme.fromSeed(
      seedColor: primaryColor, // Gardez la même couleur de base
      brightness: Brightness.dark,
    ),
    cardTheme: CardTheme(
      color: Colors.grey[850],
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    ),
    iconTheme: IconThemeData(color: primaryColor),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: Colors.grey[850],
      elevation: 8,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: primaryColor,
      unselectedItemColor: Colors.grey[400],
      selectedLabelStyle: TextStyle(
        fontFamily: "Inter",
        fontSize: 12,
        fontWeight: FontWeight.w600,
      ),
      unselectedLabelStyle: TextStyle(
        fontFamily: "Inter",
        fontSize: 12,
        fontWeight: FontWeight.normal,
      ),
      selectedIconTheme: IconThemeData(
        size: 24,
        color: primaryColor,
      ),
      unselectedIconTheme: IconThemeData(
        size: 24,
        color: Colors.grey[400],
      ),
      showSelectedLabels: true,
      showUnselectedLabels: true,
    ),
  );

  // GetStorage instance
  static final _box = GetStorage();
  static final _key = 'isThemeDark';

  // Sauvegarder le thème
  static saveThemeData(bool isDark) => _box.write(_key, isDark);

  // Charger le thème
  static bool loadThemeData() => _box.read(_key) ?? false;

  // Changer le thème
  static void switchTheme() {
    Get.changeTheme(Get.isDarkMode ? lightTheme : darkTheme);
    saveThemeData(!loadThemeData());
  }
}
