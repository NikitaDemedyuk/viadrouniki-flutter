import 'package:go_router/go_router.dart';
import 'package:viadrouniki/core/router/app_shell.dart';
import 'package:viadrouniki/core/router/app_tab.dart';
import 'package:viadrouniki/core/router/tab_placeholder_screen.dart';

GoRouter createAppRouter({String? initialLocation}) => GoRouter(
  initialLocation: initialLocation ?? AppTab.values.first.path,
  routes: [
    // The web's home page; the app has no home tab.
    GoRoute(path: '/', redirect: (context, state) => AppTab.values.first.path),
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) =>
          AppShell(navigationShell: navigationShell),
      branches: [
        for (final tab in AppTab.values)
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: tab.path,
                name: tab.name,
                builder: (context, state) => TabPlaceholderScreen(tab),
              ),
            ],
          ),
      ],
    ),
  ],
);
