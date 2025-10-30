part of '../tap_tester.dart';

extension TapTesterAbsent on TapTester {
  Future<void> absent(
    TapKey key, {
    Duration timeout = const Duration(seconds: 5),
  }) async {
    final finder = _finder(key);

    await _expectWithTimeout(
      () {
        expect(finder, findsNothing);
        return Future.value();
      },
      'Checking absence ${_formatKey(key)}',
      timeout,
    );

    _print('Absent ${_formatKey(key)}', _PrintType.success, overwrite: true);
  }
}
