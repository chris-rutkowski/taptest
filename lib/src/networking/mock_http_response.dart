import 'dart:io';

final class MockHttpResponse {
  final int statusCode;
  final Map<String, String> headers;
  final dynamic body;

  const MockHttpResponse({
    this.statusCode = HttpStatus.ok,
    this.headers = const {},
    this.body,
  });
}
