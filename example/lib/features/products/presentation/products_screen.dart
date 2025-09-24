import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../domain/products_repository.dart';
import 'products_keys.dart';
import 'widgets/product_list_tile.dart';

final class ProductsScreen extends ConsumerWidget {
  const ProductsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final products = ref.watch(productsRepositoryProvider);

    return Scaffold(
      key: ProductScreenKeys.screen,
      appBar: AppBar(
        title: const Text('Products'),
      ),
      body: products.when(
        data: (products) => ListView.separated(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            bottom: MediaQuery.paddingOf(context).bottom,
          ),
          separatorBuilder: (_, _) => const SizedBox(height: 16),
          itemCount: products.length,
          itemBuilder: (context, index) {
            final product = products[index];

            return ProductListTile(
              key: ProductScreenKeys.tile(index),
              product: product,
              onTap: () => GoRouter.of(context).go('/products/${product.id}'),
            );
          },
        ),

        loading: () => const Center(child: CircularProgressIndicator()),

        error: (_, _) => Center(
          child: Text('Error'),
        ),
      ),
    );
  }
}
