import 'package:flutter/material.dart';
import '/models/factures.dart';

class FacturesExternalScreen extends StatefulWidget {
  const FacturesExternalScreen({super.key});

  @override
  FacturesExternalScreenState createState() => FacturesExternalScreenState();
}

class FacturesExternalScreenState extends State<FacturesExternalScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  List<FactureFournisseur> externalFactures = FactureFournisseur.getExternalFactures();

  List<FactureFournisseur> _filterFactures(List<FactureFournisseur> factures) {
    return factures.where((facture) {
      return facture.supplierName.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final filteredFactures = _filterFactures(externalFactures);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          TextField(
            controller: _searchController,
            decoration: const InputDecoration(
              labelText: 'Rechercher par nom du fournisseur',
              border: OutlineInputBorder(),
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
                    title: Text(facture.supplierName),
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

  void _showFactureDetails(FactureFournisseur facture) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Détails de la Facture'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Fournisseur: ${facture.supplierName}'),
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