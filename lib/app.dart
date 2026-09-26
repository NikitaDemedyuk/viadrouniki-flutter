import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:viadrouniki/core/l10n/gen/app_localizations.dart';
import 'package:viadrouniki/core/settings/app_language.dart';
import 'package:viadrouniki/core/settings/app_theme_mode.dart';
import 'package:viadrouniki/core/settings/language_cubit.dart';
import 'package:viadrouniki/core/settings/theme_cubit.dart';

class ViadrounikiApp extends StatelessWidget {
  const new({required this.languageCubit, required this.themeCubit, super.key});

  final LanguageCubit languageCubit;
  final ThemeCubit themeCubit;

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
          return MaterialApp(
            onGenerateTitle: (context) => AppLocalizations.of(context).appTitle,
            locale: language.toLocale(),
            themeMode: themeMode.toThemeMode(),
            supportedLocales: AppLocalizations.supportedLocales,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            home: const _PlaceholderScreen(),
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

class _PlaceholderScreen extends StatelessWidget {
  const new();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text(AppLocalizations.of(context).appTitle)),
    );
  }
}
