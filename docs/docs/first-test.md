# First test

Put keys on the widgets you care about, then drive them with `tapTest`.

```dart
import 'package:flutter/material.dart';
import 'package:taptest/taptest.dart';
import 'package:taptest_runtime/taptest_runtime.dart';

abstract class AppKeys {
  static const screen = ValueKey('homeScreen');
  static const button = ValueKey('counterButton');
  static const label = ValueKey('counterLabel');
}

void main() {
  final config = Config(
    themeModes: const [ThemeMode.light],
    locales: const [Locale('en')],
    builder: (RuntimeParams params) {
      return MaterialApp(
        themeMode: params.themeMode.value,
        locale: params.locale.value,
        home: const _HomeScreen(),
      );
    },
  );

  tapTest('counter increments', config, (tt) async {
    await tt.exists(AppKeys.screen);
    await tt.expectText(AppKeys.label, '0');
    await tt.tap(AppKeys.button);
    await tt.expectText(AppKeys.label, '1');
    await tt.snapshot('counter_one');
  });
}
```

`exists` and `expectText` retry for up to 5 seconds, so you usually do not need manual `wait` calls after a tap.

To update snapshot PNGs, use the Linux Docker image — not host `flutter test --update-goldens`. See [Snapshots](./snapshots.md#updating-goldens).

For a fuller app, see the [`example/`](https://github.com/chris-rutkowski/taptest/tree/main/example) directory in the repo.
