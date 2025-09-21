// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'todo_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TodoDto _$TodoDtoFromJson(Map<String, dynamic> json) => TodoDto(
  id: (json['id'] as num).toInt(),
  text: json['todo'] as String,
  completed: json['completed'] as bool,
);

Map<String, dynamic> _$TodoDtoToJson(TodoDto instance) => <String, dynamic>{
  'id': instance.id,
  'todo': instance.text,
  'completed': instance.completed,
};
