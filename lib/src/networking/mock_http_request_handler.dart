import 'dart:async';
import 'dart:io';

import 'http_method.dart';
import 'mock_http_response.dart';

abstract class MockHttpRequestHandler {
  const MockHttpRequestHandler();

  bool canHandle(
    Uri uri,
    HttpMethod method,
  );

  FutureOr<MockHttpResponse?> handle(Uri uri, HttpHeaders headers, String? body);
}
