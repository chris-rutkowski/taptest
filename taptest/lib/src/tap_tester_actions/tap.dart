part of '../tap_tester.dart';

extension TapTesterTap on TapTester {
  Future<void> tap(TapKey key, {SyncType sync = SyncType.settled, int count = 1}) async {
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
      logger.log(TapTesterLogType.stepSuccessful, '${_formatKey(key)} tapped');
    } else {
      logger.log(TapTesterLogType.stepSuccessful, '${_formatKey(key)} tapped $count times');
    }
  }
}
