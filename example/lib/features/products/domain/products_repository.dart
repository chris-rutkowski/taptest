import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../data/products_webservice.dart';
import 'product.dart';

part 'products_repository.g.dart';

@Riverpod(keepAlive: true)
Future<List<Product>> productsRepository(Ref ref) async {
  final webservice = ProductsWebservice();
  final dtos = await webservice.getProducts();
  return dtos.map(Product.fromDto).toList();
}
