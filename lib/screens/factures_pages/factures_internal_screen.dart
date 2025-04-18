import 'package:flutter/material.dart';
import '/models/factures.dart';
import '/models/internal_order.dart';
import 'details_facture_internal_screen.dart'; // Importez votre écran de détail

class FacturesInternalScreen extends StatefulWidget {
  const FacturesInternalScreen({super.key});

  @override
  FacturesInternalScreenState createState() => FacturesInternalScreenState();
}

class FacturesInternalScreenState extends State<FacturesInternalScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  List<FactureClient> internalFactures = FactureClient.getInternalFactures();
  List<InternalOrder> internalOrders = []; // Vous devez récupérer cette liste

  @override
  void initState() {
    super.initState();
    // Chargez vos commandes internes ici si nécessaire
    // internalOrders = InternalOrder.getInternalOrders();
  }

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
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ModernFactureDetailScreen(
          facture: facture,
          internalOrders: internalOrders, // Passez la liste des commandes
        ),
      ),
    );
  }
}