extension StringExtensions on String {
  String capitalize() {
    return length == 0
        ? ''
        : length == 1
            ? this[0].toUpperCase()
            : '${this[0].toUpperCase()}${substring(1).toLowerCase()}';
  }
}
