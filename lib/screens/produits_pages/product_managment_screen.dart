import 'dart:async';
import 'package:flutter/material.dart';
import 'add_product_screen.dart';
import '/models/product.dart';
import 'delete_product_screen.dart';
import 'edit_product_screen.dart';
import 'details_product_screen.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:permission_handler/permission_handler.dart';



class ProductManagementScreen extends StatefulWidget {
  const ProductManagementScreen({super.key});

  @override
  ProductManagementScreenState createState() => ProductManagementScreenState();
}

class ProductManagementScreenState extends State<ProductManagementScreen> {
  final List<Product> products = Product.productList;

  String _searchQuery = '';
  String _selectedCategory = 'Tout';
  int _currentPage = 1;
  final int _itemsPerPage = 5;

  List<String> get categories {
    Set<String> uniqueCategories = products.map((p) => p.category).toSet();
    return ['Tout', ...uniqueCategories];
  }

  List<Product> get filteredProducts {
    return products.where((product) {
      final matchesSearch = product.name.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesCategory = _selectedCategory == 'Tout' || product.category == _selectedCategory;
      return matchesSearch && matchesCategory;
    }).toList();
  }

  List<Product> get paginatedProducts {
    int startIndex = (_currentPage - 1) * _itemsPerPage;
    int endIndex = startIndex + _itemsPerPage;
    endIndex = endIndex > filteredProducts.length ? filteredProducts.length : endIndex;
    return filteredProducts.sublist(startIndex, endIndex);
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
                  icon: Icon(Icons.close, color: Colors.white),
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
    setState(() {
    });
    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              // Barre de recherche
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.search),
                    hintText: 'Rechercher des produits...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                      _currentPage = 1;
                    });
                  },
                ),
              ),
              
              // Ligne avec sélecteur et bouton Exporter
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                child: Row(
                  children: [
                    // Sélecteur de catégorie
                    Expanded(
                      flex: 3,
                      child: DropdownButtonFormField<String>(
                        value: _selectedCategory,
                        items: categories.map((category) {
                          return DropdownMenuItem<String>(
                            value: category,
                            child: Text(category),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedCategory = value!;
                            _currentPage = 1;
                          });
                        },
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                        ),
                      ),
                    ),
                    
                    const SizedBox(width: 8),
                    
                    // Bouton Exporter
                    Expanded(
                      flex: 2,
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.file_download, size: 20, color: Colors.white),
                        label: const Text('Exporter', style: TextStyle(color: Colors.white)),
                        onPressed: () {
                          // Action pour exporter
                        },
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(0, 50),
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          backgroundColor: const Color.fromARGB(255, 33, 71, 124),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
              // Liste des produits
              Expanded(
                child: ListView.builder(
                  itemCount: paginatedProducts.length,
                  itemBuilder: (context, index) {
                    final product = paginatedProducts[index];
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DetailsProductScreen(
                              product: product,
                            ),
                          ),
                        ); 
                        },
                      child: Card(
                        color: const Color.fromARGB(255, 194, 224, 240),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(8),
                          leading: Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              color: Colors.blue[50],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.asset(
                                product.imagePaths?[0] ?? 'assets/image/icon_shop.jpg',
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return const Icon(Icons.image_not_supported, color: Colors.grey);
                                },
                              ),
                            ),
                          ),
                          title: Text(
                            product.name,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Wrap(
                                children: [
                                  Text('${product.variants} variants -'),
                                  const SizedBox(width: 5,),
                                  Text(
                                    product.category,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Wrap(
                                children: [
                                  Text(
                                    '${product.stock} en stock',
                                    style: TextStyle(
                                      color: product.stock <= 10 ? Colors.red : Colors.green,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Text(
                                    '${product.price.toStringAsFixed(2)} DH',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit, color: Colors.blue),
                                onPressed: () => _showEditDialog(index),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete, color: Colors.red),
                                onPressed:  () => _showDeleteDialog(index),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              
              // Pagination
              Container(
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  border: Border(top: BorderSide(color: Colors.grey.shade300)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${filteredProducts.length} éléments',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                    Row(
                      children: [
                        Text(
                          'Page $_currentPage/${(filteredProducts.length / _itemsPerPage).ceil()}',
                        ),
                        const SizedBox(width: 16),
                        IconButton(
                          icon: const Icon(Icons.arrow_back),
                          onPressed: _currentPage > 1
                              ? () => setState(() => _currentPage--)
                              : null,
                        ),
                        IconButton(
                          icon: const Icon(Icons.arrow_forward),
                          onPressed: _currentPage < (filteredProducts.length / _itemsPerPage).ceil()
                              ? () => setState(() => _currentPage++)
                              : null,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          // Bouton de scanne produit
          Positioned(
            right: 23,
            bottom: 120,
            child: IconButton(
              onPressed: () async {
                final scannedBarcode = await _scanBarcode(); // Appel de la méthode _scanBarcode
                if (scannedBarcode != null) {
                  try {
                    // Recherche du produit correspondant
                    final matchingProduct = products.firstWhere(
                      (product) => product.code == scannedBarcode,
                    );

                    // Afficher un message de succès
                    // ignore: use_build_context_synchronously
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Produit trouvé : ${matchingProduct.name}'),
                        backgroundColor: Colors.green,
                        duration: const Duration(seconds: 3),
                      ),
                    );

                    // Naviguer vers les détails du produit scanné
                    Navigator.push(
                      // ignore: use_build_context_synchronously
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailsProductScreen(product: matchingProduct),
                      ),
                    );
                  } catch (e) {
                    // Afficher un message d'erreur si aucun produit n'est trouvé
                    // ignore: use_build_context_synchronously
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Aucun produit trouvé pour le code $scannedBarcode'),
                        backgroundColor: Colors.red,
                        duration: const Duration(seconds: 3),
                      ),
                    );
                  }
                } else {
                  // Afficher un message si le scan est annulé
                  // ignore: use_build_context_synchronously
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Scan annulé'),
                      backgroundColor: Colors.orange,
                      duration: Duration(seconds: 3),
                    ),
                  );
                }
              },
              icon: const Icon(
                Icons.barcode_reader,
                color: Color.fromARGB(255, 18, 65, 85),
                size: 30,
              ),
            ),
          ),
          Positioned(
            right: 15,
            bottom: 60,
            child: FloatingActionButton(
              onPressed: _showAddProductDialog,
              backgroundColor: Colors.blue,
              elevation: 4,
              child: const Icon(Icons.add, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  void _showAddProductDialog() {
    showDialog(
      context: context,
      builder: (context) => AddProductScreen(
        onProductAdded: (newProduct) {
          setState(() {
            products.insert(0, newProduct);
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Produit Ajouté avec succès'), duration: const Duration(seconds: 3), backgroundColor: Colors.green,),
          );        
        },
      ),
    );
  }

  void _showDeleteDialog(int index) {
    showDialog(
      context: context,
      builder: (context) => DeleteProductScreen(
        product: products[index],
        onDeleteConfirmed: () {
          setState(() {
            products.removeAt(index);
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Produit supprimé avec succès'), duration: const Duration(seconds: 3), backgroundColor: Colors.red,),
          );
        },
      ),
    );
  }

  void _showEditDialog(int index) {
  final productIndex = products.indexOf(paginatedProducts[index]); // Trouve l'index réel dans la liste complète
  showDialog(
    context: context,
    builder: (context) => EditProductScreen(
      product: products[productIndex], // Utilise l'index réel
      onProductUpdated: (updatedProduct) {
        setState(() {
          products[productIndex] = updatedProduct; // Met à jour le produit dans la liste complète
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Produit "${updatedProduct.name}" mis à jour avec succès'),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 3),
          ),
        );
      },
    ),
  );
}
}