import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  double _decorationHeight = 250; // Hauteur initiale de la décoration

  void _reduceDecoration() {
    setState(() {
      _decorationHeight = 150; // Réduire la hauteur de la décoration
    });
  }

  void _resetDecoration() {
    setState(() {
      _decorationHeight = 250; // Restaurer la hauteur initiale
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Barre rectangulaire en haut de la page
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 100, // Hauteur fixe de la barre
              color: const Color(0xFF002E6D), // Bleu foncé
            ),
          ),
          // Contenu principal
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 120), // Espace sous la barre
                  const Text(
                    'Bienvenue !',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF002E6D), // Bleu foncé
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Connectez-vous pour continuer.',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 50),
                  // Champ Email
                  Focus(
                    onFocusChange: (hasFocus) {
                      if (hasFocus) {
                        _reduceDecoration();
                      } else {
                        _resetDecoration();
                      }
                    },
                    child: TextField(
                      decoration: InputDecoration(
                        labelText: 'Email',
                        labelStyle:
                            const TextStyle(color: Color(0xFF002E6D)), // Bleu foncé
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFF002E6D)), // Bleu foncé
                        ),
                      ),
                      keyboardType: TextInputType.emailAddress,
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Champ Mot de passe
                  Focus(
                    onFocusChange: (hasFocus) {
                      if (hasFocus) {
                        _reduceDecoration();
                      } else {
                        _resetDecoration();
                      }
                    },
                    child: TextField(
                      decoration: InputDecoration(
                        labelText: 'Mot de passe',
                        labelStyle:
                            const TextStyle(color: Color(0xFF002E6D)), // Bleu foncé
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFF002E6D)), // Bleu foncé
                        ),
                      ),
                      obscureText: true,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Lien Mot de passe oublié
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        // Ajouter la navigation vers la page de récupération de mot de passe
                      },
                      child: const Text(
                        'Mot de passe oublié ?',
                        style: TextStyle(
                          color: Color(0xFF002E6D), // Bleu foncé
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Bouton Se connecter
                  GestureDetector(
                    onTap: () {
                      // Naviguer vers la page Home
                      Navigator.pushNamed(context, '/home');
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      curve: Curves.easeInOut,
                      decoration: BoxDecoration(
                        color: const Color(0xFF002E6D), // Bleu foncé
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      alignment: Alignment.center,
                      child: const Text(
                        'Se connecter',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Bouton Se connecter avec Google
                  OutlinedButton.icon(
                    onPressed: () {
                      // Ajouter la logique de connexion avec Google ici
                    },
                    icon: const Icon(Icons.login, color: Color(0xFF002E6D)),
                    label: const Text(
                      'Se connecter avec Google',
                      style: TextStyle(
                        color: Color(0xFF002E6D), // Bleu foncé
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Color(0xFF002E6D)), // Bleu foncé
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Lien Créer un compte
                  TextButton(
                    onPressed: () {
                      // Naviguer vers la page RegisterScreen
                      Navigator.pushNamed(context, '/register');
                    },
                    child: const Text(
                      'Créer un compte',
                      style: TextStyle(
                        color: Color(0xFF002E6D), // Bleu foncé
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}