import 'package:flutter/material.dart';
import 'package:viadrouniki/core/theme/app_colors.dart';

/// Material 3 theme styled after the web app, viadrouniki.by.
///
/// The web app sets "SN Pro" as its font, self-hosted from its own build
/// with no public license confirmed yet, so this theme leaves `fontFamily`
/// unset and falls back to the platform default until a licensed source is
/// bundled.
abstract final class AppTheme {
  static ThemeData light() => _theme(brightness: Brightness.light);

  static ThemeData dark() => _theme(brightness: Brightness.dark);

  static ThemeData _theme({required Brightness brightness}) {
    final isDark = brightness == Brightness.dark;
    final colorScheme =
        ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          brightness: brightness,
        ).copyWith(
          primary: AppColors.primary,
          secondary: AppColors.gold,
          tertiary: AppColors.info,
          error: AppColors.error,
          surface: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
          onSurface: isDark
              ? AppColors.onSurfaceDark
              : AppColors.onSurfaceLight,
          onSurfaceVariant: isDark
              ? AppColors.onSurfaceVariantDark
              : AppColors.onSurfaceVariantLight,
          surfaceContainer: isDark
              ? AppColors.surfaceDark
              : AppColors.surfaceLight,
          surfaceContainerHighest: isDark
              ? AppColors.surfaceElevatedDark
              : AppColors.surfaceLight,
        );

    return ThemeData(
      brightness: brightness,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: isDark
          ? AppColors.backgroundDark
          : AppColors.backgroundLight,
      cardTheme: const CardThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
      ),
      inputDecorationTheme: const InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(6)),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(6)),
          ),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(6)),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(6)),
          ),
        ),
      ),
    );
  }
}
