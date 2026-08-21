# Scroll to

Scrolls a scrollable until `key` is visible.

```dart
await tt.scrollTo(AppKeys.row(72), scrollable: AppKeys.list);
```

`scrollable` may be a `Scrollable` or an ancestor that contains one.

| Parameter | Default |
| --- | --- |
| `key` | required |
| `scrollable` | required |
| `delta` | `50` |
| `maxScrolls` | `1000` |
