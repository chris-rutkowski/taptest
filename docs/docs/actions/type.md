# Type

Enter text into a field.

```dart
await tt.type(AppKeys.email, 'user@example.com');
await tt.type(AppKeys.password, 'secret', secret: true);
```

| Parameter | Default |
| --- | --- |
| `key` | required |
| `text` | required |
| `secret` | `false` (masks the log line) |
| `sync` | `SyncType.instant` |
