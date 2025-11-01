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

| Parameter  | Type       | Default  | Description                |
| ---------- | ---------- | -------- | -------------------------- |
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

### Debounced search:

Often search fields implement a debounce mechanism to avoid firing expensive queries on every keystroke. Use the `wait` action to accommodate this behavior between typing and expecting results.

```dart
await tester.type(MyKeys.searchField, 'Blue');
await tester.wait(Duration(milliseconds: 300)); // Debounce time
await tester.exists(MyKeys.searchResults[0]);
```

## Alternative approach

- When possible, use `SyncType.settled` in the preceding action if you expect an animation to complete.
- When possible, use `expect` with a timeout (e.g., to wait for a loaded state).

## Remedy for "Pending timers" assertion failures

If your test fails with an error showing pending timers like this:

```
Pending timers:
Timer (duration: 0:00:00.040000, periodic: false), created:
#0 new FakeTimer._ (package:fake_async/fake_async.dart:342:62)
#1 FakeAsync._createTimer (package:fake_async/fake_async.dart:260:29)
#2 FakeAsync.run.<anonymous closure> (package:fake_async/fake_async.dart:185:15)
...
```

Simply add a `wait` action at the end of your test to finalise any remaining timers. This issue is commonly caused by gesture recognisers reserving time for double-tap detection, animations, or other asynchronous code that hasn't completed. If this behavior is not intentional in your app, consider debugging your code.
