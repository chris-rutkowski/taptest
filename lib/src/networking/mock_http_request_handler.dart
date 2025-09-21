import 'dart:io';

import 'http_method.dart';
import 'mock_http_response.dart';

abstract class MockHttpRequestHandler {
  const MockHttpRequestHandler();

  bool canHandle(
    Uri uri,
    HttpMethod method,
    String path,
  );

  MockHttpResponse? handle(Uri uri, HttpHeaders headers, String? body);
}
