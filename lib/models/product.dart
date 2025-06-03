class Product {
  final int id;
  final String title;
  final String description;
  final double price;
  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
  });
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      price: (json['price'] as num).toDouble(),
    );
  }
}
