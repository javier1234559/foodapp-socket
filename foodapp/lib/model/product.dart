class Product {
  final int id;
  final String name;
  final String imageUrl;
  final int price;

  Product({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.price,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as int,
      name: json['name'] as String,
      price: json['price'] as int,
      imageUrl: json['image'] as String,
    );
  }

}
