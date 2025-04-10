import 'package:flutter/material.dart';
import '../../models/product.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'edit_product_screen.dart';


class DetailsProductScreen extends StatelessWidget {
  final Product product;

  const DetailsProductScreen({super.key, required this.product});

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
            _buildImageGallery(),
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
                    icon: const Icon(Icons.barcode_reader),
                    label: const Text('Scanner'),
                    onPressed: () => _scanBarcode(context),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.inventory),
                    label: const Text('Gérer Stock'),
                    onPressed: () => _manageStock(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
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

  Widget _buildImageGallery() {
    return SizedBox(
      height: 250,
      child: PageView.builder(
        itemCount: product.imagePaths?.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: product.imagePaths![index].startsWith('http')
                  ? CachedNetworkImage(
                      imageUrl: product.imagePaths![index],
                      fit: BoxFit.cover,
                      placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                      errorWidget: (context, url, error) => const Icon(Icons.error),
                    )
                  : Image.asset(
                      product.imagePaths![index],
                      fit: BoxFit.cover,
                    ),
            ),
          );
        },
      ),
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
              value: product.stock.toStringAsFixed(2),
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
          product.description!.join('\n\n'),
          style: const TextStyle(fontSize: 16),
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
            updatedProduct;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Produit mis à jour avec succès'), duration: const Duration(seconds: 3), backgroundColor: Colors.green,),
          );
        },
      ),
    );
  }

  void _scanBarcode(BuildContext context) {
    // Implémentez le scan de code-barres
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Fonctionnalité de scan à implémenter')),
    );
  }

  void _manageStock(BuildContext context) {
    // Implémentez la gestion du stock
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
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Nouvelle quantité',
                border: OutlineInputBorder(),
              ),
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
              // Sauvegarder la nouvelle quantité
              Navigator.pop(context);
            },
            child: const Text('Valider'),
          ),
        ],
      ),
    );
  }
}