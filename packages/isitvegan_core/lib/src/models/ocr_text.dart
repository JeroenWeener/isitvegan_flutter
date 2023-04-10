import 'dart:ui';

import '../extensions/rect_extensions.dart';

class OCRText {
  const OCRText({
    required this.text,
    required this.bbox,
  });

  final String text;
  final Rect bbox;

  factory OCRText.resolved(Iterable<OCRText> ocrTexts, String resolvedName) {
    return OCRText(
      text: resolvedName,
      bbox: ocrTexts.map((OCRText ocrText) => ocrText.bbox).merge(),
    );
  }

  OCRText merge(OCRText other) {
    return OCRText(text: '$text ${other.text}', bbox: bbox.merge(other.bbox));
  }
}
