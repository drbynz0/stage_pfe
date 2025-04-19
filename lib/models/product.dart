class Product {
  final String name;
  int variants;
  final String code;
  final String category;
  int stock;
  final double price;
  final String date;
  final List<String>? imagePaths;
  final String? description;

  static final List<Product> productList = [
    Product(
      name: "Handmade Pouch",
      variants: 3,
      code: "6223007650274",
      category: "Bgg & Pouch",
      stock: 10,
      price: 121.00,
      date: "29 Dec 2022",
      imagePaths: ["assets/image/icon_shop.jpg"],
    ),
    Product(
      name: "Smartwatch E2",
      variants: 2,
      code: "30201",
      category: "Watch",
      stock: 20,
      price: 590.00,
      date: "24 Dec 2022",
      imagePaths: ["assets/image/icon_shop.jpg"],
    ),
    Product(
      name: "Wireless Earbuds",
      variants: 5,
      code: "402034",
      category: "Electronics",
      stock: 15,
      price: 99.99,
      date: "10 Jan 2023",
      imagePaths: ["assets/image/icon_shop.jpg"],
    ),
    Product(
      name: "Yoga Mat",
      variants: 2,
      code: "509876",
      category: "Fitness",
      stock: 35,
      price: 25.50,
      date: "5 Feb 2023",
      imagePaths: ["assets/image/icon_shop.jpg"],
    ),
    Product(
      name: "Gaming Mouse",
      variants: 3,
      code: "601233",
      category: "Accessories",
      stock: 50,
      price: 49.99,
      date: "15 Jan 2023",
      imagePaths: ["assets/image/icon_shop.jpg"],
    ),
    Product(
      name: "Bluetooth Speaker",
      variants: 4,
      code: "702145",
      category: "Electronics",
      stock: 30,
      price: 75.00,
      date: "22 Dec 2022",
      imagePaths: ["assets/image/icon_shop.jpg"],
    ),
    Product(
      name: "Coffee Maker",
      variants: 2,
      code: "806321",
      category: "Home",
      stock: 25,
      price: 150.00,
      date: "1 Feb 2023",
      imagePaths: ["assets/image/icon_shop.jpg"],
    ),
    Product(
      name: "Travel Backpack",
      variants: 3,
      code: "909876",
      category: "Bags",
      stock: 40,
      price: 120.00,
      date: "18 Jan 2023",
      imagePaths: ["assets/image/icon_shop.jpg"],
    ),
    Product(
      name: "Laptop Stand",
      variants: 1,
      code: "103045",
      category: "Accessories",
      stock: 55,
      price: 45.00,
      date: "3 Jan 2023",
      imagePaths: ["assets/image/icon_shop.jpg"],
    ),
    Product(
      name: "Smartphone Case",
      variants: 6,
      code: "204567",
      category: "Accessories",
      stock: 100,
      price: 15.99,
      date: "28 Feb 2023",
      imagePaths: ["assets/image/icon_shop.jpg"],
    ),
  ];


  Product({
    required this.name,
    required this.variants,
    required this.code,
    required this.category,
    required this.stock,
    required this.price,
    required this.date,
    this.imagePaths,
    this.description,
  });

  static List<Product> getProducts() {
    return productList;
  }

  static void addProduct(Product newProduct) {
    productList.insert(0, newProduct);
  }

  static void removeProduct(Product product) {
    productList.remove(product);
  }
  
  static Product getProductById(String id) {
    return productList.firstWhere((element) => element.code == id, orElse: () => Product
    (name: "",
    variants: 0,
    code: "",
    category: "",
    stock: 0,
    price: 0.00,
    date: "",
    imagePaths: [],
    description: "",
    ));
    }

    static Product empty() {
    return Product(
      code: '',
      name: '',
      variants: 0,
      category: '',
      stock: 0,
      price: 0.0,
      date: '',
      imagePaths: [],
    );
  }
}