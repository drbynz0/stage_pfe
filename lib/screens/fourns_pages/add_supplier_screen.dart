import 'package:flutter/material.dart';
import '/models/supplier.dart';
import '/models/product.dart';

class AddSupplierScreen extends StatefulWidget {
  final Function(Supplier) onAddSupplier;

  const AddSupplierScreen({super.key, required this.onAddSupplier});

  @override
  AddSupplierScreenState createState() => AddSupplierScreenState();
}

class AddSupplierScreenState extends State<AddSupplierScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _companyController = TextEditingController();
  final TextEditingController _activityController = TextEditingController();

  final List<Product> products = Product.getProducts();
  String productId = '';

  @override
  void initState() {
    super.initState();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final newSupplier = Supplier(
        ice: DateTime.now().millisecondsSinceEpoch.toString(),
        name: _nameController.text,
        email: _emailController.text,
        phone: _phoneController.text,
        address: _addressController.text,
        company: _companyController.text,
        products: [], // Liste vide par défaut
        paymentTerms: '', // Valeur par défaut
      );

      widget.onAddSupplier(newSupplier);
      Navigator.of(context).pop();
    }
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

  Widget _buildCompanyAutocomplete() {
    return Autocomplete<Product>(
      optionsBuilder: (TextEditingValue textEditingValue) {
        if (textEditingValue.text.isEmpty) {
          return const Iterable<Product>.empty();
        }
        return products.where((client) =>
            client.category.toLowerCase().contains(textEditingValue.text.toLowerCase()));
      },
      displayStringForOption: (Product option) => option.category,
      fieldViewBuilder: (BuildContext context, TextEditingController textEditingController,
          FocusNode focusNode, VoidCallback onFieldSubmitted) {
        return TextFormField(
          controller: textEditingController,
          focusNode: focusNode,
          decoration: const InputDecoration(
            labelText: 'Compagnie',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.business),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Veuillez entrer une compagnie';
            }
            return null;
          },
        );
      },
      onSelected: (Product selection) {
        setState(() {
          _companyController.text = selection.category;
          productId = selection.code;
        });
      },
      optionsViewBuilder: (BuildContext context, AutocompleteOnSelected<Product> onSelected,
          Iterable<Product> options) {
        return Align(
          alignment: Alignment.topLeft,
          child: Material(
            elevation: 4.0,
            child: SizedBox(
              height: 200,
              width: MediaQuery.of(context).size.width - 90,
              child: ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: options.length,
                itemBuilder: (BuildContext context, int index) {
                  final Product option = options.elementAt(index);
                  return ListTile(
                    title: Text(option.category),
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

  Widget _buildActivityAutocomplete() {
    return Autocomplete<Product>(
      optionsBuilder: (TextEditingValue textEditingValue) {
        if (textEditingValue.text.isEmpty) {
          return const Iterable<Product>.empty();
        }
        return products.where((product) =>
            product.category.toLowerCase().contains(textEditingValue.text.toLowerCase()));
      },
      displayStringForOption: (Product option) => option.name,
      fieldViewBuilder: (BuildContext context, TextEditingController textEditingController,
          FocusNode focusNode, VoidCallback onFieldSubmitted) {
        return TextFormField(
          controller: textEditingController,
          focusNode: focusNode,
          decoration: const InputDecoration(
            labelText: 'Activité',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.shopping_cart),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Veuillez entrer une activité';
            }
            return null;
          },
        );
      },
      onSelected: (Product selection) {
        setState(() {
          _activityController.text = selection.name;
          productId = selection.code;
        });
      },
      optionsViewBuilder: (BuildContext context, AutocompleteOnSelected<Product> onSelected,
          Iterable<Product> options) {
        return Align(
          alignment: Alignment.topLeft,
          child: Material(
            elevation: 4.0,
            child: SizedBox(
              height: 200,
              width: MediaQuery.of(context).size.width - 90,
              child: ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: options.length,
                itemBuilder: (BuildContext context, int index) {
                  final Product option = options.elementAt(index);
                  return ListTile(
                    title: Text(option.category),
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
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Ajouter un fournisseur',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),

              // Informations du fournisseur
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Nom du responsable',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer un nom';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _companyController,
                decoration: const InputDecoration(
                  labelText: 'Nom de l\'entreprise',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.business),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer un nom d\'entreprise';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.email),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(
                  labelText: 'Téléphone',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.phone),
                ),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _addressController,
                decoration: const InputDecoration(
                  labelText: 'Adresse',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.location_on),
                ),
              ),
              const SizedBox(height: 24),

              _buildCompanyAutocomplete(),
              const SizedBox(height: 24),

              _buildActivityAutocomplete(),
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
}