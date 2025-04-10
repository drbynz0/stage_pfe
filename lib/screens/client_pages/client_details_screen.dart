import 'package:flutter/material.dart';
import '/models/client.dart';

class ClientDetailsScreen extends StatelessWidget {
  final Client client;

  const ClientDetailsScreen({super.key, required this.client});

  @override
  Widget build(BuildContext context) {
    // Exemple de données fictives pour les commandes et factures
    final List<Map<String, String>> commandes = [
      {'id': 'CMD001', 'date': '2025-04-01', 'montant': '150.00'},
      {'id': 'CMD002', 'date': '2025-04-05', 'montant': '200.00'},
    ];

    final List<Map<String, String>> factures = [
      {'id': 'FAC001', 'date': '2025-04-02', 'montant': '150.00'},
      {'id': 'FAC002', 'date': '2025-04-06', 'montant': '200.00'},
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF003366),
        title: const Text(
          'Détails du client',
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
              'Informations du client',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Color(0xFF003366),
              ),
            ),
            const SizedBox(height: 8),
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildDetailRow('Nom', client.name),
                    const SizedBox(height: 8),
                    _buildDetailRow('Email', client.email),
                    const SizedBox(height: 8),
                    _buildDetailRow('Téléphone', client.phone),
                    const SizedBox(height: 8),
                    _buildDetailRow('Adresse', client.address),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Commandes
            const Text(
              'Commandes',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Color(0xFF003366),
              ),
            ),
            const SizedBox(height: 8),
            _buildSectionList(commandes, 'Commande'),

            const SizedBox(height: 24),

            // Factures
            const Text(
              'Factures',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Color(0xFF003366),
              ),
            ),
            const SizedBox(height: 8),
            _buildSectionList(factures, 'Facture'),
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

  // Widget pour afficher une liste de commandes ou factures
  Widget _buildSectionList(List<Map<String, String>> items, String type) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
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
                type[0], // Première lettre du type (C pour Commande, F pour Facture)
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
            title: Text('$type ID : ${item['id']}'),
            subtitle: Text('Date : ${item['date']}'),
            trailing: Text(
              '${item['montant']} MAD',
              style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.green),
            ),
          ),
        );
      },
    );
  }
}