part of '../tap_tester.dart';

extension TapTesterPop on TapTester {
  /// Pops the current route from the navigation stack.
  /// Automatically waits for the view to settle unless a different [sync] is provided.
  ///
  /// **Note:**
  /// If there is more than one [Navigator], the wrong one may be popped.
  /// Therefore, it is preferred to tap the close/back button by a dedicated key (using `tester.tap(MyKey.backButton)`).
  /// Use this method as a convenience for apps with a single [Navigator].
  Future<void> pop({SyncType sync = SyncType.settled}) async {
    _print('Popping screen', _PrintType.inProgress);

    // Two other ways to pop, but they don't trigger PopScope etc

    // final navigator = widgetTester.state<NavigatorState>(find.byType(Navigator));
    // navigator.pop();

    // final backButton = find.byTooltip('Back');
    // await widgetTester.tap(backButton);

    await widgetTester.pageBack();

    await _sync(sync);

    _print('Popped screen', _PrintType.success, overwrite: true);
  }
}
