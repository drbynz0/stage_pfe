import 'package:flutter/material.dart';
import '/models/factures.dart';

class FacturesInternalScreen extends StatefulWidget {
  const FacturesInternalScreen({super.key});

  @override
  FacturesInternalScreenState createState() => FacturesInternalScreenState();
}

class FacturesInternalScreenState extends State<FacturesInternalScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  List<FactureClient> internalFactures = FactureClient.getInternalFactures();

  List<FactureClient> _filterFactures(List<FactureClient> factures) {
    return factures.where((facture) {
      return facture.clientName.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final filteredFactures = _filterFactures(internalFactures);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          TextField(
            controller: _searchController,
            decoration: const InputDecoration(
              labelText: 'Rechercher par nom du client',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(30)),
              ),
              prefixIcon: Icon(Icons.search),
            ),
            onChanged: (value) {
              setState(() {
                _searchQuery = value;
              });
            },
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: filteredFactures.length,
              itemBuilder: (context, index) {
                final facture = filteredFactures[index];
                return Card(
                  color: const Color.fromARGB(255, 194, 224, 240),
                  margin: const EdgeInsets.symmetric(vertical: 4),
                  child: ListTile(
                    title: Text(facture.clientName),
                    subtitle: Text('Montant: ${facture.amount.toStringAsFixed(2)} DH'),
                    trailing: Text(facture.date),
                    onTap: () => _showFactureDetails(facture),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showFactureDetails(FactureClient facture) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Détails de la Facture'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Client: ${facture.clientName}'),
            Text('Montant: ${facture.amount.toStringAsFixed(2)} DH'),
            Text('Date: ${facture.date}'),
            Text('Description: ${facture.description}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Fermer'),
          ),
        ],
      ),
    );
  }
}