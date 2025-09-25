part of '../tap_tester.dart';

extension TapTesterWait on TapTester {
  Future<void> wait(Duration duration) async {
    _print('Waiting for $duration', _PrintType.inProgress);
    await widgetTester.pump(duration);
    _print('Waited for $duration', _PrintType.success, overwrite: true);
  }
}