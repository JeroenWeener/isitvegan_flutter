extension Iterables<E> on Iterable<E> {
  Map<K, List<E>> groupBy<K>(K Function(E) keyFunction) => fold(
        <K, List<E>>{},
        (Map<K, List<E>> map, E element) =>
            map..putIfAbsent(keyFunction(element), () => <E>[]).add(element),
      );

  /// Returns sequences of up to [lookAhead] combined elements.
  ///
  /// Returns a [List] of [List]s, where every inner list corresponds to an
  /// element in this iterable. The inner list will contain an entry with only
  /// the element, an entry with the element and the following element combined,
  /// etc, until [lookAhead] element have been combined.
  ///
  /// Example of the sequences that are checked for text element list a, b, c, d
  /// with [lookAhead] 3: [a, a b, a b c, b, b c, b c d, c, c d, d].
  List<List<E>> permutations(
    E Function(E, E) combine, {
    int lookAhead = 4,
  }) {
    List<List<E>> results = [];

    for (int i = 0; i < length; i++) {
      List<E> result = [];
      E w = elementAt(i);
      result.add(w);
      for (int j = 1; j < lookAhead; j++) {
        if (i + j == length) {
          break;
        }

        w = combine(w, elementAt(i + j));
        result.add(w);
      }
      results.add(result);
    }

    return results;
  }
}

extension IntIterables on Iterable<int> {
  int min() {
    return reduce((int a, int b) => a < b ? a : b);
  }

  int max() {
    return reduce((int a, int b) => a < b ? b : a);
  }
}

extension IterableIterables<E> on Iterable<Iterable<E>> {
  Iterable<E> flatten() {
    return fold([], (Iterable<E> a, Iterable<E> b) => a.followedBy(b));
  }
}
