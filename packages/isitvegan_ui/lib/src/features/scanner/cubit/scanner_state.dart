import 'package:camera/camera.dart';
import 'package:flutter/widgets.dart';

@immutable
class ScannerState {
  const ScannerState({this.cameras = const []});

  final Iterable<CameraDescription> cameras;
}
