import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'memo.dart';
import 'memos_repository_provider.dart';

part 'memos_list_provider.g.dart';

@riverpod
Stream<List<Memo>> memosList(Ref ref) {
  // Firebase could sort, but for the sake of not re-implementing sort in Mock repository, we sort here.
  return ref.watch(memosRepositoryProvider).watchMemos().map((memos) {
    final sorted = List<Memo>.from(memos);
    sorted.sort((a, b) => a.text.toLowerCase().compareTo(b.text.toLowerCase()));
    return sorted;
  });
}
