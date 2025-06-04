import 'package:flutter/material.dart';
import '../models/product.dart';
import '../services/cart_manager.dart';

class ProductDetailScreen extends StatefulWidget {
  final Product product;
  const ProductDetailScreen({super.key, required this.product});

  @override
  // ignore: library_private_types_in_public_api
  _ProductDetailScreenState createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  final CartManager _cartManager = CartManager();
  int _quantity = 1;

  void _addToCart() {
    _cartManager.addProduct(widget.product, quantity: _quantity);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '${widget.product.title} agregado al carrito ($_quantity)',
        ),
        duration: Duration(seconds: 2),
        action: SnackBarAction(
          label: 'Deshacer',
          onPressed: () {
            // Remover la cantidad agregada
            final currentQuantity = _cartManager.getQuantity(widget.product);
            _cartManager.updateQuantity(
              widget.product,
              currentQuantity - _quantity,
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.product.title),
        actions: [
          Stack(
            children: [
              IconButton(
                icon: Icon(Icons.shopping_cart),
                onPressed: () => Navigator.pushNamed(context, '/cart'),
              ),
              if (_cartManager.itemCount > 0)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    constraints: BoxConstraints(minWidth: 16, minHeight: 16),
                    child: Text(
                      '${_cartManager.itemCount}',
                      style: TextStyle(color: Colors.white, fontSize: 12),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.product.description, style: TextStyle(fontSize: 18)),
            SizedBox(height: 20),
            Text(
              'Precio: \$${widget.product.price.toStringAsFixed(2)}',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            SizedBox(height: 30),
            // Selector de cantidad
            Row(
              children: [
                Text('Cantidad: ', style: TextStyle(fontSize: 18)),
                IconButton(
                  icon: Icon(Icons.remove_circle_outline),
                  onPressed:
                      _quantity > 1 ? () => setState(() => _quantity--) : null,
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text('$_quantity', style: TextStyle(fontSize: 18)),
                ),
                IconButton(
                  icon: Icon(Icons.add_circle_outline),
                  onPressed: () => setState(() => _quantity++),
                ),
              ],
            ),
            SizedBox(height: 20),
            // Precio total
            Text(
              'Total: \$${(widget.product.price * _quantity).toStringAsFixed(2)}',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            Spacer(),
            // Botón agregar al carrito
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _addToCart,
                icon: Icon(Icons.add_shopping_cart),
                label: Text('Agregar al Carrito'),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  textStyle: TextStyle(fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
