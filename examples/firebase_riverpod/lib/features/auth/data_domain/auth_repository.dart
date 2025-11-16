import 'app_user.dart';

abstract class AuthRepository {
  Future<void> register({required String email, required String password});
  Future<void> login({required String email, required String password});
  Future<void> logout();

  AppUser? get user;
  Stream<AppUser?> get userStream;
}
