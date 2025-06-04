import '../models/product.dart';

class CartManager {
  static final CartManager _instance = CartManager._internal();
  factory CartManager() => _instance;
  CartManager._internal();

  final List<CartItem> _items = [];

  List<CartItem> get items => List.unmodifiable(_items);

  double get total =>
      _items.fold(0, (sum, item) => sum + (item.product.price * item.quantity));

  int get itemCount => _items.fold(0, (sum, item) => sum + item.quantity);

  void addProduct(Product product, {int quantity = 1}) {
    final existingIndex = _items.indexWhere(
      (item) => item.product.id == product.id,
    );

    if (existingIndex >= 0) {
      _items[existingIndex] = CartItem(
        product: product,
        quantity: _items[existingIndex].quantity + quantity,
      );
    } else {
      _items.add(CartItem(product: product, quantity: quantity));
    }
  }

  void removeProduct(Product product) {
    _items.removeWhere((item) => item.product.id == product.id);
  }

  void updateQuantity(Product product, int newQuantity) {
    if (newQuantity <= 0) {
      removeProduct(product);
      return;
    }

    final existingIndex = _items.indexWhere(
      (item) => item.product.id == product.id,
    );
    if (existingIndex >= 0) {
      _items[existingIndex] = CartItem(product: product, quantity: newQuantity);
    }
  }

  void decreaseQuantity(Product product) {
    final existingIndex = _items.indexWhere(
      (item) => item.product.id == product.id,
    );
    if (existingIndex >= 0) {
      final currentQuantity = _items[existingIndex].quantity;
      if (currentQuantity > 1) {
        updateQuantity(product, currentQuantity - 1);
      } else {
        removeProduct(product);
      }
    }
  }

  void clear() {
    _items.clear();
  }

  bool hasProduct(Product product) {
    return _items.any((item) => item.product.id == product.id);
  }

  int getQuantity(Product product) {
    final item = _items.firstWhere(
      (item) => item.product.id == product.id,
      orElse: () => CartItem(product: product, quantity: 0),
    );
    return item.quantity;
  }
}

class CartItem {
  final Product product;
  final int quantity;

  CartItem({required this.product, required this.quantity});
}
