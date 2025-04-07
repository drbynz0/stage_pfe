import 'package:flutter/material.dart';
import 'add_product_screen.dart';
import '/models/product.dart';
import 'delete_product_screen.dart';
import 'edit_product_screen.dart';

class ProductManagementScreen extends StatefulWidget {
  const ProductManagementScreen({super.key});

  @override
  ProductManagementScreenState createState() => ProductManagementScreenState();
}

class ProductManagementScreenState extends State<ProductManagementScreen> {
  final List<Product> products = Product.getProducts();

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

  @override
  Widget build(BuildContext context) {
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
                    return Card(
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
                              product.imagePath ?? 'assets/image/icon_shop.jpg',
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
                            Row(
                              children: [
                                Text('${product.variants} variants • ${product.category}'),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Text(
                                  '${product.stock} en stock',
                                  style: TextStyle(
                                    color: product.stock <= 10 ? Colors.red : Colors.green,
                                  ),
                                ),
                                const Spacer(),
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
            SnackBar(content: Text('Produit supprimé avec succès')),
          );
        },
      ),
    );
  }

  void _showEditDialog(int index) {
    showDialog(
      context: context,
      builder: (context) => EditProductScreen(
        product: products[index],
        onProductUpdated: (updatedProduct) {
          setState(() {
            products[index] = updatedProduct;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Produit mis à jour avec succès')),
          );
        },
      ),
    );
  }
}