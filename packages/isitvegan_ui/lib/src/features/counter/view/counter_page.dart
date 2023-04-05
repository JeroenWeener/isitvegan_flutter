import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../cubit/counter_cubit.dart';
import 'counter_view.dart';

/// A [StatelessWidget] which is responsible for providing a
/// [CounterCubit] instance to the [CounterView].
class CounterPage extends StatelessWidget {
  /// Creates a new instance of the [CounterPage] widget.
  const CounterPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => CounterCubit(
        incrementUseCase: GetIt.instance(),
      ),
      child: const CounterView(),
    );
  }
}
