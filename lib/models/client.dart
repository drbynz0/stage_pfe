class Client {
  final String id;
  final String? ice;
  final String name;
  final String email;
  final String phone;
  final String address;

    static final List<Client> _clients = [
    Client(
      id: 'C001',
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
    Client(
      id: '3',
      name: 'Mohamed El Youssfi',
      email: 'mohamed.youssfi@example.com',
      phone: '0622222222',
      address: 'Marrakech',
    ),
    Client(
      id: '4',
      name: 'Fatima Zahra',
      email: 'fatima.zahra@example.com',
      phone: '0633333333',
      address: 'Fès',
    ),
    Client(
      id: '5',
      name: 'Youssef Benali',
      email: 'youssef.benali@example.com',
      phone: '0644444444',
      address: 'Tanger',
    ),
    Client(
      id: '6',
      name: 'Khadija Benslimane',
      email: 'khadija.benslimane@example.com',
      phone: '0655555555',
      address: 'Agadir',
    ),
    Client(
      id: '7',
      name: 'Omar Lahlou',
      email: 'omar.lahlou@example.com',
      phone: '0666666666',
      address: 'Oujda',
    ),
    Client(
      id: '8',
      name: 'Salma Idrissi',
      email: 'salma.idrissi@example.com',
      phone: '0677777777',
      address: 'Kenitra',
    ),
  ];

  Client({
    required this.id,
    this.ice = 'N/A',
    required this.name,
    required this.email,
    required this.phone,
    required this.address,
  });

  static List<Client> getClients() {
    return _clients;
  }

  static Client getClientById(String id) {
    return _clients.firstWhere((client) => client.id == id, orElse: () => Client.empty());
  }

  static void addClient(Client client) {
    _clients.insert(0, client);
  }

  static void removeClient(client) {
    _clients.remove(client);
  }


    static Client empty() {
    return Client(
      id: '0',
      name: '',
      email: '',
      phone: '',
      address: '',

      // Initialize other required fields with default values
    );
  }
}