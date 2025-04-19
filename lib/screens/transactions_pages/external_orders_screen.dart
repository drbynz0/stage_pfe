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
  int _currentPage = 1;
  final int _itemsPerPage = 10;

  List<ExternalOrder> get _filteredOrders {
    return _orders.where((order) {
      return order.supplierName.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          order.id.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();
  }

  List<ExternalOrder> get _paginatedOrders {
    final startIndex = (_currentPage - 1) * _itemsPerPage;
    final endIndex = startIndex + _itemsPerPage;
    return _filteredOrders.sublist(
      startIndex,
      endIndex > _filteredOrders.length ? _filteredOrders.length : endIndex,
    );
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
                              _currentPage = 1;
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
                            _currentPage = 1;
                          });
                        }
                      },
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: _paginatedOrders.length,
                  itemBuilder: (context, index) {
                    final order = _paginatedOrders[index];
                    return _buildOrderCard(order);
                  },
                ),
              ),
              // Nouvelle pagination
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
        final updatedOrder = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailsExternalOrderScreen(order: order),
          ),
        );

        if (updatedOrder != null) {
          setState(() {
            final index = _orders.indexWhere((o) => o.id == updatedOrder.id);
            if (index != -1) {
              _orders[index] = updatedOrder;
            }
          });
        }
      },
      child: Card(
        color: const Color.fromARGB(255, 194, 224, 240),
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: ListTile(
          title: Text(order.supplierName, style: const TextStyle(fontWeight: FontWeight.bold)),
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
                icon: const Icon(Icons.edit, color: Colors.blue),
                onPressed: () => _showEditDialog(order),
              ),
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
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
            ExternalOrder.addExternalOrder(newProduct);
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Commande ajouté avec succès'),
              backgroundColor: Colors.green,
            ),
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
            ExternalOrder.removeExternalOrder(order);
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Produit supprimé avec succès'), 
              backgroundColor: Colors.red,
            ),
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
            const SnackBar(
              content: Text('Produit mis à jour avec succès'), 
              backgroundColor: Colors.green,
            ),
          );
        },
      ),
    );
  }
}