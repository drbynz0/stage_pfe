class Supplier {
  final String ice;
  final String name;
  final String email;
  final String phone;
  final String address;
  final List<String> products;
  final String company;
  final String paymentTerms;

  Supplier({
    required this.ice,
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
        ice: '1344343439876',
        name: 'Mohamed Kassi',
        email: 'contact@kassientreprise.ma',
        phone: '0522445566',
        address: 'Zone Industrielle, Casablanca',
        products: ['Ciment', 'Briques', 'Carreaux'],
        company: 'Kassi Entreprise',
        paymentTerms: '30 jours',
      ),
      Supplier(
        ice: '2',
        name: 'Fatima Zahra',
        email: 'fz@materiaux-premium.ma',
        phone: '0522889977',
        address: 'Ain Sebaa, Casablanca',
        products: ['Peinture', 'Revêtements', 'Isolation'],
        company: 'Matériaux Premium',
        paymentTerms: '45 jours',
      ),
      Supplier(
        ice: '3',
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
      ice: map['id'] ?? '',
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
      'id': ice,
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
    String? ice,
    String? name,
    String? email,
    String? phone,
    String? address,
    List<String>? products,
    String? company,
    String? paymentTerms,
  }) {
    return Supplier(
      ice: ice ?? this.ice,
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
      ice: '0',
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