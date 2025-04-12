import 'package:flutter/material.dart';
import '/models/external_order.dart';
import 'add_external_order_screen.dart';
import 'delete_order_dialog.dart';
import 'edit_external_order_screen.dart';
import 'details_external_order_screen.dart';

class ExternalOrdersScreen extends StatefulWidget {
  const ExternalOrdersScreen({super.key});

  @override
  ExternalOrdersScreenState createState() => ExternalOrdersScreenState();
}

class ExternalOrdersScreenState extends State<ExternalOrdersScreen> {
  List<ExternalOrder> _orders = ExternalOrder.getExternalOrderList();
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
  }

  List<ExternalOrder> get _filteredOrders {
    return _orders.where((order) {
      return order.supplierName.toLowerCase().contains(_searchQuery.toLowerCase()) ||
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
              onPressed: () => _showAddExternalOrderDialog(),
              backgroundColor: Colors.blue,
              elevation: 4,
              child: const Icon(Icons.add, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderCard(ExternalOrder order) {
    return GestureDetector(
      onTap: () async {
        // Navigation vers l'écran des détails
        final updatedOrder = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailsExternalOrderScreen(order: order),
          ),
        );

        // Mettre à jour la liste si une commande mise à jour est renvoyée
        if (updatedOrder != null) {
          setState(() {
            final index = _orders.indexWhere((o) => o.id == updatedOrder.id);
            if (index != -1) {
              _orders[index] = updatedOrder; // Mettre à jour l'état local
            }
          });
        }
      },
      child: Card(
        color: const Color.fromARGB(255, 194, 224, 240),
        margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: ListTile(
          title: Text(order.supplierName, style: TextStyle(fontWeight: FontWeight.bold)),
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
                  Text(
                    _getStatusText(order.status),
                    style: TextStyle(
                      color: order.status == OrderStatus.completed ? Colors.green : Colors.red,
                    ),
                  ),
                ],
              )
            ],
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

    void _showAddExternalOrderDialog() {
    showDialog(
      context: context,
      builder: (context) => AddExternalOrderScreen(
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
    void _showDeleteDialog(ExternalOrder order) {
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

      void _showEditDialog(ExternalOrder order) {
    showDialog(
      context: context,
      builder: (context) => EditExternalOrderScreen(
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