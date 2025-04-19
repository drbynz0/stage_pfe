import 'package:flutter/material.dart';
import '/models/internal_order.dart';
import 'delete_order_dialog.dart';
import 'edit_internal_order_screen.dart';
import 'add_internal_order_screen.dart';
import 'details_internal_order.dart';

class InternalOrdersScreen extends StatefulWidget {
  const InternalOrdersScreen({super.key});

  @override
  InternalOrdersScreenState createState() => InternalOrdersScreenState();
}

class InternalOrdersScreenState extends State<InternalOrdersScreen> {
  List<InternalOrder> _orders = InternalOrder.getInternalOrderList();
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  int _currentPage = 1;
  final int _itemsPerPage = 5;

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

  List<InternalOrder> get paginatedOrders {
    int startIndex = (_currentPage - 1) * _itemsPerPage;
    int endIndex = startIndex + _itemsPerPage;
    endIndex = endIndex > _filteredOrders.length ? _filteredOrders.length : endIndex;
    return _filteredOrders.sublist(startIndex, endIndex);
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
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            BoxShadow(
                              // ignore: deprecated_member_use
                              color: Colors.grey.withOpacity(0.2),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: TextField(
                          controller: _searchController,
                          decoration: InputDecoration(
                            hintText: 'Rechercher des commandes...',
                            hintStyle: const TextStyle(color: Colors.grey),
                            prefixIcon: const Icon(Icons.search, color: Colors.grey),
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          onChanged: (value) {
                            setState(() {
                              _searchQuery = value;
                              _currentPage = 1; // Réinitialiser à la première page
                            });
                          },
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),

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
                  itemCount: paginatedOrders.length,
                  itemBuilder: (context, index) {
                    final order = paginatedOrders[index];
                    return _buildOrderCard(order);
                  },
                ),
              ),
              // Pagination
              Container(
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  border: Border(top: BorderSide(color: Colors.grey.shade300)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${_filteredOrders.length} commandes',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back),
                          onPressed: _currentPage > 1
                              ? () => setState(() => _currentPage--)
                              : null,
                        ),
                        Text(
                          'Page $_currentPage/${(_filteredOrders.length / _itemsPerPage).ceil()}',
                        ),
                        IconButton(
                          icon: const Icon(Icons.arrow_forward),
                          onPressed: _currentPage < (_filteredOrders.length / _itemsPerPage).ceil()
                              ? () => setState(() => _currentPage++)
                              : null,
                        ),
                      ],
                    ),
                  ],
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
      ),
    );
  }

  Widget _buildOrderCard(InternalOrder order) {
    return GestureDetector(
      onTap: () async {
        // Navigation vers l'écran des détails
        final updatedOrder = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailsInternalOrderScreen(order: order),
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
      case OrderStatus.pending:
        return 'En attente';
      case OrderStatus.processing:
        return 'En traitement';
      case OrderStatus.toPay:
        return 'À payer';
      case OrderStatus.completed:
        return 'Terminée';
      case OrderStatus.cancelled:
        return 'Annulée';
    }
  }

  String _getPaymentMethodText(PaymentMethod method) {
    switch (method) {
      case PaymentMethod.cash:
        return 'Espèces';
      case PaymentMethod.card:
        return 'Carte';
      case PaymentMethod.virement:
        return 'Virement';
      case PaymentMethod.cheque:
        return 'Chèque';
    }
  }

  void _showAddInternalOrderDialog() {
    showDialog(
      context: context,
      builder: (context) => AddInternalOrderScreen(
        onOrderAdded: (newOrder) {
          setState(() {
            InternalOrder.addInternalOrder(newOrder);
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Commande ajoutée avec succès'),
              backgroundColor: Colors.green,
            ),
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
            InternalOrder.removeInternalOrder(order);
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Commande supprimée avec succès'),
              backgroundColor: Colors.red,
            ),
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
        onOrderUpdated: (updatedOrder) {
          setState(() {
            final index = _orders.indexWhere((o) => o.id == order.id);
            if (index != -1) {
              _orders[index] = updatedOrder;
            }
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Commande mise à jour avec succès'),
              backgroundColor: Colors.green,
            ),
          );
        },
      ),
    );
  }
}