import 'package:flutter/material.dart';
import 'screen/login_screen.dart'; // Import de l'écran de connexion
import 'screen/welcome_screen.dart'; // Import de l'écran d'accueil
import 'screen/home_screen.dart'; // Import de l'écran principal (Home)

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter app',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      initialRoute: '/', // Route initiale
      routes: {
        '/': (context) => WelcomeScreen(), // Écran d'accueil
        '/login': (context) => LoginScreen(), // Écran de connexion
        '/home': (context) => HomeScreen(), // Écran principal (Home)
        
      },
    );
  }
}