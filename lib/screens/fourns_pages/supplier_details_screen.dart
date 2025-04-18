import 'package:flutter/material.dart';
import '/models/supplier.dart';
import '/models/external_order.dart';
import '../transactions_pages/details_external_order_screen.dart';

class SupplierDetailsScreen extends StatelessWidget {
  final Supplier supplier;
    final List<ExternalOrder> externalOrders;

  SupplierDetailsScreen({super.key, required this.supplier}) : externalOrders = ExternalOrder.getExternalOrderList();

  @override
  Widget build(BuildContext context) {
    // Filtrer les commandes du fournisseur
    final supplierOrders = externalOrders.where((order) => order.supplierId== supplier.ice).toList();

    // Calculer les statistiques des commandes
    final totalOrders = supplierOrders.length;
    final pendingOrders = supplierOrders.where((order) => order.status == OrderStatus.pending).length;
    final completedOrders = supplierOrders.where((order) => order.status == OrderStatus.completed).length;
    final processingOrders = supplierOrders.where((order) => order.status == OrderStatus.processing).length;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF003366),
        title: const Text(
          'Détails du Fournisseur',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white), // Flèche de retour en blanc
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Détails du client
            const Text(
              'Informations du Fournisseur',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Color(0xFF003366),
              ),
            ),
            const SizedBox(height: 8),
            Card(
              color: const Color.fromARGB(255, 194, 224, 240),
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildDetailRow('ICE', supplier.ice),
                    const SizedBox(height: 8,),
                    _buildDetailRow('Nom', supplier.name),
                    const SizedBox(height: 8),
                    _buildDetailRow('Email', supplier.email),
                    const SizedBox(height: 8),
                    _buildDetailRow('Téléphone', supplier.phone),
                    const SizedBox(height: 8),
                    _buildDetailRow('Adresse', supplier.address),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Carte récapitulative des commandes
            const Text(
              'Statistiques des Commandes',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Color(0xFF003366),
              ),
            ),
            const SizedBox(height: 8),
            Card(
              color: const Color.fromARGB(255, 207, 230, 244),
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStatCard('Total', totalOrders.toString(), Colors.blue),
                    _buildStatCard('En attente', pendingOrders.toString(), Colors.orange),
                    _buildStatCard('Traitement', processingOrders.toString(), Colors.yellow),
                    _buildStatCard('Complétées', completedOrders.toString(), Colors.green),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Liste des commandes
            const Text(
              'Commandes',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Color(0xFF003366),
              ),
            ),
            const SizedBox(height: 8),
            _buildOrdersList(supplierOrders),
          ],
        ),
      ),
    );
  }

   // Widget pour afficher une ligne de détail
  Widget _buildDetailRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$label : ',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: Colors.black87,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black54,
            ),
          ),
        ),
      ],
    );
  }

    // Widget pour afficher une carte statistique
  Widget _buildStatCard(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.black54,
          ),
        ),
      ],
    );
  }

  // Widget pour afficher la liste des commandes
  Widget _buildOrdersList(List<ExternalOrder> orders) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: orders.length,
      itemBuilder: (context, index) {
        final order = orders[index];
        return Card(
          elevation: 4,
          margin: const EdgeInsets.symmetric(vertical: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: const Color(0xFF004A99),
              child: Text(
                'C', // Première lettre de "Commande"
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
            title: Text('Commande ID : ${order.id}'),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Date : ${order.date}'),
                Text('Articles : ${order.items.length}'),
                Text(_getStatusText(order.status),
                    style: TextStyle(
                      color: order.status == OrderStatus.completed ? Colors.green : Colors.red,
                      fontWeight: FontWeight.bold,
                    )),
              ],
            ),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              // Action lors du clic sur une commande (par exemple, afficher les détails)
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetailsExternalOrderScreen(order: order),
                ),
              );
            },
          ),
        );
      },
    );
  }

    // Méthode pour obtenir le texte du statut
  String _getStatusText(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending:
        return 'En attente';
      case OrderStatus.processing:
        return 'En traitement';
      case OrderStatus.completed:
        return 'Terminée';
      case OrderStatus.cancelled:
        return 'Annulée';
      }
  }
}