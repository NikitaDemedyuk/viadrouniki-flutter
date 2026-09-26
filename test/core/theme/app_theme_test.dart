import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:viadrouniki/core/theme/app_colors.dart';
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

    test('cards use a 12px radius and buttons a 6px radius', () {
      final theme = AppTheme.light();

      final cardShape = theme.cardTheme.shape! as RoundedRectangleBorder;
      expect(cardShape.borderRadius, BorderRadius.circular(12));

      final buttonShape =
          theme.elevatedButtonTheme.style!.shape!.resolve({})!
              as RoundedRectangleBorder;
      expect(buttonShape.borderRadius, BorderRadius.circular(6));
    });
  });
}
