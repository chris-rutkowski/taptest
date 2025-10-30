part of '../tap_tester.dart';

extension TapTesterInfo on TapTester {
  Future<void> info(String message) {
    _print(message, _PrintType.info);
    return Future.value();
  }
}
