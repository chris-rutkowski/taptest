# TapTest

Flutter testing framework for user-facing widget and integration tests. Tests tap buttons, type into fields, check labels, and take snapshots — the same way a person uses the app.

See [https://taptest.dev](https://taptest.dev) for documentation.

## Why TapTest?

- **Fast** — full flows as widget tests
- **Stable under refactors** — tests target UI, not implementation details
- **Snapshots** — visual regression across light/dark and locales
- **HTTP mocks** — required for widget tests, optional for integration tests

## Install

```yaml
dependencies:
  taptest_runtime: ^1.0.0

dev_dependencies:
  taptest: ^1.0.0
```

`taptest_runtime` is a thin production dependency (`RuntimeParams`). `taptest` stays in `dev_dependencies`.

## Quick example

```dart
import 'package:flutter/material.dart';
import 'package:taptest/taptest.dart';

void main() {
  final config = Config(
    themeModes: const [ThemeMode.light, ThemeMode.dark],
    locales: const [Locale('en')],
    httpRequestHandlers: [
      // MockHttpRequestHandler implementations for widget tests
    ],
    builder: (params) {
      return ListenableBuilder(
        listenable: Listenable.merge([params.themeMode, params.locale]),
        builder: (context, _) {
          return MyApp(
            themeMode: params.themeMode.value,
            locale: params.locale.value,
            initialRoute: params.initialRoute,
          );
        },
      );
    },
  );

  tapTest('register flow', config, (tt) async {
    await tt.exists(AppKeys.homeScreen);
    await tt.snapshot('home_initial');
    await tt.type(AppKeys.usernameField, 'John Doe');
    await tt.type(AppKeys.passwordField, 'password123', secret: true);
    await tt.tap(AppKeys.registerButton);
    await tt.expectText(AppKeys.errorMessage, 'Please accept terms.');
    await tt.tap(AppKeys.acceptTermsCheckbox);
    await tt.tap(AppKeys.registerButton, sync: SyncType.settled);

    await tt.exists(AppKeys.welcomeScreen);
    await tt.expectText(AppKeys.welcomeMessage, 'Welcome John Doe!');
    await tt.snapshot('welcome_john');
  });
}
```

Keys are `ValueKey`s on your widgets. Nested keys work as a descendant path: `[ScreenKeys.list, CellKeys.title]`.

## Actions

| Action | Purpose |
| --- | --- |
| `tap` | Tap a widget (`count` for multi-tap) |
| `type` | Enter text |
| `exists` / `absent` | Assert presence |
| `expectText` | Assert `Text` / `RichText` content |
| `snapshot` | Golden comparison across theme/locale |
| `scrollTo` | Scroll until visible |
| `go` / `pop` | Route navigation |
| `changeThemeMode` / `changeLocale` | Switch variant |
| `wait` / `info` | Timing and log lines |

## Support

If TapTest is useful, you can support development: [buymeacoffee.com/chrisrkw](https://www.buymeacoffee.com/chrisrkw)
