// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(productRepository)
const productRepositoryProvider = ProductRepositoryFamily._();

final class ProductRepositoryProvider
    extends $FunctionalProvider<AsyncValue<Product>, Product, FutureOr<Product>>
    with $FutureModifier<Product>, $FutureProvider<Product> {
  const ProductRepositoryProvider._({
    required ProductRepositoryFamily super.from,
    required ProductId super.argument,
  }) : super(
         retry: null,
         name: r'productRepositoryProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$productRepositoryHash();

  @override
  String toString() {
    return r'productRepositoryProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<Product> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<Product> create(Ref ref) {
    final argument = this.argument as ProductId;
    return productRepository(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is ProductRepositoryProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$productRepositoryHash() => r'f8ab3dc313f8ef9c8d7b8b600a017b3e297ade43';

final class ProductRepositoryFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<Product>, ProductId> {
  const ProductRepositoryFamily._()
    : super(
        retry: null,
        name: r'productRepositoryProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  ProductRepositoryProvider call(ProductId id) =>
      ProductRepositoryProvider._(argument: id, from: this);

  @override
  String toString() => r'productRepositoryProvider';
}
