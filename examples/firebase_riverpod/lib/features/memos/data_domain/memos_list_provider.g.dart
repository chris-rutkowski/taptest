// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'memos_list_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(memosList)
const memosListProvider = MemosListProvider._();

final class MemosListProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Memo>>,
          List<Memo>,
          Stream<List<Memo>>
        >
    with $FutureModifier<List<Memo>>, $StreamProvider<List<Memo>> {
  const MemosListProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'memosListProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$memosListHash();

  @$internal
  @override
  $StreamProviderElement<List<Memo>> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<List<Memo>> create(Ref ref) {
    return memosList(ref);
  }
}

String _$memosListHash() => r'357405dfe23cb7aa0a301093fb8a702ffb24eeb6';
