---
title: Actions
---

# Actions

All actions take a `TapKey`: a `Key`, or a `List<Key>` treated as a descendant path.

```dart
await tt.tap(AppKeys.submit);
await tt.tap([AppKeys.tile(1), AppKeys.deleteButton]);
```

| Action | Role |
| --- | --- |
| [tap](./tap.md) | Tap |
| [type](./type.md) | Enter text |
| [exists](./exists.md) | Widget is present |
| [absent](./absent.md) | Widget is gone |
| [expectText](./expect-text.md) | `Text` / `RichText` value |
| [snapshot](../snapshots.md) | Golden |
| [scrollTo](./scroll-to.md) | Scroll until visible |
| [go](./go.md) / [pop](./pop.md) | Navigation |
| [changeThemeMode](./change-theme.md) / [changeLocale](./change-locale.md) | Variant |
| [wait](./wait.md) / [info](./info.md) | Timing / logs |

Most mutating actions take `sync`: `SyncType.instant` (one pump), `settled` (`pumpAndSettle`), or `skip`.
