---
---

# 👋 Getting Started with TapTest

Welcome to TapTest! This comprehensive tutorial will guide you through everything you need to know to start writing effective Flutter UI tests using TapTest.

## What is TapTest?

TapTest is a powerful Flutter testing framework designed to make UI testing intuitive, reliable, and maintainable. It provides a rich set of actions and assertions that allow you to:

- **Simulate user interactions** like taps, scrolls, and text input
- **Take visual snapshots** for regression testing
- **Mock HTTP requests** for isolated testing
- **Navigate through complex app flows** with ease
- **Test responsive designs** across different screen sizes

## Why Choose TapTest?

### 🎯 **Intuitive API**
TapTest's API is designed to read like natural language, making your tests easy to write and understand.

### 📸 **Visual Testing**
Built-in snapshot testing helps catch visual regressions before they reach production.

### 🔧 **Flexible Configuration**
Extensive configuration options allow you to tailor TapTest to your project's specific needs.

### 🚀 **Performance Focused**
Optimized for fast test execution without sacrificing reliability.

## Prerequisites

Before you begin, make sure you have:

- **Flutter SDK** version 3.9.0 or higher
- **Dart SDK** version 3.9.0 or higher
- A Flutter project ready for testing
- Basic knowledge of Flutter development
- Familiarity with Dart testing concepts

## Installation

### 1. Add TapTest to Your Project

Add TapTest to your `pubspec.yaml` file under `dev_dependencies`:

```yaml
dev_dependencies:
  flutter_test:
    sdk: flutter
  taptest: ^0.0.1
  integration_test:
    sdk: flutter
```

### 2. Install Dependencies

Run the following command to install the dependencies:

```bash
flutter pub get
```

### 3. Verify Installation

Create a simple test file to verify TapTest is working correctly:

```dart
// test/taptest_verification_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:taptest/taptest.dart';

void main() {
  testWidgets('TapTest verification', (WidgetTester tester) async {
    // This test verifies TapTest is properly installed
    expect(TapTester, isNotNull);
  });
}
```

Run the test:

```bash
flutter test test/taptest_verification_test.dart
```

## Project Structure for Testing

We recommend organizing your tests in a clear structure:

```
your_project/
├── lib/
├── test/
│   ├── unit/              # Unit tests
│   ├── widget/            # Widget tests
│   └── integration/       # Integration tests using TapTest
│       ├── helpers/       # Test helpers and utilities
│       ├── goldens/       # Golden files for snapshot tests
│       └── flows/         # End-to-end flow tests
└── integration_test/      # Integration tests for CI/CD
```

## Your First Look at TapTest

Here's a simple example of what a TapTest looks like:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:taptest/taptest.dart';
import 'package:your_app/main.dart' as app;

void main() {
  group('Welcome Flow Tests', () {
    testWidgets('User can complete welcome flow', (WidgetTester tester) async {
      await tester.pumpWidget(app.MyApp());
      
      final tt = TapTester(tester);
      
      // Tap the "Get Started" button
      await tt.tap('Get Started');
      
      // Verify we navigated to the next screen
      await tt.expectText('Welcome to the app!');
      
      // Take a snapshot for visual regression testing
      await tt.snapshot('welcome_screen');
    });
  });
}
```

Don't worry if this doesn't make complete sense yet - we'll break down every part in the following sections!

## What's Next?

Now that you have TapTest installed and understand the basics, you're ready to write your first test. In the next section, we'll walk through creating a simple but complete test that demonstrates TapTest's core features.

---

## Where to go next?

Ready to start testing? Continue to the next page where we'll write your first TapTest from scratch.

👉 **[Writing Your First Test →](./first-test)**
