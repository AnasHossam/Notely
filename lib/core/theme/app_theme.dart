import 'package:flutter/material.dart';
import 'package:notely/core/constants/app_constants.dart';
import 'package:notely/core/theme/app_colors.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: AppColors.primaryLightColor,
    scaffoldBackgroundColor: AppColors.backgroundLightColor,
    fontFamily: AppConstants.fontFamily,
    textTheme: const TextTheme(
      titleLarge: TextStyle(
        fontSize: 30,
        fontWeight: FontWeight.bold,
        color: AppColors.textPrimaryLightColor,
      ),
      titleMedium: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: AppColors.textPrimaryLightColor,
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: AppColors.textSecondaryLightColor,
      ),
      bodySmall: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: AppColors.primaryLightColor,
      ),
      labelSmall: TextStyle(
        fontSize: 10,
        fontWeight: FontWeight.bold,
        color: AppColors.backgroundLightColor,
      ),
      bodyLarge: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.normal,
        color: AppColors.textPrimaryLightColor,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.backgroundLightColor,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.borderLightColor),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.borderLightColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide:
            const BorderSide(color: AppColors.primaryLightColor, width: 2),
      ),
      labelStyle: const TextStyle(color: AppColors.textSecondaryLightColor),
      hintStyle: const TextStyle(color: AppColors.textSecondaryLightColor),
      errorStyle: const TextStyle(color: Colors.red),
    ),
    textSelectionTheme: const TextSelectionThemeData(
      cursorColor: AppColors.primaryLightColor,
      selectionColor: Color(0x4D201F26),
      selectionHandleColor: AppColors.primaryLightColor,
    ),
    snackBarTheme: SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      backgroundColor: AppColors.backgroundLightColor,
      contentTextStyle: const TextStyle(color: AppColors.primaryLightColor),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: AppColors.borderLightColor),
      ),
      insetPadding: const EdgeInsets.all(16),
    ),
    iconButtonTheme: IconButtonThemeData(
      style: ButtonStyle(
        iconColor: const WidgetStatePropertyAll(AppColors.iconLightColor),
        side: const WidgetStatePropertyAll(
          BorderSide(color: AppColors.borderLightColor),
        ),
      ),
    ),
  );

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: AppColors.primaryDarkColor,
    scaffoldBackgroundColor: AppColors.backgroundDarkColor,
    fontFamily: AppConstants.fontFamily,
    textTheme: const TextTheme(
      titleLarge: TextStyle(
        fontSize: 30,
        fontWeight: FontWeight.bold,
        color: AppColors.textPrimaryDarkColor,
      ),
      titleMedium: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: AppColors.textPrimaryDarkColor,
      ),
      bodyLarge: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.normal,
        color: AppColors.textPrimaryDarkColor,
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: AppColors.textSecondaryDarkColor,
      ),
      bodySmall: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: AppColors.primaryDarkColor,
      ),
      labelSmall: TextStyle(
        fontSize: 10,
        fontWeight: FontWeight.bold,
        color: AppColors.backgroundLightColor,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.backgroundDarkColor,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.borderDarkColor),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.borderDarkColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide:
            const BorderSide(color: AppColors.primaryDarkColor, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.red, width: 2),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.red, width: 2),
      ),
      labelStyle: const TextStyle(color: AppColors.textSecondaryDarkColor),
      hintStyle: const TextStyle(color: AppColors.textSecondaryDarkColor),
      errorStyle: const TextStyle(color: Colors.red),
    ),
    textSelectionTheme: const TextSelectionThemeData(
      cursorColor: AppColors.primaryDarkColor,
      selectionColor: Color(0x4DECECFD),
      selectionHandleColor: AppColors.primaryDarkColor,
    ),
    snackBarTheme: SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      backgroundColor: AppColors.backgroundDarkColor,
      contentTextStyle: const TextStyle(color: AppColors.primaryDarkColor),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: AppColors.borderDarkColor),
      ),
      insetPadding: const EdgeInsets.all(16),
    ),
    iconButtonTheme: IconButtonThemeData(
      style: ButtonStyle(
        iconColor: const WidgetStatePropertyAll(AppColors.iconDarkColor),
        side: const WidgetStatePropertyAll(
          BorderSide(color: AppColors.borderDarkColor),
        ),
      ),
    ),
  );
}
