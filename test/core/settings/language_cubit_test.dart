import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:viadrouniki/core/settings/app_language.dart';
import 'package:viadrouniki/core/settings/language_cubit.dart';

void main() {
  group('LanguageCubit', () {
    test('defaults to ru when nothing is persisted', () async {
      SharedPreferences.setMockInitialValues({});
      final preferences = await SharedPreferences.getInstance();

      expect(LanguageCubit(preferences).state, AppLanguage.ru);
    });

    test('starts from the persisted language', () async {
      SharedPreferences.setMockInitialValues({'language': 'be'});
      final preferences = await SharedPreferences.getInstance();

      expect(LanguageCubit(preferences).state, AppLanguage.be);
    });

    late SharedPreferences preferences;

    blocTest<LanguageCubit, AppLanguage>(
      'setLanguage emits and persists the new language',
      setUp: () async {
        SharedPreferences.setMockInitialValues({});
        preferences = await SharedPreferences.getInstance();
      },
      build: () => LanguageCubit(preferences),
      act: (cubit) => cubit.setLanguage(AppLanguage.be),
      expect: () => [AppLanguage.be],
      verify: (_) {
        expect(preferences.getString('language'), 'be');
      },
    );

    blocTest<LanguageCubit, AppLanguage>(
      'setLanguage is a no-op when the language is unchanged',
      setUp: () async {
        SharedPreferences.setMockInitialValues({});
        preferences = await SharedPreferences.getInstance();
      },
      build: () => LanguageCubit(preferences),
      act: (cubit) => cubit.setLanguage(AppLanguage.ru),
      expect: () => <AppLanguage>[],
    );
  });
}
