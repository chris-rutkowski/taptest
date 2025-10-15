part of '../tap_tester.dart';

extension TapTesterText on TapTester {
  Future<void> text(
    TapKey key,
    String text, {
    Duration timeout = const Duration(seconds: 5),
  }) async {
    // _print('Checking text of ${_formatKey(key)} matches "$text"', _PrintType.inProgress);

    // final elementWidget = _finder(key).evaluate().single.widget;
    // expect(elementWidget, isA<Text>());
    // expect((elementWidget as Text).data, text);

    // _print('Text of ${_formatKey(key)} matches "$text"', _PrintType.success, overwrite: true);

    await _expectWithTimeout(
      () {
        final elementWidget = _finder(key).evaluate().single.widget;
        expect(elementWidget, isA<Text>());
        expect((elementWidget as Text).data, text);
        return Future.value();
      },
      'Checking text of ${_formatKey(key)} matches "$text"',
      timeout,
    );

    _print('Text of ${_formatKey(key)} matches "$text"', _PrintType.success, overwrite: true);
  }
}
