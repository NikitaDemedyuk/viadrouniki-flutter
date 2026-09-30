import 'package:flutter/cupertino.dart' show CupertinoLocalizations;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:viadrouniki/app.dart';
import 'package:viadrouniki/core/l10n/gen/app_localizations.dart';
import 'package:viadrouniki/core/router/app_router.dart';
import 'package:viadrouniki/core/settings/language_cubit.dart';
import 'package:viadrouniki/core/settings/theme_cubit.dart';

void main() {
  group('ViadrounikiApp', () {
    testWidgets('starts in Russian regardless of the device locale', (
      tester,
    ) async {
      tester.platformDispatcher.localesTestValue = const [Locale('en', 'US')];
      addTearDown(tester.platformDispatcher.clearLocalesTestValue);

      SharedPreferences.setMockInitialValues({});
      final preferences = await SharedPreferences.getInstance();
      final router = createAppRouter();
      addTearDown(router.dispose);

      await tester.pumpWidget(
        ViadrounikiApp(
          languageCubit: LanguageCubit(preferences),
          themeCubit: ThemeCubit(preferences),
          router: router,
        ),
      );

      final context = tester.element(find.byType(NavigationBar));
      expect(Localizations.localeOf(context), const Locale('ru'));
      expect(find.text('Маршруты'), findsWidgets);
    });
  });

  group('AppLocalizations', () {
    test('supports exactly Russian and Belarusian', () {
      expect(
        AppLocalizations.supportedLocales,
        unorderedEquals(const [Locale('ru'), Locale('be')]),
      );
    });

    for (final locale in AppLocalizations.supportedLocales) {
      testWidgets('loads Material and Cupertino strings for $locale', (
        tester,
      ) async {
        await tester.pumpWidget(
          MaterialApp(
            locale: locale,
            supportedLocales: AppLocalizations.supportedLocales,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            home: const SizedBox(),
          ),
        );

        final context = tester.element(find.byType(SizedBox));
        expect(MaterialLocalizations.of(context), isNotNull);
        expect(CupertinoLocalizations.of(context), isNotNull);
        expect(AppLocalizations.of(context).appTitle, 'Вядроўнікі');
      });
    }
  });
}
