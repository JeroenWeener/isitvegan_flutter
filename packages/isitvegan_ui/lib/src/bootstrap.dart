import 'dart:async';
import 'dart:developer';

import 'package:camera/camera.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'app/app.dart';

/// Bootstraps the Applications UI package.
Future<void> bootstrap() async {
  FlutterError.onError = (details) {
    log(details.exceptionAsString(), stackTrace: details.stack);
  };

  await WidgetsFlutterBinding.ensureInitialized();
  List<CameraDescription> cameras = await availableCameras();

  await runZonedGuarded(
    () async => await BlocOverrides.runZoned(
      () async => runApp(App(
        cameras: cameras,
      )),
      // blocObserver: CustomBlocObserver(),
    ),
    (error, stackTrace) {
      log(error.toString(), stackTrace: stackTrace);
    },
  );
}
