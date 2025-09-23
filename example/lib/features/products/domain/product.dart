import 'package:decimal/decimal.dart';

import '../data/product_dto.dart';

final class Product {
  final int id;
  final String title;
  final Decimal price;
  final String description;
  final String category;
  final String imageUrl;
  final double stars;

  const Product({
    required this.id,
    required this.title,
    required this.price,
    required this.description,
    required this.category,
    required this.imageUrl,
    required this.stars,
  });

  /// Creates a [Product] from a [ProductDto]
  factory Product.fromDto(ProductDto dto) => Product(
    id: dto.id,
    title: dto.title,
    price: Decimal.parse(dto.price.toString()).round(scale: 2),
    description: dto.description,
    category: dto.category,
    imageUrl: dto.image,
    stars: dto.rating.rate,
  );
}
