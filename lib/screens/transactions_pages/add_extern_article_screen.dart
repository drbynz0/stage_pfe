import 'dart:async';
import 'package:flutter/material.dart';
import '/models/product.dart';
import '/models/external_order.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:permission_handler/permission_handler.dart';




class AddExternalArticleDialog extends StatefulWidget {
  final List<Product> availableProducts;
  final Function(List<OrderItem>) onArticlesAdded;

  const AddExternalArticleDialog({
    super.key,
    required this.availableProducts,
    required this.onArticlesAdded,
  });

  @override
  AddExternalArticleDialogState createState() => AddExternalArticleDialogState();
}

class AddExternalArticleDialogState extends State<AddExternalArticleDialog> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  final Map<String, int> _selectedProducts = {}; // productId -> quantity

  List<Product> get _filteredProducts {
    return widget.availableProducts.where((product) {
      return product.name.toLowerCase().contains(_searchQuery.toLowerCase());
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

    widget.onArticlesAdded(selectedItems);
    Navigator.of(context).pop(); // Ferme la boîte de dialogue
  }

  Future<String?> _scanBarcode() async {
    final cameraStatus = await Permission.camera.request();
    if (cameraStatus != PermissionStatus.granted) {
      return null;
    }

    final completer = Completer<String?>();

    await showDialog(
      // ignore: use_build_context_synchronously
      context: context,
      builder: (context) => Center(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.8,
          height: MediaQuery.of(context).size.height * 0.6,
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Stack(
            children: [
              MobileScanner(
                controller: MobileScannerController(
                  detectionSpeed: DetectionSpeed.normal,
                  facing: CameraFacing.back,
                  torchEnabled: false,
                ),
                onDetect: (capture) {
                  final barcodes = capture.barcodes;
                  if (barcodes.isNotEmpty) {
                    Navigator.pop(context);
                    completer.complete(barcodes.first.rawValue);
                  }
                },
              ),
              Positioned(
                top: 16,
                right: 16,
                child: IconButton(
                  icon: const Icon(Icons.close, color: Colors.white),
                  onPressed: () {
                    Navigator.pop(context);
                    completer.complete(null);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );

    return completer.future;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
        constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.8),
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Ajouter des articles (Commande Externe)',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            // Barre de recherche
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Rechercher un article...',
                prefixIcon: const Icon(Icons.search),
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.qr_code_scanner, color: Colors.blue),
                  onPressed: () async {
                    final scannedCode = await _scanBarcode();
                    if (scannedCode != null) {
                      final product = widget.availableProducts.firstWhere(
                        (p) => p.code == scannedCode,
                        orElse: () => throw Exception('Produit non trouvé'),
                      );
                      setState(() {
                        _searchQuery = product.name; // Filtrer par le produit scanné
                        _searchController.text = product.name;
                        if (!_selectedProducts.containsKey(product.code)) {
                          _selectedProducts[product.code] = 1;
                        }
                      });
                      // ignore: use_build_context_synchronously
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Produit "${product.name}" scanné avec succès.')),
                      );
                    }
                  },
                ),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
            const SizedBox(height: 16),

            // Liste des produits
            Expanded(
              child: ListView.builder(
                itemCount: _filteredProducts.length,
                itemBuilder: (context, index) {
                  final product = _filteredProducts[index];
                  final quantity = _selectedProducts[product.code] ?? 0;

                  return Card(
                    color: quantity > 0 ? const Color.fromARGB(255, 114, 185, 243) : const Color.fromARGB(255, 227, 237, 242),
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    child: ListTile(
                      title: Text(product.name),
                      subtitle: Text('Prix: ${product.price.toStringAsFixed(2)} DH'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.remove, color: Colors.red),
                            onPressed: () => _updateQuantity(product.code, quantity - 1),
                          ),
                          Text('$quantity'),
                          IconButton(
                            icon: const Icon(Icons.add, color: Colors.green),
                            onPressed: () => _updateQuantity(product.code, quantity + 1),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),

            // Affichage du prix total et ajout du bouton Annuler
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Nombre total d'articles sélectionnés
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${_selectedProducts.length} article(s)',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${_selectedProducts.entries.fold(0.0, (sum, entry) {
                        final product = widget.availableProducts.firstWhere((p) => p.code == entry.key);
                        return sum + (product.price * entry.value);
                      }).toStringAsFixed(2)} DH',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),

                // Boutons Annuler et Ajouter
                Row(
                  children: [
                    OutlinedButton(
                      onPressed: () {
                        Navigator.of(context).pop(); // Ferme la boîte de dialogue
                      },
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                      ),
                      child: const Text('Annuler'),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _selectedProducts.isNotEmpty ? const Color(0xFF004A99) : Colors.grey,
                      ),
                      onPressed: _selectedProducts.isNotEmpty ? _submitSelection : null,
                      child: const Text('Ajouter', style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}