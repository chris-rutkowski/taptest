
import 'package:flutter/material.dart';

import '../../domain/product.dart';

final class ProductListTile extends StatelessWidget {
  final Product product;

  const ProductListTile({
    super.key,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Image.network(
              product.imageUrl,
              width: 48,
              height: 48,
              fit: BoxFit.cover,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                product.title,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
