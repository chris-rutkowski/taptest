import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'auth_repository.dart';
import 'firebase_auth_repository.dart';

part 'auth_repository_provider.g.dart';

@Riverpod(keepAlive: true)
AuthRepository authRepository(Ref ref) {
  return FirebaseAuthRepository();
}
