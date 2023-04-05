import 'dart:async';

import 'components.dart';
import 'use_cases/counter/counter_use_cases.dart';

/// Bootstraps the isitvegan_core package ensuring all dependencies are
/// registered.
///
/// The `bootstrap()` method is called from the `isitvegan_app/main.dart`
/// file to bootstrap the Isitvegan application.
Future<void> bootstrap() async {
  final Components dependencies = Components(
    components: [
      Factory(
        () => IncrementCounterUseCase(),
      ),
    ],
  );

  dependencies.registerAll();
}
