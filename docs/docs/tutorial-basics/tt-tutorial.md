---
title: Tap Test Tutorial
---

# TapTest - tutorial

Welcome to the official TapTest tutorial!

* **🎯 What you'll build:** A comprehensive E2E automated test that verifies the app in less than 2 seconds
* **⏱️ Time needed:** 45 minutes  

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
