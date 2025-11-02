---
title: Tap Test Tutorial
---

# TapTest - tutorial

Welcome to the official TapTest tutorial!

* **🎯 What you'll build:** A comprehensive E2E automated test that verifies the app in less than 2 seconds
* **⏱️ Time needed:** ~45 minutes  

## 📄 Starting source code

We'll start with a simple two-screen app that showcases real-world patterns, includes buttons, text fields, handles bad input.

[Screenshot placeholder]

Create a brand new Flutter project and replace the contents of `lib/main.dart` with the following code:

<details>
<summary>📄 **main.dart**</summary>

```dart
import 'package:flutter/material.dart';

import 'app_keys.dart';

void main() {
  runApp(const MyApp());
}

final class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: HomeScreen(), theme: ThemeData.light(), darkTheme: ThemeData.dark());
  }
}

final class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

final class _HomeScreenState extends State<HomeScreen> {
  final nameController = TextEditingController();
  int counter = 0;

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  void showNoNameErrorDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('No name'),
        content: Text('Please enter a name.'),
        actions: [TextButton(onPressed: () => Navigator.of(context).pop(), child: Text('OK'))],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Welcome')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: nameController,
                    decoration: InputDecoration(labelText: 'Enter name'),
                  ),
                ),
                SizedBox(width: 16),
                ElevatedButton(
                  onPressed: () {
                    final trimmedName = nameController.text.trim();
                    if (trimmedName.isEmpty) {
                      showNoNameErrorDialog();
                      return;
                    }

                    final navigator = Navigator.of(context);
                    navigator.push(MaterialPageRoute(builder: (context) => DetailScreen(name: trimmedName)));
                  },
                  child: Text('Submit'),
                ),
              ],
            ),
            SizedBox(height: 32),
            Text('Click counter: $counter'),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            counter++;
          });
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

final class DetailScreen extends StatelessWidget {
  final String name;
  const DetailScreen({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Detail Screen')),
      body: Center(child: Text('Welcome $name!')),
    );
  }
}

```
</details>

## 📦 Add TapTest dependencies

TapTest uses a two-package approach to keep your production app lean.

```yaml title="pubspec.yaml"
dependencies:
  taptest_runtime:  # 🪶 Lightweight runtime (production-safe)

dev_dependencies:
  taptest:          # 🚀 Full testing power (dev-only)
```

## 📁 Project Structure

Create `test` and `integration_test` folders in your project root like this:

```
Your project
 ┣ 📂 lib
 ┃ ┗ 📜 main.dart
 ┣ 📂 test
 ┗ 📂 integration_test
```

> 💡 For now we will focus on writing Widget tests in the `test` folder.

## 🧪 Widget tests

> 💡 **Golden Rule:** Start with widget tests for 90% of your testing needs, then add integration tests for device-specific features!

|                   | Widget Tests ⚡            | Integration Tests 📱       |
| ----------------- | ------------------------- | ------------------------- |
| **Speed**         | 🚀 hundred taps per second | 🏁 acceptable              |
| **Environment**   | Simulated canvas          | Real device (or emulator) |
| **Network**       | ❌ has to be mocked        | ✅ Full access, mockable   |
| **Platform APIs** | ❌ has to be mocked        | ✅ Full access, mockable   |


### 🧑‍💻 Let's start

Create `e2e_test.dart` file in the `test` folder:

```dart title="test/e2e_test.dart"
import 'package:your_app/main.dart'; // 👈 Replace 'your_app' with your package name
import 'package:flutter/material.dart';
import 'package:taptest/taptest.dart';

void main() {
  final config = Config(
    screenSize: const Size(350, 600),
    builder: (params) {
      return MyApp();
    },
  );

  tapTest('E2E', config, (tester) async {
    // 🎪 The magic happens here - coming up next!
  });
}
```
> ⚠️ **Important:** All test files must end with `_test.dart` - Flutter's testing convention!

Run test with the command as follows:

```bash
flutter test test
```

> 💡 **test test?** First _test_ is a command like _build_, _test_, _run_. Second _test_ indicates a folder. Above command will run all tests buried in the _test_ directory. To run a specific test, run `flutter test test/e2e_test.dart`.

### 🔑 Keys

In TapTest, we identify and interact with widgets using **keys** - think of them as unique IDs for every interactive element. Create a file `app_keys.dart` in the `lib` folder:

```dart title="lib/app_keys.dart"
import 'package:flutter/material.dart';

abstract class AppKeys {
  static const homeScreen = ValueKey('homeScreen');
  // more keys coming soon
}
```

> 🏗️ **Scaling Strategy:** As your app grows, organize keys by feature (`AuthKeys`, `ProfileKeys`, `ShoppingKeys`) - but for now, one file is perfect!

Update your `main.dart` to import and use the keys:

```dart title="lib/main.dart"
import 'app_keys.dart';                     // 👈 import app_keys.dart

...

Widget build(BuildContext context) {
  return Scaffold(
    key: AppKeys.homeScreen,                // 👈 add key in HomeScreen widget
    appBar: AppBar(title: Text('Welcome')),
```

Update your test to perform its first check:

```dart title="test/e2e_test.dart"
import 'package:your_app/app_keys.dart'; // 👈 import app_keys.dart

...

tapTest('🎯 Complete E2E Journey', config, (tester) async {
  // 🎉 Your first assertion!
  await tester.exists(AppKeys.homeScreen);
});
```

**Run it:** `flutter test test`, expected output:

```
E2E
✅ Exists homeScreen
00:01 +1: All tests passed!
```

> 🎉 **Achievement Unlocked!** You've just verified your app starts correctly.

### 🎯 Testing the Counter

Time to test something interactive! Our counter feature has two key behaviors:

1. **Display** the current count
2. **Increment** when the + button is tapped

Let's give our test the power to interact with these elements! Update `app_keys.dart` with counter-specific keys:

```dart title="lib/app_keys.dart"
abstract class AppKeys {
  ...
  static const counterLabel = ValueKey('counterLabel');
  static const incrementButton = ValueKey('incrementButton');
}
```

and update your `main.dart` to add keys to the counter elements:


```dart title="main.dart"
Text(
  'Click counter: $counter',
  key: AppKeys.counterLabel, // 👈 here
),

FloatingActionButton(
  key: AppKeys.incrementButton, // 👈 and here
),
```

Now let's orchestrate the perfect counter test:

```dart title="test/e2e_test.dart"
tapTest('E2E', config, (tester) async {
  await tester.exists(AppKeys.homeScreen);
  await tester.expectText(AppKeys.counterLabel, 'Click counter: 0');
  await tester.tap(AppKeys.incrementButton);
  await tester.expectText(AppKeys.counterLabel, 'Click counter: 1');
});
```

Run the test `flutter test test` and you should see the following output:

```
E2E
✅ Exists homeScreen
✅ Text of counterLabel matches "Click counter: 0"
✅ Tapped incrementButton  
✅ Text of counterLabel matches "Click counter: 1"
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
tapTest('E2E', config, (tester) async {
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
E2E                   
✅ Exists homeScreen
✅ Text of counterLabel matches "Click counter: 0"
✅ Tapped incrementButton
✅ Text of counterLabel matches "Click counter: 1"
✅ Tapped incrementButton
✅ Tapped incrementButton
✅ Text of counterLabel matches "Click counter: 3"
✅ Tapped incrementButton 7 times
✅ Text of counterLabel matches "Click counter: 10"
✅ Tapped incrementButton
✅ Text of counterLabel matches "Click counter: 11"
✅ Tapped incrementButton
✅ Text of counterLabel matches "Click counter: 12"
...
✅ Tapped incrementButton
✅ Text of counterLabel matches "Click counter: 999"
✅ Tapped incrementButton
✅ Text of counterLabel matches "Click counter: 1000"
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
tapTest('e2e', config, (tester) async {
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
  static const nameField = ValueKey('nameField');
  static const submitButton = ValueKey('submitButton');
  static const detailsScreen = ValueKey('detailsScreen');
  static const welcomeMessage = ValueKey('welcomeMessage');
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

### ⚡ Animation Synchronization

The submit button triggers an **animated screen transition** - unlike our simple increment counter button before. Tap it with a `SyncType.settled` to wait for **all animations to complete** before proceeding to next step. This ensures your test doesn't race ahead of the UI - bulletproof reliability!

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
✅ Typed into nameField: "John Doe"
✅ Tapped submitButton
💡 On Details screen
✅ Exists detailsScreen
✅ Text of welcomeMessage matches "Welcome John Doe!"
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
  static const errorDialog = ValueKey('errorDialog');
  static const errorDialogOKButton = ValueKey('errorDialogOKButton');
}
```

... and assign them to widgets:

```dart title="main.dart"
showDialog(
  context: context,
  builder: (context) => AlertDialog(
    key: AppKeys.errorDialog,                         // 👈 here
    title: Text('No name'),
    content: Text('Please enter a name.'),
    actions: [
      TextButton(
        key: AppKeys.errorDialogOKButton,             // 👈 and here
        onPressed: () => Navigator.of(context).pop(),
        child: Text('OK a'),
      ),
    ],
  ),
);
```

#### Submit the form with empty name

```dart title="test/e2e_test.dart"
await tester.type(AppKeys.nameField, '');
await tester.tap(AppKeys.submitButton, sync: SyncType.settled);
await tester.exists(AppKeys.errorDialog);
await tester.tap(AppKeys.errorDialogOKButton, sync: SyncType.settled);
await tester.absent(AppKeys.errorDialog);
```

> 💡 **TapTest Insight:** The `type` action **replaces** existing text - perfect for testing different input scenarios!

> 🛡️ **Reliability Tip:** The `absent` assertion ensures the dialog is completely dismissed before continuing - preventing test race conditions!

> ⚡ **Animation Awareness:** Remember `sync: SyncType.settled` for dialog animations - TapTest waits for fade in/out transitions to complete!


### 🔍 All Edge Cases

With TapTest's blazing speed, we can afford to be **thorough**. Let's test all edge cases:

```dart title="test/e2e_test.dart"
// Whitespace-only input should also trigger error
await tester.type(AppKeys.nameField, ' ');
await tester.tap(AppKeys.submitButton, sync: SyncType.settled);
await tester.exists(AppKeys.errorDialog);
await tester.tap(AppKeys.errorDialogOKButton, sync: SyncType.settled);
await tester.absent(AppKeys.errorDialog);

// Whitespace should be trimmed from welcome message
await tester.type(AppKeys.nameField, '  Alice   ');
await tester.tap(AppKeys.submitButton, sync: SyncType.settled);
await tester.info('On Details screen');
await tester.exists(AppKeys.detailsScreen);
await tester.expectText(AppKeys.welcomeMessage, 'Welcome Alice!');
```

> 🏆 **Quality Mindset:** These edge cases catch bugs that plenty of developers miss - **but your users will definitely find them**!

### 📄 Code Checkpoint

We've covered a lot, let's ensure our comprehensive E2E test is perfectly aligned:

<details>
<summary>📄 **e2e_test.dart**</summary>
```
  tapTest('e2e', config, (tester) async {
    await tester.exists(AppKeys.homeScreen);
    await tester.expectText(AppKeys.counterLabel, 'Click counter: 0');
    await tester.tap(AppKeys.incrementButton);
    await tester.expectText(AppKeys.counterLabel, 'Click counter: 1');
    await tester.tap(AppKeys.incrementButton, count: 2);
    await tester.expectText(AppKeys.counterLabel, 'Click counter: 3');

    await tester.type(AppKeys.nameField, 'John Doe');
    await tester.tap(AppKeys.submitButton, sync: SyncType.settled);
    await tester.info('On Details screen');
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

    // White space should also trigger the error dialog
    await tester.type(AppKeys.nameField, ' ');
    await tester.tap(AppKeys.submitButton, sync: SyncType.settled);
    await tester.exists(AppKeys.errorDialog);
    await tester.tap(AppKeys.errorDialogOKButton, sync: SyncType.settled);
    await tester.absent(AppKeys.errorDialog);

    // White spaces should be trimmed from the welcome message
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

### 🎯 Strategic Snapshot Placement

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

**First run:** the test with `--update-goldens` flag to record the current snapshots:

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

**Subsequent runs:** Compare current UI against golden masters

```bash
flutter test test
```

> 🎯 **Workflow:** Record once with `--update-goldens`, then run normally. TapTest will catch any visual regressions!

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
  final RuntimeParams? params; // 🎯 Provided only during TapTest testing
  
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

