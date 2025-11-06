# ⚡ 1000-taps challenge

Ready for something that will blow your mind? Let's demonstrate TapTest's incredible speed with a performance showcase that would take a human tester **over 16 minutes** to complete manually!

```dart title="test/e2e_test.dart" {7-20}
tapTest('My E2E Widget test', config, (tt) async {
  await tt.exists(AppKeys.homeScreen);
  await tt.expectText(AppKeys.counterLabel, 'Click counter: 0');
  await tt.tap(AppKeys.incrementButton);
  await tt.expectText(AppKeys.counterLabel, 'Click counter: 1');

  // 👉 Add more taps
  await tt.tap(AppKeys.incrementButton);
  await tt.tap(AppKeys.incrementButton);
  await tt.expectText(AppKeys.counterLabel, 'Click counter: 3');

  // 👉 There is also count parameter
  await tt.tap(AppKeys.incrementButton, count: 7);
  await tt.expectText(AppKeys.counterLabel, 'Click counter: 10');

  // 👉 Feel free to use typical language features like for loops
  for (var i = 11; i <= 1000; i++) {
    await tt.tap(AppKeys.incrementButton);
    await tt.expectText(AppKeys.counterLabel, 'Click counter: $i');
  }
});
```

Run the test `flutter test test` and you should see the following output:

## 📋 Result

```
My E2E Widget test
✅ HomeScreen exists
✅ Text of CounterLabel matches "Click counter: 0"
✅ IncrementButton tapped
✅ Text of CounterLabel matches "Click counter: 1"
✅ IncrementButton tapped
✅ IncrementButton tapped
✅ Text of CounterLabel matches "Click counter: 3"
✅ IncrementButton tapped 7 times
✅ Text of CounterLabel matches "Click counter: 10"
✅ IncrementButton tapped
✅ Text of CounterLabel matches "Click counter: 11"
✅ IncrementButton tapped
✅ Text of CounterLabel matches "Click counter: 12"
...
✅ IncrementButton tapped
✅ Text of CounterLabel matches "Click counter: 999"
✅ IncrementButton tapped
✅ Text of CounterLabel matches "Click counter: 1000"
00:08 +1: All tests passed!
```

🏆 It took TapTest only **8 seconds** to perform 2000 operations - 1000 taps and 1,000 text verifications! **Plot Twist:** The test is actually even faster - the console output slows it down by ~40%! Without logging (configurable), we're talking about 5-second execution!

With this kind of speed, you can write **comprehensive test suites** that cover:
- 🎯 Every user interaction path
- 🛡️ All edge cases and error scenarios  
- 🎨 Visual regression testing
- 📱 Multiple screen sizes and themes
- 🤯 Complex multi-step workflows

## 🔄 Rollback to practical testing

Amazing demonstration, right? You've seen TapTest's incredible performance capabilities! However, for practical test development, we don't need such extreme scenarios. Let's drop this performance showcase and return to building a clean, comprehensive test suite that focuses on real-world functionality.

Here's our refined counter test - much more maintainable and focused on actual user behavior:

```dart title="test/e2e_test.dart"
tapTest('My E2E Widget test', config, (tt) async {
  await tt.exists(AppKeys.homeScreen);
  await tt.expectText(AppKeys.counterLabel, 'Click counter: 0');
  await tt.tap(AppKeys.incrementButton);
  await tt.expectText(AppKeys.counterLabel, 'Click counter: 1');
  await tt.tap(AppKeys.incrementButton, count: 2);
  await tt.expectText(AppKeys.counterLabel, 'Click counter: 3');
});
```

## 📚 Next steps

- **[Continue to next page →](./testing-form)**
