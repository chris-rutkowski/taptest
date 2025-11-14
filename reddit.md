Title: Introducing TapTest – Write Flutter E2E tests that complete in milliseconds and survive massive refactors

Body: 

Hey Flutter Developers 👋

I wanted to share [**TapTest**](https://pub.dev/packages/taptest) – a testing framework I built after years of frustration with tests that break on every refactor and exist just to satisfy code coverage metrics.

**TapTest takes a different approach:** test your app the way users interact with it – through the GUI. Tap buttons, expect visual changes, validate user journeys. Your implementation details can change all you want; if the UI behaves the same, your tests keep passing.

```dart
final config = Config(
  variants: Variant.lightAndDarkVariants, // ☀️ 🌙
  httpRequestHandlers: [ MockRegistrationWebservice() ], // ☁️
  builder: (params) => MyApp(params: params),
);

tapTest('TapTest with Page Objects', config, (tt) async {
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
```

This E2E test completes in under **⏱️ 80 millisecond** checking the happy path, error handling and design in both light and dark themes.

Instead of mocking routers, presenters, interactors, and half of your app consisting of single-purpose abstractions, you mock only high-level services like databases, network clients, permission handlers etc. This is only necessary for extremely fast widget test like above and optional for flaky-free integration tests.

**Key features:**
- 🚀 E2E widget tests run in milliseconds
- 🛡️ Survives refactors – change state management, restructure your app, tests keep passing
- 📸 Visual regression testing that actually renders fonts and icons
- 📱 Integration test with the same code

TapTest has been production-ready for years in projects I've worked on. I recently decided to **open source** it, so I'm cherry-picking the code and actively writing docs, tutorials, API references, and CI/CD guides.

**Check it out:**
- 📚 [Interactive Tutorial](https://taptest.dev/docs/tutorial/getting-started) (~1 hour)
- 📦 [TapTest on pub.dev](https://pub.dev/packages/taptest)
- 🗄️ [TapTest on GitHub](https://github.com/chris-rutkowski/taptest)

I'd love to hear your thoughts! What are your biggest testing pain points in Flutter?
