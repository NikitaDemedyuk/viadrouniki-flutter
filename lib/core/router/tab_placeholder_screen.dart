import 'package:flutter/material.dart';
import 'package:viadrouniki/core/l10n/gen/app_localizations.dart';
import 'package:viadrouniki/core/router/app_tab.dart';

class TabPlaceholderScreen extends StatelessWidget {
  const new(this.tab, {super.key});

  final AppTab tab;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          tab.label(AppLocalizations.of(context)),
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
    );
  }
}
