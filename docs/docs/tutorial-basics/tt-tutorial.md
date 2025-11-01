---
title: Tap Test Tutorial
---

Start with a simple two screens app including a few interactive elements like buttons and text fields.

[Screenshot]

<details>
<summary>`main.dart`</summary>

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

Add two dependencies to your `pubspec.yaml` file:

```yaml
dependencies:
  taptest_runtime:

dev_dependencies:
  taptest:
```

I've split TapTest into two main packages so the actual testing library doesn't clutter your production dependencies. The thin runtime package exposes a small subset of types.

Create `test` and `integration_test` folders in your project root like this:

```
Your project
 ┣ 📂 lib
 ┃ ┗ 📜 main.dart
 ┣ 📂 test
 ┗ 📂 integration_test
```

For now we will focus on writing tests in the `test` folder.

# Widget tests

Widget tests are extremely fast, but have a few limitations. They cannot access network, interact with device features, but once you are able to mock those dependencies, widget tests are a great way to have very comprehensive test of your app UI and business logic.

For now we will focus on adding widget tests to the `test` folder.

Create `e2e_test.dart` file in the `test` folder:

```dart

import 'package:your_app/main.dart'; <-- Replace your_app
import 'package:flutter/material.dart';
import 'package:taptest/taptest.dart';

void main() {
  final config = Config(
    screenSize: const Size(390, 844),
    builder: (params) {
      return MyApp();
    },
  );

  tapTest('e2e', config, (tester) async {
    // Test steps here
  });
}
```

Please note all test filenames have to end with `_test`!

You can run this test as follows:

```bash
flutter test test
```

First `test` is a command and the second `test` is a directory. It will run all tests in the `test` directory. You could run a specific test file like this: `flutter test test/e2e_test.dart` or using UI elements in your IDE.

The test we have written doesn't do much yet, but as the name implies - e2e it will eventually cover entire end to end scenario.

Let's ensure that when the app starts the HomeScreen is visible.

## Keys

In TapTest we asses and interact with elements by **keys**. Let's create some bucket (e.g. abstract class) to hold keys used throughout the app. Create a file `app_keys.dart` in the `lib` folder:

```dart
import 'package:flutter/material.dart';

abstract class AppKeys {
  static const homeScreen = ValueKey('homeScreen');
  // more keys coming soon
}

```

As your app grows bigger you will split files containing keys by module, feature, screen or your other preferred way.

Now let's assign this key to the HomeScreen widget in `main.dart`:

```dart
// import the app_keys.dart file
import 'app_keys.dart';

// Update build method of HomeScreen widget

  @override
  Widget build(BuildContext context) {
    return Scaffold(
----> key: AppKeys.homeScreen,
      appBar: AppBar(title: Text('Welcome')),
```

Now update the test - `e2e_test.dart`.

```dart
// import the app_keys.dart file from your app package
import 'package:your_app/app_keys.dart';

...

tapTest('e2e', config, (tester) async {
  await tester.exists(AppKeys.homeScreen);
});
```

Feel free to run the test again. It will pass and it already confirms your app starts at the HomeScreen.

It's a good practice to keep keys in a separate file, so that test only import that file and doesn't see the app implementation details.

## Let's check the counter

Let's test one of two basic functionalities - the counter.

You will need to check the text of the label and press the increment button, therefore we need to add two keys to be able to interact and assert elements.

Modify `app_keys.dart` to include these keys:

```dart
abstract class AppKeys {
  ...
  static const counterLabel = ValueKey('counterLabel');
  static const incrementButton = ValueKey('incrementButton');
}
```

And assign those keys in `main.dart`:

```dart
Text(
  'Click counter: $counter',
  key: AppKeys.counterLabel,    <--- here
)

FloatingActionButton(
  key: AppKeys.incrementButton, <--- and here
  ...
)
```

Now let's verify the text of the counter, tap the button and confirm the counter incremented.

```dart
tapTest('e2e', config, (tester) async {
  await tester.exists(AppKeys.homeScreen);

  await tester.expectText(AppKeys.counterLabel, 'Click counter: 0');
  await tester.tap(AppKeys.incrementButton);
  await tester.expectText(AppKeys.counterLabel, 'Click counter: 1');
});
```

Run the test `flutter test test`, hopefully it will work as expected and display the following output in the console:

```
e2e                                                                    
✅ Exists homeScreen
✅ Text of counterLabel matches "Click counter: 0"
✅ Tapped incrementButton
✅ Text of counterLabel matches "Click counter: 1"
00:01 +1: All tests passed!
```

This is the whole principle behind of TapTest - to use the true public interface - the GUI to test the app. User press the button, user wants to see the updated counter, without the knowledge what state contraption may be behind it.

## 1000 taps in 8 seconds

Feel free to try the following code.

```dart
...
tapTest('e2e', config, (tester) async {
  // This is what you have now
  await tester.exists(AppKeys.homeScreen);
  await tester.expectText(AppKeys.counterLabel, 'Click counter: 0');
  await tester.tap(AppKeys.incrementButton);
  await tester.expectText(AppKeys.counterLabel, 'Click counter: 1');

  // Let's tap button twice
  await tester.tap(AppKeys.incrementButton);
  await tester.tap(AppKeys.incrementButton);
  await tester.expectText(AppKeys.counterLabel, 'Click counter: 3');

  // Let's tap the button 7 times with dedicated count parameter
  await tester.tap(AppKeys.incrementButton, count: 7);
  await tester.expectText(AppKeys.counterLabel, 'Click counter: 10');

  // Feel free to use other language features
  for (var i = 11; i <= 1000; i++) {
    await tester.tap(AppKeys.incrementButton);
    await tester.expectText(AppKeys.counterLabel, 'Click counter:$i');
  }
});
```

Believe me or not, this tests on my MacBook Pro (M3 Pro) continue to completes in one second:

```
e2e                           
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

Consider how quick the widgets tests with TapTests are. What kind of useful tests you could write within 1000 assertions/actions to have a very high confidence your app works as expected.

Plot twist: it is actually faster, the console output is slowing it down by about 40%.

## Drop the 1000 taps

We try to push TapTest to the limits, we didn't reach it, but let's reduce the test code to just the following:

```dart
tapTest('e2e', config, (tester) async {
  await tester.exists(AppKeys.homeScreen);
  await tester.expectText(AppKeys.counterLabel, 'Click counter: 0');
  await tester.tap(AppKeys.incrementButton);
  await tester.expectText(AppKeys.counterLabel, 'Click counter: 1');
  await tester.tap(AppKeys.incrementButton, count: 2);
  await tester.expectText(AppKeys.counterLabel, 'Click counter: 3');
});
```

## Test name and details screen flow

Now let's create a test where we enter a name in the text field, press the submit button and verify that the details screen is displayed with correct welcome message.

Similarly, you will need a keys to identify the elements you interact with:

```dart
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
