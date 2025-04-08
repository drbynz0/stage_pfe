class InternalOrder {
  final String id;
  final String clientName;
  final DateTime date;
  final PaymentMethod paymentMethod;
  final OrderStatus status;
  final List<OrderItem> items;

  static final List<InternalOrder> internalOrderList = [
    InternalOrder(
      id: 'CMD-001',
      clientName: 'Client A',
      date: DateTime.now().subtract(Duration(days: 1)),
      paymentMethod: PaymentMethod.cash,
      status: OrderStatus.processing,
      items: [],
    ),
    InternalOrder(
      id: 'CMD-002',
      clientName: 'Client B',
      date: DateTime.now().subtract(Duration(days: 2)),
      paymentMethod: PaymentMethod.card,
      status: OrderStatus.completed,
      items: [],
      ),
  ];

  InternalOrder({
    required this.id,
    required this.clientName,
    required this.date,
    required this.paymentMethod,
    required this.status,
    required this.items,
  });

  static List<InternalOrder> getInternalOrderList() {
    return internalOrderList;
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