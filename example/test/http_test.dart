import 'dart:convert';
import 'dart:io';

import 'package:example/features/http_screen/data/todo_dto.dart';
import 'package:example/features/http_screen/data/todos_response.dart';
import 'package:example/features/http_screen/http_keys.dart';
import 'package:example/features/welcome/presentation/welcome_keys.dart';
import 'package:taptest/taptest.dart';

import '_utils/default_tap_tester_config.dart';

void main() {
  final config = defaultTapTesterConfig.copyWith(
    httpRequestHandlers: [
      const TodoHandler(
        todos: [
          TodoDto(id: 1, text: 'From test 1', completed: false),
          TodoDto(id: 2, text: 'From test 2', completed: true),
          TodoDto(id: 3, text: 'From test 3', completed: false),
          TodoDto(id: 3, text: 'From test 4', completed: false),
        ],
      ),
    ],
  );

  tapTest('http', config, (tt) async {
    await tt.info('On Welcome screen');
    await tt.exists(WelcomeKeys.screen);
    await tt.snapshot('welcome_screen');
    await tt.tap(WelcomeKeys.httpButton);

    await tt.info('On Http screen');
    await tt.exists(HttpKeys.screen);
    // await tt.snapshot('http_screen');

    // await tt.absent(LongKeys.cell(72));
    // await tt.scrollTo([LongKeys.cell(72), LongKeys.cellTitle], scrollable: LongKeys.list);
    // await tt.snapshot('long_screen_72');
    await tt.exists(HttpKeys.cell(0), timeout: const Duration(seconds: 1));
    await tt.snapshot('http_screen');

    // await tt.pop();

    // await tt.snapshot('long_screen_popped');
  });
}

final class TodoHandler implements MockHttpRequestHandler {
  final List<TodoDto> todos;

  const TodoHandler({
    required this.todos,
  });

  @override
  bool canHandle(Uri uri, HttpMethod method, String path) {
    return method == HttpMethod.get && uri.path == '/todos';
  }

  @override
  MockHttpResponse? handle(Uri uri, HttpHeaders headers, String? body) {
    return MockHttpResponse(
      headers: {
        // not truly needed
        HttpHeaders.contentTypeHeader: 'application/json',
      },
      body: jsonEncode(TodosResponseDto(todos: todos).toJson()),
    );
  }
}
