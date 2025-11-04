# 🔍 All edge cases

With TapTest's blazing speed, we can afford to be **thorough**. Let's cover all possible edge cases.

## Whitespace-only Input

Users love to be creative! Some will try submitting forms with just spaces, thinking they're clever. Your validation should catch this and treat whitespace-only input the same as empty input. Let's make sure our error dialog appears correctly:

```dart title="test/e2e_test.dart"
// previous steps

// Whitespace-only input should trigger validation
await tester.type(AppKeys.nameField, ' ');
await tester.tap(AppKeys.submitButton, sync: SyncType.settled);
await tester.exists(AppKeys.errorDialog);
await tester.tap(AppKeys.errorDialogOKButton, sync: SyncType.settled);
await tester.absent(AppKeys.errorDialog);
```

## Input Trimming

Real users type messily - extra spaces at the beginning, end, or even multiple spaces within their input. Professional apps should handle this gracefully by trimming whitespace and displaying clean, formatted text. Let's verify our app properly cleans up "  Alice   " to show "Welcome Alice!":

```dart title="test/e2e_test.dart"
// previous steps

// Input trimming - messy spacing should be cleaned up
await tester.type(AppKeys.nameField, '  Alice   ');
await tester.tap(AppKeys.submitButton, sync: SyncType.settled);
await tester.info('On Details screen');
await tester.exists(AppKeys.detailsScreen);
await tester.expectText(AppKeys.welcomeMessage, 'Welcome Alice!');
```

## 🎉 Achievement Unlocked!

Your comprehensive test now handles the tricky scenarios that separate amateur apps from professional ones - whitespace validation, input trimming, and user behavior edge cases. These are the bugs that plenty of developers miss, **but your users will definitely find them**. With TapTest's speed, you can afford to be thorough!

## 📚 Next steps

- **[Continue to next page →](./code-checkpoint)**
