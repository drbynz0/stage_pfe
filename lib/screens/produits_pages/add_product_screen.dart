import 'package:flutter/material.dart';
import '/models/product.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class AddProductScreen extends StatefulWidget {
  final Function(Product) onProductAdded;

  const AddProductScreen({super.key, required this.onProductAdded});

  @override
  AddProductScreenState createState() => AddProductScreenState();
}

class AddProductScreenState extends State<AddProductScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _codeController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _stockController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _variantsController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final List<File?> _imageFiles = List.filled(4, null);

  final List<Product> products = Product.getProducts();
  late List<String> _existingCategories;

  @override
  void initState() {
    super.initState();
    _existingCategories = products.map((p) => p.category).toSet().toList();
  }

  Future<void> _pickImage(int index) async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFiles[index] = File(pickedFile.path);
      });
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // Filtrer les images non null et convertir en chemins
      final imagePaths = _imageFiles
          .where((file) => file != null)
          .map((file) => file!.path)
          .toList();

      // Si aucune image n'est sélectionnée, utiliser l'image par défaut
      if (imagePaths.isEmpty) {
        imagePaths.add('assets/image/icon_shop.jpg');
      }

      final newProduct = Product(
        name: _nameController.text,
        price: double.parse(_priceController.text),
        stock: double.parse(_stockController.text),
        category: _categoryController.text,
        variants: int.parse(_variantsController.text),
        code: _codeController.text,
        date: "${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}",
        imagePaths: imagePaths,
        description: _descriptionController.text.isNotEmpty ? [_descriptionController.text] : null,
      );

      widget.onProductAdded(newProduct);
      Navigator.of(context).pop();
    }
  }

  @override
  void dispose() {
    _codeController.dispose();
    _nameController.dispose();
    _priceController.dispose();
    _stockController.dispose();
    _categoryController.dispose();
    _variantsController.dispose();
    super.dispose();
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
                'Ajouter un produit',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),

              // Section pour les images (4 emplacements)
              const Text('Images du produit (max 4):', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                  childAspectRatio: 1,
                ),
                itemCount: 4,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () => _pickImage(index),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey),
                      ),
                      child: _imageFiles[index] == null
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.add_a_photo, size: 30, color: Colors.grey),
                                const SizedBox(height: 4),
                                Text('Image ${index + 1}'),
                              ],
                            )
                          : ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.file(_imageFiles[index]!, fit: BoxFit.cover),
                            ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),

              // ... (le reste de votre formulaire reste inchangé) ...
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _codeController,
                      decoration: const InputDecoration(
                        labelText: 'Code du produit',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.code),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Veuillez entrer un code';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    onPressed: () {
                      // Ajouter la logique de scan de code-barres ici
                    },
                    icon: const Icon(
                      Icons.barcode_reader,
                      color: Color.fromARGB(255, 18, 65, 85),
                      size: 30,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Nom du produit',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.shopping_bag),
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
                controller: _priceController,
                decoration: const InputDecoration(
                  labelText: 'Prix',
                  border: OutlineInputBorder(),
                  prefixText: 'DH ',
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer un prix';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Veuillez entrer un nombre valide';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _stockController,
                decoration: const InputDecoration(
                  labelText: 'Quantité en stock',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.inventory),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer une quantité';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Veuillez entrer un nombre valide';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _variantsController,
                decoration: const InputDecoration(
                  labelText: 'Variantes',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.view_list),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer le nombre de variantes';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Veuillez entrer un nombre valide';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _categoryController,
                decoration: const InputDecoration(
                  labelText: 'Catégorie',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.category),
                ),
                onChanged: (value) {
                  setState(() {});
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer une catégorie';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 8),

              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _existingCategories
                    .where((category) => category.toLowerCase().contains(_categoryController.text.toLowerCase()))
                    .map((category) => GestureDetector(
                          onTap: () {
                            setState(() {
                              _categoryController.text = category;
                            });
                          },
                          child: Chip(
                            label: Text(category),
                            backgroundColor: Colors.blue.shade100,
                          ),
                        ))
                    .toList(),
              ),
              const SizedBox(height: 24),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.description),
                ),
                keyboardType: TextInputType.number,
                maxLines: 5,
              ),
              const SizedBox(height: 24),

              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        minimumSize: const Size(double.infinity, 50),
                      ),
                      child: const Text('Annuler', style: TextStyle(fontSize: 16)),               ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _submitForm,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF004A99),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text('Ajouter', style: TextStyle(fontSize: 16, color: Colors.white)),
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