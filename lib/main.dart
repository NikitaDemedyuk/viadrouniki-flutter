import 'dart:ui';

import 'package:flutter/widgets.dart';
import 'package:viadrouniki/app.dart';
import 'package:viadrouniki/core/di/injection.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // A single funnel for both error channels, so a crash reporter can be
  // plugged in here later without touching call sites elsewhere.
  FlutterError.onError = FlutterError.presentError;
  PlatformDispatcher.instance.onError = (error, stack) {
    FlutterError.presentError(
      FlutterErrorDetails(exception: error, stack: stack),
    );
    return true;
  };

  await configureDependencies();

  runApp(const ViadrounikiApp());
}
