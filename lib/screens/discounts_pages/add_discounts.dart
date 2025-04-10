
import 'package:flutter/material.dart';
import '/models/discounts.dart';

class AddDiscountScreen extends StatefulWidget {
  final Function(Discount) onAddDiscount;

  const AddDiscountScreen({super.key, required this.onAddDiscount});

  @override
  State<AddDiscountScreen> createState() => _AddDiscountScreenState();
}

class _AddDiscountScreenState extends State<AddDiscountScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _validityController = TextEditingController();
  final TextEditingController _productNameController = TextEditingController();
  final TextEditingController _normalPriceController = TextEditingController();
  final TextEditingController _promotionPriceController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _validityController.dispose();
    _productNameController.dispose();
    _normalPriceController.dispose();
    _promotionPriceController.dispose();
    super.dispose();
  }

  void _saveDiscount() {
    if (_formKey.currentState!.validate()) {
      final discount = Discount(
        id: DateTime.now().toString(), // Génère un ID unique
        title: _titleController.text,
        validity: _validityController.text,
        productName: _productNameController.text,
        normalPrice: double.tryParse(_normalPriceController.text) ?? 0.0,
        promotionPrice: double.tryParse(_promotionPriceController.text) ?? 0.0,
      );

      widget.onAddDiscount(discount);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ajouter un Discount'),
        backgroundColor: const Color(0xFF003366),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Titre'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer un titre';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _validityController,
                decoration: const InputDecoration(labelText: 'Validité'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer une validité';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _productNameController,
                decoration: const InputDecoration(labelText: 'Nom du produit'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer le nom du produit';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _normalPriceController,
                decoration: const InputDecoration(labelText: 'Prix normal'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer le prix normal';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _promotionPriceController,
                decoration: const InputDecoration(labelText: 'Prix promotionnel'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer le prix promotionnel';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveDiscount,
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF003366)),
                child: const Text('Enregistrer'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}