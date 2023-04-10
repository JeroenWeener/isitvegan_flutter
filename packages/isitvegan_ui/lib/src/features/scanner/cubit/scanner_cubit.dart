import 'package:camera/camera.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:isitvegan_core/isitvegan_core.dart';

import '../../../../isitvegan_ui.dart';

class ScannerCubit extends Cubit<ScannerState> {
  ScannerCubit({
    required RecognitionService recognitionService,
  })  : _recognitionService = recognitionService,
        super(const ScannerState());

  final RecognitionService _recognitionService;

  Future<void> init() async {
    await WidgetsFlutterBinding.ensureInitialized();
    List<CameraDescription> cameras = await availableCameras();
    CameraDescription camera = cameras[_resolveCameraIndex(cameras)];
    emit(ScannerState(camera: camera));
  }

  void onImage(CameraImage image) {
    emit(state.copyWith(lastImage: image));
  }

  int _resolveCameraIndex(List<CameraDescription> cameras) {
    if (cameras.any(
      (camera) =>
          camera.lensDirection == CameraLensDirection.back &&
          camera.sensorOrientation == 90,
    )) {
      return cameras.indexOf(
        cameras.firstWhere((camera) =>
            camera.lensDirection == CameraLensDirection.back &&
            camera.sensorOrientation == 90),
      );
    } else {
      for (int cameraIndex = 0; cameraIndex < cameras.length; cameraIndex++) {
        if (cameras[cameraIndex].lensDirection == CameraLensDirection.back) {
          return cameraIndex;
        }
      }
      if (cameras.isNotEmpty) {
        return 0;
      }

      throw Exception('No available camera found');
    }
  }

  void pausePreview() {
    emit(ScannerStatePause.from(state));
  }

  void resumePreview() {
    emit(ScannerStateResume.from(state));
  }

  void processImage() async {
    InputImage inputImage =
        state.lastImage!.toInputImage(state.camera!.sensorOrientation);
    RecognizedText recognizedText =
        await _recognitionService.scanImage(inputImage);
    Iterable<OCRText> labels = await _recognitionService.recognize(
      Levenshtein().distance,
      recognizedText.blocks
          .map((e) => e.lines)
          .reduce((value, element) => value + element)
          .map((e) => e.elements)
          .reduce((value, element) => value + element)
          .map((e) => OCRText(text: e.text, bbox: e.boundingBox)),
    );

    emit(state.copyWith(labels: labels));
  }
}
