import 'package:flutter/material.dart';
import 'colors.dart';

ThemeData buildLightTheme() {
  final scheme = ColorScheme(
    brightness: Brightness.light,
    primary: AppColors.primary,
    onPrimary: AppColors.white,
    secondary: AppColors.secondary,
    onSecondary: AppColors.white,
    error: AppColors.error,
    onError: AppColors.white,
    surface: AppColors.white,
    onSurface: AppColors.secondary,
    surfaceVariant: AppColors.background,
    onSurfaceVariant: AppColors.secondary,
    tertiary: AppColors.tertiary,
    onTertiary: AppColors.secondary,
  );

  return ThemeData(
    useMaterial3: true,
    colorScheme: scheme,
    scaffoldBackgroundColor: AppColors.background,
    disabledColor: AppColors.disable,

    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.white,
      foregroundColor: AppColors.secondary,
      elevation: 0,
    ),

    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: AppColors.primary,
      foregroundColor: AppColors.white,
      shape: CircleBorder(),
      elevation: 6,
    ),

    bottomAppBarTheme: const BottomAppBarThemeData(
      color: AppColors.white,
      elevation: 8,
      surfaceTintColor: Colors.transparent,
    ),
  );
}
