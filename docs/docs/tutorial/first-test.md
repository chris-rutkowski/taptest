# 🧑‍💻 First test

Create `e2e_test.dart` file in the `test` folder. **E2E** means **End-to-End**. Together, step by step, we'll craft a comprehensive test that validates entire user journey.

```dart title="test/e2e_test.dart"
// ‼️ Replace 'your_app' with your app package
import 'package:your_app/main.dart';
import 'package:taptest/taptest.dart';

void main() {
  final config = Config(
    builder: (params) {
      return MyApp();
    },
  );

  tapTest('My E2E Widget test', config, (tt) async {
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

This test doesn't do anything meaningful yet, but we'll change that very soon! The initial run may take a few seconds for compilation, but feel free to run the command again and it should complete **under 1 second**.

## 🔑 Keys

In TapTest, we identify and interact with widgets using **keys** - think of them as unique IDs for every interactive or inspectable element. Create a file `app_keys.dart` in the `lib` folder:

```dart title="lib/app_keys.dart"
import 'package:flutter/material.dart';

abstract class AppKeys {
  static const homeScreen = ValueKey('HomeScreen');
  // more keys coming soon
}
```

> 🏗️ **Scaling Strategy:** As your app grows, organize keys by feature (`AuthKeys`, `ProfileKeys`, `OnboardingKeys`) - but for now, one file is perfect!

Update your `main.dart` to import this file and assign the created key:

```dart title="lib/main.dart" {1,6}
import 'app_keys.dart'; // 👈 here
// other imports

Widget build(BuildContext context) {
  return Scaffold(
    key: AppKeys.homeScreen, // 👈 and here in HomeScreen widget
    appBar: AppBar(title: Text('Welcome')),
```

## 🔬 First assertion

Update your test to perform its first check:

```dart title="test/e2e_test.dart" {1,6}
import 'package:your_app/app_keys.dart'; // 👈 import app_keys.dart

...

tapTest('My E2E Widget test', config, (tt) async {
  await tt.exists(AppKeys.homeScreen);
});
```

**Run it:** `flutter test test`, expected output:

```
My E2E Widget test
✅ HomeScreen exists
00:01 +1: All tests passed!
```

Notice how TapTest only knows about the `HomeScreen`'s key - it doesn't care about your internal implementation or state management. By importing just the keys, TapTest interacts with a thin layer of your app's public interface, making tests resilient to refactoring and focused on user-visible behavior!

## 🎉 Achievement Unlocked!

You've just verified your app starts correctly. Don't worry that you can't witness it executing - that's totally normal! Widget tests run invisibly, but with snapshots (soon) you can capture the output.

## 📚 Next steps

- **[Continue to next page →](./testing-counter.md)**
- **[Learn more about `exists` →](../actions/exists)**
