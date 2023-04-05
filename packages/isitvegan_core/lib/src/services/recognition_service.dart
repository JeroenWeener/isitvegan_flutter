import 'package:edit_distance/edit_distance.dart';

import '../extensions/extensions.dart';
import '../models/models.dart';
import '../repositories/ingredient_repository.dart';

class RecognitionService {
  const RecognitionService({
    required this.ingredientRepository,
  });

  final IngredientRepository ingredientRepository;

  /// Finds the best matching words from text elements [ocrTexts] in [s] and [t].
  ///
  /// First checks if the text element exactly matches elements in [s]. Then,
  /// checks sequences of words ('permutations') increasing in length up to
  /// length [lookAhead].
  /// Some text elements will not be matched and text elements will be matched
  /// at most once. Text elements might be 'merged' using [OCRText.resolved].
  /// The length of the output is therefore smaller or equal to the length of
  /// [ocrTexts].
  ///
  /// Example of the sequences that are checked for text element list a, b, c, d
  /// with [lookAhead] 3: [a, a b, a b c, b, b c, b c d, c, c d, d].
  ///
  /// [dMax] limits how 'far' an element can be to be considered a match,
  /// according to [d].
  Future<Iterable<OCRText>> recognize(
    int Function(String, String) d,
    Iterable<OCRText> ocrTexts, {
    int lookAhead = 10,
    int dMax = 4,
  }) async {
    Set<String> s = ingredientRepository.getIngredientSet();
    BKTree<String> t = ingredientRepository.getIngredientTree();

    // Generate sequences of provided text elements.
    Iterable<Iterable<OCRText>> pss = ocrTexts.permutations(
      (OCRText a, OCRText b) => a.merge(b),
      lookAhead: lookAhead,
    );

    Iterable<Iterable<ValueDistance<String>?>> vdss = pss.map(
      (Iterable<OCRText> ps) => ps.map(
        (OCRText p) => s.contains(p.text)
            ? ValueDistance(value: p.text, distance: 0)
            : t.search<OCRText>(
                d: (String a, OCRText b) => Levenshtein().distance(a, b.text),
                w: p,
                dMax: dMax,
              ),
      ),
    );

    List<OCRText> results = [];

    // Short for-loop. Advancement of `i` is done manually.
    for (int i = 0; i < pss.length;) {
      Iterable<ValueDistance<String>?> vds = vdss.elementAt(i);

      int? bestJ;
      int? bestDistance;
      String? bestName;

      for (int j = 0; j < vds.length; j++) {
        ValueDistance<String>? vd = vds.elementAt(j);
        if (vd != null) {
          bestDistance ??= vd.distance;
          if (vd.distance <= bestDistance) {
            bestDistance = vd.distance;
            bestJ = j;
            bestName = vd.value;
          }
        }
      }

      if (bestJ != null) {
        OCRText combinedText = OCRText.resolved(
          pss.elementAt(i).take(bestJ + 1),
          bestName!,
        );
        results.add(combinedText);
      }

      // Advance outer for-loop.
      i = i + (bestJ ?? 0) + 1;
    }

    return results;
  }
}
