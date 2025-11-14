import 'memo.dart';

abstract class MemosRepository {
  Future<Memo> add(String memo);
  Stream<List<Memo>> watchMemos();
  Future<void> delete(Memo memo);
}
