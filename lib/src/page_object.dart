import 'tap_tester.dart';

/// Abstract base class for implementing Page Object patterns in TapTest.
///
/// Page Objects provide a fluent, chainable API for testing UI flows while
/// encapsulating screen-specific logic and maintaining type safety.
///
/// Each screen requires three components:
///   1. PageObject subclass - Contains screen-specific steps
///   2. Future extension - Enables step chaining for async operations
///   3. TapTester extension - Provides an entry point
///
/// e.g.
///
/// ```dart
/// final class HomeScreenPageObject extends PageObject<HomeScreenPageObject> {
///   const HomeScreenPageObject(super.tt);
///
///   Future<HomeScreenPageObject> tapLoginButton() async {
///     await tt.tap(AppKeys.loginButton);
///     return this;
///   }
/// }
///
/// extension on Future<HomeScreenPageObject> {
///   Future<HomeScreenPageObject> tapLoginButton() => then((r) => r.tapLoginButton());
/// }
///
/// extension TapTesterPageObjects on TapTester {
///   Future<HomeScreenPageObject> onHomeScreen() async {
///     await info('On Home screen');
///     await exists(AppKeys.homeScreen);
///     return HomeScreenPageObject(this);
///   }
/// }
/// ```
abstract class PageObject<T extends PageObject<T>> {
  /// Reference to the TapTester instance for executing test actions
  final TapTester tt;

  /// Creates a new PageObject with the given [TapTester] instance
  const PageObject(this.tt);

  /// Captures a visual snapshot for regression testing
  Future<T> snapshot(String name) async {
    await tt.snapshot(name);
    return this as T;
  }
}

/// Extension that enables fluent chaining for Page Object steps.
extension PageObjectFuture<T extends PageObject<T>> on Future<T> {
  /// Captures a visual snapshot for regression testing
  Future<T> snapshot(String name) => then((po) => po.snapshot(name));
}
