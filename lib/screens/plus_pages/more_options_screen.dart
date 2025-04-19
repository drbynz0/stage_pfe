import 'package:flutter/material.dart';
import '../discounts_pages/discounts_management.dart';
import '../factures_pages/factures_management_screen.dart';
import '../fourns_pages/suppliers_management_screen.dart';
import '../stats/stats.dart';
import '/models/internal_order.dart';
import '/models/external_order.dart';
import '/models/product.dart';

class MoreOptionsScreen extends StatelessWidget {
  const MoreOptionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> options = [
      {'icon': Icons.percent, 'label': 'Discounts'},
      {'icon': Icons.local_shipping, 'label': 'Fournisseurs'},
      {'icon': Icons.bar_chart, 'label': 'Stats'},
      {'icon': Icons.receipt_long, 'label': 'Factures'},
      {'icon': Icons.assignment, 'label': 'Bon à délivrer'},
    ];

    return Scaffold(
      body: _buildBody(options, context),
    );
  }

  Widget _buildBody(List<Map<String, dynamic>> options, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0), // Espacement autour de la liste
      child: ListView.builder(
        itemCount: options.length,
        itemBuilder: (context, index) {
          return _buildListTile(options[index], context);
        },
      ),
    );
  }

  Widget _buildListTile(Map<String, dynamic> option, BuildContext context) {
    return Card(
      color: const Color.fromARGB(255, 194, 224, 240),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16), // Coins arrondis pour un effet moderne
      ),
      elevation: 5, // Ombre pour un effet de profondeur
      margin: const EdgeInsets.symmetric(vertical: 8.0), // Espacement entre les cartes
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0), // Espacement interne
        leading: CircleAvatar(
          radius: 24, // Plus grand pour un meilleur effet visuel
          backgroundColor: Colors.blue.shade50,
          child: Icon(option['icon'], color: Colors.blue.shade900, size: 28), // Icône avec plus de visibilité
        ),
        title: Text(
          option['label'],
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
            color: Colors.blue.shade900, // Texte en bleu foncé pour mieux ressortir
          ),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          size: 18,
          color: Colors.blue, // Changer la couleur de l'icône de droite
        ),
        onTap: () {
          _handleOptionTap(option['label'], context);
        },
      ),
    );
  }

  void _handleOptionTap(String label, BuildContext context) {
    if (label == 'Discounts') {
      // Naviguer vers la page DiscountsManagementScreen
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const DiscountsManagementScreen(),
        ),
      );
    } else if (label == 'Factures') {
      // Afficher un SnackBar pour la page Factures
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const FacturesManagementScreen(),
        ),
      );
    } else if (label == 'Fournisseurs') {
      // Naviguer vers la page SuppliersManagementScreen
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const SuppliersManagementScreen(),
        ),
      );
    } else if (label == 'Stats') {
      Navigator.push(
        context, 
        MaterialPageRoute(
          builder: (context) => StatsPage(
            internalOrders: InternalOrder.getInternalOrderList(),
            externalOrders: ExternalOrder.getExternalOrderList(),
            allProducts: Product.getProducts(),
          ),
        ),
      );
    } else if (label == 'Bon à délivrer') {
      // Afficher un SnackBar pour la page Bon à délivrer
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('$label cliqué')),
      );

    } else {
      // Afficher un SnackBar pour les autres options
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('$label cliqué')),
      );
    }
  }
}