import 'dart:ui';

import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:google_mlkit_commons/google_mlkit_commons.dart';

extension CameraImageExtensions on CameraImage {
  InputImage toInputImage(int sensorOrientation) {
    final WriteBuffer allBytes = WriteBuffer();
    for (final Plane plane in planes) {
      allBytes.putUint8List(plane.bytes);
    }
    final bytes = allBytes.done().buffer.asUint8List();

    final Size imageSize = Size(width.toDouble(), height.toDouble());

    final imageRotation =
        InputImageRotationValue.fromRawValue(sensorOrientation);
    if (imageRotation == null) throw Exception();

    final inputImageFormat = InputImageFormatValue.fromRawValue(format.raw);
    if (inputImageFormat == null) throw Exception();

    final planeData = planes.map(
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
