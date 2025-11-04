# 🚨 Error Handling

Happy path testing is fantastic, but **error scenarios** separate amateur from professional testing! Users will inevitably:
- 📝 Submit empty forms
- 🔄 Retry failed actions  
- 🚫 Encounter validation errors
- 😅 Make unexpected inputs

## 🔑 Keys

Let's add keys:

```dart title="lib/app_keys.dart" {3-4}
abstract class AppKeys {
  // previous keys
  static const errorDialog = ValueKey('ErrorDialog');
  static const errorDialogOKButton = ValueKey('ErrorDialogOKButton');
}
```

... and assign them to widgets:

```dart title="lib/main.dart" {4,9}
showDialog(
  context: context,
  builder: (context) => AlertDialog(
    key: AppKeys.errorDialog, // 👈 here
    title: Text('No name'),
    content: Text('Please enter a name.'),
    actions: [
      TextButton(
        key: AppKeys.errorDialogOKButton, // 👈 and here
        onPressed: () => Navigator.of(context).pop(),
        child: Text('OK'),
      ),
    ],
  ),
);
```

## 🧪 Update test

Now let's test the error scenario - what happens when users submit empty form? Let's clear the name field, submit it, and handle the error dialog that appears.

```dart title="test/e2e_test.dart"
// previous steps

await tester.type(AppKeys.nameField, '');
await tester.tap(AppKeys.submitButton, sync: SyncType.settled);
await tester.exists(AppKeys.errorDialog);
await tester.tap(AppKeys.errorDialogOKButton, sync: SyncType.settled);
await tester.absent(AppKeys.errorDialog);
```

> 💡 **Pro Tips:** The `type` action **replaces** existing text. The `absent` assertion is optional but excellent practice - it explicitly verifies the dialog actually disappeared, making your tests more reliable and self-documenting!

Run the test `flutter test test` and you should see the following output:

```
My E2E Widget test
...
✅ Typed "" into NameField
✅ Tapped SubmitButton
✅ ErrorDialog exists
✅ Tapped ErrorDialogOKButton
✅ ErrorDialog is absent
00:01 +1: All tests passed!
```

## 🎉 Achievement Unlocked!

You've mastered error scenario testing! Your test now handles form validation, dialog interactions, and error recovery - all the messy edge cases that separate professional apps from amateur ones. And notice that even as our E2E test gets more and more advanced, it still completes **under 1 second**! 🚀

## 📚 Next steps

- **[Continue to next page →](./all-edge-cases)**
- **[Learn more about `absent` →](../actions/absent)**
