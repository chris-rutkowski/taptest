import 'dart:io';

import 'http_method.dart';
import 'mock_http_response.dart';

abstract class MockHttpRequestHandler {
  final HttpMethod method;
  final String path;

  const MockHttpRequestHandler({
    required this.method,
    required this.path,
  });

  MockHttpResponse? handle(Uri uri, HttpHeaders headers, String? body);
}
