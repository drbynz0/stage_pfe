import 'package:flutter/material.dart';
import '/models/discounts.dart';

class EditDiscountScreen extends StatefulWidget {
  final Discount discount;
  final Function(Discount) onEditDiscount;

  const EditDiscountScreen({
    super.key,
    required this.discount,
    required this.onEditDiscount,
  });

  @override
  State<EditDiscountScreen> createState() => _EditDiscountScreenState();
}

class _EditDiscountScreenState extends State<EditDiscountScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _validityController;
  late TextEditingController _productNameController;
  late TextEditingController _normalPriceController;
  late TextEditingController _promotionPriceController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.discount.title);
    _validityController = TextEditingController(text: widget.discount.validity);
    _productNameController = TextEditingController(text: widget.discount.productName);
    _normalPriceController = TextEditingController(text: widget.discount.normalPrice.toString());
    _promotionPriceController = TextEditingController(text: widget.discount.promotionPrice.toString());
  }

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
      final updatedDiscount = Discount(
        id: widget.discount.id,
        title: _titleController.text,
        validity: _validityController.text,
        productName: _productNameController.text,
        normalPrice: double.tryParse(_normalPriceController.text) ?? 0.0,
        promotionPrice: double.tryParse(_promotionPriceController.text) ?? 0.0,
      );

      widget.onEditDiscount(updatedDiscount);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Modifier le Discount'),
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