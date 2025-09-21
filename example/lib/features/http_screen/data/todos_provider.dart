import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'todo_dto.dart';
import 'todos_response.dart';

part 'todos_provider.g.dart';

@riverpod
Future<List<TodoDto>> todos(Ref ref) async {
  // final response = await http.get(Uri.parse('https://dummyjson.com/todos'));

  final dio = Dio();
  final response = await dio.get('https://dummyjson.com/todos');

  if (response.statusCode != 200) {
    throw Exception('Failed to load todos');
  }

  // final data = json.decode(response.body) as Map<String, dynamic>;
  // final data = json.decode(response.data.toString()) as Map<String, dynamic>;
  final body = TodosResponseDto.fromJson(response.data);
  return body.todos;
}
