# 🎯 Testing the Counter

Time to test something interactive! Our counter feature has two behaviors:

1. **Display** the current count in the label
2. **Increment** when the [+] button is tapped

## 🔑 Keys

Let's give our test the power to interact with these elements! Update `app_keys.dart` with counter-specific keys:

```dart title="lib/app_keys.dart" {3-4}
abstract class AppKeys {
  static const homeScreen = ValueKey('HomeScreen');
  static const counterLabel = ValueKey('CounterLabel');
  static const incrementButton = ValueKey('IncrementButton');
}
```

and update your `main.dart` to add keys to the counter elements:


```dart title="lib/main.dart" {3,7}
Text(
  'Click counter: $counter',
  key: AppKeys.counterLabel, // 👈 here
),

FloatingActionButton(
  key: AppKeys.incrementButton, // 👈 and here
  onPressed: () {
```

## 🧪 Update test

Now let's orchestrate the perfect counter test:

```dart title="test/e2e_test.dart" {3-5}
tapTest('My E2E Widget test', config, (tester) async {
  await tester.exists(AppKeys.homeScreen);
  await tester.expectText(AppKeys.counterLabel, 'Click counter: 0');
  await tester.tap(AppKeys.incrementButton);
  await tester.expectText(AppKeys.counterLabel, 'Click counter: 1');
});
```

Run the test `flutter test test` and you should see the following output:

```
My E2E Widget test
✅ HomeScreen exists
✅ Text of CounterLabel matches "Click counter: 0"
✅ IncrementButton tapped
✅ Text of CounterLabel matches "Click counter: 1"
00:01 +1: All tests passed!
```

## 🎉 Achievement Unlocked!

You've just created your first interactive test! You successfully verified initial state, performed a user action (button tap), and confirmed the result. This is the foundation of comprehensive testing - and it completes in under a second!

## 🧠 The TapTest philosophy

TapTest tests your app exactly like a user would - through the GUI. No peeking at internal state, no mocking interactors, routers and views. Just pure, user-focused testing that gives you confidence your app actually works!

This approach is revolutionary because:
- 🎯 **User-centric** - Tests what users actually see and do
- 🛡️ **Refactoring-safe** - Internal changes don't break tests
- 🚀 **Fast feedback** - Catches real issues quickly
- 🎪 **Comprehensive** - Tests the complete user journey

## 📚 Next Steps

👉 **[Continue to next page →](./thousand-taps-challenge)**

Learn more about tap and expectText actions **TODO LINKS**.
