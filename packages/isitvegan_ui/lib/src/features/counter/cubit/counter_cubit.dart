import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isitvegan_core/isitvegan_core.dart';

/// The [CounterCubit] is responsible for managing counter the state and
/// notifying widgets of state changes.
class CounterCubit extends Cubit<int> {
  /// Create a new `CounterCubit`.
  CounterCubit({
    required IncrementCounterUseCase incrementUseCase,
  })  : _incrementUseCase = incrementUseCase,
        super(0);

  final IncrementCounterUseCase _incrementUseCase;

  /// Increments the state using the `IncrementCounterUseCase` and emits the
  /// newly created state.
  void increment() => emit(_incrementUseCase(state));
}
