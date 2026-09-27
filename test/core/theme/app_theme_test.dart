import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:viadrouniki/core/theme/app_colors.dart';
import 'package:viadrouniki/core/theme/app_radius.dart';
import 'package:viadrouniki/core/theme/app_theme.dart';

void main() {
  group('AppTheme', () {
    test('light theme uses the web app light tokens', () {
      final theme = AppTheme.light();

      expect(theme.brightness, Brightness.light);
      expect(theme.colorScheme.primary, AppColors.primary);
      expect(theme.colorScheme.secondary, AppColors.gold);
      expect(theme.colorScheme.surface, AppColors.surfaceLight);
      expect(theme.scaffoldBackgroundColor, AppColors.backgroundLight);
    });

    test('dark theme uses the web app dark tokens', () {
      final theme = AppTheme.dark();

      expect(theme.brightness, Brightness.dark);
      expect(theme.colorScheme.primary, AppColors.primary);
      expect(theme.colorScheme.secondary, AppColors.gold);
      expect(theme.colorScheme.surface, AppColors.surfaceDark);
      expect(theme.scaffoldBackgroundColor, AppColors.backgroundDark);
    });

    test('containers stay neutral instead of taking the seed tint', () {
      final light = AppTheme.light().colorScheme;
      expect(light.surfaceContainerLowest, AppColors.surfaceLight);
      expect(light.surfaceContainerLow, AppColors.surfaceLight);
      expect(light.surfaceContainerHigh, AppColors.surfaceLight);

      final dark = AppTheme.dark().colorScheme;
      expect(dark.surfaceContainerLowest, AppColors.backgroundDark);
      expect(dark.surfaceContainerLow, AppColors.surfaceDark);
      expect(dark.surfaceContainerHigh, AppColors.surfaceElevatedDark);
    });

    for (final theme in [AppTheme.light(), AppTheme.dark()]) {
      final scheme = theme.colorScheme;
      test('${scheme.brightness.name} accents meet WCAG AA contrast', () {
        final pairs = {
          'primary': (scheme.primary, scheme.onPrimary),
          'secondary': (scheme.secondary, scheme.onSecondary),
          'tertiary': (scheme.tertiary, scheme.onTertiary),
          'error': (scheme.error, scheme.onError),
        };
        for (final MapEntry(key: role, value: (background, foreground))
            in pairs.entries) {
          expect(
            _contrast(background, foreground),
            greaterThanOrEqualTo(4.5),
            reason: role,
          );
        }
      });
    }

    test('cards use a 12px radius and buttons a 6px radius', () {
      final theme = AppTheme.light();

      final cardShape = theme.cardTheme.shape! as RoundedRectangleBorder;
      expect(cardShape.borderRadius, BorderRadius.circular(AppRadius.card));

      final buttonShape =
          theme.elevatedButtonTheme.style!.shape!.resolve({})!
              as RoundedRectangleBorder;
      expect(
        buttonShape.borderRadius,
        BorderRadius.circular(AppRadius.control),
      );
    });
  });
}

double _contrast(Color a, Color b) {
  final la = a.computeLuminance();
  final lb = b.computeLuminance();
  return (max(la, lb) + 0.05) / (min(la, lb) + 0.05);
}
