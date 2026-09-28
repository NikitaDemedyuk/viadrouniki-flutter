import 'package:flutter/material.dart';
import 'package:viadrouniki/core/theme/app_colors.dart';
import 'package:viadrouniki/core/theme/app_radius.dart';

/// Material 3 theme styled after the web app, viadrouniki.by.
///
/// The web app sets "SN Pro" as its font, self-hosted from its own build
/// with no public license confirmed yet, so this theme leaves `fontFamily`
/// unset and falls back to the platform default.
abstract final class AppTheme {
  static final ThemeData light = _theme(brightness: Brightness.light);

  static final ThemeData dark = _theme(brightness: Brightness.dark);

  static const _controlRadius = BorderRadius.all(
    Radius.circular(AppRadius.control),
  );

  static const _controlShape = RoundedRectangleBorder(
    borderRadius: _controlRadius,
  );

  static ThemeData _theme({required Brightness brightness}) {
    final isDark = brightness == Brightness.dark;
    final colorScheme =
        ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          brightness: brightness,
        ).copyWith(
          primary: AppColors.primary,
          onPrimary: AppColors.onAccent,
          surfaceTint: AppColors.primary,
          secondary: AppColors.gold,
          onSecondary: AppColors.onAccent,
          tertiary: AppColors.info,
          onTertiary: AppColors.onAccent,
          error: AppColors.error,
          onError: AppColors.onAccent,
          surface: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
          onSurface: isDark
              ? AppColors.onSurfaceDark
              : AppColors.onSurfaceLight,
          onSurfaceVariant: isDark
              ? AppColors.onSurfaceVariantDark
              : AppColors.onSurfaceVariantLight,
          surfaceContainerLowest: isDark
              ? AppColors.backgroundDark
              : AppColors.surfaceLight,
          surfaceContainerLow: isDark
              ? AppColors.surfaceDark
              : AppColors.surfaceLight,
          surfaceContainer: isDark
              ? AppColors.surfaceDark
              : AppColors.surfaceLight,
          surfaceContainerHigh: isDark
              ? AppColors.surfaceElevatedDark
              : AppColors.surfaceLight,
          surfaceContainerHighest: isDark
              ? AppColors.fillDark
              : AppColors.fillLight,
        );

    return ThemeData(
      colorScheme: colorScheme,
      scaffoldBackgroundColor: isDark
          ? AppColors.backgroundDark
          : AppColors.backgroundLight,
      cardTheme: const CardThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(AppRadius.card)),
        ),
      ),
      inputDecorationTheme: const InputDecorationTheme(
        border: OutlineInputBorder(borderRadius: _controlRadius),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(shape: _controlShape),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(shape: _controlShape),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(shape: _controlShape),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(shape: _controlShape),
      ),
      segmentedButtonTheme: SegmentedButtonThemeData(
        style: SegmentedButton.styleFrom(shape: _controlShape),
      ),
    );
  }
}
