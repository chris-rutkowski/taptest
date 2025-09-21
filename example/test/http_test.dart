import 'dart:convert';
import 'dart:io';

import 'package:example/features/http_screen/data/todo_dto.dart';
import 'package:example/features/http_screen/data/todos_response.dart';
import 'package:example/features/http_screen/http_keys.dart';
import 'package:example/features/welcome/presentation/welcome_keys.dart';
import 'package:taptest/taptest.dart';

import '_utils/default_tap_tester_config.dart';

// const standardTapTesterConfig =

void main() {
  final config = defaultTapTesterConfig.copyWith(
    httpRequestHandlers: [
      const TodoHandler(
        method: HttpMethod.get,
        todos: [
          TodoDto(id: 1, text: 'From test 1', completed: false),
          TodoDto(id: 2, text: 'From test 2', completed: true),
          TodoDto(id: 3, text: 'From test 3', completed: false),
          TodoDto(id: 3, text: 'From test 4', completed: false),
        ],
      ),
    ],
    suite: 'http',
  );

  tapTest('flow', config, (tester) async {
    await tester.info('On Welcome screen');
    await tester.exists(WelcomeKeys.screen);
    await tester.snapshot('welcome_screen');
    await tester.tap(WelcomeKeys.httpButton, sync: SyncType.settled);

    await tester.info('On Http screen');
    await tester.exists(HttpKeys.screen);
    // await tester.snapshot('http_screen');

    // await tester.absent(LongKeys.cell(72));
    // await tester.scrollTo([LongKeys.cell(72), LongKeys.cellTitle], scrollable: LongKeys.list);
    // await tester.snapshot('long_screen_72');
    await tester.exists(HttpKeys.cell(0), timeout: const Duration(seconds: 1));
    await tester.snapshot('http_screen');

    // await tester.pop();

    // await tester.snapshot('long_screen_popped');
  });
}

final class TodoHandler extends MockHttpRequestHandler {
  final List<TodoDto> todos;

  const TodoHandler({
    required HttpMethod method,
    required this.todos,
  }) : super(method: HttpMethod.get, path: '/wrong');

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
