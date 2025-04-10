import 'package:flutter/material.dart';
import '/models/discounts.dart';

class DeleteDiscountScreen extends StatelessWidget {
  final Discount discount;
  final Function(String) onDeleteDiscount;

  const DeleteDiscountScreen({
    super.key,
    required this.discount,
    required this.onDeleteDiscount,
  });

  void _confirmDelete(BuildContext context) {
    onDeleteDiscount(discount.id);
    Navigator.pop(context); // Retour à l'écran précédent après suppression
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Supprimer le Discount'),
        backgroundColor: const Color(0xFF003366),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(
              Icons.warning,
              color: Colors.red,
              size: 80,
            ),
            const SizedBox(height: 20),
            Text(
              'Êtes-vous sûr de vouloir supprimer ce discount ?',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Text(
              'Titre : ${discount.title}',
              style: const TextStyle(fontSize: 16),
            ),
            Text(
              'Produit : ${discount.productName}',
              style: const TextStyle(fontSize: 16),
            ),
            Text(
              'Prix normal : ${discount.normalPrice} MAD',
              style: const TextStyle(fontSize: 16),
            ),
            Text(
              'Prix promotionnel : ${discount.promotionPrice} MAD',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () => Navigator.pop(context), // Annuler la suppression
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
                  child: const Text('Annuler'),
                ),
                ElevatedButton(
                  onPressed: () => _confirmDelete(context), // Confirmer la suppression
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  child: const Text('Supprimer'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}