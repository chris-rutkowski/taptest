part of '../tap_tester.dart';

extension TapTesterText on TapTester {
  Future<void> expectText(
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
        } else if (elementWidget is TextField) {
          if (elementWidget.controller == null) {
            throw _createNoTextEditingControllerFailure(key, elementWidget);
          }

          expect((elementWidget).controller!.text, text);
        } else if (elementWidget is TextFormField) {
          if (elementWidget.controller == null) {
            throw _createNoTextEditingControllerFailure(key, elementWidget);
          }

          expect((elementWidget).controller!.text, text);
        } else {}

        return Future.value();
      },
      'Checking text of ${_formatKey(key)} matches "$text"',
      timeout,
    );

    logger.log(TapTesterLogType.stepSuccessful, 'Text of ${_formatKey(key)} matches "$text"');
  }

  TapTestFailure _createNoTextEditingControllerFailure(TapKey key, Widget widget) {
    return TapTestFailure(
      '${widget.runtimeType} identified by key `${_formatKey(key)}` does not have a TextEditingController assigned, cannot get its text',
      retriable: false,
    );
  }
}
