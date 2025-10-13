---
title: Wait
description: Learn how to add delays in your tests using the wait action in taptest
---

# Wait Action

The `wait` action allows you to introduce deliberate delays in your test execution:

- Wait for time-based operations to complete
- Simulate real-world delays between user actions

As a developer, you can use this action as a temporary workaround when debugging complex scenarios.

In **widget tests**, the `wait` action is **instant** - it doesn't actually consume real time. The framework fast-forwards through the specified duration immediately, allowing schedulers, timers, and animations to complete without slowing down test execution.

In **integration tests**, the `wait` action **actually waits** for the specified duration in real time. This affects test execution time and should be used judiciously.

## Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `duration` | `Duration` | required | The amount of time to wait |

## Examples

Wait for 2 seconds:

```dart
await tester.wait(Duration(seconds: 2));
```

Wait for 500 milliseconds:

```dart
await tester.wait(Duration(milliseconds: 500));
```

## Best Practices

- When possible, use `SyncType.settled` in the preceding action if you expect an animation to complete.
- When possible, use `expect` with a timeout (e.g., to wait for a loaded state).

### Debounced search

```dart
await tester.type(MyKeys.searchField, 'flutter');
await tester.wait(Duration(milliseconds: 300)); // Wait for debounce
await tester.exists(MyKeys.searchResults[0]);
```
