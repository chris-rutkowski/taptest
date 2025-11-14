part of '../tap_tester.dart';

extension TapTesterType on TapTester {
  Future<void> type(
    TapKey key,
    String text, {
    bool tap = false,
    bool secret = false,
    bool submit = false,
    SyncType sync = SyncType.instant,
  }) async {
    final printText = secret ? '*' * text.length : text;
    logger.log(TapTesterLogType.stepInProgress, 'Typing "$printText" into ${_formatKey(key)}');

    final finder = _finder(key);

    if (tap) {
      await widgetTester.tap(finder);
      await widgetTester.pump();
    }

    await widgetTester.enterText(finder, text);
    await _sync(sync);

    if (submit) {
      await widgetTester.testTextInput.receiveAction(TextInputAction.done);
    }

    logger.log(TapTesterLogType.stepSuccessful, 'Typed "$printText" into ${_formatKey(key)}');
  }
}
