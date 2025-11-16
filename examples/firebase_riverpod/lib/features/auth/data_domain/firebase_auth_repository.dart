import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';

import 'app_user.dart';
import 'auth_repository.dart';

final class FirebaseAuthRepository implements AuthRepository {
  @override
  AppUser? get user => _convertUser(FirebaseAuth.instance.currentUser);

  @override
  Stream<AppUser?> get userStream => _authStateController.stream;

  final StreamController<AppUser?> _authStateController = StreamController<AppUser?>.broadcast();

  FirebaseAuthRepository() {
    FirebaseAuth.instance.authStateChanges().listen((user) {
      _authStateController.add(_convertUser(user));
    });
  }

  void dispose() {
    _authStateController.close();
  }

  @override
  Future<void> register({required String email, required String password}) {
    return FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
  }

  @override
  Future<void> login({required String email, required String password}) {
    return FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
  }

  @override
  Future<void> logout() {
    return FirebaseAuth.instance.signOut();
  }

  static AppUser? _convertUser(User? user) => user == null
      ? null
      : AppUser(
          id: user.uid,
          email: user.email!,
        );
}
