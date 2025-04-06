class Product {
  final String name;
  final int variants;
  final String code;
  final String category;
  final double stock;
  final double price;
  final String date;
  final String? imagePath;

  Product({
    required this.name,
    required this.variants,
    required this.code,
    required this.category,
    required this.stock,
    required this.price,
    required this.date,
    this.imagePath,
  });
}