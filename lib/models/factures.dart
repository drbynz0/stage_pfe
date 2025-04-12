class FactureClient {
  final String id;
  final String orderId;
  final String clientId;
  final String clientName;
  final double amount;
  final String date;
  final String description;
  final bool isInternal;

  FactureClient({
    required this.id,
    required this.orderId,
    required this.clientId,
    required this.clientName,
    required this.amount,
    required this.date,
    required this.description,
    required this.isInternal,
  });
  
  static List<FactureClient> internalFactures = [
      FactureClient(
        id: 'INT001',
        orderId: 'CMD001',
        clientId: 'C001',
        clientName: 'Client A',
        amount: 1200.50,
        date: '2025-04-10',
        description: 'Facture pour la commande interne INT001',
        isInternal: true,
      ),
      FactureClient(
        id: 'INT002',
        orderId: 'CMD002',
        clientId: 'C002',
        clientName: 'Client B',
        amount: 850.00,
        date: '2025-04-11',
        description: 'Facture pour la commande interne INT002',
        isInternal: true,
      ),
      FactureClient(
        id: 'INT003',
        orderId: 'CMD003',
        clientId: 'C003',
        clientName: 'Client C',
        amount: 500.00,
        date: '2025-04-12',
        description: 'Facture pour la commande interne INT003',
        isInternal: true,
      ),
      FactureClient(
        id: 'INT004',
        orderId: 'CMD004',
        clientId: 'C004',
        clientName: 'Client D',
        amount: 2000.00,
        date: '2025-04-13',
        description: 'Facture pour la commande interne INT004',
        isInternal: true,
      ),
      FactureClient(
        id: 'INT005',
        orderId: 'CMD005',
        clientId: 'C005',
        clientName: 'Client E',
        amount: 1500.00,
        date: '2025-04-14',
        description: 'Facture pour la commande interne INT005',
        isInternal: true,
      ),
      FactureClient(
        id: 'INT006',
        orderId: 'CMD006',
        clientId: 'C006',
        clientName: 'Client F',
        amount: 300.00,
        date: '2025-04-15',
        description: 'Facture pour la commande interne INT006',
        isInternal: true,
      ),
    ];




  // Exemple de données factices pour les commandes internes
  static List<FactureClient> getInternalFactures() {
    return internalFactures;
  }

  // Exemple de données factices pour les commandes externes

}

class FactureFournisseur {
  final String id;
  final String supplierId;
  final String supplierName;
  final double amount;
  final String date;
  final String description;
  final bool isInternal;

  FactureFournisseur({
    required this.id,
    required this.supplierId,
    required this.supplierName,
    required this.amount,
    required this.date,
    required this.description,
    required this.isInternal,
  });

    static List<FactureFournisseur> externalFactures = [
    FactureFournisseur(
      id: 'EXT001',
      supplierId: 'F001',
      supplierName: 'Fournisseur A',
      amount: 3000.75,
      date: '2025-04-09',
      description: 'Facture pour la commande externe EXT001',
      isInternal: false,
    ),
    FactureFournisseur(
      id: 'EXT002',
      supplierId: 'F002',
      supplierName: 'Fournisseur B',
      amount: 4500.00,
      date: '2025-04-10',
      description: 'Facture pour la commande externe EXT002',
      isInternal: false,
    ),
    FactureFournisseur(
      id: 'EXT003',
      supplierId: 'F003',
      supplierName: 'Fournisseur C',
      amount: 1200.50,
      date: '2025-04-11',
      description: 'Facture pour la commande externe EXT003',
      isInternal: false,
    ),
    FactureFournisseur(
      id: 'EXT004',
      supplierId: 'F004',
      supplierName: 'Fournisseur D',
      amount: 850.00,
      date: '2025-04-12',
      description: 'Facture pour la commande externe EXT004',
      isInternal: false,
    ),
    FactureFournisseur(
      id: 'EXT005',
      supplierId: 'F005',
      supplierName: 'Fournisseur E',
      amount: 500.00,
      date: '2025-04-13',
      description: 'Facture pour la commande externe EXT005',
      isInternal: false,
    ),
    FactureFournisseur(
      id: 'EXT006',
      supplierId: 'F006',
      supplierName: 'Fournisseur F',
      amount: 2000.00,
      date: '2025-04-14',
      description: 'Facture pour la commande externe EXT006',
      isInternal: false,
    ),
    FactureFournisseur(
      id: 'EXT007',
      supplierId: 'F007',
      supplierName: 'Fournisseur G',
      amount: 1500.00,
      date: '2025-04-15',
      description: 'Facture pour la commande externe EXT007',
      isInternal: false,
    ),
    FactureFournisseur(
      id: 'EXT008',
      supplierId: 'F008',
      supplierName: 'Fournisseur H',
      amount: 300.00,
      date: '2025-04-16',
      description: 'Facture pour la commande externe EXT008',
      isInternal: false,
    ),
    FactureFournisseur(
      id: 'EXT009',
      supplierId: 'F009',
      supplierName: 'Fournisseur I',
      amount: 1000.00,
      date: '2025-04-17',
      description: 'Facture pour la commande externe EXT009',
      isInternal: false,
    ),
    FactureFournisseur(
      id: 'EXT010',
      supplierId: 'F010',
      supplierName: 'Fournisseur J',
      amount: 2500.00,
      date: '2025-04-18',
      description: 'Facture pour la commande externe EXT010',
      isInternal: false,
    ),
  ];

    static List<FactureFournisseur> getExternalFactures() {
    return externalFactures;
  }
}