class Supplier {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String address;
  final List<String> products;
  final String company;
  final String paymentTerms;

  Supplier({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.address,
    required this.products,
    required this.company,
    required this.paymentTerms,
  });

  // Méthode statique pour obtenir la liste initiale
  static List<Supplier> get listSuppliers {
    return [
      Supplier(
        id: '1',
        name: 'Mohamed Kassi',
        email: 'contact@kassientreprise.ma',
        phone: '0522445566',
        address: 'Zone Industrielle, Casablanca',
        products: ['Ciment', 'Briques', 'Carreaux'],
        company: 'Kassi Entreprise',
        paymentTerms: '30 jours',
      ),
      Supplier(
        id: '2',
        name: 'Fatima Zahra',
        email: 'fz@materiaux-premium.ma',
        phone: '0522889977',
        address: 'Ain Sebaa, Casablanca',
        products: ['Peinture', 'Revêtements', 'Isolation'],
        company: 'Matériaux Premium',
        paymentTerms: '45 jours',
      ),
      Supplier(
        id: '3',
        name: 'Karim El Fassi',
        email: 'k.fassi@batimetal.ma',
        phone: '0522334455',
        address: 'Sidi Maarouf, Casablanca',
        products: ['Métaux', 'Tôles', 'Profilés'],
        company: 'BatiMetal',
        paymentTerms: '60 jours',
      ),
    ];
  }

  factory Supplier.fromMap(Map<String, dynamic> map) {
    return Supplier(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      phone: map['phone'] ?? '',
      address: map['address'] ?? '',
      products: List<String>.from(map['products'] ?? []),
      company: map['company'] ?? '',
      paymentTerms: map['paymentTerms'] ?? '30 jours',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'address': address,
      'products': products,
      'company': company,
      'paymentTerms': paymentTerms,
    };
  }

  Supplier copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? address,
    List<String>? products,
    String? company,
    String? paymentTerms,
  }) {
    return Supplier(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      products: products ?? this.products,
      company: company ?? this.company,
      paymentTerms: paymentTerms ?? this.paymentTerms,
    );
  }

      static Supplier empty() {
    return Supplier(
      id: '0',
      name: '',
      email: '',
      phone: '',
      address: '',
      products: [],
      company: '',
      paymentTerms: '30 jours',

      // Initialize other required fields with default values
    );
  }
}