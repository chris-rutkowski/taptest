part of '../tap_tester.dart';

extension TapTesterInfo on TapTester {
  Future<void> info(String message) {
    logger.log(TapTesterLogType.info, message);
    return Future.value();
  }
}
