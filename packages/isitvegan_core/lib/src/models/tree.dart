import '../extensions/extensions.dart';
import 'models.dart';

/// BK-Tree implementation according to https://en.wikipedia.org/wiki/BK-tree.
class BKTree<T> {
  const BKTree._({
    required this.value,
    required this.trees,
  });

  factory BKTree({
    required Iterable<T> values,
    required int Function(T, T) d,
  }) {
    T rootValue = values.first;

    Map<int, BKTree<T>> distances = values
        .skip(1)
        .map(
          (T v) => ValueDistance(
            value: v,
            distance: d(rootValue, v),
          ),
        )
        .groupBy((ValueDistance vd) => vd.distance)
        .map(
          (int distance, Iterable<ValueDistance> vds) => MapEntry(
            distance,
            BKTree(
              values: vds.map((ValueDistance vd) => vd.value),
              d: d,
            ),
          ),
        );

    return BKTree<T>._(
      value: rootValue,
      trees: distances,
    );
  }

  /// Searches for the closest element in the tree closest to [w].
  ///
  /// Closeness is defined by function [d].
  /// Returns [Null] if no element is closer than [dMax].
  ValueDistance<T>? search<E>({
    required int Function(T, E) d,
    required E w,
    required int dMax,
  }) {
    Set<BKTree<T>> s = <BKTree<T>>{this};
    T? valueBest;
    int dBest = dMax;

    while (s.isNotEmpty) {
      BKTree<T> u = s.first;
      s.remove(u);
      T wu = u.value;
      int du = d(wu, w);
      if (du < dBest) {
        valueBest = wu;
        dBest = du;
      }

      for (MapEntry<int, BKTree<T>> entry in u.trees.entries) {
        int duv = entry.key;
        if ((duv - du).abs() < dBest) {
          BKTree<T> v = entry.value;
          s.add(v);
        }
      }
    }
    return valueBest == null
        ? null
        : ValueDistance(value: valueBest, distance: dBest);
  }

  int depth() {
    int depth = trees.isEmpty
        ? 0
        : trees.entries
            .map((MapEntry<int, BKTree> entry) => entry.value.depth())
            .max();
    return 1 + depth;
  }

  final T value;
  final Map<int, BKTree<T>> trees;
}
