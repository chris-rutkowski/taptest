# Install

Add both packages to your app `pubspec.yaml`:

```yaml title="pubspec.yaml"
dependencies:
  taptest_runtime: ^1.0.0

dev_dependencies:
  taptest: ^1.0.0
```

```bash
flutter pub get
```

Create `test/` for widget tests and `integration_test/` for device tests:

```bash
mkdir -p test integration_test
```

Your app `builder` should read `RuntimeParams` from `taptest_runtime` so tests can change theme, locale, and initial route without importing `taptest` in production code.

## Next

- [First test](./first-test.md)
- [Config](./config.md)
