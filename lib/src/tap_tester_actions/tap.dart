part of '../tap_tester.dart';

extension TapTesterTap on TapTester {
  Future<void> tap(TapKey key, {SyncType sync = SyncType.instant, int count = 1}) async {
    final finder = _finder(key);

    for (var i = 0; i < count; i++) {
      if (count == 1) {
        _print('Tapping ${_formatKey(key)}', _PrintType.inProgress);
      } else {
        _print('Tapping ${_formatKey(key)} ${i + 1}/$count', _PrintType.inProgress, overwrite: i != 0);
      }

      await widgetTester.tap(finder);

      if (i != count - 1) {
        await widgetTester.pump(kDoubleTapMinTime);
      }
    }

    await _sync(sync);
    if (count == 1) {
      _print('Tapped ${_formatKey(key)}', _PrintType.success, overwrite: true);
    } else {
      _print('Tapped ${_formatKey(key)} $count times', _PrintType.success, overwrite: true);
    }
  }
}
