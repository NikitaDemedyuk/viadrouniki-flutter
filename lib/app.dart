import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:viadrouniki/core/l10n/gen/app_localizations.dart';
import 'package:viadrouniki/core/settings/app_language.dart';
import 'package:viadrouniki/core/settings/app_theme_mode.dart';
import 'package:viadrouniki/core/settings/language_cubit.dart';
import 'package:viadrouniki/core/settings/theme_cubit.dart';
import 'package:viadrouniki/core/theme/app_theme.dart';

class ViadrounikiApp extends StatelessWidget {
  const new({
    required this.languageCubit,
    required this.themeCubit,
    required this.router,
    super.key,
  });

  final LanguageCubit languageCubit;
  final ThemeCubit themeCubit;
  final GoRouter router;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: languageCubit),
        BlocProvider.value(value: themeCubit),
      ],
      child: Builder(
        builder: (context) {
          final language = context.watch<LanguageCubit>().state;
          final themeMode = context.watch<ThemeCubit>().state;
          return MaterialApp.router(
            onGenerateTitle: (context) => AppLocalizations.of(context).appTitle,
            locale: language.toLocale(),
            theme: AppTheme.light,
            darkTheme: AppTheme.dark,
            themeMode: themeMode.toThemeMode(),
            supportedLocales: AppLocalizations.supportedLocales,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            routerConfig: router,
          );
        },
      ),
    );
  }
}

extension on AppLanguage {
  Locale toLocale() => switch (this) {
    AppLanguage.ru => const Locale('ru'),
    AppLanguage.be => const Locale('be'),
  };
}

extension on AppThemeMode {
  ThemeMode toThemeMode() => switch (this) {
    AppThemeMode.system => ThemeMode.system,
    AppThemeMode.light => ThemeMode.light,
    AppThemeMode.dark => ThemeMode.dark,
  };
}
