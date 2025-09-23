import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/products_repository.dart';

final class ProductsScreen extends ConsumerWidget {
  const ProductsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final products = ref.watch(productsRepositoryProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Products'),
      ),
      body: products.when(
        data: (promotions) => ListView(
          children: promotions
              .map(
                (e) => ListTile(
                  title: Text(e.title),
                  onTap: () {
                    // GoRouter.of(context).go('/member/promotions/${e.id}');
                  },
                ),
              )
              .toList(),
        ),

        loading: () => const Center(child: CircularProgressIndicator()),

        error: (_, _) => Center(
          child: Text('Error'),
        ),
      ),
    );
  }
}
