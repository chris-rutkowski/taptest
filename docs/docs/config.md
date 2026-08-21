# Config

`Config` is passed to every `tapTest`. The `builder` receives `RuntimeParams` from `taptest_runtime`.

```dart
Config(
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
```

Listen to `params.themeMode` and `params.locale`. Snapshot tests change those notifiers and re-pump.

## Fields

| Field | Default | Notes |
| --- | --- | --- |
| `builder` | required | Builds the app under test |
| `themeModes` | light and dark | Snapshot matrix |
| `locales` | `en`, `en_US`, `en_GB` | Snapshot matrix |
| `screenSize` | `393 x 852` | Widget tests only |
| `pixelDensity` | `2.0` | Widget tests only |
| `customFonts` | `[]` | Loaded in widget tests |
| `httpRequestHandlers` | `[]` | See [HTTP mocks](./http-mocks.md) |
| `snapshot` | `SnapshotConfig()` | See [Snapshots](./snapshots.md) |
| `initialRoute` | `null` | Passed through as `RuntimeParams.initialRoute` |
| `suite` | `null` | Used in the snapshot path (`[suite]`) |
| `precachedImages` | `[]` | Precache before first pump |
| `extensions` | `[]` | App-specific objects; `params.extension<T>()` |

Narrow `themeModes` and `locales` if you do not want a full snapshot matrix on every test.

```dart
config.copyWith(
  themeModes: const [ThemeMode.light],
  locales: const [Locale('en')],
);
```
