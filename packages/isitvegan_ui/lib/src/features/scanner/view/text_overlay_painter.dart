import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:isitvegan_core/isitvegan_core.dart';

import '../../../utils/utils.dart';

class TextOverlayPainter extends CustomPainter {
  TextOverlayPainter(
    this.recognizedText,
    this.absoluteImageSize,
    this.rotation,
  );

  final List<OCRText> recognizedText;
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

    for (final textBlock in recognizedText) {
      bool hasMilk = textBlock.text.contains('melk');

      final left =
          translateX(textBlock.bbox.left, rotation, size, absoluteImageSize);
      final _ =
          translateY(textBlock.bbox.top, rotation, size, absoluteImageSize);
      final right =
          translateX(textBlock.bbox.right, rotation, size, absoluteImageSize);
      final bottom =
          translateY(textBlock.bbox.bottom, rotation, size, absoluteImageSize);

      canvas.drawLine(
        Offset(left, bottom),
        Offset(right, bottom),
        hasMilk ? badPaint : goodPaint,
      );
    }
  }

  @override
  bool shouldRepaint(TextOverlayPainter oldDelegate) {
    return listEquals(oldDelegate.recognizedText, recognizedText);
  }
}
