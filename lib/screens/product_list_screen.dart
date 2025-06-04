import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/product.dart';
import '../services/cart_manager.dart';
import 'product_detail_screen.dart';
import 'cart_screen.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ProductListScreenState createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  List<Product> products = [];
  final CartManager _cartManager = CartManager();

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    final response = await http.get(
      Uri.parse('https://dummyjson.com/products'),
    );
    final data = jsonDecode(response.body);
    setState(() {
      products =
          (data['products'] as List).map((e) => Product.fromJson(e)).toList();
    });
  }

  void _addToCart(Product product) {
    _cartManager.addProduct(product);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${product.title} agregado al carrito'),
        duration: Duration(seconds: 1),
        action: SnackBarAction(
          label: 'Ver Carrito',
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => CartScreen()),
            );
          },
        ),
      ),
    );
    setState(() {}); // Actualizar para mostrar cambios en el badge
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Productos'),
        actions: [
          Stack(
            children: [
              IconButton(
                icon: Icon(Icons.shopping_cart),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => CartScreen()),
                  );
                },
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
                    constraints: BoxConstraints(
                      minWidth: 16,
                      minHeight: 16,
                    ),
                    child: Text(
                      '${_cartManager.itemCount}',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          return Card(
            margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: ListTile(
              title: Text(
                product.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4),
                  Text(
                    '\$${product.price.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.visibility),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ProductDetailScreen(product: product),
                        ),
                      );
                    },
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.add_shopping_cart,
                      color: Colors.blue,
                    ),
                    onPressed: () => _addToCart(product),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}