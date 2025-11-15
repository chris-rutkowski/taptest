# E2E tests with Firebase (Riverpod)

Learn how to write lightning-fast end-to-end tests for Firebase apps using TapTest! This guide (and example app) demonstrates mocking Firebase Auth and Firestore for widget tests, while keeping integration tests flexible with real services or emulators.

**⏱️ Time to read:** 15 minutes  
**🎯 State management:** Riverpod (patterns apply to any architecture)  
**📦 Example app:** [taptest/examples/firebase_riverpod](https://github.com/chris-rutkowski/taptest/tree/main/examples/firebase_riverpod)

## 🚀 Comprehensive E2E test

The Widget Test in example app completes in **⏰ 3 seconds** and verifies complete user journeys, including:

**✨ Pixel-perfect design** (light & dark themes)
- Registration screen
- About screen  
- Dashboard (empty state and with data)

**🛡️ Error handling**
- Empty form validation
- Invalid password confirmation

**🎭 User flows**
- Registration
- Login
- Start app with logged-in state
- Logout
- Saving and deleting memos
- Memos sorting logic
- Form behavior (clearing fields on submit)

**🧭 Navigation**
- Deeplinks
- Route guards (protecting authenticated routes)

## 🎯 Testing strategy

**Widget tests:** You have to use mocks for Firebase services. This gives you blazing-fast tests with complete control over data and edge cases.

**Integration tests:** Your choice, use mocks, real Firebase project or Firebase Emulators.

## 🏗️ Dependency Inversion

To enable fast, mockable tests, we'll apply the **Dependency Inversion Principle** (one of the SOLID principles). Instead of tightly coupling your app to the Firebase SDK, we'll depend on abstractions. This approach works with any architecture - MVVM, Clean Architecture, or none at all.

### ❌ Before: Tight coupling

Your code directly depends on Firebase SDK:

```dart
final firebaseAuth = FirebaseAuth.instance;

// try/catch ...

await firebaseAuth.createUserWithEmailAndPassword(
  email: emailTextEditingController.text,
  password: passwordTextEditingController.text
);

// route to next screen etc.
```

**Problems:**
- Hard to test (requires real Firebase)
- Hard to swap implementations
- Firebase details leak throughout your app

### ✅ After: Dependency inversion

Create an interface and Firebase implementation:

```dart
abstract class AuthRepository {
  Future<void> register({required String email, required String password});
  // other methods and accessors for current user
}

final class FirebaseAuthRepository {
  Future<void> register({required String email, required String password}) {
    return FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password
    );
  }
}
```

### 🔌 Wire it up with Riverpod

Create a provider that returns your Firebase implementation:

```dart
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_repository_provider.g.dart';

@Riverpod(keepAlive: true)
AuthRepository authRepository(Ref ref) {
  return FirebaseAuthRepository();
}
```

### 🎯 Use the abstraction

Now your code depends on the interface, not Firebase directly:

```dart
final authRepository = ref.read(authRepositoryProvider);

// try/catch ...

await authRepository.login(
  email: emailTextEditingController.text,
  password: passwordTextEditingController.text
);

// route to next screen etc.
```

**Benefits:**
- ✅ Easy to mock in tests
- ✅ Can swap Firebase for another service
- ✅ Firebase details contained in one place

## 🎭 Create mock implementation

Now that we have an interface, let's create a mock implementation for widget tests. Create this in your `test` folder:

```dart
final class MockAuthRepository implements AuthRepository {
  final StreamStore<AppUser?> _store;

  @override
  AppUser? get user => _store.value;

  @override
  Stream<AppUser?> get userStream => _store.stream;

  MockAuthRepository({AppUser? user}) : _store = StreamStore<AppUser?>(user);

  @override
  Future<void> register({required String email, required String password}) {
    _store.value = AppUser(
      id: Uuid().v4(),
      email: email,
    );

    return Future<void>.value();
  }
}
```

> 💡 **See the complete implementation:** Check [mock_auth_repository.dart](https://github.com/chris-rutkowski/taptest/blob/main/examples/firebase_riverpod/test/_utils/mock_auth_repository.dart) in the example app for all auth methods (login, logout, etc.)

### 🔄 StreamStore helper

Both `MockAuthRepository` and `MockMemosRepository` use a simple `StreamStore` - a lightweight stream-backed value holder:

```dart
final class StreamStore<T> {
  final BehaviorSubject<T> _subject;

  Stream<T> get stream => _subject.stream;
  T get value => _subject.value;
  set value(T value) => _subject.add(value);
  void close() => _subject.close();

  StreamStore(T value) : _subject = BehaviorSubject<T>.seeded(value);
}
```

### 🎯 Custom user model

Following the dependency inversion principle, we don't depend on Firebase's `User` type directly. Instead, we define our own `AppUser` model:

```dart
class AppUser {
  final String id;
  final String email;
  
  AppUser({required this.id, required this.email});
}
```

> 💡 See [FirebaseAuthRepository](https://github.com/chris-rutkowski/taptest/blob/main/examples/firebase_riverpod/lib/core/auth/firebase_auth_repository.dart) in the example for how to convert between `User` and `AppUser`.

### ✨ Flexible initialization

You can initialize `MockAuthRepository` with or without a user to test different scenarios:

```dart
// Test logged-out state
MockAuthRepository()

// Test logged-in state
MockAuthRepository(user: AppUser(id: '123', email: 'test@example.com'))
```

**Your mocks, your control!** You decide the initial state, data, and behavior.

## Configure TapTest

Production starting point of your app `main.dart` usually sets up Firebase, configure other essential services and runs app wrapped in `ProviderScope` for Riverpod. Something like this:

```dart title="lib/main.dart" {1-11}
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: ...);

  runApp(
    ProviderScope(
      child: const YourApp(),
    ),
  );
}
```

In Widget Tests the lib/main.dart is not used, but every test suite has it's `main()` function. Therefore, in the TapTests config builder, we need to setup Firebase, Riverpod and override the Firebase dependencies with our mocks.

```dart title="test/e2e_test.dart" {3-20}
// imports ...
void main() {
  final config = Config(
    builder: (params) {
      final providerContainer = ProviderContainer(
        overrides: [
          authRepositoryProvider.overrideWithValue(
            MockAuthRepository(),
          ),
        ],
      );

      return UncontrolledProviderScope(
        container: providerContainer,
        child: YourApp(params: params),
      );
    },
  );

  tapTest('E2E', config, (tt) async {
    await tt.exists(RegisterKeys.screen);

    // Let's register
    await tt.type(RegisterKeys.emailField, 'test@example.com');
    await tt.type(RegisterKeys.passwordField, 'password123');
    await tt.type(RegisterKeys.confirmPasswordField, 'password123', submit: true);

    // Let's verify we are on Dashboard with correct user
    await tt.exists(DashboardKeys.screen);
    await tt.expectText(DashboardKeys.email, 'test@example.com');

    // Let's logout
    await tt.tap(DashboardKeys.logoutButton);
    await tt.exists(RegisterKeys.screen);
  });
}
```

Now you are free to interact with auth related features in your Widget Test. Again check my example to see how I pushed it forward with Firestore mock.

## Integration tests

As always, integration tests doesn't have any limitations. It is your call if you wish to mock Firebase services, or use as is. The example app contains the integration test, that uses the same implementation as "production" version of the app app. Well, in fact both production and integration tests use Firebase emulator, but again, it's your call if in integration test you want to use real implementation, mock, or emulator or mix approach.

The only thing to note is statefulness. In WidgetTest our builder was always recreating the underlying data layer - `StreamStore`. If you rely on actual Firebase implementation once registered user is already registered, so you cannot register again with the same email. You can always create a helper function that returns random email, registers it and verifies that Dashboard screen shows the correct email, e.g.

```dart
final randomEmail = '${Uuid().v4()}@example.com';
await tt.type(RegisterKeys.emailField, randomEmail);
...
await tt.expectText(DashboardKeys.email, randomEmail);
```

or use some tricks like, although. I find it a bit hacky, but it works:

```dart
await FirebaseAuth.instance.currentUser?.delete();
await tt.tap(DashboardKeys.logoutButton);
```

If you want to verify login experience with real FirebaseAuth (inc. emulators), you can utilise the 

```dart  title="integration_test/e2e_test.dart"
final config = Config(
  builder: (params) async {
    await Firebase.initializeApp(options: ...);

    // prepare user
    await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: 'email@example.com',
      password: 'password'
    );

    // logout (if testing login flow, or skip it if testing already logged in flow)
    await FirebaseAuth.instance.signOut();

    return ProviderScope(
      child: YourApp(params: params),
    );
  },
);
```
