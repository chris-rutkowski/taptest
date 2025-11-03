---
---

# Writing Your First Test

Now that you have TapTest installed, let's write your first comprehensive test! We'll build a test for a simple counter app step by step, covering the most common TapTest features.

## The App We're Testing

For this tutorial, we'll test a simple counter app that has:
- A counter display
- An increment button (+)
- A decrement button (-)
- A reset button

Here's the app code we'll be testing:

```dart
// lib/counter_app.dart
import 'package:flutter/material.dart';

class CounterApp extends StatefulWidget {
  @override
  _CounterAppState createState() => _CounterAppState();
}

class _CounterAppState extends State<CounterApp> {
  int _counter = 0;

  void _increment() => setState(() => _counter++);
  void _decrement() => setState(() => _counter--);
  void _reset() => setState(() => _counter = 0);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('Counter App')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Counter Value:', style: TextStyle(fontSize: 18)),
              Text('$_counter', 
                   key: Key('counter-display'),
                   style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold)),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    key: Key('decrement-button'),
                    onPressed: _decrement,
                    child: Text('-'),
                  ),
                  ElevatedButton(
                    key: Key('reset-button'),
                    onPressed: _reset,
                    child: Text('Reset'),
                  ),
                  ElevatedButton(
                    key: Key('increment-button'),
                    onPressed: _increment,
                    child: Text('+'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
```

## Setting Up Your Test File

Create a new test file:

```dart
// test/integration/counter_app_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:taptest/taptest.dart';
import 'package:your_app/counter_app.dart';

void main() {
  group('Counter App Tests', () {
    // We'll add our tests here
  });
}
```

## Basic Test Structure

Every TapTest follows this basic pattern:

```dart
testWidgets('test description', (WidgetTester tester) async {
  // 1. Setup: Pump your widget
  await tester.pumpWidget(CounterApp());
  
  // 2. Create TapTester instance
  final tt = TapTester(tester);
  
  // 3. Perform actions and assertions
  await tt.tap('increment-button');
  await tt.expectText('1');
});
```

## Test 1: Basic Counter Increment

Let's write our first test:

```dart
testWidgets('should increment counter when + button is tapped', (WidgetTester tester) async {
  // Setup
  await tester.pumpWidget(CounterApp());
  final tt = TapTester(tester);
  
  // Verify initial state
  await tt.expectText('0');
  
  // Perform action
  await tt.tap('increment-button');
  
  // Verify result
  await tt.expectText('1');
  
  // Test multiple increments
  await tt.tap('increment-button');
  await tt.tap('increment-button');
  await tt.expectText('3');
});
```

### Key TapTest Methods Used:

- **`expectText(text)`**: Verifies that text exists on screen
- **`tap(finder)`**: Simulates a tap on a widget (by key, text, or type)

## Test 2: Counter Decrement

```dart
testWidgets('should decrement counter when - button is tapped', (WidgetTester tester) async {
  await tester.pumpWidget(CounterApp());
  final tt = TapTester(tester);
  
  // Start with some increments
  await tt.tap('increment-button');
  await tt.tap('increment-button');
  await tt.expectText('2');
  
  // Test decrement
  await tt.tap('decrement-button');
  await tt.expectText('1');
  
  // Test going to negative
  await tt.tap('decrement-button');
  await tt.tap('decrement-button');
  await tt.expectText('-1');
});
```

## Test 3: Reset Functionality

```dart
testWidgets('should reset counter to 0 when reset button is tapped', (WidgetTester tester) async {
  await tester.pumpWidget(CounterApp());
  final tt = TapTester(tester);
  
  // Get to a non-zero state
  await tt.tap('increment-button');
  await tt.tap('increment-button');
  await tt.tap('increment-button');
  await tt.expectText('3');
  
  // Test reset
  await tt.tap('reset-button');
  await tt.expectText('0');
});
```

## Test 4: Visual Snapshot Testing

TapTest makes it easy to add visual regression testing:

```dart
testWidgets('should maintain visual consistency', (WidgetTester tester) async {
  await tester.pumpWidget(CounterApp());
  final tt = TapTester(tester);
  
  // Test initial state snapshot
  await tt.snapshot('counter_initial_state');
  
  // Test after some interactions
  await tt.tap('increment-button');
  await tt.tap('increment-button');
  await tt.snapshot('counter_incremented_state');
  
  // Test negative value appearance
  await tt.tap('decrement-button');
  await tt.tap('decrement-button');
  await tt.tap('decrement-button');
  await tt.snapshot('counter_negative_state');
});
```

### Understanding Snapshots:

- **First run**: Creates golden files in `test/goldens/`
- **Subsequent runs**: Compares current state with golden files
- **Failures**: Show pixel-by-pixel differences
- **Update goldens**: Run `flutter test --update-goldens`

## Test 5: Testing Widget Properties

You can also test widget properties and states:

```dart
testWidgets('should have correct widget properties', (WidgetTester tester) async {
  await tester.pumpWidget(CounterApp());
  final tt = TapTester(tester);
  
  // Test that buttons are enabled
  await tt.expectEnabled('increment-button');
  await tt.expectEnabled('decrement-button');
  await tt.expectEnabled('reset-button');
  
  // Test widget visibility
  await tt.expectVisible('counter-display');
  
  // Test specific widget by type
  await tt.expectWidgetType<ElevatedButton>('increment-button');
});
```

## Running Your Tests

### Run a single test file:
```bash
flutter test test/integration/counter_app_test.dart
```

### Run all tests:
```bash
flutter test
```

### Run with coverage:
```bash
flutter test --coverage
```

### Update golden files:
```bash
flutter test --update-goldens
```

## Complete Test File

Here's the complete test file with all our tests:

```dart
// test/integration/counter_app_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:taptest/taptest.dart';
import 'package:your_app/counter_app.dart';

void main() {
  group('Counter App Tests', () {
    testWidgets('should increment counter when + button is tapped', (WidgetTester tester) async {
      await tester.pumpWidget(CounterApp());
      final tt = TapTester(tester);
      
      await tt.expectText('0');
      await tt.tap('increment-button');
      await tt.expectText('1');
      
      await tt.tap('increment-button');
      await tt.tap('increment-button');
      await tt.expectText('3');
    });

    testWidgets('should decrement counter when - button is tapped', (WidgetTester tester) async {
      await tester.pumpWidget(CounterApp());
      final tt = TapTester(tester);
      
      await tt.tap('increment-button');
      await tt.tap('increment-button');
      await tt.expectText('2');
      
      await tt.tap('decrement-button');
      await tt.expectText('1');
      
      await tt.tap('decrement-button');
      await tt.tap('decrement-button');
      await tt.expectText('-1');
    });

    testWidgets('should reset counter to 0 when reset button is tapped', (WidgetTester tester) async {
      await tester.pumpWidget(CounterApp());
      final tt = TapTester(tester);
      
      await tt.tap('increment-button');
      await tt.tap('increment-button');
      await tt.tap('increment-button');
      await tt.expectText('3');
      
      await tt.tap('reset-button');
      await tt.expectText('0');
    });

    testWidgets('should maintain visual consistency', (WidgetTester tester) async {
      await tester.pumpWidget(CounterApp());
      final tt = TapTester(tester);
      
      await tt.snapshot('counter_initial_state');
      
      await tt.tap('increment-button');
      await tt.tap('increment-button');
      await tt.snapshot('counter_incremented_state');
      
      await tt.tap('decrement-button');
      await tt.tap('decrement-button');
      await tt.tap('decrement-button');
      await tt.snapshot('counter_negative_state');
    });

    testWidgets('should have correct widget properties', (WidgetTester tester) async {
      await tester.pumpWidget(CounterApp());
      final tt = TapTester(tester);
      
      await tt.expectEnabled('increment-button');
      await tt.expectEnabled('decrement-button');
      await tt.expectEnabled('reset-button');
      
      await tt.expectVisible('counter-display');
      await tt.expectWidgetType<ElevatedButton>('increment-button');
    });
  });
}
```

## What You've Learned

Congratulations! You've just written your first comprehensive TapTest suite. You now know how to:

- ✅ Set up basic test structure
- ✅ Use `tap()` to simulate user interactions
- ✅ Use `expectText()` to verify content
- ✅ Create visual snapshots with `snapshot()`
- ✅ Test widget properties and states
- ✅ Run and manage your tests

## Debugging Tips

### Test Failing?
- Use `await tt.printWidgetTree()` to see all available widgets
- Check widget keys and text exactly match
- Ensure proper async/await usage

### Golden file issues?
- Run `flutter test --update-goldens` to regenerate
- Check image resolution consistency across devices
- Consider using custom snapshot configurations

---

## Where to Go Next

You're now ready to learn more advanced TapTest techniques! In the next section, we'll explore complex scenarios like form testing, navigation, HTTP mocking, and more.

👉 **[Advanced Testing Techniques →](./advanced-techniques)**