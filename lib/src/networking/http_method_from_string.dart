import 'http_method.dart';

HttpMethod httpMethodFromString(String method) {
  switch (method.toUpperCase()) {
    case 'GET':
      return HttpMethod.get;
    case 'POST':
      return HttpMethod.post;
    case 'PUT':
      return HttpMethod.put;
    case 'DELETE':
      return HttpMethod.delete;
    case 'PATCH':
      return HttpMethod.patch;
    case 'HEAD':
      return HttpMethod.head;
    case 'OPTIONS':
      return HttpMethod.options;
    case 'TRACE':
      return HttpMethod.trace;
    case 'CONNECT':
      return HttpMethod.connect;
    default:
      throw ArgumentError('Unknown HTTP method: $method');
  }
}
