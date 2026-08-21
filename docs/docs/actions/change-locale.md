# Change locale

Sets `RuntimeParams.locale`. The value must be in `config.locales`.

```dart
await tt.changeLocale(Locale('es'));
```

The app must listen to `params.locale` (see [Config](../config.md)).
