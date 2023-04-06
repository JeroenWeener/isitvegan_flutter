import 'dart:async';

import 'package:isitvegan_core/isitvegan_core.dart';

import 'repositories/repositories.dart';

/// Bootstraps the isitvegan_data package ensuring all dependencies are
/// registered.
///
/// The `bootstrap()` method is called from the `isitvegan_app/main.dart`
/// file to bootstrap the Isitvegan application.
Future<void> bootstrap() async {
  final Components dependencies = Components(
    components: [
      Factory<IngredientRepository>(
        () => TxtIngredientRepository(),
      ),
    ],
  );

  dependencies.registerAll();
}
