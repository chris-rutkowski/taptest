import 'dart:io';

import 'package:fake_http_client/fake_http_client.dart';

import 'http_method.dart';
import 'http_method_from_string.dart';
import 'mock_http_request_handler.dart';

final class MockableHttpOverrides extends HttpOverrides {
  final Iterable<MockHttpRequestHandler> handlers;

  MockableHttpOverrides({required this.handlers});

  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return _MockableHttpClient(handlers, super.createHttpClient(context));
  }
}

final class _MockableHttpClient implements HttpClient {
  final Iterable<MockHttpRequestHandler> handlers;
  final HttpClient defaultClient;
  final FakeHttpClient fakeClient;

  _MockableHttpClient(this.handlers, this.defaultClient)
    : fakeClient = FakeHttpClient((request, client) {
        final httpMethod = httpMethodFromString(request.method);

        for (final handler in handlers) {
          if (!handler.canHandle(request.uri, httpMethod, request.uri.path)) continue;

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

        throw UnimplementedError('No mock handler found');
      });

  bool _hasMockHandler(HttpMethod method, Uri uri) => handlers.any(
    (handler) => handler.canHandle(uri, method, uri.path),
  );

  @override
  Future<HttpClientRequest> openUrl(String method, Uri url) {
    final httpMethod = httpMethodFromString(method);

    if (_hasMockHandler(httpMethod, url)) {
      return fakeClient.openUrl(method, url);
    }

    return defaultClient.openUrl(method, url);
  }

  // Delegate all other methods to the default client
  @override
  bool get autoUncompress => defaultClient.autoUncompress;

  @override
  set autoUncompress(bool value) => defaultClient.autoUncompress = value;

  @override
  Duration? get connectionTimeout => defaultClient.connectionTimeout;

  @override
  set connectionTimeout(Duration? value) => defaultClient.connectionTimeout = value;

  @override
  Duration get idleTimeout => defaultClient.idleTimeout;

  @override
  set idleTimeout(Duration value) => defaultClient.idleTimeout = value;

  @override
  int? get maxConnectionsPerHost => defaultClient.maxConnectionsPerHost;

  @override
  set maxConnectionsPerHost(int? value) => defaultClient.maxConnectionsPerHost = value;

  @override
  String? get userAgent => defaultClient.userAgent;

  @override
  set userAgent(String? value) => defaultClient.userAgent = value;

  @override
  void addCredentials(Uri url, String realm, HttpClientCredentials credentials) =>
      defaultClient.addCredentials(url, realm, credentials);

  @override
  void addProxyCredentials(String host, int port, String realm, HttpClientCredentials credentials) =>
      defaultClient.addProxyCredentials(host, port, realm, credentials);

  @override
  set authenticate(Future<bool> Function(Uri url, String scheme, String? realm)? f) => defaultClient.authenticate = f;

  @override
  set authenticateProxy(Future<bool> Function(String host, int port, String scheme, String? realm)? f) =>
      defaultClient.authenticateProxy = f;

  @override
  set badCertificateCallback(bool Function(X509Certificate cert, String host, int port)? callback) =>
      defaultClient.badCertificateCallback = callback;

  @override
  void close({bool force = false}) => defaultClient.close(force: force);

  @override
  Future<HttpClientRequest> delete(String host, int port, String path) =>
      openUrl('DELETE', Uri(scheme: 'http', host: host, port: port, path: path));

  @override
  Future<HttpClientRequest> deleteUrl(Uri url) => openUrl('DELETE', url);

  @override
  set findProxy(String Function(Uri url)? f) => defaultClient.findProxy = f;

  @override
  Future<HttpClientRequest> get(String host, int port, String path) =>
      openUrl('GET', Uri(scheme: 'http', host: host, port: port, path: path));

  @override
  Future<HttpClientRequest> getUrl(Uri url) => openUrl('GET', url);

  @override
  Future<HttpClientRequest> head(String host, int port, String path) =>
      openUrl('HEAD', Uri(scheme: 'http', host: host, port: port, path: path));

  @override
  Future<HttpClientRequest> headUrl(Uri url) => openUrl('HEAD', url);

  @override
  Future<HttpClientRequest> open(String method, String host, int port, String path) =>
      openUrl(method, Uri(scheme: 'http', host: host, port: port, path: path));

  @override
  Future<HttpClientRequest> patch(String host, int port, String path) =>
      openUrl('PATCH', Uri(scheme: 'http', host: host, port: port, path: path));

  @override
  Future<HttpClientRequest> patchUrl(Uri url) => openUrl('PATCH', url);

  @override
  Future<HttpClientRequest> post(String host, int port, String path) =>
      openUrl('POST', Uri(scheme: 'http', host: host, port: port, path: path));

  @override
  Future<HttpClientRequest> postUrl(Uri url) => openUrl('POST', url);

  @override
  Future<HttpClientRequest> put(String host, int port, String path) =>
      openUrl('PUT', Uri(scheme: 'http', host: host, port: port, path: path));

  @override
  Future<HttpClientRequest> putUrl(Uri url) => openUrl('PUT', url);

  @override
  set connectionFactory(Future<ConnectionTask<Socket>> Function(Uri url, String? proxyHost, int? proxyPort)? f) =>
      defaultClient.connectionFactory = f;

  @override
  set keyLog(Function(String line)? callback) => defaultClient.keyLog = callback;
}
