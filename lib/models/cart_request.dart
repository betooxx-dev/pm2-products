class CartRequest {
  final int userId;
  final String date;
  final List<CartItemRequest> products;

  CartRequest({
    required this.userId,
    required this.date,
    required this.products,
  });

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'date': date,
      'products': products.map((item) => item.toJson()).toList(),
    };
  }
}

class CartItemRequest {
  final int productId;
  final int quantity;

  CartItemRequest({required this.productId, required this.quantity});

  Map<String, dynamic> toJson() {
    return {'productId': productId, 'quantity': quantity};
  }
}
