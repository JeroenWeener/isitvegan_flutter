import '../models/models.dart';

abstract class IngredientRepository {
  const IngredientRepository();

  Future<Set<String>> getIngredientSet();
  Future<BKTree<String>> getIngredientTree();
}
