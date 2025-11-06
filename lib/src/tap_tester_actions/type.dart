part of '../tap_tester.dart';

extension TapTesterType on TapTester {
  Future<void> type(
    TapKey key,
    String text, {
    bool secret = false,
    SyncType sync = SyncType.instant,
  }) async {
    final printText = secret ? '*' * text.length : text;
    logger.log(TapTesterLogType.stepInProgress, 'Typing "$printText" into ${_formatKey(key)}');

    final finder = _finder(key);

    // Focus the field first (if necessary)
    // await _tester.tap(finder);
    // await _tester.pump();

    await widgetTester.enterText(finder, text);
    await _sync(sync);

    logger.log(TapTesterLogType.stepSuccessful, 'Typed "$printText" into ${_formatKey(key)}');
  }
}
