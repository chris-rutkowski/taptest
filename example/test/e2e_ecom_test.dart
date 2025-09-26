import 'dart:convert';
import 'dart:io';

import 'package:example/features/products/data/product_dto.dart';
import 'package:example/features/products/data/rating_dto.dart';
import 'package:example/features/products/presentation/products_keys.dart';
import 'package:example/features/welcome/presentation/welcome_keys.dart';
import 'package:taptest/taptest.dart';

import '_utils/default_tap_tester_config.dart';

void main() {
  final config = defaultTapTesterConfig.copyWith(
    httpRequestHandlers: [
      const ProductsHandler(
        products: [
          ProductDto(
            id: 1,
            title: 'Test Product 1',
            price: 29.99,
            description: 'Description for Test Product 1',
            category: 'electronics',
            image: 'https://fakestoreapi.com/img/81fPKd-2AYL._AC_SL1500_t.png',
            rating: RatingDto(rate: 4.5, count: 120),
          ),
        ],
      ),
    ],
    suite: 'e2e_ecom',
  );

  tapTest('flow', config, (tester) async {
    await tester.info('On Welcome screen');
    await tester.exists(WelcomeKeys.screen);
    // await tester.snapshot('welcome_screen');
    await tester.tap(WelcomeKeys.productsButton, sync: SyncType.settled);

    await tester.info('On Products screen');
    await tester.exists(ProductScreenKeys.screen);
    await tester.exists(ProductScreenKeys.tile(0));
    // await tester.wait(Duration(seconds: 3));
    // await tester.snapshot('http_screen');

    // await tester.absent(LongKeys.cell(72));
    // await tester.scrollTo([LongKeys.cell(72), LongKeys.cellTitle], scrollable: LongKeys.list);
    // await tester.snapshot('long_screen_72');
    await tester.snapshot('http_screen');

    // await tester.pop();

    // await tester.snapshot('long_screen_popped');
  });
}

final class ProductsHandler implements MockHttpRequestHandler {
  final List<ProductDto> products;

  const ProductsHandler({
    required this.products,
  });

  @override
  bool canHandle(Uri uri, HttpMethod method, String path) {
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
