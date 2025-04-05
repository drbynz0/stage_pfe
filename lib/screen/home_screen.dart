import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Créez une clé globale pour le Scaffold
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
      key: scaffoldKey, // Associez la clé au Scaffold
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF003366), // Couleur bleu foncé
        automaticallyImplyLeading: false, // Supprime la flèche de retour
        title: Row(
          children: [
            IconButton(
              icon: const Icon(
                Icons.menu,
                color: Colors.white,
                size: 30,
              ),
              onPressed: () {
                // Utilisez la clé pour ouvrir le Drawer
                scaffoldKey.currentState?.openDrawer();
              },
            ),
            const SizedBox(width: 10),
            const Text(
              'CTI Technologie',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications, color: Colors.white),
            onPressed: () {
              // Ajouter une action pour les notifications
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
                color: Color(0xFF003366), // Couleur bleu foncé
              ),
              child: const Text(
                'Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Profil'),
              onTap: () {
                // Naviguer vers la page Profil
                Navigator.pushNamed(context, '/profile');
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Paramètres'),
              onTap: () {
                // Naviguer vers la page Paramètres
                Navigator.pushNamed(context, '/settings');
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Déconnexion'),
              onTap: () {
                // Naviguer vers la page de connexion
                Navigator.pushNamed(context, '/login');
              },
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          children: [
            _buildDashboardCard(
              icon: Icons.show_chart,
              label: "Chiffre d’affaire",
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
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.blue.shade50,
        selectedItemColor: Colors.blue.shade900,
        unselectedItemColor: Colors.blue.shade300,
        currentIndex: 2, // Home sélectionné
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.monetization_on_outlined),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.group_outlined),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: CircleAvatar(
              backgroundColor: Color(0xFF003366),
              child: Icon(Icons.home, color: Colors.white),
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_bag_outlined),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.inventory_2_outlined),
            label: '',
          ),
        ],
        type: BottomNavigationBarType.fixed,
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
        color: const Color(0xFF004A99), // Bleu
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.all(16),
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
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              color: valueColor,
              fontWeight: FontWeight.bold,
              fontSize: 22,
            ),
          ),
        ],
      ),
    );
  }
}