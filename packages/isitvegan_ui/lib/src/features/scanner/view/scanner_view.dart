import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../scanner.dart';

class ScannerView extends StatelessWidget {
  const ScannerView();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ScannerCubit, ScannerState>(
      builder: (BuildContext context, ScannerState state) {
        return Center(
          child: Text(
            state.cameras.length.toString(),
            style: const TextStyle(fontSize: 200),
          ),
        );
      },
    );
  }
}
