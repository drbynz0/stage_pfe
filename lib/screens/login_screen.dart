import 'package:flutter/material.dart';
import 'forgot_pass_screen.dart'; // Importez la nouvelle page

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  void _reduceDecoration() {
  }

  void _resetDecoration() {
  }

  void _login() {
    setState(() => _isLoading = true);
    // Simulation de connexion
    Future.delayed(const Duration(seconds: 2), () {
      setState(() => _isLoading = false);
      // ignore: use_build_context_synchronously
      Navigator.pushNamed(context, '/home');
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 100,
              color: const Color(0xFF002E6D),
            ),
          ),
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 120),
                  const Text(
                    'Bienvenue !',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF002E6D),
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
                  Focus(
                    onFocusChange: (hasFocus) => hasFocus ? _reduceDecoration() : _resetDecoration(),
                    child: TextField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        labelStyle: const TextStyle(color: Color(0xFF002E6D)),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFF002E6D)),
                        ),
                      ),
                      keyboardType: TextInputType.emailAddress,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Focus(
                    onFocusChange: (hasFocus) => hasFocus ? _reduceDecoration() : _resetDecoration(),
                    child: TextField(
                      controller: _passwordController,
                      decoration: InputDecoration(
                        labelText: 'Mot de passe',
                        labelStyle: const TextStyle(color: Color(0xFF002E6D)),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFF002E6D)),
                        ),
                      ),
                      obscureText: true,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ForgotPasswordScreen(),
                          ),
                        );
                      },
                      child: const Text(
                        'Mot de passe oublié ?',
                        style: TextStyle(
                          color: Color(0xFF002E6D),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  GestureDetector(
                    onTap: _isLoading ? null : _login,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      curve: Curves.easeInOut,
                      decoration: BoxDecoration(
                        color: const Color(0xFF002E6D),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            // ignore: deprecated_member_use
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      alignment: Alignment.center,
                      child: _isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : const Text(
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
                  OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      backgroundColor: Colors.white,
                      side: const BorderSide(color: Color(0xFFDDDDDD)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(
                          'assets/image/google_logo.png',
                          height: 18,
                          width: 18,
                        ),
                        const SizedBox(width: 12),
                        const Text(
                          'Continuer avec Google',
                          style: TextStyle(
                            color: Colors.black54,
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                          ),
                        ),
                      ],
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