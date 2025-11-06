part of '../tap_tester.dart';

extension TapTesterChangeThemeMode on TapTester {
  Future<void> changeThemeMode(
    ThemeMode mode, {
    SyncType sync = SyncType.settled,
  }) async {
    logger.log(TapTesterLogType.stepInProgress, 'Changing theme to $mode');

    _themeModeNotifier.value = mode;
    await _sync(sync);

    logger.log(TapTesterLogType.stepSuccessful, 'Theme changed to $mode');
  }
}
