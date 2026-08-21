# Pop

Pops the current route with `pageBack`.

```dart
await tt.pop();
```

If the app has more than one `Navigator`, this may hit the wrong one. Prefer tapping a dedicated back/close key.

Default `sync` is `SyncType.settled`.
