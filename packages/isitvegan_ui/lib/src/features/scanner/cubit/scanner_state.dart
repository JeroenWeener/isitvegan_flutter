import 'package:camera/camera.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:isitvegan_core/isitvegan_core.dart';

@immutable
class ScannerState extends Equatable {
  const ScannerState({
    this.camera,
    this.labels = const [],
    this.lastImage,
  });

  final CameraDescription? camera;
  final Iterable<OCRText> labels;
  final CameraImage? lastImage;

  ScannerState copyWith({
    CameraDescription? camera,
    Iterable<OCRText>? labels,
    CameraImage? lastImage,
  }) {
    return ScannerState(
      camera: camera ?? this.camera,
      labels: labels ?? this.labels,
      lastImage: lastImage ?? this.lastImage,
    );
  }

  @override
  List<Object?> get props => [
        camera,
        labels,
        lastImage,
      ];
}

class ScannerStateResume extends ScannerState {
  const ScannerStateResume({
    super.camera,
  });

  factory ScannerStateResume.from(ScannerState state) {
    return ScannerStateResume(camera: state.camera);
  }
}

class ScannerStatePause extends ScannerState {
  const ScannerStatePause({
    super.camera,
    super.lastImage,
  });

  factory ScannerStatePause.from(ScannerState state) {
    return ScannerStatePause(
      camera: state.camera,
      lastImage: state.lastImage,
    );
  }
}
