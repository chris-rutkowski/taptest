import 'package:json_annotation/json_annotation.dart';

part 'rating_dto.g.dart';

@JsonSerializable()
final class RatingDto {
  const RatingDto({
    required this.rate,
    required this.count,
  });

  final double rate;
  final int count;

  factory RatingDto.fromJson(Map<String, dynamic> json) => _$RatingDtoFromJson(json);

  Map<String, dynamic> toJson() => _$RatingDtoToJson(this);
}
