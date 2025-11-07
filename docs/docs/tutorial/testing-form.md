# ✏️ Testing the Form

Now for the grand finale of basic interactions - let's test the complete user journey:
1. **Enter name** in the text field
2. **Submit** the form  
3. **Navigate** to details screen
4. **Verify** personalized welcome message

## 🔑 Keys

Let's prepare keys to interact with this feature:

```dart title="lib/app_keys.dart" {3-6}
abstract class AppKeys {
  ...
  static const nameField = ValueKey('NameField');
  static const submitButton = ValueKey('SubmitButton');
  static const detailsScreen = ValueKey('DetailsScreen');
  static const welcomeMessage = ValueKey('WelcomeMessage');
}
```

and assign them to the relevant widgets in your `main.dart`:

```dart title="lib/main.dart" {2,6,10,15}
TextField(
  key: AppKeys.nameField, // 👈 here
  controller: nameController,

ElevatedButton(
  key: AppKeys.submitButton, // 👈 here
  onPressed: () {

return Scaffold(
  key: AppKeys.detailsScreen, // 👈 here
  appBar: AppBar(title: Text('Detail Screen')),
  body: Center(
    child: Text(
      'Welcome $name!',
      key: AppKeys.welcomeMessage, // 👈 and here
    ),
  ),
);
```

## 🧪 Update test

We will introduce a new action - `type` - to simulate user input in the text field. Let's extend our test:

```dart title="test/e2e_test.dart"
// previous steps

await tt.type(AppKeys.nameField, 'John Doe');
await tt.tap(AppKeys.submitButton);
await tt.exists(AppKeys.detailsScreen);
await tt.expectText(AppKeys.welcomeMessage, 'Welcome John Doe!');
```

Run the test `flutter test test` and you should see the following output:

```
My E2E Widget test
...
✅ Typed "John Doe" into NameField
✅ Tapped SubmitButton
✅ DetailsScreen exists
✅ Text of WelcomeMessage matches "Welcome John Doe!"
00:01 +1: All tests passed!
```

## 🎉 Achievement Unlocked!

You've successfully tested a complete user flow involving text input, button tap, navigation, and content verification! This demonstrates TapTest's capability to handle complex interactions seamlessly.

## ℹ️ Self-documenting tests

While finding the welcome message implies the details screen exists, explicit checks for this screen's existence make tests self-documenting and easier to debug when things go wrong!

For longer test cases, I recommend adding some logging with `info` action to annotate key steps. This will make troubleshooting much easier.


```dart title="test/e2e_test.dart" {2}
await tt.tap(AppKeys.submitButton);
await tt.info('On Details screen');
await tt.exists(AppKeys.detailsScreen);
await tt.expectText(AppKeys.welcomeMessage, 'Welcome John Doe!');
```

If you run the test again you should see the following output:

```bash {4}
... 
✅ Typed into NameField: "John Doe"
✅ Tapped SubmitButton
💡 On Details screen
✅ Exists DetailsScreen
✅ Text of WelcomeMessage matches "Welcome John Doe!"
```

## 📚 Next steps

- **[Continue to next page →](./pop-screen)**
- **[Learn more about `type` →](../actions/type)**
- **[Learn more about `info` →](../actions/info)**
