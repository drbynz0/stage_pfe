class ExternalOrder {
  final String id;
  final String supplierName;
  final DateTime date;
  final PaymentMethod paymentMethod;
  final OrderStatus status;
  final List<OrderItem> items;

    static final List<ExternalOrder> externalOrderList = [
    ExternalOrder(
      id: 'CMD-001',
      supplierName: 'Fournisseur A',
      date: DateTime.now().subtract(Duration(days: 1)),
      paymentMethod: PaymentMethod.cash,
      status: OrderStatus.processing,
      items: [],
    ),
    ExternalOrder(
      id: 'CMD-002',
      supplierName: 'Fournisseur B',
      date: DateTime.now().subtract(Duration(days: 2)),
      paymentMethod: PaymentMethod.card,
      status: OrderStatus.completed,
      items: [],
      ),
  ];

  ExternalOrder({
    required this.id,
    required this.supplierName,
    required this.date,
    required this.paymentMethod,
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
  final double quantity;
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