# 📄 Code checkpoint

We've covered a lot, let's ensure our comprehensive E2E test is perfectly aligned:

```dart title="test/e2e_test.dart"
  tapTest('My E2E Widget test', config, (tester) async {
    await tester.exists(AppKeys.homeScreen);
    await tester.expectText(AppKeys.counterLabel, 'Click counter: 0');

    await tester.tap(AppKeys.incrementButton);
    await tester.expectText(AppKeys.counterLabel, 'Click counter: 1');
    await tester.tap(AppKeys.incrementButton, count: 2);
    await tester.expectText(AppKeys.counterLabel, 'Click counter: 3');

    await tester.type(AppKeys.nameField, 'John Doe');
    await tester.tap(AppKeys.submitButton);
    await tester.info('On Details screen');
    await tester.exists(AppKeys.detailsScreen);
    await tester.expectText(AppKeys.welcomeMessage, 'Welcome John Doe!');

    await tester.pop();
    await tester.info('On Home screen');
    await tester.exists(AppKeys.homeScreen);

    await tester.type(AppKeys.nameField, '');
    await tester.tap(AppKeys.submitButton);
    await tester.exists(AppKeys.errorDialog);
    await tester.tap(AppKeys.errorDialogOKButton);
    await tester.absent(AppKeys.errorDialog);

    // Whitespace-only input should trigger validation
    await tester.type(AppKeys.nameField, ' ');
    await tester.tap(AppKeys.submitButton);
    await tester.exists(AppKeys.errorDialog);
    await tester.tap(AppKeys.errorDialogOKButton);
    await tester.absent(AppKeys.errorDialog);

    // Input trimming - messy spacing should be cleaned up
    await tester.type(AppKeys.nameField, '  Alice   ');
    await tester.tap(AppKeys.submitButton);
    await tester.info('On Details screen');
    await tester.exists(AppKeys.detailsScreen);
    await tester.expectText(AppKeys.welcomeMessage, 'Welcome Alice!');
  });
```

## 📚 Next steps

- **[Continue to next page →](./snapshots)**

