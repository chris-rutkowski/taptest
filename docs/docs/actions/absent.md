# Absent

Asserts the widget is not in the tree. Retries until `timeout`.

```dart
await tt.absent(AppKeys.spinner);
```

Also used via `SnapshotConfig.deferredKeys` before snapshots.
