import 'dart:convert';
import 'dart:io';

import 'package:example/features/products/data/product_dto.dart';
import 'package:example/features/products/presentation/products_keys.dart';
import 'package:example/features/welcome/presentation/welcome_keys.dart';
import 'package:taptest/taptest.dart';

import '_utils/default_integration_tap_tester_config.dart';

void main() {
  final config = defaultIntegrationTapTesterConfig.copyWith();

  tapTest('flow', config, (tt) async {
    await tt.info('On Welcome screen');
    await tt.exists(WelcomeKeys.screen);
    await tt.tap(WelcomeKeys.productsButton);

    await tt.info('On Products screen');
    await tt.exists(ProductScreenKeys.screen);
    await tt.exists(ProductScreenKeys.tile(0));

    await tt.snapshot('http_screen');

    // await tt.pop();

    // await tt.snapshot('long_screen_popped');
  });
}

final class ProductsHandler implements MockHttpRequestHandler {
  final List<ProductDto> products;

  const ProductsHandler({
    required this.products,
  });

  @override
  bool canHandle(Uri uri, HttpMethod method) {
    return method == HttpMethod.get && uri.path == '/products';
  }

  @override
  MockHttpResponse? handle(Uri uri, HttpHeaders headers, String? body) {
    return MockHttpResponse(
      headers: {
        // not truly needed
        HttpHeaders.contentTypeHeader: 'application/json',
      },
      body: jsonEncode(products),
    );
  }
}
