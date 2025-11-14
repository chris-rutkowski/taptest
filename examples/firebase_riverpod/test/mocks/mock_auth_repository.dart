import 'package:collection/collection.dart';
import 'package:firebase_riverpod/features/auth/data_domain/app_user.dart';
import 'package:firebase_riverpod/features/auth/data_domain/auth_repository.dart';
import 'package:uuid/uuid.dart';

import 'stream_store.dart';

final class AppUserWithPassword {
  final AppUser user;
  final String password;

  const AppUserWithPassword({
    required this.user,
    required this.password,
  });
}

final class MockAuthRepository implements AuthRepository {
  final StreamStore<AppUser?> _store;
  final List<AppUserWithPassword> _allUsers;

  MockAuthRepository({
    AppUser? user,
    Iterable<AppUserWithPassword>? allUsers,
  }) : _store = StreamStore<AppUser?>(user),
       _allUsers = allUsers?.toList() ?? [];

  @override
  AppUser? get user => _store.value;

  @override
  Stream<AppUser?> get userStream => _store.stream;

  @override
  Future<void> login({required String email, required String password}) {
    final userWithPassword = _allUsers.firstWhereOrNull(
      (e) => e.user.email == email && e.password == password,
    );

    if (userWithPassword != null) {
      _store.value = userWithPassword.user;
      return Future<void>.value();
    }

    throw UnimplementedError();
  }

  @override
  Future<void> logout() {
    _store.value = null;
    return Future<void>.value();
  }

  @override
  Future<void> register({required String email, required String password}) {
    final user = AppUser(
      id: Uuid().v4(),
      email: email,
    );

    _store.value = user;
    _allUsers.add(
      AppUserWithPassword(
        user: user,
        password: password,
      ),
    );

    return Future<void>.value();
  }
}
