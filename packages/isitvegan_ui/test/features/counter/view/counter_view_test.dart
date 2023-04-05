// import 'package:bloc_test/bloc_test.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:isitvegan_ui/isitvegan_ui.dart';
// import 'package:mocktail/mocktail.dart';

// class _MockCounterCubit extends MockCubit<int> implements CounterCubit {}

// const _incrementButtonKey = Key('counterView_increment_floatingActionButton');

// void main() {
//   group('CounterView', () {
//     late CounterCubit counterCubit;

//     setUp(() {
//       counterCubit = _MockCounterCubit();
//     });

//     testWidgets('renders current CounterCubit state', (tester) async {
//       when(() => counterCubit.state).thenReturn(42);
//       await tester.pumpWidget(
//         MaterialApp(
//           home: BlocProvider.value(
//             value: counterCubit,
//             child: const CounterView(),
//           ),
//         ),
//       );
//       expect(find.text('42'), findsOneWidget);
//     });

//     testWidgets('tapping increment button invokes increment', (tester) async {
//       when(() => counterCubit.state).thenReturn(0);
//       await tester.pumpWidget(
//         MaterialApp(
//           home: BlocProvider.value(
//             value: counterCubit,
//             child: const CounterView(),
//           ),
//         ),
//       );
//       await tester.tap(find.byKey(_incrementButtonKey));
//       verify(() => counterCubit.increment()).called(1);
//     });
//   });
// }
