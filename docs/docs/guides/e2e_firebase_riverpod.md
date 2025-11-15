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

## Dependency inversion principle

It is one of the SOLD principles. Instead of tightly coupling your app to Firebase SDK, we will depend on abstraction, and Firebase will be one of many. Thanks to this approach you can easily swap Firebase with other service in the future, without refactoring your entire app. This approach is also architecture agnostic, whether you use MVVM, Clean Architecture or even no architecture at all.

Therefore, instead of tightly coupling **FirebaseAuth** in your View, ViewModel or similar, like this:

```dart
final firebaseAuth = FirebaseAuth.instance;

// try/catch ...

final user = await firebaseAuth.createUserWithEmailAndPassword(
  email: emailTextEditingController.text,
  password: passwordTextEditingController.text
);

// route to next screen...

```
create an interface (abstract class) and Firebase implementation as follows:

```dart
abstract class AuthRepository {
  Future<void> register({required String email, required String password});
  // other methods and accessors for current user
}

abstract class FirebaseAuthRepository {
  Future<void> register({required String email, required String password}) {
    return FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password
    );
  }
}
```

In **Riverpod** you should create a provider for `AuthRepository` that returns `FirebaseAuthRepository` in production code.

```dart
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'auth_repository_provider.g.dart';

@Riverpod(keepAlive: true)
AuthRepository authRepository(Ref ref) {
  return FirebaseAuthRepository();
}
```

Now let's corrected code in your View, ViewModel or similar. You should use Riverpod for service discovery - obtain the  to provide `AuthRepository` without directly depending on `FirebaseAuthRepository` and it's implementation detail.

```dart

final auth = ref.read(authRepositoryProvider);

// try/catch ...

final user = await auth.login(
  email: emailTextEditingController.text,
  password: passwordTextEditingController.text
);

// route to next screen...
```

## Mock Firebase Auth

Now in your `test` folder let's create somewhere a mock implementation of `AuthRepository` for widget tests.

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

Check the mock_auth_repository.dart file in the example app for more information. Both MockAuthRepository as well as MockMemosRepository (mock for Firebase memos collection) use a very Simple `StreamStore` - a trivial implementation of a stream-backed value holder, feel free to reuse it:

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

To elevate on dependency inversion principle, we also don't depend on `User` type from Firebase SDK directly, but have our own `AppUser` model. You can see the complete implementation of FirebaseAuthRepository how we convert between these two types.

This MockAuthRepository can be initialised with or without a user, to simulate both logged in and logged out states when the app starts if you need it. Your mocks, you are in full control.

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
