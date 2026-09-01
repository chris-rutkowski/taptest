# TapTest runtime

Production-safe companion to [taptest](https://pub.dev/packages/taptest).

Add `taptest_runtime` to your app `dependencies` and `taptest` to `dev_dependencies`. Your app builder receives `RuntimeParams` (theme mode, locale, initial route, extensions) so widget tests can drive those without importing the test package.

```dart
import 'package:material_ui/material_ui.dart';
import 'package:taptest_runtime/taptest_runtime.dart';

class MyApp extends StatelessWidget {
  final ThemeMode themeMode;
  final Locale locale;
  final String? initialRoute;

  const MyApp({
    super.key,
    required this.themeMode,
    required this.locale,
    this.initialRoute,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      themeMode: themeMode,
      locale: locale,
      initialRoute: initialRoute ?? '/',
      // ...
    );
  }
}
```

See [https://taptest.dev](https://taptest.dev) and the [taptest](https://pub.dev/packages/taptest) package for tests.
