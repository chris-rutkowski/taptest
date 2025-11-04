---
title: Tap Test Tutorial
---

# TapTest - tutorial

Welcome to the official TapTest tutorial!

* **🎯 What you'll build:** A comprehensive E2E automated test that verifies the app in less than 2 seconds
* **⏱️ Time needed:** 45 minutes  

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
