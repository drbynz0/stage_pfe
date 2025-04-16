import 'package:flutter/material.dart';
import '/models/supplier.dart';

class EditSupplierScreen extends StatefulWidget {
  final Supplier supplier;
  final Function(Supplier) onEditSupplier;
//v
  const EditSupplierScreen({
    super.key,
    required this.supplier,
    required this.onEditSupplier,
  });

  @override
  State<EditSupplierScreen> createState() => _EditSupplierScreenState();
}

class _EditSupplierScreenState extends State<EditSupplierScreen> {
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;
  late final TextEditingController _addressController;
  late final TextEditingController _companyController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.supplier.name);
    _emailController = TextEditingController(text: widget.supplier.email);
    _phoneController = TextEditingController(text: widget.supplier.phone);
    _addressController = TextEditingController(text: widget.supplier.address);
    _companyController = TextEditingController(text: widget.supplier.company);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.all(20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Modifier fournisseur',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),

              // Champ Nom
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Nom du fournisseur',
                  border: OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.person),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer un nom';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Champ Email
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.email),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),

              // Champ Téléphone
              TextFormField(
                controller: _phoneController,
                decoration: InputDecoration(
                  labelText: 'Téléphone',
                  border: OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.phone),
                ),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 16),

              // Champ Adresse
              TextFormField(
                controller: _addressController,
                decoration: InputDecoration(
                  labelText: 'Adresse',
                  border: OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.location_on),
                ),
              ),
              const SizedBox(height: 16),

              // Champ Entreprise
              TextFormField(
                controller: _companyController,
                decoration: InputDecoration(
                  labelText: 'Entreprise',
                  border: OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.business),
                ),
              ),
              const SizedBox(height: 24),

              // Boutons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        minimumSize: const Size(double.infinity, 50),
                      ),
                      child: const Text('Annuler', style: TextStyle(fontSize: 16)),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _updateSupplier,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF004A99),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text('Mettre à jour', style: TextStyle(fontSize: 16, color: Colors.white)),
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

  void _updateSupplier() {
    final updatedSupplier = widget.supplier.copyWith(
      name: _nameController.text,
      email: _emailController.text,
      phone: _phoneController.text,
      address: _addressController.text,
      company: _companyController.text,
    );
    widget.onEditSupplier(updatedSupplier);
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _companyController.dispose();
    super.dispose();
  }
}