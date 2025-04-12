import 'package:flutter/material.dart';
import '/models/factures.dart';
import '/models/internal_order.dart';

class DetailsFactureInternalScreen extends StatelessWidget {
  final FactureClient facture;
  final List<InternalOrder> internalOrders; // Liste des commandes internes

  const DetailsFactureInternalScreen({
    super.key,
    required this.facture,
    required this.internalOrders,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Détails Facture Client'),
        backgroundColor: const Color(0xFF003366),
        actions: [
          IconButton(
            icon: const Icon(Icons.print),
            onPressed: () {
              // Fonctionnalité d'impression
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Impression en cours...')),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 30),
            _buildClientInfo(),
            const SizedBox(height: 30),
            _buildProductsTable(),
            const SizedBox(height: 30),
            _buildTotalSection(),
            const SizedBox(height: 30),
            _buildFooter(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Facture # ${facture.id}', 
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text('Date: ${facture.date}'),
          ],
        ),
        Image.asset('assets/logo.png', height: 60), // Remplacez par votre logo
      ],
    );
  }

  Widget _buildClientInfo() {
    return Card(
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('INFORMATIONS CLIENT', 
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const Divider(),
            Text('Nom: ${facture.clientName}'),
            Text('Identifiant: ${facture.clientId}'),
          ],
        ),
      ),
    );
  }

  Widget _buildProductsTable() {
    // Récupérer la commande interne correspondante
    final InternalOrder order = internalOrders.firstWhere(
      (o) => o.id == facture.orderId,
      orElse: () => InternalOrder.empty(),
    );

    return Card(
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            const Text('ARTICLES COMMANDÉS', 
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const Divider(),
            DataTable(
              columns: const [
                DataColumn(label: Text('Référence')),
                DataColumn(label: Text('Désignation')),
                DataColumn(label: Text('Qty')),
                DataColumn(label: Text('Prix Unitaire')),
                DataColumn(label: Text('Total')),
              ],
              rows: order.items.map((item) {
                return DataRow(cells: [
                  DataCell(Text(item.productId)),
                  DataCell(Text(item.productName)),
                  DataCell(Text(item.quantity.toString())),
                  DataCell(Text('${item.unitPrice.toStringAsFixed(2)} DH')),
                  DataCell(Text('${(item.quantity * item.unitPrice).toStringAsFixed(2)} DH')),
                ]);
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTotalSection() {
    return Align(
      alignment: Alignment.centerRight,
      child: Card(
        elevation: 3,
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('Sous Total: ${facture.amount.toStringAsFixed(2)} DH'),
              const Divider(),
              Text('TOTAL TTC: ${facture.amount.toStringAsFixed(2)} DH', 
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFooter() {
    return const Card(
      elevation: 3,
      child: Padding(
        padding: EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('CONDITIONS DE PAIEMENT', 
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            Divider(),
            Text('Paiement à réception de facture'),
            Text('Délai de paiement: 30 jours'),
            SizedBox(height: 10),
            Text('Merci pour votre confiance!'),
          ],
        ),
      ),
    );
  }
}