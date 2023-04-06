import 'package:flutter/services.dart';

Future<Iterable<String>> readFile(String filename) async {
  return (await rootBundle.loadString(
          'packages/isitvegan_data/assets/ingredient_list_curated.txt'))
      .split('\n');
}
