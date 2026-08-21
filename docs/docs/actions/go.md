# Go

Pushes a route via `WidgetTester.binding.handlePushRoute`.

```dart
await tt.go('/settings');
```

Prefer tapping UI that already performs navigation when you can. `go` is a convenience for deeplink-style paths.

Default `sync` is `SyncType.settled`.
