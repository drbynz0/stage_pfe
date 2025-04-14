import 'package:flutter/material.dart';
import 'produits_pages/product_managment_screen.dart';
import 'transactions_pages/transactions_screen.dart';
import 'client_pages/client_management_screen.dart';
import 'plus_pages/more_options_screen.dart';
import 'settings_pages/settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  int _currentIndex = 2;
  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      const TransactionsScreen(),
      const ClientManagementScreen(),
      _buildHomePage(),
      const ProductManagementScreen(),
      const MoreOptionsScreen(),
    ];
  }

  Widget _buildHomePage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Statistiques",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF003366),
            ),
          ),
          const SizedBox(height: 16),
          GridView.count(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 1.2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              _buildDashboardCard(
                icon: Icons.show_chart,
                label: "Chiffre d'affaire",
                value: "100 000",
                valueColor: Colors.green,
              ),
              _buildDashboardCard(
                icon: Icons.attach_money,
                label: "Achat",
                value: "300 000",
                valueColor: Colors.green,
              ),
              _buildDashboardCard(
                icon: Icons.inventory,
                label: "Fournisseurs",
                value: "10",
                valueColor: Colors.red,
              ),
              _buildDashboardCard(
                icon: Icons.group,
                label: "Clients",
                value: "20",
                valueColor: Colors.red,
              ),
            ],
          ),
          const SizedBox(height: 32),
          const Text(
            "Graphiques",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF003366),
            ),
          ),
          const SizedBox(height: 16),
          Container(
            height: 200,
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Center(
              child: Text(
                "Graphique des ventes (à intégrer avec un package comme charts_flutter)",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.blue.shade900),
              ),
            ),
          ),
          const SizedBox(height: 32),
          const Text(
            "Activités récentes",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF003366),
            ),
          ),
          const SizedBox(height: 16),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 3,
            itemBuilder: (context, index) {
              final activities = [
                {"desc": "Nouvelle commande de 10 000 €", "icon": Icons.shopping_cart},
                {"desc": "Ajout d'un nouveau client : John Doe", "icon": Icons.person_add},
                {"desc": "Mise à jour du stock : +50 articles", "icon": Icons.inventory},
              ];
              return _buildActivityTile(activities[index]["desc"] as String, 
                                      activities[index]["icon"] as IconData);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDashboardCard({
    required IconData icon,
    required String label,
    required String value,
    required Color valueColor,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF004A99),
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.all(1),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 50, color: Colors.white),
          const SizedBox(height: 10),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              color: valueColor,
              fontWeight: FontWeight.bold,
              fontSize: 22),
          ),
        ],
      ),
    );
  }

  Widget _buildActivityTile(String description, IconData icon) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: ListTile(
        leading: Icon(icon, color: Colors.blue.shade900),
        title: Text(description),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () {
          // Action pour chaque activité
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        backgroundColor: const Color(0xFF003366),
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.menu, color: Colors.white, size: 30),
              onPressed: () => scaffoldKey.currentState?.openDrawer(),
            ),
            const SizedBox(width: 10),
            const Text(
              'CTI Technologie',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications, color: Colors.white),
            onPressed: () {
              // Action pour les notifications
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Color(0xFF003366),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/image/welcome.png',
                    width: 100,
                    height: 100,
                  ),
      
                
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.person, color: Color(0xFF003366)),
              title: const Text('Profil'),
              onTap: () {
                Navigator.pop(context);
                // Navigation vers le profil
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings, color: Color(0xFF003366)),
              title: const Text('Paramètres'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SettingsScreen()),
                );
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text('Déconnexion', style: TextStyle(color: Colors.red)),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushReplacementNamed(context, '/login');
              },
            ),
          ],
        ),
      ),
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.blue.shade50,
        selectedItemColor: Colors.blue.shade900,
        unselectedItemColor: Colors.blue.shade300,
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart_outlined),
            label: 'Commandes',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.group_outlined),
            label: 'Clients',
          ),
          BottomNavigationBarItem(
            icon: CircleAvatar(
              backgroundColor: Color(0xFF003366),
              child: Icon(Icons.home, color: Colors.white),
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_bag_outlined),
            label: 'Produits',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.more_horiz),
            label: 'Plus',
          ),
        ],
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}