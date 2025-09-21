import 'package:json_annotation/json_annotation.dart';

part 'todo_dto.g.dart';

@JsonSerializable()
final class TodoDto {
  final int id;
  @JsonKey(name: 'todo')
  final String text;
  final bool completed;

  const TodoDto({
    required this.id,
    required this.text,
    required this.completed,
  });

  factory TodoDto.fromJson(Map<String, dynamic> json) => _$TodoDtoFromJson(json);
  Map<String, dynamic> toJson() => _$TodoDtoToJson(this);
}
