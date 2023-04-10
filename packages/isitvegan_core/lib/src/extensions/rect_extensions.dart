import 'dart:ui';

extension RectExtensions on Rect {
  Rect merge(Rect other) {
    return Rect.fromLTRB(left + other.left, top + other.top,
        right + other.right, bottom + other.bottom);
  }
}

extension RectIterableExtensions on Iterable<Rect> {
  Rect merge() {
    return Rect.fromLTRB(
      map((Rect r) => r.left)
          .reduce((value, element) => value < element ? value : element),
      map((Rect r) => r.top)
          .reduce((value, element) => value < element ? value : element),
      map((Rect r) => r.right)
          .reduce((value, element) => value < element ? element : value),
      map((Rect r) => r.bottom)
          .reduce((value, element) => value < element ? element : value),
    );
  }
}
