import 'dart:async';

import 'package:get_it/get_it.dart';

import '../isitvegan_core.dart';

/// Bootstraps the isitvegan_core package ensuring all dependencies are
/// registered.
///
/// The `bootstrap()` method is called from the `isitvegan_app/main.dart`
/// file to bootstrap the Isitvegan application.
Future<void> bootstrap() async {
  final Components dependencies = Components(
    components: [
      Factory<RecognitionService>(
        () => RecognitionService(
          ingredientRepository: GetIt.instance.get<IngredientRepository>(),
        ),
      ),
    ],
  );

  dependencies.registerAll();
}
