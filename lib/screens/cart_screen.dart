import 'package:flutter/material.dart';
import '../cart/cart.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final items = Cart.items;
    return Scaffold(
      appBar: AppBar(title: Text('Carrito	de	Compras')),
      body:
          items.isEmpty
              ? Center(child: Text('El	carrito	está	vacío'))
              : ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final product = items[index];
                  return ListTile(
                    title: Text(product.name),
                    subtitle: Text('\$${product.price.toStringAsFixed(2)}'),
                  );
                },
              ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          'Total:	\$${Cart.total.toStringAsFixed(2)}',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
