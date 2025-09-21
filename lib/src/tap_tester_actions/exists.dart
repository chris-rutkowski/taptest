part of '../tap_tester.dart';

extension TapTesterExists on TapTester {
  Future<void> exists(
    dynamic key, {
    Duration timeout = const Duration(seconds: 5),
  }) async {
    final finder = _finder(key);

    await _expectWithTimeout(
      () {
        expect(finder, findsOneWidget);
        return Future.value();
      },
      'Checking existence ${_formatKey(key)}',
      timeout,
    );

    _print('Exists ${_formatKey(key)}', _PrintType.success, overwrite: true);
  }
}
