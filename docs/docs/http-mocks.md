# HTTP mocks

Widget tests have no real network. Register `MockHttpRequestHandler`s on `Config` so `HttpClient` calls are stubbed.

```dart
final class TodoHandler implements MockHttpRequestHandler {
  const TodoHandler();

  @override
  bool canHandle(Uri uri, HttpMethod method, String path) {
    return method == HttpMethod.get && uri.path == '/todos';
  }

  @override
  MockHttpResponse? handle(Uri uri, HttpHeaders headers, String? body) {
    return MockHttpResponse(
      headers: {HttpHeaders.contentTypeHeader: 'application/json'},
      body: '{"todos":[]}',
    );
  }
}

final config = Config(
  httpRequestHandlers: const [TodoHandler()],
  builder: (params) => MyApp(...),
);
```

Handlers are tried in order. The first `canHandle == true` wins.

`ToQrImageHttpRequestHandler` turns image GETs into deterministic QR images for snapshots (useful when you cannot ship real network bitmaps in widget tests).

Integration tests can omit handlers and hit a real backend if you want.
