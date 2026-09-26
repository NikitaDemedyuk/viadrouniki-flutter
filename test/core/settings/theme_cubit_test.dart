import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:viadrouniki/core/settings/app_theme_mode.dart';
import 'package:viadrouniki/core/settings/theme_cubit.dart';

void main() {
  group('ThemeCubit', () {
    test('defaults to system when nothing is persisted', () async {
      SharedPreferences.setMockInitialValues({});
      final preferences = await SharedPreferences.getInstance();

      expect(ThemeCubit(preferences).state, AppThemeMode.system);
    });

    test('starts from the persisted theme mode', () async {
      SharedPreferences.setMockInitialValues({'theme_mode': 'dark'});
      final preferences = await SharedPreferences.getInstance();

      expect(ThemeCubit(preferences).state, AppThemeMode.dark);
    });

    late SharedPreferences preferences;

    blocTest<ThemeCubit, AppThemeMode>(
      'setThemeMode emits and persists the new mode',
      setUp: () async {
        SharedPreferences.setMockInitialValues({});
        preferences = await SharedPreferences.getInstance();
      },
      build: () => ThemeCubit(preferences),
      act: (cubit) => cubit.setThemeMode(AppThemeMode.dark),
      expect: () => [AppThemeMode.dark],
      verify: (_) {
        expect(preferences.getString('theme_mode'), 'dark');
      },
    );

    blocTest<ThemeCubit, AppThemeMode>(
      'setThemeMode is a no-op when the mode is unchanged',
      setUp: () async {
        SharedPreferences.setMockInitialValues({});
        preferences = await SharedPreferences.getInstance();
      },
      build: () => ThemeCubit(preferences),
      act: (cubit) => cubit.setThemeMode(AppThemeMode.system),
      expect: () => <AppThemeMode>[],
    );
  });
}
