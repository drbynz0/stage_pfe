import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '/models/discounts.dart';
import '/models/product.dart';
import 'edit_discounts.dart';
import '/services/share_discount_service.dart';

class DetailsDiscountScreen extends StatefulWidget {
  final Discount discount;
  final Product product;

  const DetailsDiscountScreen({
    super.key,
    required this.discount,
    required this.product,
  });

  @override
  State<DetailsDiscountScreen> createState() => _DetailsDiscountScreenState();
}

class _DetailsDiscountScreenState extends State<DetailsDiscountScreen> {
  late Discount discount;
  late Product product;

  @override
  void initState() {
    super.initState();
    discount = widget.discount;
    product = widget.product;
  }

  void _showEditDiscountDialog() {
    showDialog(
      context: context,
      builder: (context) => EditDiscountScreen(
        discount: discount,
        onEditDiscount: (updatedDiscount) {
          setState(() {
            discount = updatedDiscount;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Promotion mise à jour avec succès'),
              backgroundColor: Colors.green,
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final discountPercentage = ((discount.normalPrice - discount.promotionPrice) / 
                             discount.normalPrice * 100).round();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Détails de la Promotion',
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: const Color(0xFF003366),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: _showEditDiscountDialog,
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildImageCarousel(),
                  _buildProductInfoSection(discountPercentage),
                ],
              ),
            ),
          ),
          _buildActionButtons(),
        ],
      ),
    );
  }

  Widget _buildImageCarousel() {
    final images = product.imagePaths ?? [];
    final hasImages = images.isNotEmpty;

    return Column(
      children: [
        CarouselSlider(
          options: CarouselOptions(
            height: 300,
            autoPlay: true,
            enlargeCenterPage: true,
            viewportFraction: 1,
          ),
          items: hasImages 
              ? images.map((imageUrl) => _buildImageItem(imageUrl)).toList()
              : [_buildPlaceholderItem()],
        ),
        if (hasImages) 
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: images.asMap().entries.map((entry) => 
              _buildCarouselIndicator(entry.key == 0)
            ).toList(),
          ),
      ],
    );
  }

  Widget _buildImageItem(String imageUrl) {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.symmetric(horizontal: 1),
      child: Image.asset(
        imageUrl,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _buildPlaceholderItem(),
      ),
    );
  }

  Widget _buildPlaceholderItem() {
    return Container(
      color: Colors.grey[200],
      child: const Center(
        child: Icon(Icons.image_not_supported, size: 50, color: Colors.grey),
      ),
    );
  }

  Widget _buildCarouselIndicator(bool isActive) {
    return Container(
      width: 8,
      height: 8,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        // ignore: deprecated_member_use
        color: Colors.grey.withOpacity(isActive ? 0.9 : 0.4),
      ),
    );
  }

  Widget _buildProductInfoSection(int discountPercentage) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
          
          _buildPriceSection(discountPercentage),
          const SizedBox(height: 24),
          
          _buildPromotionDetailsSection(),
          const SizedBox(height: 16),
          
          _buildValiditySection(),
          const SizedBox(height: 16),
          
          _buildProductDetailsSection(),
        ],
      ),
    );
  }

  Widget _buildPriceSection(int discountPercentage) {
    return Wrap(
      spacing: 16,
      runSpacing: 8,
      children: [
        Text(
          '${discount.promotionPrice.toStringAsFixed(2)} MAD',
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.red,
          ),
        ),
        Text(
          '${discount.normalPrice.toStringAsFixed(2)} MAD',
          style: TextStyle(
            fontSize: 28,
            color: Colors.grey[600],
            decoration: TextDecoration.lineThrough,
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
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
    );
  }

  Widget _buildPromotionDetailsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
      ],
    );
  }

  Widget _buildValiditySection() {
    return _buildInfoRow(
      icon: Icons.calendar_today,
      label: 'Validité :',
      value: discount.validity,
    );
  }

  Widget _buildProductDetailsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
            'Description',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Text(
              product.description!,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
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
            style: TextStyle(color: Colors.grey[600]),
          ),
          const SizedBox(width: 8),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                icon: const Icon(Icons.link, color: Colors.black),
                label: const Text(
                  'Voir dans le site',
                  style: TextStyle(color: Colors.black),
                ),
                onPressed: () {
                  // Action pour voir dans le site
                },
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
            const SizedBox(width: 16),
        Expanded(
          child: ElevatedButton.icon(
            icon: const Icon(Icons.share, color: Colors.white),
            label: const Text(
              'Partager',
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () async {
              try {
                await ShareDiscountService.showShareOptions(
                  context: context,
                  discount: discount,
                  product: product,
                  imagePath: product.imagePaths?.isNotEmpty == true 
                      ? product.imagePaths!.first 
                      : null,
                );
              } catch (e) {
                // ignore: use_build_context_synchronously
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Erreur lors du partage: ${e.toString()}'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              backgroundColor: const Color(0xFF004A99),
            ),
          ),
        ),
          ],
        ),
      ),
    );
  }
} 