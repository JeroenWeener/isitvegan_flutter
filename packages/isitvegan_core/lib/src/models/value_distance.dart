class ValueDistance<T> {
  const ValueDistance({
    required this.value,
    required this.distance,
  });

  final T value;
  final int distance;

  @override
  String toString() {
    return '$value: $distance';
  }
}
