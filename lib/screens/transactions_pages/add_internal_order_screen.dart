import 'package:flutter/material.dart';
import '../../models/internal_order.dart';
import '../../models/product.dart';
import '../../models/client.dart';
import 'add_intern_article_screen.dart';

class AddInternalOrderScreen extends StatefulWidget {
  final Function(InternalOrder) onOrderAdded;

  const AddInternalOrderScreen({super.key, required this.onOrderAdded});

  @override
  AddInternalOrderScreenState createState() => AddInternalOrderScreenState();
}

class AddInternalOrderScreenState extends State<AddInternalOrderScreen> {
  final List<Product> _availableProducts = Product.getProducts();
  final List<Client> _clients = Client.getClients(); // Récupère la liste des clients
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _clientNameController = TextEditingController();
  OrderStatus _status = OrderStatus.pending;
  PaymentMethod _paymentMethod = PaymentMethod.cash;
  final TextEditingController _totalPriceController = TextEditingController();
  final TextEditingController _paidPriceController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _remainingPriceController = TextEditingController();

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

  double returnTotalPrice() {
    return _items.fold(0.0, (sum, item) => sum + (item.unitPrice * item.quantity));
  }

  double returnPaidPrice() {
    return double.tryParse(_paidPriceController.text) ?? 0.0;
  }

  double returnRemainingPrice() {
    return returnTotalPrice() - returnPaidPrice();
  }

  void _submitForm() {
    double totalPrice = returnTotalPrice();
    double paidPrice = returnPaidPrice();
    double remainingPrice = returnRemainingPrice();

    if (_formKey.currentState!.validate() && _items.isNotEmpty) {
      final newOrder = InternalOrder(
        id: 'CMD-${DateTime.now().millisecondsSinceEpoch}',
        clientId: 'C${DateTime.now().millisecondsSinceEpoch}',
        clientName: _clientNameController.text,
        date: _selectedDate,
        paymentMethod: _paymentMethod,
        totalPrice: totalPrice,
        paidPrice: paidPrice,
        remainingPrice: remainingPrice,
        description: _descriptionController.text,
        status: _status,
        items: _items,
      );

      // Vérification de l'état de la commande
      if (_status == OrderStatus.completed) {
        for (var item in _items) {
          final productIndex = _availableProducts.indexWhere((product) => product.code == item.productId);
          if (productIndex != -1) {
            setState(() {
              _availableProducts[productIndex].stock -= item.quantity;
            });
          }
        }
      }

      widget.onOrderAdded(newOrder);
      Navigator.of(context).pop();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Veuillez ajouter au moins un article'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

Widget _buildClientAutocomplete() {
  return Autocomplete<Client>(
    optionsBuilder: (TextEditingValue textEditingValue) {
      if (textEditingValue.text.isEmpty) {
        return const Iterable<Client>.empty();
      }
      return _clients.where((client) => 
        client.name.toLowerCase().contains(textEditingValue.text.toLowerCase())
      );
    },
    displayStringForOption: (Client option) => option.name,
    fieldViewBuilder: (BuildContext context, 
                      TextEditingController textEditingController, 
                      FocusNode focusNode, 
                      VoidCallback onFieldSubmitted) {
      return TextFormField(
        controller: textEditingController,
        focusNode: focusNode,
        decoration: const InputDecoration(
          labelText: 'Nom du Client*',
          border: OutlineInputBorder(),
          suffixIcon: Icon(Icons.arrow_drop_down),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Veuillez sélectionner ou saisir un client';
          }
          return null;
        },
      );
    },
    onSelected: (Client selection) {
      setState(() {
        _clientNameController.text = selection.name;
      });
    },
    optionsViewBuilder: (BuildContext context,
                        AutocompleteOnSelected<Client> onSelected,
                        Iterable<Client> options) {
      return Align(
        alignment: Alignment.topLeft,
        child: Material(
          elevation: 4.0,
          child: SizedBox(
            height: 200,
            child: ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: options.length,
              itemBuilder: (BuildContext context, int index) {
                final Client option = options.elementAt(index);
                return ListTile(
                  title: Text(option.name),
                  subtitle: Text(option.email),
                  onTap: () {
                    onSelected(option);
                  },
                );
              },
            ),
          ),
        ),
      );
    },
  );
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
              _buildClientAutocomplete(),
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

              // Champ pour le prix total
              TextFormField(
                enabled: false,
                controller: _totalPriceController,
                decoration: const InputDecoration(
                  labelText: 'Prix Total',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),

              // Champ pour le prix payé
              TextFormField(
                controller: _paidPriceController,
                decoration: const InputDecoration(
                  labelText: 'Prix Payé',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  if (value.isNotEmpty) {
                    setState(() {
                      returnPaidPrice();
                      returnRemainingPrice();
                      _remainingPriceController.text = returnRemainingPrice().toStringAsFixed(2);
                    });
                  } else {
                    setState(() {
                      _remainingPriceController.text = returnTotalPrice().toStringAsFixed(2);
                    });
                  }
                },
              ),
              const SizedBox(height: 16),

              // Champ pour le prix restant
              TextFormField(
                controller: _remainingPriceController,
                enabled: false,
                decoration: const InputDecoration(
                  labelText: 'Prix Restant',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),

              // Champ pour la description
              TextFormField(
                controller: _descriptionController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),

              // Liste des articles
              const Text('Articles:', style: TextStyle(fontWeight: FontWeight.bold)),
              ..._items.map((item) => ListTile(
                    title: Text(item.productName),
                    subtitle: Text('${item.quantity * item.unitPrice} DH (${item.quantity})'),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        setState(() {
                          _items.remove(item);
                          _totalPriceController.text = returnTotalPrice().toStringAsFixed(2);
                          _remainingPriceController.text = returnRemainingPrice().toStringAsFixed(2);
                        });
                      },
                    ),
                  )),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 17, 109, 207),
                ),
                onPressed: () => _showAddArticleDialog(),
                child: const Text('Ajouter un Article', style: TextStyle(color: Colors.white)),
              ),
              const SizedBox(height: 32),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        minimumSize: const Size(double.infinity, 50),
                      ),
                      child: const Text('Annuler', style: TextStyle(fontSize: 16)),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _submitForm,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: const Color(0xFF004A99),
                        minimumSize: const Size(double.infinity, 50),
                      ),
                      child: const Text('Enregistrer', style: TextStyle(color: Colors.white, fontSize: 16)),
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

  void _showAddArticleDialog() async {
    await showDialog<List<OrderItem>>(
      context: context,
      builder: (context) => Dialog(
        child: AddInternArticleDialog(
          availableProducts: _availableProducts,
          onArticlesAdded: (items) {
            setState(() {
              _items.addAll(items);
              _totalPriceController.text = returnTotalPrice().toStringAsFixed(2);
              _remainingPriceController.text = returnRemainingPrice().toStringAsFixed(2);
            });
            Navigator.of(context).pop(items);
          },
        ),
      ),
      useRootNavigator: false,
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