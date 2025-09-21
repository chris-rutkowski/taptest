// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'todos_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TodosResponseDto _$TodosResponseDtoFromJson(Map<String, dynamic> json) =>
    TodosResponseDto(
      todos: (json['todos'] as List<dynamic>)
          .map((e) => TodoDto.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$TodosResponseDtoToJson(TodosResponseDto instance) =>
    <String, dynamic>{'todos': instance.todos};
