import 'dart:ui';

extension RectExtensions on Rect {
  Rect merge(Rect other) {
    return Rect.fromLTRB((left + other.left) / 2, (top + other.top) / 2,
        (right + other.right) / 2, (bottom + other.bottom) / 2);
  }
}

extension RectIterableExtensions on Iterable<Rect> {
  Rect merge() {
    return Rect.fromLTRB(
      map((Rect r) => r.left).reduce((a, b) => a < b ? a : b),
      map((Rect r) => r.top).reduce((a, b) => a < b ? a : b),
      map((Rect r) => r.right).reduce((a, b) => a < b ? b : a),
      map((Rect r) => r.bottom).reduce((a, b) => a < b ? b : a),
    );
  }
}
