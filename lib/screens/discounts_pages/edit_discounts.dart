import 'package:flutter/material.dart';
import '/models/discounts.dart';
import '/models/product.dart';

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
  final List<Product> products = Product.getProducts();
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _productNameController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _normalPriceController = TextEditingController();
  final TextEditingController _promotionPriceController = TextEditingController();
  
  Product? _selectedProduct;
  DateTime? _startDate;
  DateTime? _endDate;
  double _discountPercentage = 0;

  @override
  void initState() {
    super.initState();
    // Initialiser les contrôleurs avec les valeurs existantes du discount
    _titleController.text = widget.discount.title;
    _descriptionController.text = widget.discount.description;
    _normalPriceController.text = widget.discount.normalPrice.toStringAsFixed(2);
    _promotionPriceController.text = widget.discount.promotionPrice.toStringAsFixed(2);
    _productNameController.text = widget.discount.productName;
    
    // Calculer le pourcentage initial
    _calculateDiscount();
    
    // Trouver le produit correspondant
    _selectedProduct = products.firstWhere(
      (product) => product.code == widget.discount.productId,
      orElse: () => Product.empty(),
    );
    
    // Parser les dates de validité si elles existent
    final dates = widget.discount.validity.split(' - ');
    if (dates.length == 2) {
      _startDate = DateTime.tryParse(dates[0]);
      _endDate = DateTime.tryParse(dates[1]);
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _normalPriceController.dispose();
    _promotionPriceController.dispose();
    _productNameController.dispose();
    super.dispose();
  }

  void _calculateDiscount() {
    if (_normalPriceController.text.isNotEmpty && 
        _promotionPriceController.text.isNotEmpty) {
      final normalPrice = double.tryParse(_normalPriceController.text) ?? 0;
      final promoPrice = double.tryParse(_promotionPriceController.text) ?? 0;
      
      if (normalPrice > 0) {
        setState(() {
          _discountPercentage = ((normalPrice - promoPrice) / normalPrice * 100).roundToDouble();
        });
      }
    }
  }

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isStartDate ? _startDate ?? DateTime.now() : _endDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 1),
    );
    
    if (picked != null) {
      setState(() {
        if (isStartDate) {
          _startDate = picked;
        } else {
          _endDate = picked;
        }
      });
    }
  }

  void _saveDiscount() {
    if (_formKey.currentState!.validate() && _selectedProduct != null) {
      final updatedDiscount = widget.discount.copyWith(
        title: _titleController.text,
        validity: '${_startDate?.toLocal().toString().split(' ')[0]} - ${_endDate?.toLocal().toString().split(' ')[0]}',
        productId: _selectedProduct!.code,
        productName: _productNameController.text,
        productCategory: _selectedProduct!.category,
        normalPrice: double.tryParse(_normalPriceController.text) ?? 0.0,
        promotionPrice: double.tryParse(_promotionPriceController.text) ?? 0.0,
        description: _descriptionController.text,
      );

      widget.onEditDiscount(updatedDiscount);
      Navigator.pop(context);
    }
  }

  Widget _buildProductAutocomplete() {
    return Autocomplete<Product>(
      optionsBuilder: (TextEditingValue textEditingValue) {
        if (textEditingValue.text.isEmpty) {
          return products;
        }
        return products.where((product) =>
            product.name.toLowerCase().contains(textEditingValue.text.toLowerCase()) ||
            product.category.toLowerCase().contains(textEditingValue.text.toLowerCase()));
      },
      displayStringForOption: (Product option) => option.name,
      fieldViewBuilder: (BuildContext context, TextEditingController textEditingController,
          FocusNode focusNode, VoidCallback onFieldSubmitted) {
        textEditingController.text = _selectedProduct?.name ?? '';
        return TextFormField(
          controller: textEditingController,
          focusNode: focusNode,
          decoration: const InputDecoration(
            labelText: 'Produit*',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.shopping_cart),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Veuillez sélectionner un produit';
            }
            return null;
          },
        );
      },
      onSelected: (Product selection) {
        setState(() {
          _productNameController.text = selection.name;
          _selectedProduct = selection;
          _normalPriceController.text = selection.price.toStringAsFixed(2);
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
                    leading: option.imagePaths!.isNotEmpty
                      ? Image.network(option.imagePaths!.first, width: 40, height: 40)
                      : const Icon(Icons.image, size: 40),
                    title: Text(option.name),
                    subtitle: Text('${option.price.toStringAsFixed(2)} MAD - ${option.category}'),
                    onTap: () {
                      onSelected(option);
                      Navigator.pop(context);
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
      insetPadding: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxHeight: 600),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Modifier la Promotion',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                const Divider(),
                const SizedBox(height: 16),

                // Sélection du produit
                _buildProductAutocomplete(),
                const SizedBox(height: 16),

                // Titre de la promotion
                TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.title),
                    labelText: 'Titre de la promotion*',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) => value?.isEmpty ?? true ? 'Ce champ est requis' : null,
                ),
                const SizedBox(height: 16),

                // Description
                TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Description',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 2,
                ),
                const SizedBox(height: 16),

                // Période de validité
                const Text('Période de validité*', style: TextStyle(fontSize: 16)),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () => _selectDate(context, true),
                        child: InputDecorator(
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                          ),
                          child: Text(
                            _startDate != null 
                              ? '${_startDate!.day}/${_startDate!.month}/${_startDate!.year}'
                              : 'Date de début',
                          ),
                        ),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      child: Text('au'),
                    ),
                    Expanded(
                      child: InkWell(
                        onTap: () => _selectDate(context, false),
                        child: InputDecorator(
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                          ),
                          child: Text(
                            _endDate != null 
                              ? '${_endDate!.day}/${_endDate!.month}/${_endDate!.year}'
                              : 'Date de fin',
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Prix et promotion
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _normalPriceController,
                        decoration: const InputDecoration(
                          labelText: 'Prix normal*',
                          border: OutlineInputBorder(),
                          prefixText: 'MAD ',
                        ),
                        keyboardType: TextInputType.number,
                        onChanged: (_) => _calculateDiscount(),
                        validator: (value) => value?.isEmpty ?? true ? 'Ce champ est requis' : null,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextFormField(
                        controller: _promotionPriceController,
                        decoration: const InputDecoration(
                          labelText: 'Prix promo*',
                          border: OutlineInputBorder(),
                          prefixText: 'MAD ',
                        ),
                        keyboardType: TextInputType.number,
                        onChanged: (_) => _calculateDiscount(),
                        validator: (value) => value?.isEmpty ?? true ? 'Ce champ est requis' : null,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                if (_discountPercentage > 0)
                  Text(
                    'Réduction: ${_discountPercentage.toStringAsFixed(0)}%',
                    style: const TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                const SizedBox(height: 24),

                // Bouton de validation
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _saveDiscount,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF003366),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text('Enregistrer les modifications', style: TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}