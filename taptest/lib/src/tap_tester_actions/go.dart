part of '../tap_tester.dart';

extension TapTesterGo on TapTester {
  Future<void> go(
    String path, {
    SyncType sync = SyncType.settled,
  }) async {
    _print('Navigating to $path', _PrintType.inProgress);

    // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
    await widgetTester.binding.handlePushRoute(path);

    await _sync(sync);
    _print('Navigated to $path', _PrintType.success, overwrite: true);
  }
}
