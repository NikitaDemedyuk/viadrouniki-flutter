import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:viadrouniki/app.dart';
import 'package:viadrouniki/core/router/app_router.dart';
import 'package:viadrouniki/core/router/app_tab.dart';
import 'package:viadrouniki/core/settings/app_language.dart';
import 'package:viadrouniki/core/settings/language_cubit.dart';
import 'package:viadrouniki/core/settings/theme_cubit.dart';

void main() {
  group('app router', () {
    late LanguageCubit languageCubit;
    late GoRouter router;

    Future<void> pumpApp(WidgetTester tester, {String? initialLocation}) async {
      SharedPreferences.setMockInitialValues({});
      final preferences = await SharedPreferences.getInstance();
      languageCubit = LanguageCubit(preferences);
      router = createAppRouter(initialLocation: initialLocation);
      addTearDown(router.dispose);

      await tester.pumpWidget(
        ViadrounikiApp(
          languageCubit: languageCubit,
          themeCubit: ThemeCubit(preferences),
          router: router,
        ),
      );
      await tester.pumpAndSettle();
    }

    int selectedIndex(WidgetTester tester) =>
        tester.widget<NavigationBar>(find.byType(NavigationBar)).selectedIndex;

    Finder destination(String label) => find.descendant(
      of: find.byType(NavigationBar),
      matching: find.text(label),
    );

    testWidgets('starts on the trips tab', (tester) async {
      await pumpApp(tester);

      expect(router.state.uri.path, AppTab.trips.path);
      expect(selectedIndex(tester), AppTab.trips.index);
    });

    testWidgets('the web root redirects to the trips tab', (tester) async {
      await pumpApp(tester, initialLocation: '/');

      expect(router.state.uri.path, AppTab.trips.path);
      expect(selectedIndex(tester), AppTab.trips.index);
    });

    testWidgets('each destination opens its tab', (tester) async {
      await pumpApp(tester);
      const labels = {
        AppTab.trips: 'Маршруты',
        AppTab.points: 'Точки',
        AppTab.cars: 'Машины',
        AppTab.profile: 'Профиль',
      };

      for (final tab in AppTab.values.reversed) {
        await tester.tap(destination(labels[tab]!));
        await tester.pumpAndSettle();

        expect(router.state.uri.path, tab.path);
        expect(selectedIndex(tester), tab.index);
      }
    });

    for (final tab in AppTab.values) {
      testWidgets('${tab.path} selects the ${tab.name} tab', (tester) async {
        await pumpApp(tester, initialLocation: tab.path);

        expect(selectedIndex(tester), tab.index);
      });
    }

    testWidgets('a language switch relabels the tabs and keeps the tab', (
      tester,
    ) async {
      await pumpApp(tester, initialLocation: AppTab.cars.path);

      await languageCubit.setLanguage(AppLanguage.be);
      await tester.pumpAndSettle();

      expect(destination('Машыны'), findsOneWidget);
      expect(destination('Машины'), findsNothing);
      expect(router.state.uri.path, AppTab.cars.path);
      expect(selectedIndex(tester), AppTab.cars.index);
    });
  });
}
