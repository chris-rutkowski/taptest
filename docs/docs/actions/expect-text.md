# Expect text

Asserts a `Text` or `RichText` widget's content. Retries until `timeout`.

```dart
await tt.expectText(AppKeys.title, 'Welcome');
```

For `RichText` with widget spans, use `objectReplacementCharacter` as the placeholder for each `WidgetSpan`.

If the keyed widget is neither `Text` nor `RichText`, the step fails immediately (not retried).
