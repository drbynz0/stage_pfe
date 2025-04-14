class ExternalOrder {
  final String id;
  final String supplierId;
  final String supplierName;
  final DateTime date;
  final PaymentMethod paymentMethod;
  final double totalPrice;
  final double paidPrice;
  final double remainingPrice;
  final String? description;
  OrderStatus status;
  final List<OrderItem> items;

    static final List<ExternalOrder> externalOrderList = [
    ExternalOrder(
      id: 'CMD-001',
      supplierId: 'F001',
      supplierName: 'Fournisseur A',
      date: DateTime.now().subtract(Duration(days: 1)),
      paymentMethod: PaymentMethod.cash,
      totalPrice: 200.00,
      paidPrice: 100.00,
      remainingPrice: 100.00,
      description: 'Commande de fournitures de bureau',
      status: OrderStatus.processing,
      items: [],
    ),
    ExternalOrder(
      id: 'CMD-002',
      supplierId: 'F002',
      supplierName: 'Fournisseur B',
      date: DateTime.now().subtract(Duration(days: 2)),
      paymentMethod: PaymentMethod.card,
      totalPrice: 300.00,
      paidPrice: 300.00,
      remainingPrice: 0.00,
      description: 'Commande de matériel informatique',
      status: OrderStatus.completed,
      items: [],
      ),
  ];

  ExternalOrder({
    required this.id,
    required this.supplierId,
    required this.supplierName,
    required this.date,
    required this.paymentMethod,
    required this.totalPrice,
    required this.paidPrice,
    required this.remainingPrice,
    this.description,
    required this.status,
    required this.items,
  });

    static List<ExternalOrder> getExternalOrderList() {
    return externalOrderList;
  }
}

class OrderItem {
  final String productId;
  final String productName;
  final int quantity;
  final double unitPrice;

  OrderItem({
    required this.productId,
    required this.productName,
    required this.quantity,
    required this.unitPrice,
  });
}

enum OrderStatus {
  pending,
  processing,
  completed,
  cancelled,
}

enum PaymentMethod {
  cash,
  card,
  virement,
  cheque,
}