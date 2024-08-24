import 'package:ecommerce_app/models/product.dart';
import 'package:flutter/material.dart';

class ProductCard extends StatelessWidget {
  final Product product;

  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      child: Column(
        children: [
          Image.network(
            product.image ?? "",
            height: 100,
            fit: BoxFit.cover,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              product.title ?? "",
              style: const TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
          ),
          Text(
            '\$${product.price.toString()}',
            style: const TextStyle(fontSize: 14, color: Colors.green),
          ),
          ElevatedButton(
            onPressed: () {
              // Add to cart functionality here
            },
            child: const Text('Add to Cart'),
          ),
        ],
      ),
    );
  }
}
