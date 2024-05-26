import 'package:flutter/material.dart';

class ThemeManager {
  static ThemeData currentTheme = ThemeData.light(); // Tema predeterminado

  static void applyTheme(BuildContext context, int index) {
    switch (index) {
      case 0:
        currentTheme = ThemeData.light();
        break;
      case 1:
        currentTheme = ThemeData.dark();
        break;
      case 2:
        currentTheme =
        MediaQuery.of(context).platformBrightness == Brightness.dark
            ? ThemeData.light()
            : ThemeData.dark();
        break;
      default:
        currentTheme = ThemeData.light();
    }
  }
}
