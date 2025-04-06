import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../../models/product.dart';

class EditProductScreen extends StatefulWidget {
  final Product product;
  final Function(Product) onProductUpdated;

  const EditProductScreen({
    super.key,
    required this.product,
    required this.onProductUpdated,
  });

  @override
  EditProductScreenState createState() => EditProductScreenState();
}

class EditProductScreenState extends State<EditProductScreen> {
  late final TextEditingController _nameController;
  late final TextEditingController _priceController;
  late final TextEditingController _stockController;
  late final TextEditingController _categoryController;
  late final TextEditingController _variantsController;
  File? _imageFile;
  bool _imageUpdated = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.product.name);
    _priceController = TextEditingController(text: widget.product.price.toString());
    _stockController = TextEditingController(text: widget.product.stock.toString());
    _categoryController = TextEditingController(text: widget.product.category);
    _variantsController = TextEditingController(text: widget.product.variants.toString());
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _stockController.dispose();
    _categoryController.dispose();
    _variantsController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
        _imageUpdated = true;
      });
    }
  }

  void _submitForm() {
    if (_nameController.text.isEmpty ||
        _priceController.text.isEmpty ||
        _stockController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veuillez remplir tous les champs obligatoires')),
      );
      return;
    }

    final updatedProduct = Product(
      name: _nameController.text,
      price: double.parse(_priceController.text),
      stock: double.parse(_stockController.text),
      category: _categoryController.text,
      variants: int.parse(_variantsController.text),
      code: widget.product.code,
      date: widget.product.date,
      imagePath: _imageUpdated ? _imageFile?.path : widget.product.imagePath,
    );

    widget.onProductUpdated(updatedProduct);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.all(20),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Modifier le produit',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            
            // Image du produit
            GestureDetector(
              onTap: _pickImage,
              child: Container(
                height: 150,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey),
                ),
                child: _imageFile != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.file(_imageFile!, fit: BoxFit.cover),
                      )
                    : widget.product.imagePath != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.file(
                              File(widget.product.imagePath!),
                              fit: BoxFit.cover,
                            ),
                          )
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(Icons.add_a_photo, size: 40, color: Colors.grey),
                              SizedBox(height: 8),
                              Text('Changer l\'image'),
                            ],
                          ),
              ),
            ),
            const SizedBox(height: 20),
            
            // Nom du produit
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Nom du produit*',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.production_quantity_limits),
              ),
            ),
            const SizedBox(height: 16),
            
            // Prix
            TextFormField(
              controller: _priceController,
              decoration: const InputDecoration(
                labelText: 'Prix*',
                border: OutlineInputBorder(),
                prefixText: 'DH ',
              ),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
            ),
            const SizedBox(height: 16),
            
            // Stock
            TextFormField(
              controller: _stockController,
              decoration: const InputDecoration(
                labelText: 'Quantité en stock*',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.inventory),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            
            // Catégorie
            TextFormField(
              controller: _categoryController,
              decoration: const InputDecoration(
                labelText: 'Catégorie',
                prefixIcon: Icon(Icons.category),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            
            // Variants
            TextFormField(
              controller: _variantsController,
              decoration: const InputDecoration(
                labelText: 'Variantes',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.view_list),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 24),
            
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
                    onPressed: _submitForm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF004A99),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text('Enregistrer', 
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
}