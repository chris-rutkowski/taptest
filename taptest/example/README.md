# Example

The full example app lives at the repository root: [`example/`](../../example/).

Minimal usage:

```dart
import 'package:flutter/material.dart';
import 'package:taptest/taptest.dart';

void main() {
  tapTest(
    'home is shown',
    Config(
      themeModes: const [ThemeMode.light],
      locales: const [Locale('en')],
      builder: (params) => MaterialApp(
        themeMode: params.themeMode.value,
        locale: params.locale.value,
        home: const Scaffold(body: Text('hello', key: Key('hello'))),
      ),
    ),
    (tt) async {
      await tt.exists(const Key('hello'));
    },
  );
}
```
