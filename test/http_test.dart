import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:taptest/taptest.dart';

void main() {
  final statefulConfig = Config(
    // Two variants to verify stateful HTTP mocks reset between variants
    variants: Variant.lightAndDarkVariants,
    httpRequestHandlers: () {
      final getHandler = _GetTodosHandler(
        todos: [
          'Feed cat',
          'Walk dog',
          'Write tests',
          'Buy milk',
        ],
      );

      final postHandler = _PostTodoHandler(
        getHandler: getHandler,
      );

      return [
        getHandler,
        postHandler,
      ];
    },
    builder: (params) => const MaterialApp(
      home: _Screen(),
    ),
  );

  tapTest('stateful http', statefulConfig, (tt) async {
    // Ensure the app displays the expected screen (good general practice)
    await tt.exists(_Keys.screen);
    await tt.verifyTodos(['Feed cat', 'Walk dog', 'Write tests', 'Buy milk']);
    await tt.type(_Keys.addTodoField, 'Just added', submit: true);

    await tt.info('Form submitted');
    await tt.expectText(_Keys.addTodoField, ''); // Text field should be cleared
    await tt.verifyTodos(['Just added', 'Feed cat', 'Walk dog', 'Write tests', 'Buy milk']);
    await tt.expectText([_Keys.tile(4), _Keys.tileTitle], 'Buy milk');
  });

  final faultyConfig = Config(
    httpRequestHandlers: () => [
      _GetTodosHandler(faulty: true, todos: []),
      // no need for POST handler in this test
    ],

    builder: (params) => const MaterialApp(
      home: _Screen(),
    ),
  );

  tapTest('stateful http', faultyConfig, (tt) async {
    // Ensure the app displays the expected screen (good general practice)
    await tt.exists(_Keys.screen);
    await tt.expectText(_Keys.errorLabel, 'HTTP Error: 500');
  });
}

extension on TapTester {
  Future<void> verifyTodos(List<String> todos) async {
    for (var i = 0; i < todos.length; i++) {
      await expectText([_Keys.tile(i), _Keys.tileTitle], todos[i]);
    }

    await absent(_Keys.tile(todos.length));
  }
}

// --- Below is the app being tested with the test(s) above ---

abstract class _Keys {
  static const screen = ValueKey('Screen');
  static const addTodoField = ValueKey('AddTodoField');
  static ValueKey<String> tile(int index) => ValueKey('Tile:$index');
  static const tileTitle = ValueKey('TileTitle');
  static const errorLabel = ValueKey('ErrorLabel');
}

final class _Screen extends StatefulWidget {
  const _Screen();

  @override
  State<_Screen> createState() => _ScreenState();
}

final class _ScreenState extends State<_Screen> {
  List<String>? todos = [];
  String? error;
  final textController = TextEditingController();

  @override
  void initState() {
    super.initState();

    fetch();
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  Future<void> fetch() async {
    try {
      final resp = await http.get(Uri.parse('https://example.com/todos'));
      if (!mounted) return;

      if (resp.statusCode == 200) {
        setState(() {
          final decoded = jsonDecode(resp.body);
          todos = (decoded as List).map((e) => e.toString()).toList();
        });
      } else {
        setState(() => error = 'HTTP Error: ${resp.statusCode}');
      }
    } catch (e) {
      setState(() => error = 'Unknown error');
    }
  }

  Future<void> submit() async {
    final content = textController.text.trim();
    if (content.isEmpty) return;

    try {
      final resp = await http.post(
        Uri.parse('https://example.com/todos'),
        body: jsonEncode({'content': content}),
      );

      if (!mounted) return;

      if (resp.statusCode == 201) {
        textController.clear();
        unawaited(fetch());
      }
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _Keys.screen,
      appBar: AppBar(
        title: const Text('Todo app'),
      ),
      body: error != null
          ? Center(child: Text(error!, key: _Keys.errorLabel))
          : todos == null
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                ListTile(
                  title: TextField(
                    key: _Keys.addTodoField,
                    controller: textController,
                    onSubmitted: (_) => submit(),
                    decoration: InputDecoration(
                      hintText: 'Add todo',
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: todos!.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        key: _Keys.tile(index),
                        title: Text(todos![index], key: _Keys.tileTitle),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}

final class _GetTodosHandler implements MockHttpRequestHandler {
  final bool faulty;
  final List<String> todos;

  _GetTodosHandler({
    required this.todos,
    this.faulty = false,
  });

  @override
  bool canHandle(Uri uri, HttpMethod method) {
    return method == HttpMethod.get && uri.path == '/todos';
  }

  @override
  FutureOr<MockHttpResponse>? handle(Uri uri, HttpHeaders headers, String? body) {
    if (faulty) {
      return MockHttpResponse(
        statusCode: HttpStatus.internalServerError,
      );
    }

    return MockHttpResponse(
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
      },
      body: jsonEncode(todos),
    );
  }
}

final class _PostTodoHandler implements MockHttpRequestHandler {
  final _GetTodosHandler getHandler;

  const _PostTodoHandler({
    required this.getHandler,
  });

  @override
  bool canHandle(Uri uri, HttpMethod method) {
    return method == HttpMethod.post && uri.path == '/todos';
  }

  @override
  FutureOr<MockHttpResponse>? handle(Uri uri, HttpHeaders headers, String? body) {
    final todo = jsonDecode(body!)['content'] as String;
    getHandler.todos.insert(0, todo);

    return MockHttpResponse(
      statusCode: HttpStatus.created, // 201
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
      },
    );
  }
}
