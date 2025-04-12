class InternalOrder {
  final String id;
  final String clientId;
  final String clientName;
  final DateTime date;
  final PaymentMethod paymentMethod;
  final double totalPrice;
  final double paidPrice;
  final double remainingPrice;
  OrderStatus status;
  final String? description;
  final List<OrderItem> items;

  static final List<InternalOrder> internalOrderList = [
    InternalOrder(
      id: 'CMD-001',
      clientId: 'C001',
      clientName: 'Ahmed Amine',
      date: DateTime.now().subtract(Duration(days: 1)),
      paymentMethod: PaymentMethod.cash,
      totalPrice: 100.00,
      paidPrice: 50.00,
      remainingPrice: 50.00,
      status: OrderStatus.processing,
      items: [],
    ),
    InternalOrder(
      id: 'CMD-002',
      clientId: 'C002',
      clientName: 'Client B',
      date: DateTime.now().subtract(Duration(days: 2)),
      paymentMethod: PaymentMethod.card,
      totalPrice: 150.00,
      paidPrice: 150.00,
      remainingPrice: 0.00,
      status: OrderStatus.completed,
      items: [],
      ),
  ];

  InternalOrder({
    required this.id,
    required this.clientId,
    required this.clientName,
    required this.date,
    required this.paymentMethod,
    required this.totalPrice,
    required this.paidPrice,
    required this.remainingPrice,
    this.description,
    required this.status,
    required this.items,
  });

  static List<InternalOrder> getInternalOrderList() {
    return internalOrderList;
  }

    static InternalOrder empty() {
    return InternalOrder(
      id: '',
      clientId: '',
      clientName: '',
      date: DateTime.now(),
      paymentMethod: PaymentMethod.cash,
      totalPrice: 0.0,
      paidPrice: 0.0,
      remainingPrice: 0.0,
      status: OrderStatus.pending,
      items: [],
      // Add other required fields with default values
    );
  }
}

class OrderItem {
  final String productId;
  final String productName;
   double quantity;
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