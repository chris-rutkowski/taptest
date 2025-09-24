import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'product.dart';
import 'products_repository.dart';

part 'product_repository.g.dart';

@riverpod
Future<Product> productRepository(Ref ref, ProductId id) async {
  final products = await ref.watch(productsRepositoryProvider.future);
  return products.firstWhere((product) => product.id == id);
}
