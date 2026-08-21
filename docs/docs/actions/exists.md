# Exists

Asserts the widget is in the tree. Retries until `timeout`.

```dart
await tt.exists(AppKeys.homeScreen);
await tt.exists(AppKeys.spinner, timeout: Duration(seconds: 1));
```
