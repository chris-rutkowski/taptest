import 'dart:async';

import 'package:firebase_riverpod/features/memos/data_domain/memo.dart';
import 'package:firebase_riverpod/features/memos/data_domain/memos_repository.dart';
import 'package:uuid/uuid.dart';

import '../utils/stream_store.dart';

final class MockMemosRepository implements MemosRepository {
  final StreamStore<List<Memo>> _store;

  MockMemosRepository() : _store = StreamStore<List<Memo>>([]);

  @override
  Future<Memo> add(String memo) {
    final newMemo = Memo(
      id: Uuid().v4(),
      text: memo,
    );
    _store.value = List<Memo>.from(_store.value)..add(newMemo);

    return Future.value(newMemo);
  }

  @override
  Stream<List<Memo>> watchMemos() => _store.stream;

  @override
  Future<void> delete(Memo memo) {
    _store.value = List<Memo>.from(_store.value)..removeWhere((e) => e.id == memo.id);
    return Future<void>.value();
  }
}
