part of '../tap_tester.dart';

extension TapTesterWait on TapTester {
  Future<void> wait(Duration duration) async {
    logger.log(TapTesterLogType.stepInProgress, 'Waiting for $duration');
    await widgetTester.pump(duration);
    logger.log(TapTesterLogType.stepSuccessful, 'Waited for $duration');
  }
}
