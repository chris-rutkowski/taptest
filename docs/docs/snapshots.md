# Snapshots

`tt.snapshot(name)` captures the app (or a keyed widget) and compares it to goldens.

By default it cycles **every** `config.themeModes` × `config.locales` combination.

```dart
await tt.snapshot('home');
await tt.snapshot('tile', key: AppKeys.productTile);
await tt.snapshot('current_only', variations: false);
```

## Parameters

| Parameter | Default | Notes |
| --- | --- | --- |
| `name` | required | File name fragment |
| `variations` | `true` | If `false`, uses the current theme and locale only |
| `key` | full `AppWrapper` | Snapshot a subtree |
| `themeModes` / `locales` | from `Config` | Must be subsets of config |
| `acceptableDifference` | from `SnapshotConfig` (default `0`) | Exact match at `0` (Flutter's stock comparator). Slack + skip rewrite when `> 0` |
| `prePumpAndSettle` | `true` | Settle before the first frame |

## Path template

Default:

```
goldens/[suite]/[test]/[name]-[theme]-[locale]-[platform].png
```

Placeholders: `[suite]`, `[test]`, `[name]`, `[theme]`, `[locale]`, `[device]`, `[platform]`.

Widget tests use platform/device `headless`. Integration tests use the OS and device model.

Update goldens with Flutter's usual `--update-goldens` flag.

## Deferred widgets

`SnapshotConfig.deferredKeys` must be absent (e.g. image placeholders) before a snapshot is taken.
