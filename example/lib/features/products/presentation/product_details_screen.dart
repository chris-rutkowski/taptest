import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/product.dart';
import '../domain/product_repository.dart';

final class ProductDetailsScreen extends ConsumerWidget {
  final ProductId id;

  const ProductDetailsScreen({
    super.key,
    required this.id,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final product = ref.watch(productRepositoryProvider(id));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Product'),
      ),
      body: product.when(
        data: (product) => _ProductScreenContent(product: product),

        loading: () => const Center(child: Text('loading...')),

        error: (_, _) => const Center(
          child: Text('Error'),
        ),
      ),
    );
  }
}

final class _ProductScreenContent extends StatelessWidget {
  final Product product;
  const _ProductScreenContent({required this.product});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Image.network(product.imageUrl),
        Text(product.title),
        Text('\$${product.price.toString()}'),
        Text(product.description),
      ],
    );
  }
}
