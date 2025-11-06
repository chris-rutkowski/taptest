# ⬅️ Pop the screen

Our previous steps brought us to a simple Details screen - but we want to test more edge cases! We could create multiple separate tests, but our **E2E test** (call it a 🐵 monkey test if you want) should simulate what users actually do in real-life scenarios.

Users don't just navigate forward - they go back, retry actions, and test the boundaries of your app. So we definitely want to return to the home screen to explore more functionality and edge cases.

Let's use TapTest's `pop` action to simulate the system back button:

```dart title="test/e2e_test.dart"
// previous steps

await tt.pop();
await tt.info('On Home screen');
await tt.exists(AppKeys.homeScreen);
```

> 🎯 **Best Practice:** Always validate screen state after navigation, like in this case - existence of Home Screen - it makes debugging complex test failures much easier!

## 💡 Alternative navigation

If your screen had a dedicated close button with a key (like `AppKeys.closeButton`), you could obviously tap it instead.

## 📚 Next steps

- **[Continue to next page →](./pop-screen)**
- **[Learn more about `pop` →](../actions/pop)**
