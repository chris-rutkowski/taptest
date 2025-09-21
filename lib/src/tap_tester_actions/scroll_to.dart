part of '../tap_tester.dart';

extension TapTesterScrollTo on TapTester {
  Future<void> scrollTo(
    dynamic key, {
    required dynamic scrollable,
    double delta = 50,
    int maxScrolls = 1000,
  }) async {
    _print('Scrolling to ${_formatKey(key)}', _PrintType.inProgress);

    final finder = _finder(key);
    var scrollableFinder = _finder(scrollable);

    if (widgetTester.widget(scrollableFinder) is! Scrollable) {
      scrollableFinder = find.descendant(
        of: scrollableFinder,
        matching: find.byType(Scrollable),
      );
    }

    await widgetTester.scrollUntilVisible(
      finder,
      delta,
      scrollable: scrollableFinder,
      maxScrolls: maxScrolls,
      // duration: Duration between steps
    );

    await widgetTester.pump();

    _print('Scrolled to ${_formatKey(key)}', _PrintType.success, overwrite: true);
  }
}
