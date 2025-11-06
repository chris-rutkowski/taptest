# 📄 Code checkpoint

We've covered a lot, let's ensure our comprehensive E2E test is perfectly aligned:

```dart title="test/e2e_test.dart"
  tapTest('My E2E Widget test', config, (tt) async {
    await tt.exists(AppKeys.homeScreen);
    await tt.expectText(AppKeys.counterLabel, 'Click counter: 0');

    await tt.tap(AppKeys.incrementButton);
    await tt.expectText(AppKeys.counterLabel, 'Click counter: 1');
    await tt.tap(AppKeys.incrementButton, count: 2);
    await tt.expectText(AppKeys.counterLabel, 'Click counter: 3');

    await tt.type(AppKeys.nameField, 'John Doe');
    await tt.tap(AppKeys.submitButton);
    await tt.info('On Details screen');
    await tt.exists(AppKeys.detailsScreen);
    await tt.expectText(AppKeys.welcomeMessage, 'Welcome John Doe!');

    await tt.pop();
    await tt.info('On Home screen');
    await tt.exists(AppKeys.homeScreen);

    await tt.type(AppKeys.nameField, '');
    await tt.tap(AppKeys.submitButton);
    await tt.exists(AppKeys.errorDialog);
    await tt.tap(AppKeys.errorDialogOKButton);
    await tt.absent(AppKeys.errorDialog);

    // Whitespace-only input should trigger validation
    await tt.type(AppKeys.nameField, ' ');
    await tt.tap(AppKeys.submitButton);
    await tt.exists(AppKeys.errorDialog);
    await tt.tap(AppKeys.errorDialogOKButton);
    await tt.absent(AppKeys.errorDialog);

    // Input trimming - messy spacing should be cleaned up
    await tt.type(AppKeys.nameField, '  Alice   ');
    await tt.tap(AppKeys.submitButton);
    await tt.info('On Details screen');
    await tt.exists(AppKeys.detailsScreen);
    await tt.expectText(AppKeys.welcomeMessage, 'Welcome Alice!');
  });
```

## 📚 Next steps

- **[Continue to next page →](./snapshots)**

