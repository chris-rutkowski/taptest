import 'package:dio/dio.dart';

import 'product_dto.dart';

final class ProductsWebservice {
  const ProductsWebservice();

  /// Fetches all products from the fake store API
  /// Returns a [List] of [ProductDto] objects
  Future<List<ProductDto>> getProducts() async {
    final response = await Dio().get('https://fakestoreapi.com/products');

    return (response.data as List<dynamic>)
        .map(
          (json) => ProductDto.fromJson(
            json as Map<String, dynamic>,
          ),
        )
        .toList();
  }
}
