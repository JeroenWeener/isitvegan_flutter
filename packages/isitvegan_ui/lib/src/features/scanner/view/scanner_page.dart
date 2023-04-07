import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../scanner.dart';

class ScannerPage extends StatelessWidget {
  const ScannerPage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider<ScannerCubit>(
        create: (BuildContext context) => ScannerCubit()..init(),
        child: const ScannerView(),
      ),
    );
  }
}
