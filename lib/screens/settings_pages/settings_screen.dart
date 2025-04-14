import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Paramètres'),
        backgroundColor: const Color(0xFF003366),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildSettingsSection(
            title: 'Compte',
            children: [
              _buildSettingsTile(
                icon: Icons.person,
                title: 'Profil',
                onTap: () {
                  // Naviguer vers la page de profil
                },
              ),
              _buildSettingsTile(
                icon: Icons.notifications,
                title: 'Notifications',
                trailing: Switch(
                  value: true,
                  onChanged: (value) {},
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          _buildSettingsSection(
            title: 'Préférences',
            children: [
              _buildSettingsTile(
                icon: Icons.color_lens,
                title: 'Thème',
                subtitle: 'Mode clair',
                onTap: () {
                  // Changer le thème
                },
              ),
              _buildSettingsTile(
                icon: Icons.language,
                title: 'Langue',
                subtitle: 'Français',
                onTap: () {
                  // Changer la langue
                },
              ),
            ],
          ),
          const SizedBox(height: 24),
          _buildSettingsSection(
            title: 'Sécurité',
            children: [
              _buildSettingsTile(
                icon: Icons.lock,
                title: 'Changer le mot de passe',
                onTap: () {
                  // Naviguer vers le changement de mot de passe
                },
              ),
              _buildSettingsTile(
                icon: Icons.security,
                title: 'Authentification à deux facteurs',
                trailing: Switch(
                  value: false,
                  onChanged: (value) {},
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          _buildSettingsSection(
            title: 'A propos',
            children: [
              _buildSettingsTile(
                icon: Icons.info,
                title: 'Version',
                subtitle: '1.0.0',
              ),
              _buildSettingsTile(
                icon: Icons.help,
                title: 'Aide & Support',
                onTap: () {
                  // Naviguer vers la page d'aide
                },
              ),
            ],
          ),
          const SizedBox(height: 32),
          Center(
            child: TextButton(
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/login');
              },
              child: const Text(
                'Déconnexion',
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsSection({
    required String title,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16.0, bottom: 8.0),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF003366),
            ),
          ),
        ),
        Card(
          margin: const EdgeInsets.only(bottom: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(children: children),
        ),
      ],
    );
  }

  Widget _buildSettingsTile({
    required IconData icon,
    required String title,
    String? subtitle,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xFF004A99)),
      title: Text(title),
      subtitle: subtitle != null ? Text(subtitle) : null,
      trailing: trailing ?? const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}