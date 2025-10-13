---
title: Actions
description: Learn about all the available actions in taptest for interacting with your Flutter app
---

# Actions

Actions are the core building blocks of taptest that allow you to interact with your Flutter app during testing. Each action simulates a specific user interaction or verification.

## Available Actions

### Interaction Actions
- **[Tap](./tap.md)** - Click buttons and interactive elements
- **Scroll** - Navigate through scrollable content
- **Enter Text** - Input text into form fields
- **Drag** - Perform drag gestures

### Verification Actions
- **Exists** - Verify widgets are present
- **Absent** - Verify widgets are not present
- **Snapshot** - Capture and compare UI screenshots

### Navigation Actions
- **Navigate** - Move between app screens
- **Pop** - Go back in navigation stack

## Action Patterns

All taptest actions follow consistent patterns:

### Async/Await
```dart
await tester.tap(MyKeys.button);
await tester.exists(MyKeys.result);
```

### Key-Based Targeting
```dart
// Target widgets using keys
await tester.tap(MyKeys.submitButton);
await tester.exists(MyKeys.successMessage);
```

### Synchronization Options
```dart
// Control timing with sync parameter
await tester.tap(MyKeys.button, sync: SyncType.settled);
```

## Getting Started

To use actions in your tests:

1. **Set up your test** with taptest configuration
2. **Define keys** for your widgets  
3. **Chain actions** to simulate user flows
4. **Verify results** with assertion actions

```dart
testWidgets('user flow example', (tester) async {
  // Interaction
  await tester.tap(MyKeys.loginButton);
  
  // Verification
  await tester.exists(MyKeys.loginForm);
  
  // More interactions...
  await tester.enterText(MyKeys.emailField, 'user@example.com');
  await tester.tap(MyKeys.submitButton, sync: SyncType.settled);
  
  // Final verification
  await tester.exists(MyKeys.dashboard);
});
```