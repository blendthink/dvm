extension IterableExtensions<T> on Iterable<T> {
  T? firstDuplicatedWhereOrNull(bool Function(T element) test) {
    final list = <T>[];
    for (final e in this) {
      if (test(e)) {
        if (list.contains(e)) {
          return e;
        }
        list.add(e);
      }
    }
    return null;
  }
}
