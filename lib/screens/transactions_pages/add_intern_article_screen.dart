import 'package:flutter/material.dart';
import '/models/product.dart';
import '/models/internal_order.dart';
class AddInternArticleDialog extends StatefulWidget {
  final List<Product> availableProducts;
  final Function(InternalOrder) onArticlesAdded;

  const AddInternArticleDialog({
    super.key,
    required this.availableProducts,
    required this.onArticlesAdded,
  });

  @override
  AddInternArticleDialogState createState() => AddInternArticleDialogState();
}

class AddInternArticleDialogState extends State<AddInternArticleDialog> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  final Map<String, int> _selectedProducts = {}; // productId -> quantity

  List<Product> get _filteredProducts {
    return widget.availableProducts.where((product) {
      return product.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          product.price.toString().contains(_searchQuery);
    }).toList();
  }

  void _updateQuantity(String productId, int quantity) {
    setState(() {
      if (quantity > 0) {
        _selectedProducts[productId] = quantity;
      } else {
        _selectedProducts.remove(productId);
      }
    });
  }

  void _submitSelection() {
    final selectedItems = _selectedProducts.entries.map((entry) {
      final product = widget.availableProducts.firstWhere((p) => p.code == entry.key);
      return OrderItem(
        productId: product.code,
        productName: product.name,
        quantity: entry.value.toDouble(),
        unitPrice: product.price,
      );
    }).toList();

    widget.onArticlesAdded(selectedItems as InternalOrder);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.all(16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
        constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.8),
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Ajouter des articles',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Rechercher un article...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
            SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: _filteredProducts.length,
                itemBuilder: (context, index) {
                  final product = _filteredProducts[index];
                  final quantity = _selectedProducts[product.code] ?? 0;

                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 4),
                    child: ListTile(
                      title: Text(product.name),
                      subtitle: Text('Prix: \$${product.price.toStringAsFixed(2)}'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.remove),
                            onPressed: () => _updateQuantity(product.code, quantity - 1),
                          ),
                          Text('$quantity'),
                          IconButton(
                            icon: Icon(Icons.add),
                            onPressed: () => _updateQuantity(product.code, quantity + 1),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${_selectedProducts.length} article(s) sélectionné(s)',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                ElevatedButton(
                  onPressed: _selectedProducts.isNotEmpty ? _submitSelection : null,
                  child: Text('Ajouter'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class OrderItem {
  final String productId;
  final String productName;
  final double quantity;
  final double unitPrice;

  OrderItem({
    required this.productId,
    required this.productName,
    required this.quantity,
    required this.unitPrice,
  });
}