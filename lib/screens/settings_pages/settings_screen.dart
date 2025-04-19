import 'package:flutter/material.dart';
import 'package:stage_pfe/screens/settings_pages/fingerprint_options_screen.dart';
import 'change_password_screen.dart';
import 'pin_options_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool pinEnabled = false;
  bool fingerprintEnabled = false;
  bool notificationsEnabled = true; // <== Pour gérer les notifications


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
                onTap: () {},
              ),
              _buildSettingsTile(
                icon: notificationsEnabled
                    ? Icons.notifications_active
                    : Icons.notifications_off,
                title: 'Notifications',
                trailing: Switch(
                  value: notificationsEnabled,
                  onChanged: (v) {
                    setState(() {
                      notificationsEnabled = v;
                    });
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          _buildSecuritySection(),
          const SizedBox(height: 24),
          _buildSettingsSection(
            title: 'À propos',
            children: [
              _buildSettingsTile(
                icon: Icons.info,
                title: 'Version',
                subtitle: '1.0.0',
              ),
              _buildSettingsTile(
                icon: Icons.help,
                title: 'Aide & Support',
                onTap: () {},
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
                style: TextStyle(color: Colors.red, fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSecuritySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 16.0, bottom: 8.0),
          child: Text(
            'Sécurité',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF003366),
            ),
          ),
        ),
        Card(
          margin: const EdgeInsets.only(bottom: 8),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: _buildSettingsTile(
            icon: Icons.lock,
            title: 'Changer le mot de passe',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ChangePasswordScreen()),
              );
            },
          ),
        ),
        Card(
          margin: const EdgeInsets.only(bottom: 8),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: ListTile(
            leading: const Icon(Icons.pin, color: Color(0xFF004A99)),
            title: const Text('PIN'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Switch(
                  value: pinEnabled,
                  onChanged: (bool value) {
                    setState(() {
                      pinEnabled = value;
                    });
                  },
                ),
                const SizedBox(width: 8),
                const Icon(Icons.arrow_forward_ios),
              ],
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const PinOptionsScreen()),
              );
            },
          ),
        ),
        Card(
          margin: const EdgeInsets.only(bottom: 8),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: ListTile(
            leading: const Icon(Icons.fingerprint, color: Color(0xFF004A99)),
            title: const Text('Empreinte Digitale'),
            subtitle: const Text("Utiliser l'empreinte digitale pour déverrouiller"),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Switch(
                  value: fingerprintEnabled,
                  onChanged: (bool value) {
                    setState(() {
                      fingerprintEnabled = value;
                    });
                    if (value) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const FingerprintSetupScreen(),
                        ),
                      );
                    }
                  },
                ),
                const SizedBox(width: 8),
                const Icon(Icons.arrow_forward_ios),
              ],
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const FingerprintSetupScreen(),
                ),
              );
            },
          ),
        ),
      ],
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
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
