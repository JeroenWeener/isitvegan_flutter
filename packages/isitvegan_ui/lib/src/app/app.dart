import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:isitvegan_core/isitvegan_core.dart';

import '../features/scanner/view/scanner_page.dart';
import '../features/scanner/view/text_overlay_painter.dart';

/// This widget is the entry-point of the Widget-tree.
class App extends StatelessWidget {
  const App({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: ScannerPage());
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    super.key,
    required this.cameras,
  });

  final List<CameraDescription> cameras;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late final TextRecognizer _textRecognizer;
  late final CameraController _controller;

  int _cameraIndex = -1;
  CustomPaint? _customPaint;
  bool _processing = false;
  late CameraImage _lastImage;

  @override
  void initState() {
    super.initState();

    _textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
    _cameraIndex = _resolveCameraIndex(widget.cameras);
    _startLiveFeed(widget.cameras[_cameraIndex]);
  }

  @override
  void dispose() async {
    _textRecognizer.close();
    _stopLiveFeed();
    super.dispose();
  }

  Future _startLiveFeed(CameraDescription camera) async {
    _controller = CameraController(
      camera,
      ResolutionPreset.high,
      enableAudio: false,
    );

    _controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      _controller.startImageStream((CameraImage image) {
        _lastImage = image;
        setState(() {});
      });
    });
  }

  Future _stopLiveFeed() async {
    await _controller.stopImageStream();
    await _controller.dispose();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: _liveFeedBody());
  }

  Widget _liveFeedBody() {
    if (!_controller.value.isInitialized) {
      return const SizedBox.shrink();
    }

    return GestureDetector(
      onTapDown: (details) => _pausePreview(),
      onTapUp: (details) => _playPreview(),
      onLongPressEnd: (details) => _playPreview(),
      onSecondaryLongPressEnd: (details) => _playPreview(),
      onTertiaryLongPressEnd: (details) => _playPreview(),
      onForcePressEnd: (details) => _playPreview(),
      child: Container(
        color: Colors.black,
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            CameraPreview(_controller),
            if (_customPaint != null) _customPaint!,
          ],
        ),
      ),
    );
  }

  void _pausePreview() async {
    await _controller.pausePreview();
    setState(() {
      _processing = true;
    });

    final inputImage = _cameraImageToInputImage(_lastImage);
    final recognizedText = <OCRText>[];

    if (!_processing) return;

    if (inputImage.inputImageData?.size != null &&
        inputImage.inputImageData?.imageRotation != null) {
      final painter = TextOverlayPainter(
          recognizedText,
          inputImage.inputImageData!.size,
          inputImage.inputImageData!.imageRotation);
      _customPaint = CustomPaint(painter: painter);
      setState(() {});
    }
  }

  void _playPreview() async {
    await _controller.resumePreview();
    setState(() {
      _processing = false;
      _customPaint = null;
    });
  }

  InputImage _cameraImageToInputImage(CameraImage cameraImage) {
    final WriteBuffer allBytes = WriteBuffer();
    for (final Plane plane in cameraImage.planes) {
      allBytes.putUint8List(plane.bytes);
    }
    final bytes = allBytes.done().buffer.asUint8List();

    final Size imageSize =
        Size(cameraImage.width.toDouble(), cameraImage.height.toDouble());

    final camera = widget.cameras[_cameraIndex];
    final imageRotation =
        InputImageRotationValue.fromRawValue(camera.sensorOrientation);
    if (imageRotation == null) throw Exception();

    final inputImageFormat =
        InputImageFormatValue.fromRawValue(cameraImage.format.raw);
    if (inputImageFormat == null) throw Exception();

    final planeData = cameraImage.planes.map(
      (Plane plane) {
        return InputImagePlaneMetadata(
          bytesPerRow: plane.bytesPerRow,
          height: plane.height,
          width: plane.width,
        );
      },
    ).toList();

    final inputImageData = InputImageData(
      size: imageSize,
      imageRotation: imageRotation,
      inputImageFormat: inputImageFormat,
      planeData: planeData,
    );

    return InputImage.fromBytes(bytes: bytes, inputImageData: inputImageData);
  }
}
