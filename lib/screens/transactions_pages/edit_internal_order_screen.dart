import 'package:flutter/material.dart';
import '../../models/internal_order.dart';

class EditInternalOrderScreen extends StatefulWidget {
  final InternalOrder order;
  final Function(InternalOrder) onOrderUpdated;

  const EditInternalOrderScreen({
    super.key,
    required this.order,
    required this.onOrderUpdated,
  });

  @override
  EditInternalOrderScreenState createState() => EditInternalOrderScreenState();
}

class EditInternalOrderScreenState extends State<EditInternalOrderScreen> {
  late final TextEditingController _clientNameController;
  late OrderStatus _status;
  late PaymentMethod _paymentMethod;
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    _clientNameController = TextEditingController(text: widget.order.clientName);
    _status = widget.order.status;
    _paymentMethod = widget.order.paymentMethod;
    _selectedDate = widget.order.date;
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
      });
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
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Modifier Commande',
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
                labelText: 'Nom du Client',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            // Sélecteur de méthode de paiement
            DropdownButtonFormField<PaymentMethod>(
              value: _paymentMethod,
              decoration: const InputDecoration(
                labelText: 'Méthode de Paiement',
                border: OutlineInputBorder(),
              ),
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
            ),
            const SizedBox(height: 16),

            // Sélecteur de date
            Row(
              children: [
                const Text('Date de la commande:'),
                const SizedBox(width: 8),
                TextButton(
                  onPressed: () => _selectDate(context),
                  child: Text(
                    '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Sélecteur de statut
            DropdownButtonFormField<OrderStatus>(
              value: _status,
              decoration: const InputDecoration(
                labelText: 'Statut',
                border: OutlineInputBorder(),
              ),
              items: OrderStatus.values.map((status) {
                return DropdownMenuItem(
                  value: status,
                  child: Text(status.toString().split('.').last),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _status = value;
                  });
                }
              },
            ),
            const SizedBox(height: 24),

            // Liste des articles
            const Text(
              'Articles',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: widget.order.items.length,
              itemBuilder: (context, index) {
                final item = widget.order.items[index];
                final TextEditingController quantityController =
                    TextEditingController(text: item.quantity.toString());

                return Row(
                  children: [
                    // Nom du produit
                    Expanded(
                      child: Text(item.productName),
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
                            final newQuantity = double.tryParse(value) ?? 1;
                            item.quantity = newQuantity;
                          });
                        },
                      ),
                    ),

                    // Bouton pour supprimer l'article
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        setState(() {
                          widget.order.items.removeAt(index);
                        });
                      },
                    ),
                  ],
                );
              },
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
                      final updatedOrder = InternalOrder(
                        id: widget.order.id,
                        clientName: _clientNameController.text,
                        date: _selectedDate,
                        paymentMethod: _paymentMethod,
                        totalPrice: widget.order.items.fold(
                          0.0,
                          (sum, item) => sum + (item.quantity * item.unitPrice),
                        ),
                        status: _status,
                        items: widget.order.items,
                      );
                      widget.onOrderUpdated(updatedOrder);
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF004A99),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text(
                      'Enregistrer',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _clientNameController.dispose();
    super.dispose();
  }
}