---
title: Tap Test Tutorial
---

# TapTest - tutorial

Welcome to the official TapTest tutorial!

* **🎯 What you'll build:** A comprehensive E2E automated test that verifies the app in less than 2 seconds
* **⏱️ Time needed:** 45 minutes  


### 🎯 Testing the Counter

Time to test something interactive! Our counter feature has two behaviors:

1. **Display** the current count in the label
2. **Increment** when the [+] button is tapped

Let's give our test the power to interact with these elements! Update `app_keys.dart` with counter-specific keys:

```dart title="lib/app_keys.dart"
abstract class AppKeys {
  ...
  static const counterLabel = ValueKey('CounterLabel');
  static const incrementButton = ValueKey('IncrementButton');
}
```

and update your `main.dart` to add keys to the counter elements:


```dart title="lib/main.dart"
Text(
  'Click counter: $counter',
  key: AppKeys.counterLabel, // 👈 here
),

FloatingActionButton(
  key: AppKeys.incrementButton, // 👈 and here
  onPressed: () {
```

Now let's orchestrate the perfect counter test:

```dart title="test/e2e_test.dart"
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
✅ Exists HomeScreen
✅ Text of CounterLabel matches "Click counter: 0"
✅ Tapped IncrementButton
✅ Text of CounterLabel matches "Click counter: 1"
00:01 +1: All tests passed!
```

### 🧠 The TapTest Philosophy

> **🎯 Black Box Brilliance:** TapTest tests your app exactly like a user would - through the GUI. No peeking at internal state, no mocking interactors, routers and views. Just pure, user-focused testing that gives you confidence your app actually works!

This approach is revolutionary because:
- 🎯 **User-centric** - Tests what users actually see and do
- 🛡️ **Refactoring-safe** - Internal changes don't break tests
- 🚀 **Fast feedback** - Catches real issues quickly
- 🎪 **Comprehensive** - Tests the complete user journey

### ⚡ The 1000 Taps Challenge

Ready for something that will blow your mind? Let's demonstrate TapTest's incredible speed with a performance showcase that would take a human tester **over 16 minutes** to complete manually!

```dart title="test/e2e_test.dart"
tapTest('My E2E Widget test', config, (tester) async {
  await tester.exists(AppKeys.homeScreen);
  await tester.expectText(AppKeys.counterLabel, 'Click counter: 0');
  await tester.tap(AppKeys.incrementButton);
  await tester.expectText(AppKeys.counterLabel, 'Click counter: 1');

  // 👉 Add more taps
  await tester.tap(AppKeys.incrementButton);
  await tester.tap(AppKeys.incrementButton);
  await tester.expectText(AppKeys.counterLabel, 'Click counter: 3');

  // 👉 There is also count parameter
  await tester.tap(AppKeys.incrementButton, count: 7);
  await tester.expectText(AppKeys.counterLabel, 'Click counter: 10');

  // 👉 Feel free to use typical language features like for loops
  for (var i = 11; i <= 1000; i++) {
    await tester.tap(AppKeys.incrementButton);
    await tester.expectText(AppKeys.counterLabel, 'Click counter: $i');
  }
});
```

Run the test `flutter test test` and you should see the following output:

```
My E2E Widget test
✅ Exists HomeScreen
✅ Text of CounterLabel matches "Click counter: 0"
✅ Tapped IncrementButton
✅ Text of CounterLabel matches "Click counter: 1"
✅ Tapped IncrementButton
✅ Tapped IncrementButton
✅ Text of CounterLabel matches "Click counter: 3"
✅ Tapped IncrementButton 7 times
✅ Text of CounterLabel matches "Click counter: 10"
✅ Tapped IncrementButton
✅ Text of CounterLabel matches "Click counter: 11"
✅ Tapped IncrementButton
✅ Text of CounterLabel matches "Click counter: 12"
...
✅ Tapped IncrementButton
✅ Text of CounterLabel matches "Click counter: 999"
✅ Tapped IncrementButton
✅ Text of CounterLabel matches "Click counter: 1000"
00:08 +1: All tests passed!
```

🏆 It took TapTest only **8 seconds** to perform 2000 operations!

> **Plot Twist:** The test is actually even faster - the console output slows it down by ~40%! Without logging, we're talking about **5-second execution** for 2000 operations!

With this kind of speed, you can write **comprehensive test suites** that cover:
- 🎯 Every user interaction path
- 🛡️ All edge cases and error scenarios  
- 🎨 Visual regression testing
- 📱 Multiple screen sizes and themes
- 🤯 Complex multi-step workflows

### 🔄 Rollback

Amazing demonstration, right? Now let's return to building a comprehensive, practical test suite. Here's our refined counter test:

```dart title="test/e2e_test.dart"
tapTest('My E2E Widget test', config, (tester) async {
  await tester.exists(AppKeys.homeScreen);
  await tester.expectText(AppKeys.counterLabel, 'Click counter: 0');
  await tester.tap(AppKeys.incrementButton);
  await tester.expectText(AppKeys.counterLabel, 'Click counter: 1');
  await tester.tap(AppKeys.incrementButton, count: 2);
  await tester.expectText(AppKeys.counterLabel, 'Click counter: 3');
});
```

### 🎯 Testing the Form and Navigation

Now for the grand finale of basic interactions - let's test the complete user journey:
1. **Enter name** in the text field
2. **Submit** the form  
3. **Navigate** to details screen
4. **Verify** personalized welcome message

Let's prepare keys to interact with this feature:

```dart title="lib/app_keys.dart"
abstract class AppKeys {
  ...
  static const nameField = ValueKey('NameField');
  static const submitButton = ValueKey('SubmitButton');
  static const detailsScreen = ValueKey('DetailsScreen');
  static const welcomeMessage = ValueKey('WelcomeMessage');
}
```

and update your `main.dart` with the navigation keys:

```dart title="main.dart" 
TextField(
  key: AppKeys.nameField, // 👈 here
  controller: nameController,

ElevatedButton(
  key: AppKeys.submitButton, // 👈 here
  onPressed: () {

return Scaffold(
  key: AppKeys.detailsScreen, // 👈 here
  appBar: AppBar(title: Text('Detail Screen')),
  body: Center(
    child: Text(
      'Welcome $name!',
      key: AppKeys.welcomeMessage, // 👈 and here
    ),
  ),
);
```

Now let's add first form interaction to our test:

```dart title="test/e2e_test.dart"
await tester.expectText(AppKeys.counterLabel, 'Click counter: 3');

// 👉 Here
await tester.type(AppKeys.nameField, 'John Doe');
```

> ✨ **The `type` action:** simulates keyboard input just like a real user.

### ⚡ Animation sync

The submit button triggers an **animated screen transition** - unlike the simple increment button that responds instantly. You can tap it the same way, but we should add `sync: SyncType.settled` to ensure all animations complete before moving to the next step. **This prevents your test from racing ahead of the UI.**


```dart title="test/e2e_test.dart"
await tester.tap(AppKeys.submitButton, sync: SyncType.settled);
```

### 🧑‍💻 Let's continue

Complete the navigation journey with comprehensive validation:

```dart title="test/e2e_test.dart"
await tester.exists(AppKeys.detailsScreen);
await tester.expectText(AppKeys.welcomeMessage, 'Welcome John Doe!');
```

> 🧠 **Testing Philosophy:** While finding the welcome message implies the details screen exists, **explicit checks make tests self-documenting** and easier to debug when things go wrong!

For longer test cases, I recommend adding some logging with `info` action to annotate key steps. This will make troubleshooting much easier.


```dart title="test/e2e_test.dart"
await tester.info('On Details screen'); // 👈 here
await tester.exists(AppKeys.detailsScreen);
await tester.expectText(AppKeys.welcomeMessage, 'Welcome John Doe!');
```

If you run the test `flutter test test` you should see the following output:

```
...
✅ Typed into NameField: "John Doe"
✅ Tapped SubmitButton
💡 On Details screen
✅ Exists DetailsScreen
✅ Text of WelcomeMessage matches "Welcome John Doe!"
```

> 🎉 **Achievement Unlocked:** You've mastered form handling and screen navigation testing!

### 🔙 Pop the screen

Let's return to the home screen to test error scenarios. TapTest's `pop` action simulates the back button:

```dart title="test/e2e_test.dart"
await tester.pop();
await tester.info('On Home screen');
await tester.exists(AppKeys.homeScreen);
```

This action waits for any animations to settle by default - no need to add `sync: SyncType.settled`.

> 🎯 **Best Practice:** Always validate screen state after navigation - it makes debugging complex test failures much easier!

### 🚨 Error Handling

Happy path testing is fantastic, but **error scenarios** separate amateur from professional testing! Users will inevitably:
- 📝 Submit empty forms
- 🔄 Retry failed actions  
- 🚫 Encounter validation errors
- 😅 Make unexpected inputs

Let's add keys:

```dart title="lib/app_keys.dart"
abstract class AppKeys {
  ...
  static const errorDialog = ValueKey('ErrorDialog');
  static const errorDialogOKButton = ValueKey('ErrorDialogOKButton');
}
```

... and assign them to widgets:

```dart title="lib/main.dart"
showDialog(
  context: context,
  builder: (context) => AlertDialog(
    key: AppKeys.errorDialog, // 👈 here
    title: Text('No name'),
    content: Text('Please enter a name.'),
    actions: [
      TextButton(
        key: AppKeys.errorDialogOKButton, // 👈 and here
        onPressed: () => Navigator.of(context).pop(),
        child: Text('OK'),
      ),
    ],
  ),
);
```

Now let's test the error scenario - what happens when users submit empty form? Let's clear the name field, submit it, and handle the error dialog that appears. Remember to use `sync: SyncType.settled` for dialog interactions since they have fade in/out animations. While omitting it might not cause issues now, it's excellent practice to build this into your testing muscle memory for reliable, race-condition-free tests!


```dart title="test/e2e_test.dart"
// previous steps

await tester.type(AppKeys.nameField, '');
await tester.tap(AppKeys.submitButton, sync: SyncType.settled);
await tester.exists(AppKeys.errorDialog);
await tester.tap(AppKeys.errorDialogOKButton, sync: SyncType.settled);
await tester.absent(AppKeys.errorDialog);
```

> 💡 **Pro Tips:** The `type` action **replaces** existing text. The `absent` assertion is optional but excellent practice - it explicitly verifies the dialog actually disappeared, making your tests more reliable and self-documenting!

### 🔍 All Edge Cases

With TapTest's blazing speed, we can afford to be **thorough**. Let's test all edge cases:

```dart title="test/e2e_test.dart"
// Edge Case 1: Whitespace-only input should trigger validation
await tester.type(AppKeys.nameField, ' ');
await tester.tap(AppKeys.submitButton, sync: SyncType.settled);
await tester.exists(AppKeys.errorDialog);
await tester.tap(AppKeys.errorDialogOKButton, sync: SyncType.settled);
await tester.absent(AppKeys.errorDialog);

// Edge Case 2: Input trimming - messy spacing should be cleaned up
await tester.type(AppKeys.nameField, '  Alice   ');
await tester.tap(AppKeys.submitButton, sync: SyncType.settled);
await tester.info('On Details screen');
await tester.exists(AppKeys.detailsScreen);
await tester.expectText(AppKeys.welcomeMessage, 'Welcome Alice!');
```

> 🏆 **Quality Mindset:** These edge cases catch bugs that plenty of developers miss - **but your users will definitely find them**!

### 📄 Code checkpoint

We've covered a lot, let's ensure our comprehensive E2E test is perfectly aligned:

<details>
<summary>📄 **e2e_test.dart**</summary>
```
  tapTest('My E2E Widget test', config, (tester) async {
    await tester.exists(AppKeys.homeScreen);
    await tester.expectText(AppKeys.counterLabel, 'Click counter: 0');
    await tester.tap(AppKeys.incrementButton);
    await tester.expectText(AppKeys.counterLabel, 'Click counter: 1');
    await tester.tap(AppKeys.incrementButton, count: 2);
    await tester.expectText(AppKeys.counterLabel, 'Click counter: 3');

    await tester.type(AppKeys.nameField, 'John Doe');
    await tester.tap(AppKeys.submitButton, sync: SyncType.settled);
    await tester.info('On Details screen'); // 👈 here
    await tester.exists(AppKeys.detailsScreen);
    await tester.expectText(AppKeys.welcomeMessage, 'Welcome John Doe!');

    await tester.pop();
    await tester.info('On Home screen');
    await tester.exists(AppKeys.homeScreen);

    await tester.type(AppKeys.nameField, '');
    await tester.tap(AppKeys.submitButton, sync: SyncType.settled);
    await tester.exists(AppKeys.errorDialog);
    await tester.tap(AppKeys.errorDialogOKButton, sync: SyncType.settled);
    await tester.absent(AppKeys.errorDialog);

    // Edge Case 1: Whitespace-only input should trigger validation
    await tester.type(AppKeys.nameField, ' ');
    await tester.tap(AppKeys.submitButton, sync: SyncType.settled);
    await tester.exists(AppKeys.errorDialog);
    await tester.tap(AppKeys.errorDialogOKButton, sync: SyncType.settled);
    await tester.absent(AppKeys.errorDialog);

    // Edge Case 2: Input trimming - messy spacing should be cleaned up
    await tester.type(AppKeys.nameField, '  Alice   ');
    await tester.tap(AppKeys.submitButton, sync: SyncType.settled);
    await tester.info('On Details screen');
    await tester.exists(AppKeys.detailsScreen);
    await tester.expectText(AppKeys.welcomeMessage, 'Welcome Alice!');
  });
```
</details>

## 📸 Snapshot tests

> 💡 This is a continuation of **Widget testing**, but it deserves its own section.

Our **functional tests are fantastic** - they catch logic bugs and broken workflows. But what about:
- 🎨 **Design regressions** - Wrong colors, fonts, or spacing
- 📱 **Layout issues** - Misaligned elements or broken responsive design  
- 🌓 **Theme problems** - Dark mode rendering incorrectly
- 🔤 **Typography changes** - Unintended font modifications

**Snapshot testing** catches these visual bugs automatically!

> 💡 **Pro Strategy:** Combine **functional assertions** with **visual snapshots** for bulletproof testing. Functional tests catch logic issues, snapshots catch design regressions!

### 🎯 Strategic snapshot placement

Add visual checkpoints at key moments in your user journey:

```dart title="test/e2e_test.dart" {3,9,16}
await tester.exists(AppKeys.homeScreen);
await tester.expectText(AppKeys.counterLabel, 'Click counter: 0');
await tester.snapshot('HomeScreen_initial');

await tester.tap(AppKeys.incrementButton);
await tester.expectText(AppKeys.counterLabel, 'Click counter: 1');
await tester.tap(AppKeys.incrementButton, count: 2);
await tester.expectText(AppKeys.counterLabel, 'Click counter: 3');
await tester.snapshot('HomeScreen_counter3');

await tester.type(AppKeys.nameField, 'John Doe');
await tester.tap(AppKeys.submitButton, sync: SyncType.settled);
await tester.info('🚀 Navigated to Details screen');
await tester.exists(AppKeys.detailsScreen);
await tester.expectText(AppKeys.welcomeMessage, 'Welcome John Doe!');
await tester.snapshot('DetailsScreen_JohnDoe');
```

### 🎬 Record current snapshots

Run the test with `--update-goldens` flag to record the current snapshots:

```bash
flutter test test --update-goldens
```

TapTest creates the `goldens` folder with your reference images:

```
Your project
 ┣ 📂 lib
 ┣ 📂 test
 ┃ ┣ 📂 goldens
 ┃ ┃ ┣ 🌇 🌁 🌅 snapshots are here
 ┃ ┃ ┗ ☀️ 🌙 in light and dark themes
 ┃ ┗ 📄 e2e_test.dart
 ┗ 📂 integration_test
```

Subsequent runs (without `--update-goldens`) will compare current UI against prerecorded.

```bash
flutter test test
```

> 🎯 **Workflow:** Record once with `--update-goldens`, then run as usual. TapTest will catch any visual regressions.

### 🎨 Dark Theme and drop the debug ribbon

We have two problems to solve:
1. 🐛 **Debug ribbon** appears in snapshots (not cool, and glitched)
2. 🌓 **Theme testing** - snapshots only show light theme even in dark theme snapshot files

**The solution?** Connect your app to TapTest's runtime parameters for complete control!

Update your app to accept TapTest's runtime parameters:

```dart title="lib/main.dart" {1,5,9,16,17}
import 'package:taptest_runtime/taptest_runtime.dart';
// ... other imports

final class MyApp extends StatelessWidget {
  final RuntimeParams? params; // 🎯 Provided by TapTest during testing
  
  const MyApp({
    super.key,
    this.params,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomeScreen(),
      themeMode: params?.themeMode.value, // 🌓 Theme overwrite
      debugShowCheckedModeBanner: params == null, // 🎨 Hide debug ribbon
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
    );
  }
}
```

Update your test config to make your app reactive to theme changes:

```dart title="test/e2e_test.dart" {4-9}
final config = Config(
  screenSize: const Size(390, 844),
  builder: (params) {
    return ListenableBuilder(
      listenable: Listenable.merge([params.themeMode, params.locale]),
      builder: (context, _) {
        return MyApp(params: params); // 🎯 Pass runtime params
      },
    );
  },
);
```

After connecting your app with TapTest runtime:

```bash
flutter test test --update-goldens
```

**Results:** Clean snapshots without debug ribbon + perfect dark theme testing! 

### 📺 The Simulated Canvas

Notice `screenSize: const Size(390, 844)` in your config? Widget Tests run on a **simulated canvas**, not real devices - that's why they're lightning fast!

> 🛠️ **Pro Tip:** Adjust canvas size for different testing scenarios - wider for landscape, super tal for long lists and forms. TapTest also provides scrolling actions for comprehensive testing!

## 📱 Integration tests

**Widget tests are incredible** for 90% of your testing needs, but sometimes you need the **full platform stack**:

| Need                     | Widget Tests      | Integration Tests   |
| ------------------------ | ----------------- | ------------------- |
| 🎯 **UI Logic**           | ✅ Perfect         | ✅ Also works        |
| 🌐 **Network Calls**      | ❌ (Mock required) | ✅ Real APIs         |
| 📷 **Camera/Photos**      | ❌ (Mock required) | ✅ Device features   |
| 🔔 **Push Notifications** | ❌ (Mock required) | ✅ Platform services |
| 📍 **Location Services**  | ❌ (Mock required) | ✅ GPS access        |

### 📄 Same code

Your widget tests become integration tests with ZERO changes! Same test code, same assertions, **similar snapshots** - just running on real devices instead of simulated canvas!

Simply copy `e2e_test.dart` from `test` folder to `integration_test` folder.

```
Your project
 ┣ 📂 lib
 ┣ 📂 test
 ┃ ┣ 📂 goldens
 ┃ ┗ 📄 e2e_test.dart
 ┗ 📂 integration_test
   ┗ 📄 e2e_test.dart 👈 here
```

Start iOS or Android simulator or connect a physical device, then run:

```
flutter test integration_test --update-goldens
```

Watch your app come alive on device as TapTest executes your comprehensive test suite with **identical assertions and perfect accuracy**!

> 📋 **Device selection:** If you have connected more than one compatible device you will be presented with the choice menu where to run your tests. You can select the device upfront by passing the `-d` parameter (device ID) e.g. `flutter test integration_test -d D3166B06-2B21...`.

> 🎉 **Achievement Unlocked!** You can now run integration tests as well. Skip the `--update-goldens` flag in subsequent runs.
