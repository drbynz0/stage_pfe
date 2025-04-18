import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';

class FingerprintSetupScreen extends StatefulWidget {
  const FingerprintSetupScreen({super.key});

  @override
  State<FingerprintSetupScreen> createState() => _FingerprintSetupScreenState();
}

class _FingerprintSetupScreenState extends State<FingerprintSetupScreen> {
  final LocalAuthentication _localAuth = LocalAuthentication();
  bool _canCheckBiometrics = false;
  bool _isBiometricAvailable = false;

  @override
  void initState() {
    super.initState();
    _checkBiometrics();
  }

  Future<void> _checkBiometrics() async {
    bool canCheck = await _localAuth.canCheckBiometrics;
    bool isAvailable = await _localAuth.isDeviceSupported();
    setState(() {
      _canCheckBiometrics = canCheck;
      _isBiometricAvailable = isAvailable;
    });
  }

  Future<void> _authenticateWithFingerprint() async {
    try {
      bool authenticated = await _localAuth.authenticate(
        localizedReason: 'Veuillez vous authentifier avec votre empreinte digitale.',
        
      );
      if (authenticated) {
        // Authentification réussie
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Authentification réussie')),
        );
      } else {
        // Échec de l'authentification
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Échec de l\'authentification')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Configurer Empreinte Digitale'),
        backgroundColor: const Color(0xFF003366),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            if (!_isBiometricAvailable)
              const Text(
                'L\'appareil ne prend pas en charge l\'authentification par empreinte digitale.',
                style: TextStyle(color: Colors.red),
              ),
            if (_canCheckBiometrics && _isBiometricAvailable)
              ElevatedButton(
                onPressed: _authenticateWithFingerprint,
                child: const Text('Authentification par Empreinte Digitale'),
              ),
            if (!_canCheckBiometrics)
              const Text('Aucune biométrie détectée sur cet appareil.'),
          ],
        ),
      ),
    );
  }
}
