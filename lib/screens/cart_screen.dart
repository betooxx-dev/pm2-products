import 'package:flutter/material.dart';
import '../services/cart_manager.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final CartManager _cartManager = CartManager();

  void _updateQuantity(CartItem item, int newQuantity) {
    setState(() {
      _cartManager.updateQuantity(item.product, newQuantity);
    });
  }

  void _removeItem(CartItem item) {
    setState(() {
      _cartManager.removeProduct(item.product);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${item.product.title} eliminado del carrito'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _clearCart() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Limpiar Carrito'),
          content: Text(
            '¿Estás seguro de que quieres eliminar todos los productos?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _cartManager.clear();
                });
                Navigator.of(context).pop();
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text('Carrito limpiado')));
              },
              child: Text('Limpiar', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final items = _cartManager.items;

    return Scaffold(
      appBar: AppBar(
        title: Text('Carrito de Compras'),
        actions: [
          if (items.isNotEmpty)
            IconButton(
              icon: Icon(Icons.delete_sweep),
              onPressed: _clearCart,
              tooltip: 'Limpiar carrito',
            ),
        ],
      ),
      body:
          items.isEmpty
              ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.shopping_cart_outlined,
                      size: 80,
                      color: Colors.grey,
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Tu carrito está vacío',
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                    SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text('Continuar Comprando'),
                    ),
                  ],
                ),
              )
              : Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        final item = items[index];
                        return Card(
                          margin: EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(8),
                            child: Row(
                              children: [
                                // Información del producto
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item.product.title,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        '\$${item.product.price.toStringAsFixed(2)}',
                                        style: TextStyle(
                                          color: Colors.green,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                // Controles de cantidad
                                Column(
                                  children: [
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        IconButton(
                                          icon: Icon(
                                            Icons.remove_circle_outline,
                                          ),
                                          onPressed: () {
                                            if (item.quantity > 1) {
                                              _updateQuantity(
                                                item,
                                                item.quantity - 1,
                                              );
                                            } else {
                                              _removeItem(item);
                                            }
                                          },
                                        ),
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 12,
                                            vertical: 4,
                                          ),
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              color: Colors.grey,
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              4,
                                            ),
                                          ),
                                          child: Text(
                                            '${item.quantity}',
                                            style: TextStyle(fontSize: 16),
                                          ),
                                        ),
                                        IconButton(
                                          icon: Icon(Icons.add_circle_outline),
                                          onPressed: () {
                                            _updateQuantity(
                                              item,
                                              item.quantity + 1,
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                    // Subtotal y botón eliminar
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          '\$${(item.product.price * item.quantity).toStringAsFixed(2)}',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),
                                        SizedBox(width: 8),
                                        IconButton(
                                          icon: Icon(
                                            Icons.delete,
                                            color: Colors.red,
                                          ),
                                          onPressed: () => _removeItem(item),
                                          tooltip: 'Eliminar producto',
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  // Total y botón de compra
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          spreadRadius: 1,
                          blurRadius: 5,
                          offset: Offset(0, -3),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Total (${_cartManager.itemCount} items):',
                              style: TextStyle(fontSize: 18),
                            ),
                            Text(
                              '\$${_cartManager.total.toStringAsFixed(2)}',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              // Aquí puedes agregar la lógica de compra
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Función de compra próximamente...',
                                  ),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(vertical: 16),
                              backgroundColor: Colors.green,
                              foregroundColor: Colors.white,
                            ),
                            child: Text(
                              'Proceder al Pago',
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
    );
  }
}
