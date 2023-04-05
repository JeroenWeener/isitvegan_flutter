import 'package:isitvegan_core/isitvegan_core.dart';
import 'package:test/test.dart';

void main() {
  test(
      'IncrementCounterUseCase.call() should increment the current count by one',
      () {
    final IncrementCounterUseCase incrementUseCase = IncrementCounterUseCase();
    final int count = incrementUseCase(0);
    expect(count, 1);
  });
}
