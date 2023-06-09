import 'dart:async';
import 'dart:developer';

import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'app/app.dart';

/// Bootstraps the Applications UI package.
Future<void> bootstrap() async {
  FlutterError.onError = (details) {
    log(details.exceptionAsString(), stackTrace: details.stack);
  };

  await runZonedGuarded(
    () async => await BlocOverrides.runZoned(
      () async => runApp(const App()),
      // blocObserver: CustomBlocObserver(),
    ),
    (error, stackTrace) {
      log(error.toString(), stackTrace: stackTrace);
    },
  );
}
