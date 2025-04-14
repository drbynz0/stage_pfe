import 'package:flutter/material.dart';
import '/models/discounts.dart';
import '/models/product.dart';
import 'package:carousel_slider/carousel_slider.dart';

class DetailsDiscountScreen extends StatelessWidget {
  final Discount discount;
  final Product product; // Produit associé récupéré via l'ID du discount

  const DetailsDiscountScreen({
    super.key,
    required this.discount,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    final discountPercentage = ((discount.normalPrice - discount.promotionPrice) / 
                             discount.normalPrice * 100).round();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Détails de la Promotion', 
            style: TextStyle(fontSize: 20, color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: const Color(0xFF003366),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              // Fonctionnalité de partage
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Carrousel d'images
            _buildImageCarousel(),
            
            // Section informations produit
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Nom et catégorie
                  Text(
                    product.name,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    product.category,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Prix et promotion
                  Row(
                    children: [
                      Text(
                        '${discount.promotionPrice.toStringAsFixed(2)} MAD',
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Text(
                        '${discount.normalPrice.toStringAsFixed(2)} MAD',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.grey[600],
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          // ignore: deprecated_member_use
                          color: Colors.red.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          '-$discountPercentage%',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  
                  // Détails de la promotion
                  const Text(
                    'Détails de la Promotion',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    discount.description,
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 16),
                  
                  // Période de validité
                  _buildInfoRow(
                    icon: Icons.calendar_today,
                    label: 'Valide jusqu\'au',
                    value: discount.validity,
                  ),
                  const SizedBox(height: 16),
                  
                  // Détails du produit
                  const Text(
                    'Caractéristiques du Produit',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildInfoRow(
                    icon: Icons.code,
                    label: 'Référence',
                    value: product.code,
                  ),
                  _buildInfoRow(
                    icon: Icons.category,
                    label: 'Catégorie',
                    value: product.category,
                  ),
                  _buildInfoRow(
                    icon: Icons.inventory,
                    label: 'Stock disponible',
                    value: '${product.stock} unités',
                  ),
                  if (product.description != null && product.description!.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    const Text(
                      'Spécifications techniques',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Text(
                          product.description ?? '',
                          style: const TextStyle(fontSize: 16),
                          ),
                      ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildActionButtons(),
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

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey[600]),
          const SizedBox(width: 12),
          Text(
            label,
            style: TextStyle(
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(width: 8),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton.icon(
              icon: const Icon(Icons.shopping_cart),
              label: const Text('Ajouter au panier'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: Colors.orange,
              ),
              onPressed: () {
                // Ajouter au panier
              },
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: ElevatedButton.icon(
              icon: const Icon(Icons.attach_money),
              label: const Text('Acheter maintenant'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: Colors.green,
              ),
              onPressed: () {
                // Procéder au paiement
              },
            ),
          ),
        ],
      ),
    );
  }
}