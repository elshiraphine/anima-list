import 'package:anima_list/theme/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:anima_list/theme/colors.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      primaryColor: AppColors.lightPrimaryColor,
      scaffoldBackgroundColor: AppColors.lightBackgroundColor,
      cardColor: AppColors.lightSurfaceBackgroundColor,

      colorScheme: const ColorScheme.light(
        primary: AppColors.lightPrimaryColor,
        surface: AppColors.lightSurfaceBackgroundColor,
        background: AppColors.lightBackgroundColor,
        onSurface: AppColors.onLightSurfaceColor,
        onPrimary: AppColors.onLightPrimaryColor,
        onBackground: AppColors.onLightBackgroundColor,
      ).copyWith(background: AppColors.lightBackgroundColor),

      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.lightPrimaryColor,
        foregroundColor: AppColors.onLightPrimaryColor,
      ),

      textTheme: const TextTheme(
        displayLarge: AppTextStyles.displayLarge,
        displayMedium: AppTextStyles.displayMedium,
        titleLarge: AppTextStyles.titleLarge,
        titleMedium: AppTextStyles.titleMedium,
        bodyMedium: AppTextStyles.bodyMedium,
      ),

      fontFamily: 'Inter',

      inputDecorationTheme: const InputDecorationTheme(
        filled: true,
        fillColor: AppColors.lightBackgroundColor,
        border: OutlineInputBorder(),
      ),
    );
  }
}