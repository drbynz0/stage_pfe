import 'package:flutter/material.dart';
import '/models/internal_order.dart';
import 'delete_order_dialog.dart';
import 'edit_internal_order_screen.dart';
import 'add_internal_order_screen.dart';

class InternalOrdersScreen extends StatefulWidget {
  const InternalOrdersScreen({super.key});

  @override
  InternalOrdersScreenState createState() => InternalOrdersScreenState();
}

class InternalOrdersScreenState extends State<InternalOrdersScreen> {
  List<InternalOrder> _orders = InternalOrder.getInternalOrderList();
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
  }

  List<InternalOrder> get _filteredOrders {
    return _orders.where((order) {
      return order.clientName.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          order.id.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    // Champ de recherche
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: 'Rechercher des commandes...',
                          prefixIcon: Icon(Icons.search),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        onChanged: (value) {
                          setState(() {
                            _searchQuery = value;
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: 8), // Espacement entre les widgets

                    // Bouton de filtrage par date
                    IconButton(
                      icon: const Icon(Icons.calendar_today, color: Colors.blue),
                      onPressed: () async {
                        final DateTime? selectedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime.now(),
                        );
                        if (selectedDate != null) {
                          setState(() {
                            _orders = _orders.where((order) {
                              return order.date.year == selectedDate.year &&
                                  order.date.month == selectedDate.month &&
                                  order.date.day == selectedDate.day;
                            }).toList();
                          });
                        }
                      },
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: _filteredOrders.length,
                  itemBuilder: (context, index) {
                    final order = _filteredOrders[index];
                    return _buildOrderCard(order);
                  },
                ),
              ),
            ],
          ),
          Positioned(
            right: 15,
            bottom: 60,
            child: FloatingActionButton(
              onPressed: () => _showAddInternalOrderDialog(),
              backgroundColor: Colors.blue,
              elevation: 4,
              child: const Icon(Icons.add, color: Colors.white),
            ),
          ),
        ],
      )
    );
  }

  Widget _buildOrderCard(InternalOrder order) {
    return Card(
      color: const Color.fromARGB(255, 194, 224, 240),
      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: ListTile(
        title: Text(order.clientName, style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(order.id),
                const Spacer(),
                Text('${order.date.day}/${order.date.month}/${order.date.year}'),
              ],
            ),
            Row(
              children: [
                Text('Articles: ${order.items.length}'),
                const Spacer(),
                Text('${order.totalPrice.toStringAsFixed(2)} DH'),
              ],
            ),
            Row(
              children: [
                Text(_getPaymentMethodText(order.paymentMethod)),
                const Spacer(),
                Text(_getStatusText(order.status),
                  style: TextStyle(
                    color: order.status == OrderStatus.completed ? Colors.green : Colors.red,
                  ),
                ),
              ],
            )
          ]
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(Icons.edit, color: Colors.blue),
              onPressed: () => _showEditDialog(order),
            ),
            IconButton(
              icon: Icon(Icons.delete, color: Colors.red),
              onPressed: () => _showDeleteDialog(order),
            ),
          ],
        ),
      ),
    );
  }

  String _getStatusText(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending: return 'En attente';
      case OrderStatus.processing: return 'En traitement';
      case OrderStatus.completed: return 'Terminée';
      case OrderStatus.cancelled: return 'Annulée';
    }
  }

  String _getPaymentMethodText(PaymentMethod method) {
    switch (method) {
      case PaymentMethod.cash: return 'Espèces';
      case PaymentMethod.card: return 'Carte';
      case PaymentMethod.virement: return 'Virement';
      case PaymentMethod.cheque: return 'Chèque';
    }
  }

    void _showAddInternalOrderDialog() {
    showDialog(
      context: context,
      builder: (context) => AddInternalOrderScreen(
        onOrderAdded: (newProduct) {
          setState(() {
            _orders.insert(0, newProduct);
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Commande ajouté avec succès'), backgroundColor: Colors.green,),
          );
        },
      ),
    );
  }

    void _showDeleteDialog(InternalOrder order) {
    showDialog(
      context: context,
      builder: (context) => DeleteOrderDialog(
        orderId: order.id,
        onConfirm: () {
          setState(() {
            _orders.removeWhere((o) => o.id == order.id);
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Produit supprimé avec succès'), backgroundColor: Colors.red,),
          );
        },
      ),
    );
  }

    void _showEditDialog(InternalOrder order) {
    showDialog(
      context: context,
      builder: (context) => EditInternalOrderScreen(
        order: order,
        onOrderUpdated: (updatedProduct) {
          setState(() {
            final index = _orders.indexWhere((o) => o.id == order.id);
            if (index != -1) {
              _orders[index] = updatedProduct;
            }
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Produit mis à jour avec succès'), backgroundColor: Colors.green,),
          );
        },
      ),
    );
  }
}