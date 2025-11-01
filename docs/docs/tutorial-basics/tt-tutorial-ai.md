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

### 🔌 Connecting Navigation Keys to Widgets

Update your `main.dart` with the navigation keys:

```dart title="main.dart" 
TextField(
  key: AppKeys.nameField, // 📝 Form input key
  controller: nameController,
  decoration: InputDecoration(labelText: 'Enter name'),
),

ElevatedButton(
  key: AppKeys.submitButton, // 🚀 Navigation trigger key
  onPressed: () {
    // ... validation logic
  },
  child: Text('Submit'),
),

// In DetailScreen class:
return Scaffold(
  key: AppKeys.detailsScreen, // 📱 Screen identifier key
  appBar: AppBar(title: Text('Detail Screen')),
  body: Center(
    child: Text(
      'Welcome $name!',
      key: AppKeys.welcomeMessage, // 💬 Dynamic content key
    ),
  ),
);
```

> 🎯 **Navigation Testing Strategy:** We're targeting the form input, navigation trigger, destination screen, and dynamic content - complete journey coverage!

### 🎬 The Form Interaction Performance

Now let's add form interaction to our test symphony:

```dart title="test/e2e_test.dart" {5-7}
tapTest('🎯 Complete E2E Journey', config, (tester) async {
  // ... existing counter tests ...
  await tester.expectText(AppKeys.counterLabel, 'Click counter: 3');

  // 🎭 Act 4: Form interaction begins!
  await tester.type(AppKeys.nameField, 'John Doe');
});
```

> ✨ **The `type` Action:** This powerful action simulates user keyboard input, including focus management and text selection - just like a real user!

### ⚡ Animation Synchronization - The Secret Sauce

Here's where TapTest shows its brilliance! The submit button triggers an **animated screen transition** - unlike our simple counter button. 

**The Challenge:** Screen transitions take multiple frames to complete  
**The Solution:** `SyncType.settled` - TapTest's animation-aware synchronization

```dart title="Animation-Aware Testing" {3}
await tester.type(AppKeys.nameField, 'John Doe');
// 🎪 Magic parameter for animated transitions!
await tester.tap(AppKeys.submitButton, sync: SyncType.settled);
```

> 🎯 **Pro Insight:** `SyncType.settled` waits for **all animations to complete** before proceeding. This ensures your test doesn't race ahead of the UI - bulletproof reliability!

### 🎭 The Grand Finale - Navigation Validation

Complete the navigation journey with comprehensive validation:

```dart title="Complete Navigation Test" {4-5}
await tester.type(AppKeys.nameField, 'John Doe');
await tester.tap(AppKeys.submitButton, sync: SyncType.settled);

// 🎯 Verify successful navigation
await tester.exists(AppKeys.detailsScreen);
await tester.expectText(AppKeys.welcomeMessage, 'Welcome John Doe!');
```

### 🎪 Test Narrative Enhancement

Add context and clarity with info messages for complex test flows:

```dart title="Self-Documenting Tests" {3}
await tester.type(AppKeys.nameField, 'John Doe');
await tester.tap(AppKeys.submitButton, sync: SyncType.settled);
await tester.info('🚀 Navigated to Details screen'); // 💡 Test storytelling!
await tester.exists(AppKeys.detailsScreen);
await tester.expectText(AppKeys.welcomeMessage, 'Welcome John Doe!');
```

> 🧠 **Testing Philosophy:** While finding the welcome message implies the screen exists, **explicit checks make tests self-documenting** and easier to debug when things go wrong!

### 🏆 Beautiful Test Output

Run your enhanced test and enjoy the storytelling:

```
...
✅ Text of counterLabel matches "Click counter: 3"
✅ Typed into nameField: "John Doe"  
✅ Tapped submitButton
💡 🚀 Navigated to Details screen
✅ Exists detailsScreen
✅ Text of welcomeMessage matches "Welcome John Doe!"
```

> 🎉 **Achievement Unlocked:** You've mastered form handling and screen navigation testing!

---

## 🚨 Chapter 8: Error Handling - Testing When Things Go Wrong

### 🛡️ The Error Testing Philosophy

**Happy path testing is fantastic**, but **error scenarios** separate amateur from professional testing! Users will inevitably:
- 📝 Submit empty forms
- 🔄 Retry failed actions  
- 🚫 Encounter validation errors
- 😅 Make unexpected inputs

Let's make our app **bulletproof** by testing these scenarios!

### 🗝️ Error Dialog Keys - Your Safety Net

Add error-specific keys to handle dialog interactions:

```dart title="lib/app_keys.dart" {13-14}
abstract class AppKeys {
  // ... existing keys ...
  
  // 🚨 Error handling elements
  static const errorDialog = ValueKey('errorDialog');
  static const errorDialogOKButton = ValueKey('errorDialogOKButton');
}
```

### 🔌 Connecting Error Keys to Dialog

Update your error dialog in `main.dart`:

```dart title="main.dart - Error Dialog Enhancement" {4,9}
showDialog(
  context: context,
  builder: (context) => AlertDialog(
    key: AppKeys.errorDialog, // 🚨 Dialog identifier
    title: Text('No name'),
    content: Text('Please enter a name.'),
    actions: [
      TextButton(
        key: AppKeys.errorDialogOKButton, // 🎯 Dismissal action
        onPressed: () => Navigator.of(context).pop(),
        child: Text('OK'),
      ),
    ],
  ),
);
```

> 🎯 **Error Testing Strategy:** We're covering dialog appearance, content verification, and dismissal - complete error flow validation!

### 🔙 Navigation Cleanup - Setting the Stage

First, let's return to the home screen to test error scenarios. TapTest's `pop` action simulates the back button:

```dart title="Navigation Reset" {2}
await tester.pop(); // 🔙 Back button simulation
await tester.info('🏠 Back to Home screen'); // 💡 Clear test narrative
await tester.exists(AppKeys.homeScreen);
```

> 🎯 **Best Practice:** Always validate screen state after navigation - it makes debugging complex test failures much easier!

### 🚨 The Empty Form Challenge

Now let's trigger and handle the error dialog with precision:

```dart title="Error Scenario Testing" {1,5}
await tester.type(AppKeys.nameField, ''); // 🗑️ Clear the field
await tester.tap(AppKeys.submitButton, sync: SyncType.settled);
await tester.exists(AppKeys.errorDialog);
await tester.tap(AppKeys.errorDialogOKButton, sync: SyncType.settled);
await tester.absent(AppKeys.errorDialog); // 🛡️ Ensure cleanup
```

> 💡 **TapTest Insight:** The `type` action **replaces** existing text - perfect for testing different input scenarios!

> 🛡️ **Reliability Tip:** The `absent` assertion ensures the dialog is completely dismissed before continuing - preventing test race conditions!

> ⚡ **Animation Awareness:** Remember `sync: SyncType.settled` for dialog animations - TapTest waits for fade in/out transitions to complete!

### 🔍 Edge Case Excellence - The Professional Touch

With TapTest's blazing speed, we can afford to be **thorough**. Let's test edge cases that separate professional apps from amateur ones:

```dart title="Edge Case Testing - The Professional Touch"
// 🚨 Test #1: Whitespace-only input should also trigger error
await tester.type(AppKeys.nameField, ' ');
await tester.tap(AppKeys.submitButton, sync: SyncType.settled);
await tester.exists(AppKeys.errorDialog);
await tester.tap(AppKeys.errorDialogOKButton, sync: SyncType.settled);
await tester.absent(AppKeys.errorDialog);

// ✂️ Test #2: Whitespace trimming validation  
await tester.type(AppKeys.nameField, '  Alice   ');
await tester.tap(AppKeys.submitButton, sync: SyncType.settled);
await tester.info('🚀 Navigated to Details screen');
await tester.exists(AppKeys.detailsScreen);
await tester.expectText(AppKeys.welcomeMessage, 'Welcome Alice!'); // 🎯 Trimmed!
```

> 🏆 **Quality Mindset:** These edge cases catch bugs that **90% of developers miss** - but your users will definitely find them!

### ✅ Checkpoint #4 
- [ ] Added error handling keys to your project
- [ ] Implemented error dialog testing
- [ ] Tested edge cases (empty input, whitespace)
- [ ] Verified input trimming functionality

---

## 📍 Progress Update
⬛⬛⬛⬛⬛⬜⬜⬜⬜ **5/9 chapters** - Error handling mastered! 🛡️

---

## 🎯 Code Checkpoint - Let's Sync Up!

We've covered **a lot of ground**! Let's ensure our comprehensive E2E test is perfectly aligned:

<details>
<summary>📄 <strong>Click to see the complete `e2e_test.dart`</strong></summary>

```dart title="test/e2e_test.dart - Complete Version"
tapTest('🎯 Complete E2E Journey', config, (tester) async {
  // 🏠 Initial screen validation
  await tester.exists(AppKeys.homeScreen);
  
  // 🎯 Counter functionality testing
  await tester.expectText(AppKeys.counterLabel, 'Click counter: 0');
  await tester.tap(AppKeys.incrementButton);
  await tester.expectText(AppKeys.counterLabel, 'Click counter: 1');
  await tester.tap(AppKeys.incrementButton, count: 2);
  await tester.expectText(AppKeys.counterLabel, 'Click counter: 3');

  // 🚀 Happy path navigation
  await tester.type(AppKeys.nameField, 'John Doe');
  await tester.tap(AppKeys.submitButton, sync: SyncType.settled);
  await tester.info('🚀 Navigated to Details screen');
  await tester.exists(AppKeys.detailsScreen);
  await tester.expectText(AppKeys.welcomeMessage, 'Welcome John Doe!');

  // 🔙 Return to home for error testing
  await tester.pop();
  await tester.info('🏠 Back to Home screen');
  await tester.exists(AppKeys.homeScreen);
  
  // 🚨 Error scenario #1: Empty input
  await tester.type(AppKeys.nameField, '');
  await tester.tap(AppKeys.submitButton, sync: SyncType.settled);
  await tester.exists(AppKeys.errorDialog);
  await tester.tap(AppKeys.errorDialogOKButton, sync: SyncType.settled);
  await tester.absent(AppKeys.errorDialog);

  // 🚨 Error scenario #2: Whitespace-only input
  await tester.type(AppKeys.nameField, ' ');
  await tester.tap(AppKeys.submitButton, sync: SyncType.settled);
  await tester.exists(AppKeys.errorDialog);
  await tester.tap(AppKeys.errorDialogOKButton, sync: SyncType.settled);
  await tester.absent(AppKeys.errorDialog);

  // ✂️ Edge case: Input trimming validation
  await tester.type(AppKeys.nameField, '  Alice   ');
  await tester.tap(AppKeys.submitButton, sync: SyncType.settled);
  await tester.info('🚀 Navigated to Details screen');
  await tester.exists(AppKeys.detailsScreen);
  await tester.expectText(AppKeys.welcomeMessage, 'Welcome Alice!');
});
```
</details>

---

## 📸 Chapter 9: Snapshot Testing - Visual Perfection Guaranteed

### 🎨 The Visual Testing Revolution

Our **functional tests are fantastic** - they catch logic bugs and broken workflows. But what about:
- 🎨 **Design regressions** - Wrong colors, fonts, or spacing
- 📱 **Layout issues** - Misaligned elements or broken responsive design  
- 🌓 **Theme problems** - Dark mode rendering incorrectly
- 🔤 **Typography changes** - Unintended font modifications

**Snapshot testing** catches these visual bugs automatically!

### 🛡️ The Perfect Defense Strategy

> 💡 **Pro Strategy:** Combine **functional assertions** with **visual snapshots** for bulletproof testing. Functional tests catch logic issues, snapshots catch design regressions!

### 📸 Strategic Snapshot Placement

Add visual checkpoints at key moments in your user journey:

```dart title="Enhanced E2E with Visual Testing" {3,8,14}
tapTest('🎯 Complete E2E Journey', config, (tester) async {
  await tester.exists(AppKeys.homeScreen);
  await tester.expectText(AppKeys.counterLabel, 'Click counter: 0');
  await tester.snapshot('HomeScreen_initial'); // 📸 Initial state
  
  await tester.tap(AppKeys.incrementButton);
  await tester.expectText(AppKeys.counterLabel, 'Click counter: 1');
  await tester.tap(AppKeys.incrementButton, count: 2);
  await tester.expectText(AppKeys.counterLabel, 'Click counter: 3');
  await tester.snapshot('HomeScreen_counter3'); // 📸 After interactions
  
  await tester.type(AppKeys.nameField, 'John Doe');
  await tester.tap(AppKeys.submitButton, sync: SyncType.settled);
  await tester.info('🚀 Navigated to Details screen');
  await tester.exists(AppKeys.detailsScreen);
  await tester.expectText(AppKeys.welcomeMessage, 'Welcome John Doe!');
  await tester.snapshot('DetailsScreen_JohnDoe'); // 📸 Navigation result
  // ... rest of test
```

> 🎯 **Smart Strategy:** Always pair functional assertions with snapshots - if text changes break the functional test, you'll know the snapshot failure is a visual-only issue!

### 🎬 Recording Your Visual Golden Masters

**First run:** Record the "golden" reference images

```bash
flutter test test --update-goldens
```

**Magic happens:** TapTest creates the `goldens` folder with your reference images:

```
🏗️ Your Project Structure
 ┣ 📂 lib
 ┣ 📂 test
 ┃ ┣ 📂 goldens 📸        ← Visual golden masters
 ┃ ┃ ┣ 🖼️ HomeScreen_initial.png
 ┃ ┃ ┣ 🖼️ HomeScreen_counter3.png
 ┃ ┃ └ 🖼️ DetailsScreen_JohnDoe.png
 ┃ └ 📄 e2e_test.dart
 ┗ 📂 integration_test
```

**Subsequent runs:** Compare current UI against golden masters

```bash
flutter test test  # 🔍 Detects visual changes automatically
```

> 🎯 **Workflow:** Record once with `--update-goldens`, then run normally. TapTest will catch any visual regressions!


### Dark theme and drop the ribbon

You may have noticed that the recorded snapshots contain a glitching debug ribbon, but more importantly, snapshots are recorded in both light and dark theme, but all images show light theme only.

This is when we need to add small interoperability of TapTest with your app.

Update `MyApp` widget to accept an optional `RuntimeParams` from `taptest_runtime` and use it to configure theme mode and hide the ribbon when the value is provided (what happens only in tap-tests).

```dart
import 'package:taptest_runtime/taptest_runtime.dart';
...

final class MyApp extends StatelessWidget {
  final RuntimeParams? params;                     <--- here
  
  const MyApp({
    super.key,
    this.params,                                   <--- here
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomeScreen(),
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: params?.themeMode.value,          <--- here
      debugShowCheckedModeBanner: params == null,  <--- and here
    );
  }
}
```

then update the `builder` in the test config to make your app listen to theme changes and pass those params.

```dart
  final config = Config(
    screenSize: const Size(390, 844),
    builder: (params) {
      return ListenableBuilder(
        listenable: Listenable.merge([params.themeMode, params.locale]),
        builder: (context, _) {
          return MyApp(params: params);
        },
      );
    },
  );

  tapTest('e2e', config, (tester) async {
```

### 🎨 Perfect Visual Testing Setup

After connecting your app with TapTest runtime:

```bash
flutter test test --update-goldens  # 🔄 Update with clean visuals
```

**Results:** Clean snapshots without debug ribbon + perfect dark theme testing! 

### 📱 The Simulated Canvas Advantage

> 💡 **Performance Secret:** Notice `screenSize: const Size(390, 844)` in your config? Tests run on a **simulated canvas**, not real devices - that's why they're lightning fast!

**Canvas Benefits:**
- ⚡ **Speed**: No device overhead
- 🎯 **Consistency**: Identical rendering every time  
- 📏 **Flexibility**: Test any screen size instantly
- 🔄 **Scalability**: Run hundreds of screen size combinations

> 🛠️ **Pro Tip:** Adjust canvas size for different testing scenarios - wider for complex forms, taller for long lists. TapTest also provides scrolling actions for comprehensive testing!

## That's it!

I hope you enjoyed this tutorial so far and learned how to write effective tests with TapTest.

I'd like to iterate one more time how amazed I'm myself with the capability and performance of Widget Testing with TapTest in Flutter. The execution of this tests just takes 2 second and gives me full confidence that app looks and works as expected. 

## Integration tests

Widget tests are powerful and should be preferred for their unmatched performance, however they have limitations regarding access to device features, network and other platform services. Integration tests however run on actual physical or virtual devices, therefore they can interact with the entire platform stack.

Our current E2E tests can run without any changes as integration tests as well, therefore simply copy `e2e_test.dart` from `test` folder to `integration_test` folder. Connect a device or run, ideally an iPhone Simulator and run:

```bash
flutter test integration_test --update-goldens
```

As you see this time we run the all test from the `integration_test` folder and since we introduced snapshots, we need to record them again for the specific device hence the `--update-goldens` flag.

You may encounter the message like this:

```
[1]: iPhone 17 Pro (D3166B06-2B21-45B1-A698-8A0ACD2076A9)
[2]: iPhone 17 (33F5C8B4-BE2D-498F-A411-071642FD1608)
[3]: macOS (macos)
[4]: Chrome (chrome)
[5]: Chris 15P (wireless) (00008130-00060C693C20001C)
```

After compilation process you should witness the app running and being tested on the actual device. On My MacBook Pro (M3 Pro) it takes about 20 seconds to build this app, followed by 6 seconds to actually run the test on iPhone 17 Pro Simulator.

## One more thing - Page Object Model

Feel free to create an extensions to TapTester to encapsulate common operations on specific screens. This will make your tests more readable and maintainable.

```dart
extension MyTapTester on TapTester {
  Future<void> expectAndDismissErrorDialog() async {
    await exists(AppKeys.errorDialog);
    await tap(AppKeys.errorDialogOKButton, sync: SyncType.settled);
    await absent(AppKeys.errorDialog);
  }
}
```

Now you can use `await tester.expectAndDismissErrorDialog();` in your test steps.
