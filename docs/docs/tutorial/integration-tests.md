# 📱 Integration tests

So far, we've focused on **widget tests** - and they're fantastic! Our simple app let us cover entire user journeys with incredible performance. But widget tests run in a environment without access to real device capabilities.

When your app needs real mobile services - camera, push notifications, GPS, or especially network calls (webservices) - widget tests require mocking everything. **Integration tests** remove these limitations by running on real devices, though they're significantly slower than widget tests.

> 💡 **Pro Strategy:** Use widget tests for 90% of your testing, integration tests for critical real-device scenarios.

## 📄 Same code

Your widget tests become integration tests with **ZERO changes**! Same test code, same assertions, **similar snapshots** - just running on real devices instead of simulated canvas!

Simply copy `e2e_test.dart` from `test` folder to `integration_test` folder:

```
Your project
 ┣ 📂 lib
 ┣ 📂 test
 ┃ ┣ 📂 snapshots
 ┃ ┗ 📄 e2e_test.dart 👈 copy from here
 ┗ 📂 integration_test
   ┗ 📄 e2e_test.dart 👈 to here
```

Let's update the test name to reflect it's now an integration test:

```dart title="integration_test/e2e_test.dart"
  tapTest('My E2E Integration test', config, (tt) async {
```

## 🏁 Run the integration tests

Start an iOS or Android simulator or connect a physical device, then run:

```bash
flutter test integration_test --update-goldens
```

> 💡 **Note the difference:** We use `integration_test` instead of `test` - this tells Flutter to run tests from the `integration_test` folder on **real devices**!

We're adding `--update-goldens` because snapshots need to be re-recorded on the actual device. These new snapshots will capture real screen dimensions, pixel density, notches, and other device-specific features.

You'll likely see a device selection menu:

```
[1]: iPhone 17 Pro (D3166B06-2B21-45B1-A698-8A0ACD2076A9)
[2]: iPhone 17 (33F5C8B4-BE2D-498F-A411-071642FD1608)
[3]: macOS (macos)
[4]: Chrome (chrome)
Please choose one (or "q" to quit): 
```

Choose by typing the number. For faster re-runs, you can target a specific device directly:

```bash
flutter test integration_test --update-goldens -d D3166B06-2B21...
flutter test integration_test -d D3166B06-2B21...
```

Observe your app come alive on device as TapTest executes your comprehensive test suite.

## 🐢 Performance

Widget tests spoiled you with 1-second execution times. Integration tests are a different story, Expect **1 minute** to bootstrap the device and run your tests.

## 🎉 Achievement Unlocked!

You've mastered both widget and integration testing with TapTest! You now understand when to use blazing-fast widget tests for comprehensive coverage and when to deploy integration tests for real device validation. You've built a complete testing strategy that combines speed with thorough real-world verification - exactly what professional Flutter developers need for bulletproof applications.

## 📚 Next steps

- **[Continue to next page →](../tutorial-extras/congratulations)**
