# 📑 Page Objects

Page Objects are a design pattern that helps you organize E2E tests by encapsulating each screen's structure and behavior into dedicated classes. This approach significantly improves test readability, maintainability, and reusability across your test suite.

While Page Objects require more initial setup, they pay off substantially as your app and test suite grow in complexity.

With this pattern, your test steps become fluent and self-documenting:

```dart
await tt
    .onHomeScreen()
    .expectCounterLabel('Click counter: 0')
    .snapshot('HomeScreen_initial')
    .tapIncrementButton()
    .expectCounterLabel('Click counter: 1')
    .tapIncrementButton(count: 2)
    .expectCounterLabel('Click counter: 3')
    .snapshot('HomeScreen_counter3')
    .typeName('John Doe')
    .tapSubmit();

await tt
    .onDetailsScreen()
    .expectWelcomeMessage('Welcome John Doe!')
    .snapshot('DetailsScreen_JohnDoe')
    .pop();
```

You can mix this syntax with traditional TapTest steps in the same file. It's essentially syntactic sugar on top of existing TapTest methods, giving you flexibility in how you write tests.

## 📦 Setting up Page Objects

For each distinct screen in your app, you need to create three components.

First, create a Page Object class that encapsulates the screen's structure and behavior:

```dart
final class HomeScreenPageObject extends PageObject<HomeScreenPageObject> {
  const HomeScreenPageObject(super.tt);

  Future<HomeScreenPageObject> tapIncrementButton({int count = 1}) async {
    await tt.tap(HomeKeys.incrementButton, count: count);
    return this;
  }

  Future<HomeScreenPageObject> expectCounterLabel(String text) async {
    await tt.expectText(HomeKeys.counterLabel, text);
    return this;
  }

  ...
}
```

Since every step is asynchronous, each Page Object needs a `Future` extension to enable fluent dot-chaining:

```dart
extension on Future<HomeScreenPageObject> {
  Future<HomeScreenPageObject> tapIncrementButton({int count = 1}) => then((r) => r.tapIncrementButton(count: count));
  Future<HomeScreenPageObject> expectCounterLabel(String text) => then((r) => r.expectCounterLabel(text));
  ...
}
```

Finally, create a TapTester extension that provides navigation entry points to your Page Objects:

```dart
extension TapTesterPageObjects on TapTester {
  Future<HomeScreenPageObject> onHomeScreen() async {
    await info('On Home screen');
    await exists(HomeKeys.homeScreen);
    return HomeScreenPageObject(this);
  }

  // You can include all your app's Page Objects in this file

  Future<LoginPageObject> onLoginScreen() async {
    await info('On Login screen');
    await exists(LoginKeys.loginScreen);
    return LoginPageObject(this);
  }
}
```
