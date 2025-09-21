import 'dart:io';

import 'package:fake_http_client/fake_http_client.dart';

import 'http_method_from_string.dart';
import 'mock_http_request_handler.dart';

final class MockHttpOverrides extends HttpOverrides {
  final Iterable<MockHttpRequestHandler> handlers;

  MockHttpOverrides({required this.handlers});

  @override
  HttpClient createHttpClient(_) => FakeHttpClient(
    (request, client) {
      final httpMethod = httpMethodFromString(request.method);

      for (final handler in handlers) {
        if (handler.method != httpMethod) continue;
        if (handler.path != request.uri.path) continue;

        final response = handler.handle(
          request.uri,
          request.headers,
          request.bodyText,
        );

        if (response != null) {
          return FakeHttpResponse(
            statusCode: response.statusCode,
            headers: response.headers,
            body: response.body,
          );
        }
      }

      throw UnimplementedError('No MockHttpRequestHandler found for $httpMethod ${request.uri}');
    },
  );
}
