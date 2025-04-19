import 'package:flutter/material.dart';
import '/models/factures.dart';
import '/models/internal_order.dart';
import '/models/client.dart';

class ModernFactureDetailScreen extends StatelessWidget {
  final FactureClient facture;
  final List<InternalOrder> internalOrders;

  const ModernFactureDetailScreen({
    super.key,
    required this.facture,
    required this.internalOrders,
  });

  @override
  Widget build(BuildContext context) {
    final order = internalOrders.firstWhere(
      (o) => o.id == facture.orderId,
      orElse: () => InternalOrder.empty(),
    );

    final double totalHT = facture.amount;
    final double tva = totalHT * 0.20;
    final double totalTTC = totalHT + tva;
    final double paidAmount = order.paidPrice;
    final double remainingAmount = order.remainingPrice;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Détail Facture', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF003366),
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.print, color: Colors.white),
            onPressed: () => _printFacture(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _buildHeader(),
            const SizedBox(height: 24),
            _buildClientCard(),
            const SizedBox(height: 24),
            _buildProductList(order),
            const SizedBox(height: 24),
            _buildAmountSection(totalHT, tva, totalTTC),
            const SizedBox(height: 24),
            _buildPaymentStatus(paidAmount, remainingAmount),
            const SizedBox(height: 24),
            _buildFooter(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('FACTURE #${facture.id}',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text('Date: ${facture.date}', style: const TextStyle(color: Colors.grey)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildClientCard() {
        final order = internalOrders.firstWhere(
      (o) => o.id == facture.orderId,
      orElse: () => InternalOrder.empty(),
    );

    final client = Client.getClientById(order.clientId);

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('CLIENT',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF003366))),
            const Divider(),
            const SizedBox(height: 8),
            _buildInfoRow('Nom', facture.clientName),
            _buildInfoRow('ID Client', facture.clientId),
            _buildInfoRow('ICE', client.ice ?? 'N/A'),
            if (facture.clientAddress != null)
              _buildInfoRow('Adresse', facture.clientAddress!),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text('$label : ', style: const TextStyle(fontWeight: FontWeight.bold)),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  Widget _buildProductList(InternalOrder order) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('ARTICLES',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF003366))),
            const Divider(),
            const SizedBox(height: 8),
            ...order.items.map((item) => _buildProductItem(item)).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildProductItem(OrderItem item) {
    final total = item.unitPrice * item.quantity;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.productName, style: const TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text('Réf: ${item.productId}', style: const TextStyle(color: Colors.grey, fontSize: 12)),
              ],
            ),
          ),
          Expanded(
            child: Text('${item.quantity} x ${item.unitPrice.toStringAsFixed(2)}',
                textAlign: TextAlign.center),
          ),
          Expanded(
            child: Text('${total.toStringAsFixed(2)} DH',
                textAlign: TextAlign.right,
                style: const TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget _buildAmountSection(double totalHT, double tva, double totalTTC) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildAmountRow('Total HT:', totalHT),
            _buildAmountRow('TVA (20%):', tva),
            const Divider(thickness: 1.5),
            _buildAmountRow('TOTAL TTC:', totalTTC, isTotal: true),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentStatus(double paidAmount, double remainingAmount) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text('STATUT DE PAIEMENT',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF003366))),
            const Divider(),
            const SizedBox(height: 8),
            _buildAmountRow('Montant payé:', paidAmount),
            _buildAmountRow('Reste à payer:', remainingAmount),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: facture.isPaid ? Colors.green[50] : Colors.orange[50],
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                facture.isPaid ? 'FACTURE PAYÉE' : 'EN ATTENTE DE PAIEMENT',
                style: TextStyle(
                  color: facture.isPaid ? Colors.green : Colors.orange,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAmountRow(String label, double amount, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: TextStyle(
                fontSize: isTotal ? 16 : 14,
                fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              )),
          Text('${amount.toStringAsFixed(2)} DH',
              style: TextStyle(
                fontSize: isTotal ? 18 : 14,
                fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
                color: isTotal ? const Color(0xFF003366) : Colors.black,
              )),
        ],
      ),
    );
  }

  Widget _buildFooter() {
    return Column(
      children: [
        const Text('Merci pour votre confiance!', style: TextStyle(fontStyle: FontStyle.italic)),
        const SizedBox(height: 16),
        Text('Date d\'échéance: ${_calculateDueDate(facture.date)}',
            style: const TextStyle(color: Colors.grey)),
      ],
    );
  }

  String _calculateDueDate(String invoiceDate) {
    // Implémenter la logique de calcul réel si nécessaire
    return '30 jours après réception';
  }

  void _printFacture(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Impression en cours...')),
    );
  }
}
