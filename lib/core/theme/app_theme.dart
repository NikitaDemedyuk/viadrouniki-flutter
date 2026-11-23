import 'package:flutter/material.dart';
import 'package:viadrouniki/core/theme/app_colors.dart';
import 'package:viadrouniki/core/theme/app_extra_colors.dart';
import 'package:viadrouniki/core/theme/app_radius.dart';

/// Material 3 theme with the mobile design system's Android colours, used on
/// every platform, and shapes after the web app, viadrouniki.by.
///
/// The web app sets "SN Pro" as its font, self-hosted from its own build
/// with no public license found, so this theme leaves `fontFamily` unset and
/// falls back to the platform default.
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
    final primary = isDark ? AppColors.primaryDark : AppColors.primaryLight;
    final primaryContainer = isDark
        ? AppColors.primaryContainerDark
        : AppColors.primaryContainerLight;
    final onPrimaryContainer = isDark
        ? AppColors.onPrimaryContainerDark
        : AppColors.onPrimaryContainerLight;
    final colorScheme =
        ColorScheme.fromSeed(
          seedColor: AppColors.brand,
          brightness: brightness,
        ).copyWith(
          primary: primary,
          onPrimary: isDark
              ? AppColors.onPrimaryDark
              : AppColors.onPrimaryLight,
          primaryContainer: primaryContainer,
          onPrimaryContainer: onPrimaryContainer,
          // Material draws the navigation indicator, selected segments and
          // chips and tonal buttons with secondaryContainer; the design
          // draws all of them with the primary container.
          secondaryContainer: primaryContainer,
          onSecondaryContainer: onPrimaryContainer,
          surfaceTint: primary,
          surface: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
          surfaceContainerLow: isDark
              ? AppColors.surfaceContainerLowDark
              : AppColors.surfaceContainerLowLight,
          surfaceContainer: isDark
              ? AppColors.surfaceContainerDark
              : AppColors.surfaceContainerLight,
          surfaceContainerHigh: isDark
              ? AppColors.surfaceContainerHighDark
              : AppColors.surfaceContainerHighLight,
          onSurface: isDark
              ? AppColors.onSurfaceDark
              : AppColors.onSurfaceLight,
          onSurfaceVariant: isDark
              ? AppColors.onSurfaceVariantDark
              : AppColors.onSurfaceVariantLight,
          outline: isDark ? AppColors.outlineDark : AppColors.outlineLight,
          outlineVariant: isDark
              ? AppColors.outlineVariantDark
              : AppColors.outlineVariantLight,
          error: isDark ? AppColors.errorDark : AppColors.errorLight,
          onError: isDark ? AppColors.onErrorDark : AppColors.onErrorLight,
          errorContainer: isDark
              ? AppColors.errorContainerDark
              : AppColors.errorContainerLight,
          onErrorContainer: isDark
              ? AppColors.onErrorContainerDark
              : AppColors.onErrorContainerLight,
        );

    return ThemeData(
      colorScheme: colorScheme,
      extensions: [if (isDark) AppExtraColors.dark else AppExtraColors.light],
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
