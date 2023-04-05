import 'size.dart';

class OCRText {
  const OCRText({
    required this.text,
    required this.bbox,
  });

  final String text;
  final Size bbox;

  factory OCRText.resolved(Iterable<OCRText> ocrTexts, String resolvedName) {
    return OCRText(
      text: resolvedName,
      bbox: Size.combine(
        ocrTexts.map((OCRText ocrText) => ocrText.bbox),
      ),
    );
  }

  OCRText merge(OCRText other) {
    return OCRText(text: '$text ${other.text}', bbox: bbox.merge(other.bbox));
  }
}
