part of '../tap_tester.dart';

extension TapTesterGo on TapTester {
  Future<void> go(
    String path, {
    SyncType sync = SyncType.settled,
  }) async {
    logger.log(TapTesterLogType.stepInProgress, 'Navigating to $path');

    // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
    await widgetTester.binding.handlePushRoute(path);

    await _sync(sync);
    logger.log(TapTesterLogType.stepSuccessful, 'Navigated to $path');
  }
}
