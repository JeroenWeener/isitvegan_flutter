import 'package:get_it/get_it.dart';
import 'package:isitvegan_core/isitvegan_core.dart' as core;
import 'package:isitvegan_ui/isitvegan_ui.dart' as ui;

Future<void> main() async {
  await core.bootstrap();
  await GetIt.instance.allReady();
  await ui.bootstrap();
}
