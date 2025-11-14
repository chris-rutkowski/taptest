// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'memos_repository_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(memosRepository)
const memosRepositoryProvider = MemosRepositoryProvider._();

final class MemosRepositoryProvider
    extends
        $FunctionalProvider<MemosRepository, MemosRepository, MemosRepository>
    with $Provider<MemosRepository> {
  const MemosRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'memosRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$memosRepositoryHash();

  @$internal
  @override
  $ProviderElement<MemosRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  MemosRepository create(Ref ref) {
    return memosRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(MemosRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<MemosRepository>(value),
    );
  }
}

String _$memosRepositoryHash() => r'8b07600cdaa85cc7e9325016ea824ecb2b25e82c';
