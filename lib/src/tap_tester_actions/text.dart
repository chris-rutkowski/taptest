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
        if (elementWidget is Text) {
          expect((elementWidget).data, text);
        } else if (elementWidget is RichText) {
          expect((elementWidget).text.toPlainText(), text);
        } else {
          throw TapTestFailure(
            'Widget identified by key `${_formatKey(key)}` is neither Text nor RichText',
            retriable: false,
          );
        }

        return Future.value();
      },
      'Checking text of ${_formatKey(key)} matches "$text"',
      timeout,
    );

    _print('Text of ${_formatKey(key)} matches "$text"', _PrintType.success, overwrite: true);
  }
}
