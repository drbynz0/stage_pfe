class Discount {
  final String id;
  final String title;
  final String validity;
  final String productId;
  final String productName;
  final String productCategory;
  String? images;
  final double normalPrice;
  final double promotionPrice;
  String description;

  Discount({
    required this.id,
    required this.title,
    required this.validity,
    required this.productId,
    required this.productCategory,
    this.images,
    required this.productName,
    required this.normalPrice,
    required this.promotionPrice,
    required this.description,
  });

  factory Discount.fromMap(Map<String, dynamic> map) {
    return Discount(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      validity: map['validity'] ?? '',
      productName: map['productName'] ?? '',
      productId: map['productId'] ?? '',
      productCategory: map['productCategory'] ?? '',
      images: map['images'] ?? '',
      normalPrice: map['normalPrice']?.toDouble() ?? 0.0,
      promotionPrice: map['promotionPrice']?.toDouble() ?? 0.0,
      description: map['description'] ?? '',
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'validity': validity,
      'productName': productName,
      'normalPrice': normalPrice,
      'promotionPrice': promotionPrice,
    };
  }
  Discount copyWith({
    String? id,
    String? title,
    String? validity,
    String? productName,
    double? normalPrice,
    double? promotionPrice,
  }) {
    return Discount(
      id: id ?? this.id,
      title: title ?? this.title,
      validity: validity ?? this.validity,
      productId: productId,
      productName: productName ?? this.productName,
      productCategory: productCategory,
      images: images,
      normalPrice: normalPrice ?? this.normalPrice,
      promotionPrice: promotionPrice ?? this.promotionPrice,
      description: description,
    );
  }
  static Discount empty() {
    return Discount(
      id: '0',
      title: '',
      validity: '',
      productId: '',
      productCategory: '',
      images: '',
      productName: '',
      normalPrice: 0.0,
      promotionPrice: 0.0,
      description: '',
    );
  }
  static List<Discount> getDiscountList() {
    return [
      Discount(
        id: '1',
        title: 'Remise de 10%',
        validity: '30 avril 2025',
        productId: '6223007650274',
        productCategory: 'Catégorie A',
        productName: 'Produit A',
        normalPrice: 200.0,
        promotionPrice: 180.0,
        description: 'Description du produit A',
      ),
      Discount(
        id: '2',
        title: 'Remise de 20%',
        validity: '15 mai 2025',
        productId: '2',
        productCategory: 'Catégorie B',
        images: 'assets/image/icon_shop.jpg',
        productName: 'Produit B',
        normalPrice: 300.0,
        promotionPrice: 240.0,
        description: 'Description du produit B',
      ),
    ];
  }
  static List<Discount> getDiscountListByProduct(String productId) {
    return getDiscountList().where((discount) => discount.productName == productId).toList();
  }
  static List<Discount> getDiscountListByValidity(String validity) {
    return getDiscountList().where((discount) => discount.validity == validity).toList();
  }
  static List<Discount> getDiscountListByTitle(String title) {
    return getDiscountList().where((discount) => discount.title == title).toList();
  }
  static List<Discount> getDiscountListByNormalPrice(double normalPrice) {
    return getDiscountList().where((discount) => discount.normalPrice == normalPrice).toList();
  }
  static List<Discount> getDiscountListByPromotionPrice(double promotionPrice) {
    return getDiscountList().where((discount) => discount.promotionPrice == promotionPrice).toList();
  }
  static List<Discount> getDiscountListById(String id) {
    return getDiscountList().where((discount) => discount.id == id).toList();
  }
}