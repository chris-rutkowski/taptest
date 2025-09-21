import 'dart:async';

extension ListExtensions<T> on List<T> {
  Future<void> cycle({
    required T from,
    required FutureOr<void> Function(T item) callback,
  }) async {
    if (isEmpty) return;

    final fromIndex = indexOf(from);

    if (fromIndex == -1) {
      throw ArgumentError('Starting element not found in list');
    }

    for (var i = 0; i < length; i++) {
      final index = (fromIndex + i) % length;
      await callback(this[index]);
    }
  }
}
