import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'colors_manager.dart';

class AppTheme {
  static TextStyle get appBarTitleStyle => TextStyle(
    color: ColorsManager.accentYellow,
    fontSize: 18.sp,
    fontWeight: FontWeight.w500,
  );

  static TextStyle get bodyRegularStyle => TextStyle(
    color: ColorsManager.white,
    fontSize: 15.sp,
    fontWeight: FontWeight.w400,
  );

  static TextStyle get bodySmallStyle => TextStyle(
    color: ColorsManager.white,
    fontSize: 14.sp,
    fontWeight: FontWeight.w400,
  );

  static TextStyle get yellowLinkStyle => TextStyle(
    color: ColorsManager.accentYellow,
    fontSize: 14.sp,
    fontWeight: FontWeight.w400,
  );

  static TextStyle get yellowBoldLinkStyle => TextStyle(
    color: ColorsManager.accentYellow,
    fontSize: 14.sp,
    fontWeight: FontWeight.bold,
  );

  static ButtonStyle get primaryButtonStyle => ElevatedButton.styleFrom(
    backgroundColor: ColorsManager.accentYellow,
    foregroundColor: ColorsManager.primaryDark,
    minimumSize: Size(double.infinity, 55.h),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(14.r),
    ),
    textStyle: TextStyle(
      fontSize: 20.sp,
      fontWeight: FontWeight.bold,
    ),
  );

  static ButtonStyle get googleButtonStyle => ElevatedButton.styleFrom(
    backgroundColor: ColorsManager.accentYellow,
    foregroundColor: ColorsManager.primaryDark,
    minimumSize: Size(double.infinity, 55.h),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(14.r),
    ),
    textStyle: TextStyle(
      fontSize: 16.sp,
      fontWeight: FontWeight.w500,
    ),
  );

  static ThemeData get darkTheme => ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: ColorsManager.primaryDark,
    primaryColor: ColorsManager.accentYellow,
    colorScheme: const ColorScheme.dark(
      primary: ColorsManager.accentYellow,
      onPrimary: ColorsManager.primaryDark,
      surface: ColorsManager.darkGrey,
      onSurface: ColorsManager.white,
      error: ColorsManager.errorRed,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: ColorsManager.primaryDark,
      foregroundColor: ColorsManager.accentYellow,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: appBarTitleStyle,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: ColorsManager.darkGrey,
      contentPadding:
      EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14.r),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14.r),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14.r),
        borderSide:
        BorderSide(color: ColorsManager.accentYellow, width: 1.5.w),
      ),
      hintStyle: bodyRegularStyle,
      prefixIconColor: ColorsManager.white,
      suffixIconColor: ColorsManager.white,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: primaryButtonStyle,
    ),
  );
}