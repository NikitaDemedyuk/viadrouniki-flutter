import 'dart:ui';

import 'package:flutter/widgets.dart';
import 'package:viadrouniki/app.dart';
import 'package:viadrouniki/core/di/injection.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

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
