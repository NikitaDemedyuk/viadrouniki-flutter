import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:viadrouniki/core/theme/app_colors.dart';
import 'package:viadrouniki/core/theme/app_radius.dart';
import 'package:viadrouniki/core/theme/app_theme.dart';

void main() {
  group('AppTheme', () {
    test('light theme uses the web app light tokens', () {
      final theme = AppTheme.light;

      expect(theme.brightness, Brightness.light);
      expect(theme.colorScheme.primary, AppColors.primary);
      expect(theme.colorScheme.secondary, AppColors.gold);
      expect(theme.colorScheme.surface, AppColors.surfaceLight);
      expect(theme.scaffoldBackgroundColor, AppColors.backgroundLight);
    });

    test('dark theme uses the web app dark tokens', () {
      final theme = AppTheme.dark;

      expect(theme.brightness, Brightness.dark);
      expect(theme.colorScheme.primary, AppColors.primary);
      expect(theme.colorScheme.secondary, AppColors.gold);
      expect(theme.colorScheme.surface, AppColors.surfaceDark);
      expect(theme.scaffoldBackgroundColor, AppColors.backgroundDark);
    });

    test('containers stay neutral instead of taking the seed tint', () {
      final light = AppTheme.light.colorScheme;
      expect(light.surfaceContainerLowest, AppColors.surfaceLight);
      expect(light.surfaceContainerLow, AppColors.surfaceLight);
      expect(light.surfaceContainerHigh, AppColors.surfaceLight);

      final dark = AppTheme.dark.colorScheme;
      expect(dark.surfaceContainerLowest, AppColors.backgroundDark);
      expect(dark.surfaceContainerLow, AppColors.surfaceDark);
      expect(dark.surfaceContainerHigh, AppColors.surfaceElevatedDark);
    });

    for (final theme in [AppTheme.light, AppTheme.dark]) {
      test('${theme.brightness.name} scroll tint is the brand green', () {
        expect(theme.colorScheme.surfaceTint, AppColors.primary);
      });
    }

    for (final theme in [AppTheme.light, AppTheme.dark]) {
      final scheme = theme.colorScheme;
      test('${scheme.brightness.name} control fill stands out from the '
          'surface', () {
        expect(scheme.surfaceContainerHighest, isNot(scheme.surface));
        expect(
          scheme.surfaceContainerHighest,
          isNot(scheme.surfaceContainerHigh),
        );
      });
    }

    for (final theme in [AppTheme.light, AppTheme.dark]) {
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

    for (final theme in [AppTheme.light, AppTheme.dark]) {
      final scheme = theme.colorScheme;
      test('${scheme.brightness.name} text is opaque and readable', () {
        final backgrounds = {
          'surface': scheme.surface,
          'background': theme.scaffoldBackgroundColor,
          'fill': scheme.surfaceContainerHighest,
        };
        for (final text in [scheme.onSurface, scheme.onSurfaceVariant]) {
          expect(text.a, 1);
          for (final MapEntry(key: name, value: background)
              in backgrounds.entries) {
            expect(
              _contrast(background, text),
              greaterThanOrEqualTo(4.5),
              reason: name,
            );
          }
        }
      });
    }

    test('cards use a 12px radius', () {
      final cardShape =
          AppTheme.light.cardTheme.shape! as RoundedRectangleBorder;
      expect(cardShape.borderRadius, BorderRadius.circular(AppRadius.card));
    });

    test('buttons and inputs use a 6px radius', () {
      final theme = AppTheme.light;
      final controlRadius = BorderRadius.circular(AppRadius.control);

      final buttonStyles = {
        'filled': theme.filledButtonTheme.style,
        'elevated': theme.elevatedButtonTheme.style,
        'outlined': theme.outlinedButtonTheme.style,
        'text': theme.textButtonTheme.style,
        'segmented': theme.segmentedButtonTheme.style,
      };
      for (final MapEntry(key: name, value: style) in buttonStyles.entries) {
        final shape = style?.shape?.resolve({});
        expect(shape, isA<RoundedRectangleBorder>(), reason: name);
        expect(
          (shape! as RoundedRectangleBorder).borderRadius,
          controlRadius,
          reason: name,
        );
      }

      final inputBorder =
          theme.inputDecorationTheme.border! as OutlineInputBorder;
      expect(inputBorder.borderRadius, controlRadius);
    });
  });
}

double _contrast(Color a, Color b) {
  final la = a.computeLuminance();
  final lb = b.computeLuminance();
  return (max(la, lb) + 0.05) / (min(la, lb) + 0.05);
}
