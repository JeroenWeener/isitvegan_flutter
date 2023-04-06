import 'package:flutter/services.dart';

Future<Iterable<String>> readFile(String filename) async {
  return (await rootBundle.loadString(filename)).split('\n');
}
