import 'package:flutter/material.dart';
import '../../models/internal_order.dart';
import '/models/client.dart';
import '../client_pages/client_details_screen.dart';

class DetailsInternalOrderScreen extends StatefulWidget {
  final InternalOrder order;

  const DetailsInternalOrderScreen({super.key, required this.order});

  @override
  DetailsInternalOrderScreenState createState() => DetailsInternalOrderScreenState();
}

class DetailsInternalOrderScreenState extends State<DetailsInternalOrderScreen> {
  late InternalOrder order;
  final List<Client> _clients = Client.getClients();


  @override
  void initState() {
    super.initState();
    order = widget.order;
  }

  

  @override
  Widget build(BuildContext context) {
    final totalPrice = order.items.fold(0.0, (sum, item) => sum + (item.unitPrice * item.quantity));

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF003366),
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text('Commande de ${order.clientName}', style: const TextStyle(color: Colors.white)),
        actions: [
          IconButton(
            icon: const Icon(Icons.print),
            onPressed: () => _printOrder(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section Informations Client
            _buildSectionHeader('Informations Client'),
            InkWell(
              onTap: () {
                // Naviguer vers la page des détails du client
                final client = _clients.firstWhere((c) => c.id == order.clientId, orElse: () => Client.empty());
                if (client != Client.empty()) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ClientDetailsScreen(client: client, internalOrders: [],),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Client introuvable')),
                  );
                }
              },
              child: _buildInfoCard(
                children: [
                  _buildInfoRow('Nom', order.clientName),
                  _buildInfoRow('Date', _formatDate(order.date)),
                  _buildInfoRow('Statut', _getStatusText(order.status)),
                  _buildInfoRow('Moyen de paiement', _getPaymentMethodText(order.paymentMethod)),
                ],
              ),
            ),
            const SizedBox(height: 24),

            //Section Prix
            _buildSectionHeader('Prix'),
            _buildAllPrice(),
            const SizedBox(height: 24),

            // Section Articles
            _buildSectionHeader('Articles (${order.items.length})'),
            ...order.items.map((item) => _buildOrderItemCard(item)),
            const SizedBox(height: 16),

            // Section Total
            _buildDescriptionCard(totalPrice),
            const SizedBox(height: 24),

            // Boutons d'action
            if (order.status == OrderStatus.pending || order.status == OrderStatus.processing)
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => _changeOrderStatus(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 41, 160, 220),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text('Modifier Statut', style: TextStyle(color: Colors.white)),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => _sendReceipt(context),
                      style: OutlinedButton.styleFrom(
                        backgroundColor: const Color(0xFF004A99),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text('Voir Facture', style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Color(0xFF003366),
        ),
      ),
    );
  }

  Widget _buildInfoCard({required List<Widget> children}) {
    return Card(
      color: const Color.fromARGB(255, 194, 224, 240),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: children,
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  Widget _buildOrderItemCard(OrderItem item) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: Colors.blue[50],
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(Icons.shopping_bag, color: Colors.blue),
        ),
        title: Text(item.productName, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Quantité: ${item.quantity}'),
            Text('Prix unitaire: ${item.unitPrice.toStringAsFixed(2)} DH'),
          ],
        ),
        trailing: Text(
          '${(item.quantity * item.unitPrice).toStringAsFixed(2)} DH',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildDescriptionCard(double total) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: SizedBox(
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Description', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF003366))),
              const SizedBox(height: 8),
              Text(
                order.description != null && order.description!.isNotEmpty
                    ? order.description!
                    : 'Aucune description',
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      )
    );
  }

    Widget _buildAllPrice() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildAllPriceItem(
              icon: Icons.attach_money,
              label: 'Prix total',
              value: '${order.totalPrice.toStringAsFixed(2)} DH',
              color: Colors.green,
            ),
            _buildAllPriceItem(
              icon: Icons.payments,
              label: 'Prix payé',
              value: '${order.paidPrice.toStringAsFixed(2)} DH',
              color: Colors.blue,
            ),
            _buildAllPriceItem(
              icon: Icons.pending_actions,
              label: 'Prix restant',
              value: '${order.remainingPrice.toStringAsFixed(2)} DH',
              color: Colors.red,
            ),
          ],
        ),
      ),
    );
  }

    Widget _buildAllPriceItem({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Column(
      children: [
        Icon(icon, size: 30, color: color),
        const SizedBox(height: 8),
        Text(label, style: const TextStyle(fontSize: 12)),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} à ${date.hour}h${date.minute.toString().padLeft(2, '0')}';
  }

  String _getStatusText(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending: return 'En attente';
      case OrderStatus.processing: return 'En traitement';
      case OrderStatus.completed: return 'Terminée';
      case OrderStatus.cancelled: return 'Annulée';
    }
  }

  String _getPaymentMethodText(PaymentMethod method) {
    switch (method) {
      case PaymentMethod.cash: return 'Espèces';
      case PaymentMethod.card: return 'Carte bancaire';
      case PaymentMethod.virement: return 'Virement';
      case PaymentMethod.cheque: return 'Chèque';
    }
  }

  void _printOrder(BuildContext context) {
    // Implémentez l'impression ici
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Impression de la commande...')),
    );
  }

  void _changeOrderStatus(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Modifier le statut'),
        content: DropdownButtonFormField<OrderStatus>(
          decoration: const InputDecoration(
            labelText: 'Sélectionnez le statut',
            border: OutlineInputBorder(),
          ),
          value: order.status,
          items: OrderStatus.values.map((status) {
            return DropdownMenuItem(
              value: status,
              child: Text(_getStatusText(status)),
            );
          }).toList(),
          onChanged: (newStatus) {
            if (newStatus != null) {
              if (newStatus == OrderStatus.completed || newStatus == OrderStatus.cancelled) {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Confirmation'),
                    content: Text(
                      newStatus == OrderStatus.completed
                          ? 'Êtes-vous sûr de vouloir marquer cette commande comme "Terminée"? Cette action est irréversible.'
                          : 'Êtes-vous sûr de vouloir marquer cette commande comme "Annulée"? Cette action est irréversible.',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context), // Fermer la boîte de dialogue
                        child: const Text('Annuler'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            order.status = newStatus;
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Statut mis à jour en ${_getStatusText(newStatus)}'),
                              backgroundColor: Colors.green,
                            ),
                          );
                          Navigator.pop(context);
                          Navigator.pop(context, order); // Retourner la commande mise à jour
                          },
                        child: const Text('Confirmer'),
                      ),
                    ],
                  ),
                );
              } else {
                setState(() {
                  order.status = newStatus;
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Statut mis à jour en ${_getStatusText(newStatus)}'),
                    backgroundColor: Colors.green,
                  ),
                );
                Navigator.pop(context); // Fermer la boîte de confirmation
                Navigator.pop(context, order); // Retourner la commande mise à jour
              }
            }
          },
        ),
      ),
    );
  }

  void _sendReceipt(BuildContext context) {
    // Implémentez l'envoi de facture
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Facture envoyée au client')),
    );
  }
}