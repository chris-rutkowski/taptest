part of '../tap_tester.dart';

extension TapTesterTap on TapTester {
  Future<void> tap(TapKey key, {SyncType sync = SyncType.instant, int count = 1}) async {
    final finder = _finder(key);

    for (var i = 0; i < count; i++) {
      if (count == 1) {
        logger.log(TapTesterLogType.stepInProgress, 'Tapping ${_formatKey(key)}');
      } else {
        logger.log(TapTesterLogType.stepInProgress, 'Tapping ${_formatKey(key)} ${i + 1}/$count');
      }

      await widgetTester.tap(finder);

      if (i != count - 1) {
        await widgetTester.pump(kDoubleTapMinTime);
      }
    }

    await _sync(sync);
    if (count == 1) {
      logger.log(TapTesterLogType.stepSuccessful, 'Tapped ${_formatKey(key)}');
    } else {
      logger.log(TapTesterLogType.stepSuccessful, 'Tapped ${_formatKey(key)} $count times');
    }
  }
}
