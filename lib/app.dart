import 'package:flutter/material.dart';
import 'package:viadrouniki/core/l10n/gen/app_localizations.dart';

class ViadrounikiApp extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      onGenerateTitle: (context) => AppLocalizations.of(context).appTitle,
      // The language is app-controlled, never the device's: the API only
      // serves ru/be, and an unsupported device locale would otherwise fall
      // back to whichever of the two sorts first. A persisted LanguageCubit
      // replaces this constant in M1.
      locale: const Locale('ru'),
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      home: const _PlaceholderScreen(),
    );
  }
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
