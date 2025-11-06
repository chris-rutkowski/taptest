part of '../tap_tester.dart';

extension TapTesterSettle on TapTester {
  Future<void> settle() async {
    logger.log(TapTesterLogType.stepInProgress, 'Waiting for animations to settle');
    await widgetTester.pumpAndSettle();
    logger.log(TapTesterLogType.stepSuccessful, 'Settled');
  }
}
