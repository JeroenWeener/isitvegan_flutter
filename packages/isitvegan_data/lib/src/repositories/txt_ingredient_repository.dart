import 'package:isitvegan_core/isitvegan_core.dart';

class TxtIngredientRepository implements IngredientRepository {
  Set<String>? _ingredientSet;
  BKTree<String>? _ingredientTree;

  Future<void> _init() async {
    Iterable<String> ingredients =
        await readFile('assets/ingredient_list_curated.txt');
    _ingredientSet = ingredients.toSet();
    _ingredientTree = BKTree(values: ingredients, d: Levenshtein().distance);
  }

  @override
  Future<Set<String>> getIngredientSet() async {
    if (_ingredientSet == null) {
      await _init();
    }
    return _ingredientSet!;
  }

  @override
  Future<BKTree<String>> getIngredientTree() async {
    if (_ingredientTree == null) {
      await _init();
    }
    return _ingredientTree!;
  }
}
