import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../scanner.dart';

class ScannerPage extends StatelessWidget {
  const ScannerPage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (context) => ScannerCubit()..init(),
        child: const ScannerView(),
      ),
    );
  }
}
