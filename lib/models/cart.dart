class Cart {
  final int id;
  final int userId;
  final String date;
  final List<CartItem> products;

  Cart({
    required this.id,
    required this.userId,
    required this.date,
    required this.products,
  });

  factory Cart.fromJson(Map<String, dynamic> json) {
    return Cart(
      id: json['id'],
      userId: json['userId'],
      date: json['date'],
      products:
          (json['products'] as List)
              .map((item) => CartItem.fromJson(item))
              .toList(),
    );
  }

  double get total => products.fold(
    0,
    (sum, item) => sum + (item.quantity * item.productPrice),
  );
}

class CartItem {
  final int productId;
  final int quantity;
  double productPrice = 0;
  String productTitle = '';
  String productImage = '';

  CartItem({
    required this.productId,
    required this.quantity,
    this.productPrice = 0,
    this.productTitle = '',
    this.productImage = '',
  });

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(productId: json['productId'], quantity: json['quantity']);
  }
}
