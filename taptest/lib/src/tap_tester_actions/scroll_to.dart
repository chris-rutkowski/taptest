part of '../tap_tester.dart';

extension TapTesterScrollTo on TapTester {
  Future<void> scrollTo(
    TapKey key, {
    required TapKey scrollable,
    double delta = 50,
    int maxScrolls = 1000,
  }) async {
    logger.log(TapTesterLogType.stepInProgress, 'Scrolling to ${_formatKey(key)}');

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

    logger.log(TapTesterLogType.stepSuccessful, 'Scrolled to ${_formatKey(key)}');
  }
}
