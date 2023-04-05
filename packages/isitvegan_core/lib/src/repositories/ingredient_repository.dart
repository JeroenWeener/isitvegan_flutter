import '../models/models.dart';

abstract class IngredientRepository {
  const IngredientRepository();

  Set<String> getIngredientSet();
  BKTree<String> getIngredientTree();
}
