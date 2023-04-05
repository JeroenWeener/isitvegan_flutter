import 'dart:math';

import '../extensions/extensions.dart';

class Size {
  const Size({
    required this.left,
    required this.top,
    required this.width,
    required this.height,
  });

  final int left;
  final int top;
  final int width;
  final int height;

  factory Size.combine(Iterable<Size> sizes) {
    Iterable<int> rights = sizes.map((Size s) => s.left + s.width);
    Iterable<int> bottoms = sizes.map((Size s) => s.top + s.height);

    int newLeft = sizes.map((Size s) => s.left).min();
    int newTop = sizes.map((Size s) => s.top).min();
    int newWidth = rights.max() - newLeft;
    int newHeight = bottoms.max() - newTop;

    return Size(
      left: newLeft,
      top: newTop,
      width: newWidth,
      height: newHeight,
    );
  }

  Size merge(Size other) {
    int right = left + width;
    int bottom = top + height;
    int otherRight = other.left + other.width;
    int otherBottom = other.top + other.height;

    int newLeft = min(left, other.left);
    int newTop = min(top, other.top);
    int newWidth = max(right, otherRight) - newLeft;
    int newHeight = max(bottom, otherBottom) - top;

    return Size(
      left: newLeft,
      top: newTop,
      width: newWidth,
      height: newHeight,
    );
  }
}
