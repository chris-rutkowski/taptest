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

|                   | Widget Tests ⚡              | Integration Tests 📱      |
| ----------------- | --------------------------- | ------------------------- |
| **Speed**         | 🚀 hundred taps per second   | 🏁 acceptable             |
| **Environment**   | Simulated canvas            | Real device (or emulator) |
| **Network**       | ❌ has to be mocked          | ✅ Full access, mockable  |
| **Platform APIs** | ❌ has to be mocked          | ✅ Full access, mockable  |


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

As before assign those keys to the widgets in `main.dart`:

```dart
TextField(
  key: AppKeys.nameField,                       <--- here
  controller: nameController,

ElevatedButton(
  key: AppKeys.submitButton,                    <--- here
  onPressed: () {

return Scaffold(
  key: AppKeys.detailsScreen,                   <--- here
  appBar: AppBar(title: Text('Detail Screen')),
  body: Center(
    child: Text(
      'Welcome $name!',
      key: AppKeys.welcomeMessage,
    ),
  ),
);
```

Now let's use the `type` action. Append to existing test:

```dart
tapTest('e2e', config, (tester) async {
  ...
  await tester.expectText(AppKeys.counterLabel, 'Click counter: 3');

  // this
  await tester.type(AppKeys.nameField, 'John Doe');
});
```

### Settled taps to handle transitions

You need to tap the submit button, but simple `await tester.tap(AppKeys.submitButton);` has one gimmick. The previously tapped increment button wasn't doing anything fancy. This button however perform an animated screen transition to details screen. By default tap action allows Flutter engine to draw a single frame, but screen transition takes multiple frames to complete. In these cases, remember to add a parameter `syncType: SyncType.settled`. This will make sure the next action is performed only when all occurring animations are completed.

```
await tester.type(AppKeys.nameField, 'John Doe');
await tester.tap(AppKeys.submitButton, sync: SyncType.settled);
```

### Let's continue

Add the two remaining assertions to verify the details screen is visible and the welcome message is correct.

```dart
await tester.exists(AppKeys.detailsScreen);
await tester.expectText(AppKeys.welcomeMessage, 'Welcome John Doe!');
```

You don't really need to check the existence of the details screen, because if the welcome message is found, it means the details screen is visible. However, I like to have explicit steps in my tests to make it clear what is being tested. Moreover, I like to annotate screen changes with `info` step that simply prints a log message like this:

```dart
await tester.type(AppKeys.nameField, 'John Doe');
await tester.tap(AppKeys.submitButton, sync: SyncType.settled);
await tester.info('On Details screen');                         <--- here
await tester.exists(AppKeys.detailsScreen);
await tester.expectText(AppKeys.welcomeMessage, 'Welcome JohnDoe!');
```

If you run the test `flutter test test` you should see the following output:

```
...
✅ Text of counterLabel matches "Click counter: 3"
✅ Typed into nameField: "John Doe"
✅ Tapped submitButton
💡 On Details screen
✅ Exists detailsScreen
✅ Text of welcomeMessage matches "Welcome John Doe!"
```

## Test the errors

Happy path tests are great, but you should also test how your app behaves in error situations. In our case if user presses the submit button without entering a name, an error dialog is shown.

Same drill. We need to add some keys and assign them to the widgets.

```dart
abstract class AppKeys {
  ...
  static const errorDialog = ValueKey('errorDialog');
  static const errorDialogOKButton = ValueKey('errorDialogOKButton');
}

showDialog(
  context: context,
  builder: (context) => AlertDialog(
    key: AppKeys.errorDialog,                         <--- here
    title: Text('No name'),
    content: Text('Please enter a name.'),
    actions: [
      TextButton(
        key: AppKeys.errorDialogOKButton,             <--- and here
        onPressed: () => Navigator.of(context).pop(),
        child: Text('OK a'),
      ),
    ],
  ),
);
```

### Close the detail screen

App could have a dedicated button to close the detail screen, but in this simple case we rely on the default App Bar's back button. You can use `pop` action to close it. Again, as a good practice I recommend checking if you are on the correct screen and announce it with `info` action. This will make troubleshooting more complex tests easier.

```dart
await tester.pop();
await tester.info('On Home screen');
await tester.exists(AppKeys.homeScreen);
```

### Submit the form with empty name

Executing `type` action on the same field will replace its value, so let's replace it with an empty text. Then tap the submit button and experience the error dialog flow. You will promptly close it and for test stability let's make sure it is really gone (`absent` action), before we add more steps in the next section.

```dart
await tester.type(AppKeys.nameField, '');
await tester.tap(AppKeys.submitButton, sync: SyncType.settled);
await tester.exists(AppKeys.errorDialog);
await tester.tap(AppKeys.errorDialogOKButton, sync: SyncType.settled);
await tester.absent(AppKeys.errorDialog);
```

Please remember about settled taps. The dialog appearance and disappearance are animated with a fade in/out transition.

### Nitpicking

I can assume app is pretty well tested. If this test gives me green light, I'm confident to push the next release to the stores. However, with the performance we demonstrated during the 1000 taps tests, I will check the additional edge cases.

```dart
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
```

## Code check

This was a lot, let's make sure we have the same e2e test.

<details>
<summary>`e2e_test.dart`</summary>
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

## Add snapshot tests

Existing verifies application very well. If basic functionality breaks, e.g. counter stopped working, the test will highlight it.

Snapshot tests are good addition to verify that user see our pixel-perfect design, that all colors, fonts, sizes, spacing, icons and images are as expected.

I recommend to always match snapshots test with actual expectations. Lazy developers tend to fix snapshots, by re-recording them. But if snapshot fails, because label displays wrong text, re-recording the snapshot will hide the actual problem, but the `expectText` action will still catch it.

Update the test to include the `snapshot` actions at key points in the test flow:

```dart
tapTest('e2e', config, (tester) async {
  await tester.exists(AppKeys.homeScreen);
  await tester.expectText(AppKeys.counterLabel, 'Click counter: 0');
  await tester.snapshot('HomeScreen_initial');                        <--- here
  await tester.tap(AppKeys.incrementButton);
  await tester.expectText(AppKeys.counterLabel, 'Click counter: 1');
  await tester.tap(AppKeys.incrementButton, count: 2);
  await tester.expectText(AppKeys.counterLabel, 'Click counter: 3');
  await tester.snapshot('HomeScreen_counter3');                       <--- here
  await tester.type(AppKeys.nameField, 'John Doe');
  await tester.tap(AppKeys.submitButton, sync: SyncType.settled);
  await tester.info('On Details screen');
  await tester.exists(AppKeys.detailsScreen);
  await tester.expectText(AppKeys.welcomeMessage, 'Welcome John Doe!');
  await tester.snapshot('DetailsScreen_JohnDoe');                     <--- here
  ...
```

### Record snapshots

Snapshots first needs to be recorded and in subsequent test runs compared against the recorded versions.

Run your test with a flag as follows:

```bash
flutter test test --update-goldens
```

The recorded snapshots are stored in the `goldens` folder inside the `test` directory:

```
Your project
 ┣ 📂 lib
 ┣ 📂 test
 ┃ ┗ 📂 goldens         <--- here
 ┗ 📂 integration_test
```

Now running tests with `flutter test test` will compare current screenshots with the recorded versions. If in future you need to update the snapshots, simply run the tests again with `--update-goldens` flag.


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

Rerun your tests with `--update-goldens` flag to updated new snapshots. You will notice the debug ribbon is gone and dark theme snapshots are recorded correctly.

Since we are here, did you noticed `screenSize: const Size(390, 844)` in the configuration? These tests do not run on any real device, that's why they are so fast. They run in a simulated canvas and this param control its size. It may be convenient to run some tests on artificially longer simulated screen to easily interact with lists and complex forms, however please note TapTest offers actions for scrolling as well.

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
