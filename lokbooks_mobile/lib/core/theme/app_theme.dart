
import 'package:flutter/material.dart';

import 'app_colors.dart';

abstract final class AppTheme {
  static ThemeData get light {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: AppColors.background,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        brightness: Brightness.light,
        surface: AppColors.background,
      ),
      appBarTheme: const AppBarThemeData(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
      ),
      inputDecorationTheme: const InputDecorationThemeData(
        filled: true,
        fillColor: AppColors.inputBackground,
        border: InputBorder.none,
        contentPadding: EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.button,
          foregroundColor: Colors.white,
          minimumSize: const Size(190, 44),
          shape: const StadiumBorder(),
          textStyle: const TextStyle(
            fontSize: 18,
          ),
        ),
      ),
    );
  }
}
