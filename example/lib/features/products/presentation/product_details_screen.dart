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
        title: const Text('Products'),
      ),
      body: product.when(
        data: (products) => Text('data ${products.title}'),

        loading: () => const Center(child: CircularProgressIndicator()),

        error: (_, _) => Center(
          child: Text('Error'),
        ),
      ),
    );
  }
}
