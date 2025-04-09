import 'package:flutter/material.dart';
import '../../models/internal_order.dart';
import '../../models/product.dart';

class AddInternalOrderScreen extends StatefulWidget {
  final Function(InternalOrder) onOrderAdded;

  const AddInternalOrderScreen({super.key, required this.onOrderAdded});

  @override
  AddInternalOrderScreenState createState() => AddInternalOrderScreenState();
}

class AddInternalOrderScreenState extends State<AddInternalOrderScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _clientNameController = TextEditingController();
  OrderStatus _status = OrderStatus.pending;
  PaymentMethod _paymentMethod = PaymentMethod.cash;
  DateTime _selectedDate = DateTime.now();
  final List<OrderItem> _items = [];

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2025),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _addItem() {
    final TextEditingController searchController = TextEditingController();
    String selectedCategory = 'Tout';
    List<Product> filteredProducts = Product.getProducts();
    List<Map<String, dynamic>> selectedProducts = []; // Contient le produit et sa quantité
    double totalPrice = 0.0;

    void updateFilteredProducts() {
      setState(() {
        filteredProducts = Product.getProducts().where((product) {
          final matchesSearch = product.name.toLowerCase().contains(searchController.text.toLowerCase());
          final matchesCategory = selectedCategory == 'Tout' || product.category == selectedCategory;
          return matchesSearch && matchesCategory;
        }).toList();
      });
    }

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              insetPadding: const EdgeInsets.all(20),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'Ajouter des Articles',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),

                    // Barre de recherche
                    TextField(
                      controller: searchController,
                      decoration: const InputDecoration(
                        labelText: 'Rechercher un produit',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.search),
                      ),
                      onChanged: (value) {
                        updateFilteredProducts();
                      },
                    ),
                    const SizedBox(height: 16),

                    // Sélecteur de catégorie
                    DropdownButtonFormField<String>(
                      value: selectedCategory,
                      items: ['Tout', ...Product.getProducts().map((p) => p.category).toSet()]
                          .map((category) => DropdownMenuItem(
                                value: category,
                                child: Text(category),
                              ))
                          .toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            selectedCategory = value;
                            updateFilteredProducts();
                          });
                        }
                      },
                      decoration: const InputDecoration(
                        labelText: 'Filtrer par catégorie',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Liste des produits
                    Expanded(
                      child: ListView.builder(
                        itemCount: filteredProducts.length,
                        itemBuilder: (context, index) {
                          final product = filteredProducts[index];
                          final isSelected = selectedProducts.any((item) => item['product'] == product);
                          final quantityController = TextEditingController(
                            text: isSelected
                                ? selectedProducts.firstWhere((item) => item['product'] == product)['quantity'].toString()
                                : '1',
                          );

                          return Row(
                            children: [
                              // Checkbox
                              Checkbox(
                                value: isSelected,
                                onChanged: (checked) {
                                  setState(() {
                                    if (checked == true) {
                                      selectedProducts.add({'product': product, 'quantity': 1});
                                      totalPrice += product.price;
                                    } else {
                                      final item = selectedProducts.firstWhere((item) => item['product'] == product);
                                      totalPrice -= item['quantity'] * product.price;
                                      selectedProducts.remove(item);
                                    }
                                  });
                                },
                              ),

                              // Nom et prix du produit
                              Expanded(
                                child: Text('${product.name} - ${product.price.toStringAsFixed(2)} DH'),
                              ),

                              // Champ pour la quantité
                              SizedBox(
                                width: 60,
                                child: TextField(
                                  controller: quantityController,
                                  keyboardType: TextInputType.number,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  ),
                                  onChanged: (value) {
                                    setState(() {
                                      final item = selectedProducts.firstWhere((item) => item['product'] == product);
                                      final oldQuantity = item['quantity'];
                                      final newQuantity = int.tryParse(value) ?? 1;

                                      // Met à jour la quantité et le prix total
                                      item['quantity'] = newQuantity;
                                      totalPrice += (newQuantity - oldQuantity) * product.price;
                                    });
                                  },
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Affichage du prix total
                    Text(
                      'Prix Total : ${totalPrice.toStringAsFixed(2)} DH',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                      textAlign: TextAlign.right,
                    ),
                    const SizedBox(height: 16),

                    // Boutons d'action
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => Navigator.of(context).pop(),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                            ),
                            child: const Text('Annuler'),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                for (var item in selectedProducts) {
                                  _items.add(OrderItem(
                                    productId: item['product'].code,
                                    productName: item['product'].name,
                                    quantity: item['quantity'],
                                    unitPrice: item['product'].price,
                                  ));
                                }
                              });
                              Navigator.of(context).pop();
                              setState(() {
                              }); // Actualise le formulaire principal
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF004A99),
                              padding: const EdgeInsets.symmetric(vertical: 16),
                            ),
                            child: const Text('Ajouter', style: TextStyle(color: Colors.white)),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final newOrder = InternalOrder(
        id: 'CMD-${DateTime.now().millisecondsSinceEpoch}',
        clientName: _clientNameController.text,
        date: _selectedDate,
        paymentMethod: _paymentMethod,
        totalPrice: _items.fold(0, (total, item) => total + (item.quantity * item.unitPrice)),
        status: _status,
        items: _items,
      );
      widget.onOrderAdded(newOrder);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.all(20),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Nouvelle Commande Client',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),

              // Champ pour le nom du client
              TextFormField(
                controller: _clientNameController,
                decoration: const InputDecoration(
                  labelText: 'Nom du Client*',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Ce champ est obligatoire';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Sélecteur de date
              InkWell(
                onTap: () => _selectDate(context),
                child: InputDecorator(
                  decoration: const InputDecoration(
                    labelText: 'Date de Commande',
                    border: OutlineInputBorder(),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}'),
                      const Icon(Icons.calendar_today),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Sélecteur de statut
              DropdownButtonFormField<OrderStatus>(
                value: _status,
                items: OrderStatus.values.map((status) {
                  return DropdownMenuItem(
                    value: status,
                    child: Text(_getStatusText(status)),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _status = value;
                    });
                  }
                },
                decoration: const InputDecoration(
                  labelText: 'Statut',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),

              // Sélecteur de méthode de paiement
              DropdownButtonFormField<PaymentMethod>(
                value: _paymentMethod,
                items: PaymentMethod.values.map((method) {
                  return DropdownMenuItem(
                    value: method,
                    child: Text(method.toString().split('.').last),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _paymentMethod = value;
                    });
                  }
                },
                decoration: const InputDecoration(
                  labelText: 'Moyen de Paiement*',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 24),

              // Liste des articles
              const Text('Articles:', style: TextStyle(fontWeight: FontWeight.bold)),
              ..._items.map((item) => ListTile(
                    title: Text(item.productName),
                    subtitle: Text('${item.quantity * item.unitPrice} DH'),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        setState(() {
                          _items.remove(item);
                        });
                      },
                    ),
                  )),
              ElevatedButton(
                onPressed: _addItem,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 40, 121, 187),
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: const Text('Ajouter un Article', style: TextStyle(color: Colors.white)),
              ),
              const SizedBox(height: 32),

              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text('Annuler'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _submitForm,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF004A99),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text('Enregistrer', style: TextStyle(fontSize: 16, color: Colors.white)),
                    ),
                  ),
                ],
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
      case OrderStatus.completed:
        return 'Terminée';
      case OrderStatus.cancelled:
        return 'Annulée';
    }
  }
}