import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:isitvegan_core/isitvegan_core.dart';

import '../../../../isitvegan_ui.dart';

class ScannerView extends StatelessWidget {
  const ScannerView();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ScannerCubit, ScannerState>(
      builder: (BuildContext context, ScannerState state) {
        return state.camera == null
            ? const Center(child: Text('Loading'))
            : Container(
                color: Colors.black,
                child: GestureDetector(
                  onTapDown: (details) => _pausePreview(context),
                  onTapUp: (details) => _playPreview(context),
                  onLongPressEnd: (details) => _playPreview(context),
                  onSecondaryLongPressEnd: (details) => _playPreview(context),
                  onTertiaryLongPressEnd: (details) => _playPreview(context),
                  onForcePressEnd: (details) => _playPreview(context),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      /// TODO(jweener): show preview or show overlay and image.
                      MyCameraPreview(state.camera!),
                      if (state.labels.isNotEmpty)
                        LabelOverlay(
                          state.labels,
                          state.lastImage!
                              .toInputImage(state.camera!.sensorOrientation),
                        ),
                    ],
                  ),
                ),
              );
      },
    );
  }

  void _playPreview(BuildContext context) {
    context.read<ScannerCubit>().resumePreview();
  }

  void _pausePreview(BuildContext context) {
    context.read<ScannerCubit>().pausePreview();
    context.read<ScannerCubit>().processImage();
  }
}

class MyCameraPreview extends StatefulWidget {
  const MyCameraPreview(
    this.camera,
  );
  @override
  State<MyCameraPreview> createState() => _MyCameraPreviewState();

  final CameraDescription camera;
}

class _MyCameraPreviewState extends State<MyCameraPreview> {
  late final CameraController _controller;

  @override
  void initState() {
    super.initState();
    _startLiveFeed(widget.camera);
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
      _controller.startImageStream(context.read<ScannerCubit>().onImage);
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ScannerCubit, ScannerState>(
      listener: (BuildContext context, ScannerState state) {
        switch (state.runtimeType) {
          case ScannerStatePause:
            _controller.pausePreview();
            break;
          case ScannerStateResume:
            _controller.resumePreview();
            break;
        }
      },
      child: CameraPreview(_controller),
    );
  }
}

class LabelOverlay extends StatelessWidget {
  const LabelOverlay(this.labels, this.image);

  final List<OCRText> labels;
  final InputImage image;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: TextOverlayPainter(
        labels,
        image.inputImageData!.size,
        image.inputImageData!.imageRotation,
      ),
    );
  }
}
