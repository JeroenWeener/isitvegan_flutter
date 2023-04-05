import '../use_case.dart';

/// Provides a business rule to increment the supplied count.
class IncrementCounterUseCase extends UseCase<int, int> {
  /// Increments the supplied [counter] by one.
  @override
  int call(int count) {
    return ++count;
  }
}
