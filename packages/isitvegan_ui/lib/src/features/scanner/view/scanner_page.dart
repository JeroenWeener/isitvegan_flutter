import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:isitvegan_core/isitvegan_core.dart';

import '../scanner.dart';

class ScannerPage extends StatelessWidget {
  const ScannerPage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider<ScannerCubit>(
        create: (BuildContext context) => ScannerCubit(
          recognitionService: GetIt.instance.get<RecognitionService>(),
        )..init(),
        child: const ScannerView(),
      ),
    );
  }
}
