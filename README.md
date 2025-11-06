# TapTest

**TapTest** is a revolutionary testing framework built on top of Flutter tester that encourages writing useful, user-facing tests capable of surviving massive refactors. Tests interact with your app the way users do - by tapping buttons and interface elements, validating labels content, checking elements presence and capturing visual snapshots.

## 🚀 Why TapTest?

- **⚡ Blazing Fast** - E2E Widget tests that run in the blink of an eye
- **🛡️ Refactor-Proof** - Tests survive huge code refactors by focusing on user interactions not on implementation details.
- **🎯 User-Focused** - Write tests that mirror real user behavior
- **📸 Visual Regression** - Built-in snapshot testing for pixel-perfect UI validation
- **🌐 Flexible** - Mock external resources like web services - required for widget tests, optional for integration tests

## 📚 Documentation

See [https://taptest.dev](https://taptest.dev) for tutorials and complete documentation.

## ✨ Quick Example

```dart
void main() {
  final config = Config(
    variants: Variant.lightAndDarkVariants, // ☀️ 🌙
    httpRequestHandlers: [
      // required for ultra fast Widget tests
      // optional for Integration tests
      MockRegistrationWebservice(success: true),
    ],
    builder: (params) {
      return MyApp(params: params);
    },
  );

  tapTest('E2E test (with Page Object)', config, (tt) async {
    await tt
        .onHomeScreen()
        .snapshot('HomeScreen_initial')
        .enterUsername('John Doe')
        .enterPassword('password123')
        .tapRegister()
        .expectError('Please accept terms.')
        .tapAcceptTerms()
        .tapRegister();

    await tt
        .onWelcomeScreen()
        .expectWelcomeMessage('Welcome John Doe!')
        .snapshot('WelcomeScreen_JohnDoe');
  });

  tapTest('E2E test (plain)', config, (tt) async {
    await tt.expect(AppKeys.homeScreen);
    await tt.snapshot("HomeScreen_initial");
    await tt.type(AppKeys.usernameField, 'John Doe');
    await tt.type(AppKeys.passwordField, 'password123');
    await tt.tap(AppKeys.registerButton);
    await tt.expectText(AppKeys.errorMessage, 'Please accept terms.');
    await tt.tap(AppKeys.acceptTermsCheckbox);
    await tt.tap(AppKeys.registerButton);

    await tt.expect(AppKeys.welcomeScreen);
    await tt.expectText(AppKeys.welcomeMessage, 'Welcome John Doe!');
    await tt.snapshot("WelcomeScreen_JohnDoe");
  });
}
```
