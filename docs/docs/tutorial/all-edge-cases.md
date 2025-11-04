# 🔍 All Edge Cases

With TapTest's blazing speed, we can afford to be **thorough**. Let's test all edge cases:

## Edge case #1

```dart title="test/e2e_test.dart"
// previous steps
// Edge Case 1: Whitespace-only input should trigger validation
await tester.type(AppKeys.nameField, ' ');
await tester.tap(AppKeys.submitButton, sync: SyncType.settled);
await tester.exists(AppKeys.errorDialog);
await tester.tap(AppKeys.errorDialogOKButton, sync: SyncType.settled);
await tester.absent(AppKeys.errorDialog);
```

## Edge case #2

```dart title="test/e2e_test.dart"
// previous steps
// Edge Case 2: Input trimming - messy spacing should be cleaned up
await tester.type(AppKeys.nameField, '  Alice   ');
await tester.tap(AppKeys.submitButton, sync: SyncType.settled);
await tester.info('On Details screen');
await tester.exists(AppKeys.detailsScreen);
await tester.expectText(AppKeys.welcomeMessage, 'Welcome Alice!');
```

> 🏆 **Quality Mindset:** These edge cases catch bugs that plenty of developers miss - **but your users will definitely find them**!
