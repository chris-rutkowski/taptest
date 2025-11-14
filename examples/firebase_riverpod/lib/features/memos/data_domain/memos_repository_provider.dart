import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../auth/data_domain/auth_repository_provider.dart';
import 'firebase_memos_repository.dart';
import 'memos_repository.dart';

part 'memos_repository_provider.g.dart';

@Riverpod(keepAlive: true)
MemosRepository memosRepository(Ref ref) {
  return FirebaseMemosRepository(ref.read(authRepositoryProvider));
}
