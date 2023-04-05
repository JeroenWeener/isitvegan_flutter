// import 'package:bloc_test/bloc_test.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:isitvegan_core/isitvegan_core.dart';
// import 'package:isitvegan_ui/isitvegan_ui.dart';
// import 'package:mocktail/mocktail.dart';

// void main() {
//   late final _MockIncrementCounterUseCase mockIncrementUseCase;

//   setUp(() {
//     mockIncrementUseCase = _MockIncrementCounterUseCase();
//   });

//   blocTest(
//     'emits [1] when increment() is called once.',
//     setUp: () => when(() => mockIncrementUseCase.call(0)).thenReturn(1),
//     build: () => CounterCubit(incrementUseCase: mockIncrementUseCase),
//     act: (CounterCubit counterCubit) => counterCubit.increment(),
//     expect: () => [1],
//     verify: (_) => verify(() => mockIncrementUseCase.call(0)).called(1),
//   );
// }

// class _MockIncrementCounterUseCase extends Mock
//     implements IncrementCounterUseCase {}
