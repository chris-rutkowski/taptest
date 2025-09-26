import 'package:json_annotation/json_annotation.dart';

import 'rating_dto.dart';

part 'product_dto.g.dart';

@JsonSerializable()
final class ProductDto {
  final int id;
  final String title;
  final double price;
  final String description;
  final String category;
  final String image;
  final RatingDto rating;

  const ProductDto({
    required this.id,
    required this.title,
    required this.price,
    required this.description,
    required this.category,
    required this.image,
    required this.rating,
  });

  factory ProductDto.fromJson(Map<String, dynamic> json) => _$ProductDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ProductDtoToJson(this);
}
