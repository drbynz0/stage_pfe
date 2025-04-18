import 'package:flutter/material.dart';
import '../../models/product.dart';
import 'edit_product_screen.dart';
import 'package:carousel_slider/carousel_slider.dart';



class DetailsProductScreen extends StatefulWidget {
  final Product product;

  const DetailsProductScreen({super.key, required this.product});
//bb
  @override
  DetailsProductScreenState createState() => DetailsProductScreenState();
}

class DetailsProductScreenState extends State<DetailsProductScreen> {
  late Product product;

  @override
  void initState() {
    super.initState();
    product = widget.product;
  }

@override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF003366),
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(product.name, style: const TextStyle(color: Colors.white)),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => _showEditDialog(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Galerie d'images
            _buildImageCarousel(),
            const SizedBox(height: 24),

            // Section Informations de base
            _buildSectionHeader('Informations'),
            _buildInfoCard(
              children: [
                _buildInfoRow('Code', product.code),
                _buildInfoRow('Catégorie', product.category),
                _buildInfoRow('Variantes', '${product.variants}'),
                _buildInfoRow('Date d\'ajout', product.date),
              ],
            ),
            const SizedBox(height: 24),

            // Section Stock et Prix
            _buildSectionHeader('Stock & Prix'),
            _buildStockPriceCard(),
            const SizedBox(height: 24),

            // Section Description
            if (product.description != null && product.description!.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionHeader('Description'),
                  _buildDescriptionCard(),
                  const SizedBox(height: 24),
                ],
              ),

            // Boutons d'action
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.view_list, color: Color(0xFF003366)),
                    label: const Text('Gérer la variante', style: TextStyle(color: Color(0xFF003366))),
                    onPressed: () => _manageVariants(context),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.inventory, color: Colors.white),
                    label: const Text('Gérer Stock', style: TextStyle(color: Colors.white)),
                    onPressed: () => _manageStock(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF003366),
                      padding: const EdgeInsets.symmetric(vertical: 16),
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


    Widget _buildImageCarousel() {
    return Column(
      children: [
        CarouselSlider(
          options: CarouselOptions(
            height: 300,
            autoPlay: true,
            enlargeCenterPage: true,
            viewportFraction: 1,
          ),
          items: product.imagePaths!.map((imageUrl) {
            return Builder(
              builder: (BuildContext context) {
                return Container(
                  width: MediaQuery.of(context).size.width,
                  margin: const EdgeInsets.symmetric(horizontal: 1),
                  child: Image.asset(
                    product.imagePaths?[0] ?? 'assets/image/empty_promotion.png',
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(Icons.image_not_supported, color: Colors.grey);
                    },
                  )
                );
              },
            );
          }).toList(),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: product.imagePaths!.asMap().entries.map((entry) {
            return Container(
              width: 8,
              height: 8,
              margin: const EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                // ignore: deprecated_member_use
                color: Colors.grey.withOpacity(
                  entry.key == 0 ? 0.9 : 0.4,
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.blue,
        ),
      ),
    );
  }

  Widget _buildInfoCard({required List<Widget> children}) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: children,
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  Widget _buildStockPriceCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildStockPriceItem(
              icon: Icons.inventory,
              label: 'Stock',
              value: product.stock.toString(),
              color: product.stock > 0 ? Colors.green : Colors.red,
            ),
            _buildStockPriceItem(
              icon: Icons.attach_money,
              label: 'Prix unitaire',
              value: '${product.price.toStringAsFixed(2)} DH',
              color: Colors.blue,
            ),
            _buildStockPriceItem(
              icon: Icons.calculate,
              label: 'Valeur stock',
              value: '${(product.stock * product.price).toStringAsFixed(2)} DH',
              color: Colors.purple,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStockPriceItem({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Column(
      children: [
        Icon(icon, size: 30, color: color),
        const SizedBox(height: 8),
        Text(label, style: const TextStyle(fontSize: 12)),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildDescriptionCard() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Text(
          product.description ?? 'Description indisponible',
          style: const TextStyle(fontSize: 16, height: 1.5),
        ),
      ),
    );
  }

  void _showEditDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => EditProductScreen(
        product: product,
        onProductUpdated: (updatedProduct) {
          setState(() {
            product = updatedProduct; // Met à jour le produit dans la liste
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

  void _manageVariants(BuildContext context) {
  final TextEditingController newVariantController = TextEditingController();

  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Modifier le stock'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Variantes actuel: ${product.variants}'),
          const SizedBox(height: 16),
          TextFormField(
            controller: newVariantController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Nouvelle variante',
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Veuillez entrer une variante';
              }
              if (int.tryParse(value) == null) {
                return 'Veuillez entrer un nombre valide';
              }
              return null;
            },
      ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Annuler'),
        ),
        TextButton(
          onPressed: () {
            final newVariant = int.tryParse(newVariantController.text);
            if (newVariant != null) {
              product.variants = newVariant;
              setState(() {});

              // Afficher un message de confirmation
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Variante mis à jour : $newVariant'),
                  backgroundColor: Colors.green,
                  duration: const Duration(seconds: 3),
                ),
              );

              // Fermer la boîte de dialogue
              Navigator.pop(context);
            } else {
              // Afficher un message d'erreur si la quantité est invalide
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Quantité invalide'),
                  backgroundColor: Colors.red,
                  duration: Duration(seconds: 3),
                ),
              );
            }
          },
          child: const Text('Valider'),
        ),
      ],
    ),
  );
  
  }

void _manageStock(BuildContext context) {
  final TextEditingController newStockController = TextEditingController();

  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Modifier le stock'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Stock actuel: ${product.stock}'),
          const SizedBox(height: 16),
          TextFormField(
            controller: newStockController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Nouvelle quantité',
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Veuillez entrer une quantité';
              }
              if (int.tryParse(value) == null) {
                return 'Veuillez entrer un nombre valide';
              }
              return null;
            },
      ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Annuler'),
        ),
        TextButton(
          onPressed: () {
            final newStock = int.tryParse(newStockController.text);
            if (newStock != null) {
              // Mise à jour du stock du produit
              product.stock = newStock;
              setState(() {});

              // Afficher un message de confirmation
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Stock mis à jour : $newStock'),
                  backgroundColor: Colors.green,
                  duration: const Duration(seconds: 3),
                ),
              );

              // Fermer la boîte de dialogue
              Navigator.pop(context);
            } else {
              // Afficher un message d'erreur si la quantité est invalide
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Quantité invalide'),
                  backgroundColor: Colors.red,
                  duration: Duration(seconds: 3),
                ),
              );
            }
          },
          child: const Text('Valider'),
        ),
      ],
    ),
  );
}
  
}