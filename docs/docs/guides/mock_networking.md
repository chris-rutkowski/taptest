# ☁️ Mock networking

In **Widget tests**, TapTest requires you to mock all network requests due to limitations in Flutter's underlying widget testing framework. In **Integration tests**, mocking is optional – you can mock all or part of your network layer to reduce dependency on external services.

The mocking approach described in this guide works seamlessly with [**http**](https://pub.dev/packages/http), [**dio**](https://pub.dev/packages/dio), and most likely all other HTTP client libraries. TapTest intercepts requests at the very high level, so your choice of networking package doesn't affect how you write mocks.

## 🛠️ How to mock network requests?

For each distinct webservice (or other network request), create a class that implements `MockHttpRequestHandler`. Here's an example of a simple GET request handler that returns a list of TODO items:

```dart
final class GetTodosHandler implements MockHttpRequestHandler {
  const GetTodosHandler();

  @override
  bool canHandle(Uri uri, HttpMethod method) => method == HttpMethod.get && uri.path == '/todos';

  @override
  FutureOr<MockHttpResponse>? handle(Uri uri, HttpHeaders headers, String? body) {
    return MockHttpResponse(
      statusCode: HttpStatus.ok, // 200
      headers: { HttpHeaders.contentTypeHeader: 'application/json' },
      body: jsonEncode(['Buy groceries', 'Walk the dog']),
    );
  }
}
```

Include your handler in the `httpRequestHandlers` parameter of your test's `Config`:

```dart {2-4}
final config = Config(
  httpRequestHandlers: () => [
    GetTodosHandler()
  ],
  builder: (params) => const MyApp(params: params),
);

tapTest('http', config, (tt) async {
  ...
}
```

## 📦 Configurable mocks

`MockHttpRequestHandler` is a simple interface, so you have full control over the implementation. For example, our `GetTodosHandler` could accept a list of TODOs through its constructor:

```dart {2,4,14}
final class GetTodosHandler implements MockHttpRequestHandler {
  final List<String> todos;

  const GetTodosHandler(this.todos);

  @override
  bool canHandle(Uri uri, HttpMethod method) => method == HttpMethod.get && uri.path == '/todos';

  @override
  FutureOr<MockHttpResponse>? handle(Uri uri, HttpHeaders headers, String? body) {
    return MockHttpResponse(
      statusCode: HttpStatus.ok, // 200
      headers: { HttpHeaders.contentTypeHeader: 'application/json' },
      body: jsonEncode(todos),
    );
  }
}

...

final config = Config(
  httpRequestHandlers: () => [
    GetTodosHandler(
      todos: ['Feed cat', 'Walk dog', 'Write tests', 'Buy milk'],
    ),
  ];
  builder: (params) => const MyApp(params: params),
);
```

## 🚨 Returning errors and delays

Since you control the implementation, you can return error responses or introduce artificial delays to simulate network latency:

```dart {2,5,12,14-20}
final class GetTodosHandler implements MockHttpRequestHandler {
  final bool authorized;
  final List<String> todos;

  const GetTodosHandler(this.todos, {this.authorized = true});

  @override
  bool canHandle(Uri uri, HttpMethod method) => method == HttpMethod.get && uri.path == '/todos';

  @override
  FutureOr<MockHttpResponse>? handle(Uri uri, HttpHeaders headers, String? body) async {
    await Future.delayed(const Duration(milliseconds: 300));

    if (!authorized) {
      return MockHttpResponse(
        statusCode: HttpStatus.unauthorized, // 401
        headers: { HttpHeaders.contentTypeHeader: 'application/json' },
        body: jsonEncode({'error': 'Unauthorized'}),
      );
    }

    return MockHttpResponse(
      statusCode: HttpStatus.ok, // 200
      headers: { HttpHeaders.contentTypeHeader: 'application/json' },
      body: jsonEncode(todos),
    );
  }
}
```

## 🗄️ Stateful network mocks

You can create smart mock infrastructure where requests like POST, PUT, and DELETE modify the state returned by subsequent GET requests. Since you control the implementation, this behavior is straightforward to implement.

Let's create `GetTodosHandler` and `PostTodoHandler` that work together to maintain a stateful list of TODOs:

```dart
final class GetTodosHandler implements MockHttpRequestHandler {
  final List<String> todos;

  GetTodosHandler({
    required this.todos,
  });

  @override
  bool canHandle(Uri uri, HttpMethod method) {
    return method == HttpMethod.get && uri.path == '/todos';
  }

  @override
  FutureOr<MockHttpResponse>? handle(Uri uri, HttpHeaders headers, String? body) {
    return MockHttpResponse(
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
      },
      body: jsonEncode(todos),
    );
  }
}
```

```dart
final class PostTodoHandler implements MockHttpRequestHandler {
  final GetTodosHandler getHandler;

  const PostTodoHandler({
    required this.getHandler,
  });

  @override
  bool canHandle(Uri uri, HttpMethod method) {
    return method == HttpMethod.post && uri.path == '/todos';
  }

  @override
  FutureOr<MockHttpResponse>? handle(Uri uri, HttpHeaders headers, String? body) {
    final todo = jsonDecode(body!)['content'] as String;

    // Here we modify the state of GetTodosHandler
    getHandler.todos.insert(0, todo);

    return MockHttpResponse(
      statusCode: HttpStatus.created, // 201
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
      },
    );
  }
}
```

Configure your test to use both handlers with a shared state:

```dart
final config = Config(
  httpRequestHandlers: () {
    final getHandler = GetTodosHandler(
      todos: ['Feed cat', 'Walk dog', 'Write tests', 'Buy milk'],
    );

    final postHandler = PostTodoHandler(
      getHandler: getHandler,
    );

    return [getHandler, postHandler];
  },
  builder: (params) => const MyApp(params: params),
);
```

## 🎭 Creative mocks

You can create versatile mocks that serve multiple testing purposes. The following `PostTodoHandler` works for happy path scenarios while also simulating errors like unauthorized access and validation failures based on user input:

```dart
final class PostTodoHandler implements MockHttpRequestHandler {
  final GetTodosHandler getHandler;

  const PostTodoHandler({
    required this.getHandler,
  });

  @override
  bool canHandle(Uri uri, HttpMethod method) => method == HttpMethod.post && uri.path == '/todos';

  @override
  FutureOr<MockHttpResponse>? handle(Uri uri, HttpHeaders headers, String? body) {
    final todo = jsonDecode(body!)['content'] as String;

    // Simulated errors based on todo content

    if (todo == 'unauthorized') {
      return MockHttpResponse(
        statusCode: HttpStatus.unauthorized, // 401
        headers: {HttpHeaders.contentTypeHeader: 'application/json'},
        body: jsonEncode({'error': 'Unauthorized'}),
      );
    }

    if (todo == 'bad') {
      return MockHttpResponse(
        statusCode: HttpStatus.badRequest, // 400
        headers: {HttpHeaders.contentTypeHeader: 'application/json'},
        body: jsonEncode({'error': 'Invalid TODO content'}),
      );
    }

    // Success

    getHandler.todos.insert(0, todo);

    return MockHttpResponse(
      statusCode: HttpStatus.created, // 201
      headers: {HttpHeaders.contentTypeHeader: 'application/json'},
    );
  }
}
```
