part of '../tap_tester.dart';

extension TapTesterExists on TapTester {
  Future<void> exists(
    TapKey key, {
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

    logger.log(TapTesterLogType.stepSuccessful, '${_formatKey(key)} exists');
  }
}
