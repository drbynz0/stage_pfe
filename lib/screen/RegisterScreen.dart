import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Créer un compte', 
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            )),
        backgroundColor: const Color(0xFF002E6D), // Bleu foncé
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            const Text(
              'Inscrivez-vous pour commencer',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF002E6D), // Bleu foncé
              ),
            ),
            const SizedBox(height: 20),
            // Champ Nom
            TextField(
              decoration: InputDecoration(
                labelText: 'Nom',
                labelStyle: const TextStyle(color: Color(0xFF002E6D)), // Bleu foncé
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF002E6D)), // Bleu foncé
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Champ Email
            TextField(
              decoration: InputDecoration(
                labelText: 'Email',
                labelStyle: const TextStyle(color: Color(0xFF002E6D)), // Bleu foncé
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF002E6D)), // Bleu foncé
                ),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),
            // Champ Mot de passe
            TextField(
              decoration: InputDecoration(
                labelText: 'Mot de passe',
                labelStyle: const TextStyle(color: Color(0xFF002E6D)), // Bleu foncé
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF002E6D)), // Bleu foncé
                ),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 16),
            // Champ Confirmation du mot de passe
            TextField(
              decoration: InputDecoration(
                labelText: 'Confirmer le mot de passe',
                labelStyle: const TextStyle(color: Color(0xFF002E6D)), // Bleu foncé
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF002E6D)), // Bleu foncé
                ),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 24),
            // Bouton S'inscrire
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF002E6D), // Bleu foncé
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(vertical: 16),
                minimumSize: const Size(double.infinity, 50), // Largeur pleine
              ),
              onPressed: () {
                // Ajouter la logique d'inscription ici
              },
              child: const Text(
                'S\'inscrire',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Lien vers la page de connexion
            Center(
              child: TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/login');
                },
                child: const Text(
                  'Vous avez déjà un compte ? Connectez-vous',
                  style: TextStyle(
                    color: Color(0xFF002E6D), // Bleu foncé
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}