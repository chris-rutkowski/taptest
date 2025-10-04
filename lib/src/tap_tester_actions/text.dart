part of '../tap_tester.dart';

extension TapTesterText on TapTester {
  Future<void> text(TapKey key, String text) async {
    _print('Checking text of ${_formatKey(key)} matches "$text"', _PrintType.inProgress);

    final elementWidget = _finder(key).evaluate().single.widget;
    expect(elementWidget, isA<Text>());
    expect((elementWidget as Text).data, text);

    _print('Text of ${_formatKey(key)} matches "$text"', _PrintType.success, overwrite: true);
  }
}
