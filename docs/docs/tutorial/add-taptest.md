# 📦 Add TapTest

TapTest uses a smart two-package approach that keeps your production app lean while ensuring clean namespace separation and clear separation of concerns - no testing bloat in your release builds!

Add these dependencies to your `pubspec.yaml`:

```yaml title="pubspec.yaml"
dependencies:
  ...
  taptest_runtime: # Lightweight runtime (production-safe)

dev_dependencies:
  ...
  taptest: # Full testing power (dev-only)
```

Run the command to install the packages:

```bash
flutter pub get
```

> 💡 **Two-Package Strategy:** The `taptest_runtime` provides minimal production code, while `taptest` contains the full testing framework - keeping your release builds clean and fast!

## 📁 Project Structure

Create the proper folder structure for organizing your tests. In your project root, create both `test` and `integration_test` folders:

```
Your Flutter Project
 ┣ 📂 lib
 ┃ ┗ 📄 main.dart
 ┣ 📂 test
 ┗ 📂 integration_test
```

You can create these folders using your IDE or terminal:

```bash
mkdir test integration_test
```

> 💡 **Folder Purpose:** The `test` folder is for so-called widget tests (underrated), while `integration_test` is for tests that run on real devices or emulators.

## 📚 Next steps

- **[Continue to next page →](./widget-vs-integration-tests.md)**
