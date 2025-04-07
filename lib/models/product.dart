class Product {
  final String name;
  final int variants;
  final String code;
  final String category;
  final double stock;
  final double price;
  final String date;
  final String? imagePath;

    static final List<Product> productList = [
    Product(
      name: "Handmade Pouch",
      variants: 3,
      code: "302012",
      category: "Bgg & Pouch",
      stock: 10,
      price: 121.00,
      date: "29 Dec 2022",
    ),
    Product(
      name: "Smartwatch E2",
      variants: 2,
      code: "30201",
      category: "Watch",
      stock: 20.4,
      price: 590.00,
      date: "24 Dec 2022",
      imagePath: "assets/image/welcome.png",
    ),
    // ... (autres produits restent identiques)
  ];

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

  static List<Product> getProducts() {
    return productList;
  }
}