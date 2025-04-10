class Discount {
  final String id;
  final String title;
  final String validity;
  final String productName;
  final double normalPrice;
  final double promotionPrice;

  Discount({
    required this.id,
    required this.title,
    required this.validity,
    required this.productName,
    required this.normalPrice,
    required this.promotionPrice,
  });
}