import 'package:cloud_firestore/cloud_firestore.dart';

import '../../auth/data_domain/auth_repository.dart';
import 'memo.dart';
import 'memos_repository.dart';

final class FirebaseMemosRepository implements MemosRepository {
  final AuthRepository _authRepository;

  const FirebaseMemosRepository(
    this._authRepository,
  );

  @override
  Future<Memo> add(String memo) async {
    final docRef = await FirebaseFirestore.instance
        .collection('users')
        .doc(_authRepository.user!.id)
        .collection('memos')
        .add(
          {
            'text': memo,
          },
        );

    return Memo(
      id: docRef.id,
      text: memo,
    );
  }

  @override
  Stream<List<Memo>> watchMemos() {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(_authRepository.user!.id)
        .collection('memos')
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map(
                (doc) => Memo(
                  id: doc.id,
                  text: doc.data()['text'] as String,
                ),
              )
              .toList(),
        );
  }

  @override
  Future<void> delete(Memo memo) {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(_authRepository.user!.id)
        .collection('memos')
        .doc(memo.id)
        .delete();
  }
}
