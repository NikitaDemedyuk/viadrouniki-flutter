import 'dart:ui';

import 'package:flutter/widgets.dart';
import 'package:viadrouniki/app.dart';
import 'package:viadrouniki/core/di/injection.dart';
import 'package:viadrouniki/core/settings/language_cubit.dart';
import 'package:viadrouniki/core/settings/theme_cubit.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  PlatformDispatcher.instance.onError = (error, stack) {
    FlutterError.presentError(
      FlutterErrorDetails(exception: error, stack: stack),
    );
    return true;
  };

  await configureDependencies();

  runApp(
    ViadrounikiApp(
      languageCubit: getIt<LanguageCubit>(),
      themeCubit: getIt<ThemeCubit>(),
    ),
  );
}
