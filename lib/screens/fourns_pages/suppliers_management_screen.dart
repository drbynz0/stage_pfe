import 'package:flutter/material.dart';
import '/models/supplier.dart';
import 'add_supplier_screen.dart' as add_screen;
import 'edit_supplier_screen.dart' as edit_screen;
import 'delete_supplier_screen.dart';
import 'supplier_details_screen.dart'; // Import de la page des détails du fournisseur

class SuppliersManagementScreen extends StatefulWidget {
  const SuppliersManagementScreen({super.key});

  @override
  State<SuppliersManagementScreen> createState() => _SuppliersManagementScreenState();
}

class _SuppliersManagementScreenState extends State<SuppliersManagementScreen> {
  final List<Supplier> _suppliers = Supplier.listSuppliers;
  int _currentPage = 1;
  final int _itemsPerPage = 5;

  void _addSupplier(Supplier supplier) {
    setState(() => _suppliers.add(supplier));
  }

  void _editSupplier(Supplier updatedSupplier) {
    setState(() {
      final index = _suppliers.indexWhere((s) => s.id == updatedSupplier.id);
      if (index != -1) _suppliers[index] = updatedSupplier;
    });
  }

  void _deleteSupplier(String id) {
    setState(() => _suppliers.removeWhere((s) => s.id == id));
  }

  List<Supplier> get paginatedSuppliers {
    int startIndex = (_currentPage - 1) * _itemsPerPage;
    int endIndex = startIndex + _itemsPerPage;
    endIndex = endIndex > _suppliers.length ? _suppliers.length : endIndex;
    return _suppliers.sublist(startIndex, endIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Gestion des Fournisseurs',
          style: TextStyle(color: Colors.white), // Texte en blanc
        ),
        backgroundColor: const Color(0xFF004A99), // Couleur de la barre en bleu
        iconTheme: const IconThemeData(color: Colors.white), // Icônes en blanc
        elevation: 4, // Ombre sous l'AppBar
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView.builder(
                itemCount: paginatedSuppliers.length,
                itemBuilder: (context, index) {
                  final supplier = paginatedSuppliers[index];
                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16), // Coins arrondis
                    ),
                    elevation: 4, // Ombre pour un effet de profondeur
                    margin: const EdgeInsets.symmetric(vertical: 8.0), // Espacement entre les cartes
                    child: InkWell(
                      onTap: () => _navigateToDetailsScreen(context, supplier), // Lien vers les détails
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          children: [
                            // Badge avec les initiales du fournisseur
                            CircleAvatar(
                              radius: 30,
                              backgroundColor: const Color(0xFF004A99),
                              child: Text(
                                supplier.name[0].toUpperCase(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            // Informations du fournisseur
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    supplier.name,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: Colors.black, // Couleur du titre en noir
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    supplier.company,
                                    style: TextStyle(color: Colors.grey[700], fontSize: 14),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    supplier.phone,
                                    style: TextStyle(color: Colors.grey[700], fontSize: 14),
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
                                  onPressed: () => _navigateToEditScreen(context, supplier),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete, color: Colors.red),
                                  tooltip: 'Supprimer',
                                  onPressed: () => _showDeleteDialog(context, supplier.id),
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
          ),
          // Pagination
          Container(
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              border: Border(top: BorderSide(color: Colors.grey.shade300)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${_suppliers.length} fournisseurs',
                  style: TextStyle(color: Colors.grey[600]),
                ),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: _currentPage > 1
                          ? () => setState(() => _currentPage--)
                          : null,
                    ),
                    Text(
                      'Page $_currentPage/${(_suppliers.length / _itemsPerPage).ceil()}',
                    ),
                    IconButton(
                      icon: const Icon(Icons.arrow_forward),
                      onPressed: _currentPage < (_suppliers.length / _itemsPerPage).ceil()
                          ? () => setState(() => _currentPage++)
                          : null,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 55.0), // Ajustez la valeur pour déplacer le bouton vers le haut
        child: FloatingActionButton(
          onPressed: () => _navigateToAddScreen(context),
          backgroundColor: const Color(0xFF004A99),
          child: const Icon(Icons.add, color: Colors.white),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked, // Positionne le bouton à droite
    );
  }

  void _navigateToAddScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => add_screen.AddSupplierScreen(onAddSupplier: _addSupplier),
      ),
    );
  }

  void _navigateToEditScreen(BuildContext context, Supplier supplier) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => edit_screen.EditSupplierScreen(
          supplier: supplier,
          onEditSupplier: _editSupplier,
        ),
      ),
    );
  }

  void _navigateToDetailsScreen(BuildContext context, Supplier supplier) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SupplierDetailsScreen(supplier: supplier),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, String id) {
    showDialog(
      context: context,
      builder: (context) => DeleteSupplierScreen(
        onDelete: () => _deleteSupplier(id),
      ),
    );
  }
}