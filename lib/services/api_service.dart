import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product.dart';
import '../models/cart.dart';
import '../models/cart_request.dart';

class ApiService {
  static const String baseUrl = 'https://fakestoreapi.com';

  Future<List<Product>> getProducts() async {
    final response = await http.get(Uri.parse('$baseUrl/products'));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((json) => Product.fromJson(json)).toList();
    } else {
      throw Exception('Error al cargar productos: ${response.statusCode}');
    }
  }

  Future<Product> getProduct(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/products/$id'));

    if (response.statusCode == 200) {
      return Product.fromJson(json.decode(response.body));
    } else {
      throw Exception(
        'Error al cargar el producto $id: ${response.statusCode}',
      );
    }
  }

  Future<Map<String, dynamic>> createCart(CartRequest cartRequest) async {
    final response = await http.post(
      Uri.parse('$baseUrl/carts'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(cartRequest.toJson()),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Error al crear carrito: ${response.statusCode}');
    }
  }

  Future<Cart> getCart(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/carts/$id'));

    if (response.statusCode == 200) {
      Cart cart = Cart.fromJson(json.decode(response.body));

      for (var item in cart.products) {
        try {
          Product product = await getProduct(item.productId);
          item.productTitle = product.title;
          item.productPrice = product.price;
          item.productImage = product.image;
        } catch (e) {
          print('Error al obtener detalles del producto ${item.productId}: $e');
        }
      }

      return cart;
    } else {
      throw Exception('Error al cargar el carrito $id: ${response.statusCode}');
    }
  }
}
