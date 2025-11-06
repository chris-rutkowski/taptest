---
title: Tap
description: Learn how to interact with buttons and interactive elements using the tap action in taptest
---

# Tap Action

The `tap` action allows you to simulate user taps on various interactive elements:

- Click buttons and interactive widgets
- Toggle checkboxes and switches
- Activate any tappable UI component

## Parameters

| Parameter | Type       | Default            | Description                                     |
| --------- | ---------- | ------------------ | ----------------------------------------------- |
| `key`     | `TapKey`   | required           | The key identifying the widget to tap           |
| `sync`    | `SyncType` | `SyncType.instant` | How to synchronize after the tap                |
| `count`   | `int`      | `1`                | Number of times to tap (for multi-tap gestures) |

## Examples

### Simple tap

Tap a submit button:

```dart
await tt.tap(MyKeys.submitButton);
```

Toggle a checkbox:

```dart
await tt.tap(MyKeys.acceptTermsCheckbox);
```

Tap a button within a repeatable component using nested keys:

```dart
await tt.tap([MyKeys.tile(1), MyKeys.deleteButton]);
```

### Tap and settle

By default, the screen refreshes only once after this action to prioritize fast test execution. To wait for all animations to complete (e.g., page transitions, bottom sheets, or custom animations), set `sync` to `SyncType.settled`.

```dart
await tt.tap(MyKeys.profileButton, sync: SyncType.settled);
```

### Double tap

Use the `count` parameter to simulate double taps or longer tap sequences. Subsequent taps are delayed by 40ms (`kDoubleTapMinTime`). This delay is only noticeable in integration tests where it slightly increases execution time.

```dart
await tt.tap(MyKeys.deleteButton, count: 2);
```

## Troubleshooting

### Common Issues

- Ensure the target widget is accessible:
  - The screen is in a fully loaded state
  - The widget is visible (not scrolled off-screen)
  - The widget is enabled (not disabled)

- Handle animations properly:
  - Use `SyncType.settled` if the tap triggers animations

### Debugging Tips

- Observe test execution visually to identify timing issues
- Add temporary waits before and after taps as a diagnostic tool
- Take snapshots before and after the tap to understand state changes
- Verify the widget key exists in the current widget tree
- Check if the widget is actually tappable (has gesture detection)
- Ensure the widget is not covered by overlays or modals
