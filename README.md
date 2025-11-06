# TapTest

See [https://taptest.dev](https://taptest.dev) for Tutorials and more information.

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
