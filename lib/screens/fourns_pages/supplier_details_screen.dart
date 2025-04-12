import 'package:flutter/material.dart';
import '/models/supplier.dart';

class SupplierDetailsScreen extends StatelessWidget {
  final Supplier supplier;

  const SupplierDetailsScreen({super.key, required this.supplier});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Détails du fournisseur',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF004A99), // Couleur de l'AppBar
        iconTheme: const IconThemeData(color: Colors.white), // Icônes en blanc
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Nom du fournisseur
            _buildDetailRow(
              icon: Icons.person,
              label: 'Nom',
              value: supplier.name,
            ),
            const SizedBox(height: 16),

            // Email
            _buildDetailRow(
              icon: Icons.email,
              label: 'Email',
              value: supplier.email,
            ),
            const SizedBox(height: 16),

            // Téléphone
            _buildDetailRow(
              icon: Icons.phone,
              label: 'Téléphone',
              value: supplier.phone,
            ),
            const SizedBox(height: 16),

            // Adresse
            _buildDetailRow(
              icon: Icons.location_on,
              label: 'Adresse',
              value: supplier.address,
            ),
            const SizedBox(height: 16),

            // Entreprise
            _buildDetailRow(
              icon: Icons.business,
              label: 'Entreprise',
              value: supplier.company,
            ),
            const SizedBox(height: 16),

            // Produits fournis (si applicable)
            if (supplier.products.isNotEmpty) ...[
              const Text(
                'Produits fournis',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: supplier.products
                    .map((product) => Chip(
                          label: Text(product),
                          backgroundColor: Colors.blue.shade100,
                        ))
                    .toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: const Color(0xFF004A99), size: 28),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}