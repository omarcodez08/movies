import 'package:flutter/material.dart';
import 'colors_manager.dart';

class AppTheme {
  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: ColorsManager.primaryDark,
    primaryColor: ColorsManager.accentYellow,
    colorScheme:  ColorScheme.dark(
      primary: ColorsManager.accentYellow,
      surface: ColorsManager.darkGrey,
      error: ColorsManager.errorRed,
    ),
    appBarTheme:  AppBarTheme(
      backgroundColor: ColorsManager.primaryDark,
      foregroundColor: ColorsManager.accentYellow,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: TextStyle(
        color: ColorsManager.accentYellow,
        fontSize: 18,
        fontWeight: FontWeight.w500,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: ColorsManager.darkGrey,
      contentPadding:  EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide:  BorderSide(color: ColorsManager.accentYellow, width: 1.5),
      ),
      hintStyle: const TextStyle(color: ColorsManager.white, fontSize: 15),
      prefixIconColor: ColorsManager.white,
      suffixIconColor: ColorsManager.white,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: ColorsManager.accentYellow,
        foregroundColor: ColorsManager.primaryDark,
        minimumSize: const Size(double.infinity, 54),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        textStyle: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
  );
}