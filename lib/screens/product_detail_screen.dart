import 'package:flutter/material.dart';
import '../models/product.dart';
import '../cart/cart.dart';

class ProductDetailScreen extends StatelessWidget {
  final Product product;
  const ProductDetailScreen({super.key, required this.product});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(product.name)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(product.description, style: TextStyle(fontSize: 18)),
            SizedBox(height: 16),
            Text(
              'Precio:	\$${product.price.toStringAsFixed(2)}',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Cart.add(product);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('${product.name} agregado al carrito'),
                  ),
                );
              },
              child: Text('Agregar	al	carrito'),
            ),
          ],
        ),
      ),
    );
  }
}
