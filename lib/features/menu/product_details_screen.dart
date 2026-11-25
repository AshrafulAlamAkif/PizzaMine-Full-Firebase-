
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'menu_model.dart';
import 'menu_provider.dart';

class ProductDetailsScreen extends ConsumerWidget {
  final String productId;

  const ProductDetailsScreen({
    super.key,
    required this.productId,
  });

  static const Color primaryColor = Color(0xFFE53935);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productState = ref.watch(
      menuProductProvider(productId),
    );

    return Scaffold(
      backgroundColor: const Color(0xFFFFFAF5),
      appBar: AppBar(
        title: const Text('Product Details'),
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
      ),
      body: productState.when(
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        error: (error, stackTrace) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Unable to load product.'),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () {
                  ref.invalidate(
                    menuProductProvider(productId),
                  );
                },
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
        data: (product) {
          if (product == null) {
            return const Center(
              child: Text('Product not found.'),
            );
          }

          return _buildProductDetails(product);
        },
      ),
    );
  }

  Widget _buildProductDetails(MenuProduct product) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Container(
              height: 260,
              width: double.infinity,
              color: const Color(0xFFFFEBEE),
              child: product.imageUrl.isNotEmpty
                  ? Image.network(
                      product.imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) =>
                          const Icon(
                        Icons.local_pizza,
                        size: 100,
                        color: primaryColor,
                      ),
                    )
                  : const Icon(
                      Icons.local_pizza,
                      size: 100,
                      color: primaryColor,
                    ),
            ),
          ),
          const SizedBox(height: 22),

          Text(
            product.category,
            style: const TextStyle(
              color: primaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),

          Text(
            product.name,
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),

          Text(
            product.description,
            style: const TextStyle(
              fontSize: 15,
              color: Colors.grey,
              height: 1.6,
            ),
          ),
          const SizedBox(height: 22),

          Text(
            '৳${product.price.toStringAsFixed(0)}',
            style: const TextStyle(
              color: primaryColor,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),

          Row(
            children: [
              Icon(
                product.isAvailable
                    ? Icons.check_circle
                    : Icons.cancel,
                color: product.isAvailable
                    ? Colors.green
                    : Colors.red,
              ),
              const SizedBox(width: 8),
              Text(
                product.isAvailable
                    ? 'Available'
                    : 'Currently unavailable',
              ),
            ],
          ),
        ],
      ),
    );
  }
}