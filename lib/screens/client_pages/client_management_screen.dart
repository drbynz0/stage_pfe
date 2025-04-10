import 'package:flutter/material.dart';
import '/models/client.dart';
import 'add_client_screen.dart';
import 'edit_client_screen.dart';
import 'delete_client_screen.dart';
import 'client_details_screen.dart';
 // Import de la page des détails

class ClientManagementScreen extends StatefulWidget {
  const ClientManagementScreen({super.key});

  @override
  State<ClientManagementScreen> createState() => _ClientManagementScreenState();
}

class _ClientManagementScreenState extends State<ClientManagementScreen> {
  final List<Client> _clients = [
    Client(
      id: '1',
      name: 'Ahmed Amine',
      email: 'ahmed.amine@example.com',
      phone: '0600000000',
      address: 'Casablanca',
    ),
    Client(
      id: '2',
      name: 'Sara Idrissi',
      email: 'sara.idrissi@example.com',
      phone: '0611111111',
      address: 'Rabat',
    ),
  ];

  String _searchQuery = '';

  void _addClient(Client client) {
    setState(() {
      _clients.add(client);
    });
  }

  void _editClient(Client updatedClient) {
    setState(() {
      final index = _clients.indexWhere((c) => c.id == updatedClient.id);
      if (index != -1) {
        _clients[index] = updatedClient;
      }
    });
  }

  void _deleteClient(String clientId) {
    setState(() {
      _clients.removeWhere((c) => c.id == clientId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final filteredClients = _clients.where((client) {
      return client.name.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xFF003366),
        toolbarHeight: 10,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Barre de recherche
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    // ignore: deprecated_member_use
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Rechercher un client...',
                  hintStyle: const TextStyle(color: Colors.grey),
                  prefixIcon: const Icon(Icons.search, color: Colors.grey),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 14),
                ),
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value;
                  });
                },
              ),
            ),
            const SizedBox(height: 16),
            // Liste des clients
            Expanded(
              child: ListView.builder(
                itemCount: filteredClients.length,
                itemBuilder: (context, index) {
                  final client = filteredClients[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ClientDetailsScreen(client: client),
                        ),
                      );
                    },
                    child: Card(
                      elevation: 4,
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          children: [
                            // Badge avec les initiales du client
                            CircleAvatar(
                              radius: 30,
                              backgroundColor: const Color(0xFF004A99),
                              child: Text(
                                client.name[0], // Première lettre du nom
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            // Informations du client
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    client.name,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: Color(0xFF003366),
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    client.email,
                                    style: TextStyle(color: Colors.grey[700], fontSize: 13),
                                  ),
                                  Text(
                                    client.phone,
                                    style: TextStyle(color: Colors.grey[700], fontSize: 13),
                                  ),
                                  Text(
                                    client.address,
                                    style: TextStyle(color: Colors.grey[700], fontSize: 13),
                                  ),
                                ],
                              ),
                            ),
                            // Boutons d'action
                            Column(
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit, color: Color(0xFF004A99)),
                                  tooltip: 'Modifier',
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => EditClientScreen(
                                          client: client,
                                          onEditClient: _editClient,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete, color: Colors.red),
                                  tooltip: 'Supprimer',
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => DeleteClientScreen(
                                          client: client,
                                          onDeleteClient: _deleteClient,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddClientScreen(onAddClient: _addClient),
            ),
          );
        },
        backgroundColor: const Color(0xFF004A99),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}