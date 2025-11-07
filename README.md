# TapTest

<img src="https://raw.githubusercontent.com/chris-rutkowski/taptest/main/extras/tap_test_logo_512x512.png" alt="TapTest Logo" height="52">

**TapTest** is a revolutionary testing framework built on top of Flutter tester that encourages writing useful, user-facing E2E tests. Tests interact with your app the way users do - by tapping buttons and interface elements, validating labels content, checking elements presence and capturing visual snapshots.

Because **TapTest** tests your app through its GUI, your tests are usually resilient to code refactors and implementation detail changes. Go wild, restructure your entire app, change state management, its architecture and as long as the user interface remains consistent, your tests will continue to give you confidence your app works!

## 📚 Documentation and tutorial

See [https://taptest.dev](https://taptest.dev) for tutorial, documentation, best practices and advanced guides.

## 🚀 Why TapTest?

- **⚡ Blazing Fast** - E2E Widget tests that run in the blink of an eye
- **🛡️ Refactor-Proof** - Tests survive huge code refactors by focusing on user interactions not on implementation details.
- **🎯 User-Focused** - Write tests that mirror real user behavior
- **📸 Visual Regression** - Built-in snapshot testing for pixel-perfect UI validation
- **🌐 Flexible** - Mock external resources like webservices - required for widget tests, optional for non-flaky integration tests

## ✨ Quick Example

```dart
void main() {
  final config = Config(
    variants: Variant.lightAndDarkVariants, // ☀️ 🌙
    httpRequestHandlers: [
      // required for ultra fast Widget tests
      // optional for stable Integration tests
      MockRegistrationWebservice(success: true),
    ],
    builder: (params) {
      return MyApp(params: params);
    },
  );

  tapTest('E2E test (with Page Objects)', config, (tt) async {
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

  tapTest('E2E test (without Page Objects)', config, (tt) async {
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

## 🤝 Support TapTest

If you find TapTest valuable, consider supporting its continued development:

<a href="https://www.buymeacoffee.com/chrisrkw" target="_blank"><img src="https://cdn.buymeacoffee.com/buttons/v2/default-yellow.png" alt="Buy Me A Coffee" height="60"></a>

