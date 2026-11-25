import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:viadrouniki/core/theme/app_extra_colors.dart';
import 'package:viadrouniki/core/theme/app_radius.dart';
import 'package:viadrouniki/core/theme/app_theme.dart';

void main() {
  group('AppTheme', () {
    final designRoles = {
      Brightness.light: {
        'primary': 0xFF237804,
        'onPrimary': 0xFFFFFFFF,
        'primaryContainer': 0xFFD9F7BE,
        'onPrimaryContainer': 0xFF135200,
        'surface': 0xFFF8FAF2,
        'surfaceContainerLow': 0xFFF2F5EC,
        'surfaceContainer': 0xFFECEFE5,
        'surfaceContainerHigh': 0xFFE6E9E0,
        // Seed-derived; the design uses it only as the light skeleton.
        'surfaceContainerHighest': 0xFFE1E4D9,
        'onSurface': 0xFF191D16,
        'onSurfaceVariant': 0xFF43483F,
        'outline': 0xFF73796E,
        'outlineVariant': 0xFFC3C8BB,
        'error': 0xFFBA1A1A,
        'errorContainer': 0xFFFFDAD6,
        'onErrorContainer': 0xFF410002,
      },
      Brightness.dark: {
        'primary': 0xFF52C41A,
        'onPrimary': 0xFF092B00,
        'primaryContainer': 0xFF1D3712,
        'onPrimaryContainer': 0xFF95DE64,
        'surface': 0xFF11140F,
        'surfaceContainerLow': 0xFF1C2018,
        'surfaceContainer': 0xFF1F231C,
        'surfaceContainerHigh': 0xFF2A2E26,
        'onSurface': 0xFFE1E4D9,
        'onSurfaceVariant': 0xFFC3C8BB,
        'outline': 0xFF8D9387,
        'outlineVariant': 0xFF43483F,
        'error': 0xFFFFB4AB,
        'errorContainer': 0xFF93000A,
        'onErrorContainer': 0xFFFFDAD6,
      },
    };

    for (final theme in [AppTheme.light, AppTheme.dark]) {
      final scheme = theme.colorScheme;
      final name = theme.brightness.name;

      test('$name scheme uses the design system colours', () {
        final roles = {
          'primary': scheme.primary,
          'onPrimary': scheme.onPrimary,
          'primaryContainer': scheme.primaryContainer,
          'onPrimaryContainer': scheme.onPrimaryContainer,
          'surface': scheme.surface,
          'surfaceContainerLow': scheme.surfaceContainerLow,
          'surfaceContainer': scheme.surfaceContainer,
          'surfaceContainerHigh': scheme.surfaceContainerHigh,
          'surfaceContainerHighest': scheme.surfaceContainerHighest,
          'onSurface': scheme.onSurface,
          'onSurfaceVariant': scheme.onSurfaceVariant,
          'outline': scheme.outline,
          'outlineVariant': scheme.outlineVariant,
          'error': scheme.error,
          'errorContainer': scheme.errorContainer,
          'onErrorContainer': scheme.onErrorContainer,
        };
        for (final MapEntry(key: role, value: hex)
            in designRoles[theme.brightness]!.entries) {
          expect(roles[role], Color(hex), reason: role);
        }
      });

      test('$name screen background is the design background', () {
        expect(theme.scaffoldBackgroundColor, scheme.surface);
      });

      test('$name tinted selection uses the primary container', () {
        expect(scheme.secondaryContainer, scheme.primaryContainer);
        expect(scheme.onSecondaryContainer, scheme.onPrimaryContainer);
      });

      test('$name scroll tint is the accent', () {
        expect(scheme.surfaceTint, scheme.primary);
      });

      test('$name fill stands out from cards', () {
        expect(scheme.surfaceContainerHigh, isNot(scheme.surfaceContainerLow));
        expect(
          scheme.surfaceContainerHighest,
          isNot(scheme.surfaceContainerHigh),
        );
      });

      test('$name accents meet WCAG AA contrast', () {
        final pairs = {
          'primary': (scheme.primary, scheme.onPrimary),
          'primaryContainer': (
            scheme.primaryContainer,
            scheme.onPrimaryContainer,
          ),
          'error': (scheme.error, scheme.onError),
          'errorContainer': (scheme.errorContainer, scheme.onErrorContainer),
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

      test('$name text is opaque and readable', () {
        final backgrounds = {
          'surface': scheme.surface,
          'surfaceContainerLow': scheme.surfaceContainerLow,
          'surfaceContainerHigh': scheme.surfaceContainerHigh,
          'surfaceContainerHighest': scheme.surfaceContainerHighest,
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

    test('extra colours follow the brightness', () {
      expect(AppTheme.light.extension<AppExtraColors>(), AppExtraColors.light);
      expect(AppTheme.dark.extension<AppExtraColors>(), AppExtraColors.dark);

      const light = AppExtraColors.light;
      expect(light.brand, const Color(0xFF52C41A));
      expect(light.seasonSummer, const Color(0xFFC93400));
      expect(light.seasonWinter, const Color(0xFF0040DD));

      const dark = AppExtraColors.dark;
      expect(dark.brand, const Color(0xFF52C41A));
      expect(dark.seasonSummer, const Color(0xFFFFB340));
      expect(dark.seasonWinter, const Color(0xFF409CFF));
    });

    test('extra colours lerp between the ends', () {
      const light = AppExtraColors.light;
      const dark = AppExtraColors.dark;
      expect(light.lerp(dark, 0).seasonSummer, light.seasonSummer);
      expect(light.lerp(dark, 1).seasonWinter, dark.seasonWinter);
      expect(light.lerp(null, 0.5), light);
    });

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
