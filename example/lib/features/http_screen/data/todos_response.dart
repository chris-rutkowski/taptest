import 'package:json_annotation/json_annotation.dart';

import 'todo_dto.dart';

part 'todos_response.g.dart';

@JsonSerializable()
final class TodosResponseDto {
  final List<TodoDto> todos;

  const TodosResponseDto({
    required this.todos,
  });

  factory TodosResponseDto.fromJson(Map<String, dynamic> json) => _$TodosResponseDtoFromJson(json);
  Map<String, dynamic> toJson() => _$TodosResponseDtoToJson(this);
}
