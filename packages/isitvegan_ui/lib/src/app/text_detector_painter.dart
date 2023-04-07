import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

import 'coordinates_translator.dart';

class TextRecognizerPainter extends CustomPainter {
  TextRecognizerPainter(
    this.recognizedText,
    this.absoluteImageSize,
    this.rotation,
  );

  final RecognizedText recognizedText;
  final Size absoluteImageSize;
  final InputImageRotation rotation;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint goodPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..color = Colors.green;
    final Paint badPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..color = Colors.red;

    for (final textBlock in recognizedText.blocks
        .map((e) => e.lines)
        .reduce((value, element) => value + element)
        .map((e) => e.elements)
        .reduce((value, element) => value + element)) {
      bool hasMilk = textBlock.text.contains('melk');

      final left = translateX(
          textBlock.boundingBox.left, rotation, size, absoluteImageSize);
      final _ = translateY(
          textBlock.boundingBox.top, rotation, size, absoluteImageSize);
      final right = translateX(
          textBlock.boundingBox.right, rotation, size, absoluteImageSize);
      final bottom = translateY(
          textBlock.boundingBox.bottom, rotation, size, absoluteImageSize);

      canvas.drawLine(
        Offset(left, bottom),
        Offset(right, bottom),
        hasMilk ? badPaint : goodPaint,
      );
    }
  }

  @override
  bool shouldRepaint(TextRecognizerPainter oldDelegate) {
    return oldDelegate.recognizedText != recognizedText;
  }
}
