import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../services/auth_service.dart';
import 'register_screen.dart';
import 'home_screen.dart';

import 'email_login_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isLoading = false;

  void _loginWithGoogle() async {
    setState(() => _isLoading = true);
    final authService = Provider.of<AuthService>(context, listen: false);
    final result = await authService.signInWithGoogle();
    
    setState(() => _isLoading = false);
    
    if (result == null) {
      if (mounted) {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomeScreen()));
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(result)));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFF441F), // Rappi Orange
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              // Logo
              Image.network(
                'https://raw.githubusercontent.com/ARROYOCARLOS0478/imagenes/refs/heads/main/logo-rappi.png',
                height: 120,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: const Icon(Icons.delivery_dining, color: Color(0xFFFF441F), size: 60),
                  );
                },
              ),
              const SizedBox(height: 40),
              const Text(
                'Bienvenido',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 36,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -1,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Inicia sesión o regístrate para continuar',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Spacer(),
              // Google Button
              _SocialButton(
                icon: FontAwesomeIcons.google,
                text: 'Continuar con Google',
                backgroundColor: const Color(0xFF4285F4),
                onPressed: _isLoading ? null : _loginWithGoogle,
              ),
              const SizedBox(height: 16),
              // Phone Button
              _SocialButton(
                icon: FontAwesomeIcons.phone,
                text: 'Continuar con Celular',
                backgroundColor: const Color(0xFF00D19D), // Rappi Green
                onPressed: () {
                  // TODO: Implement phone auth
                },
              ),
              const SizedBox(height: 16),
              // Email Button
              _SocialButton(
                icon: FontAwesomeIcons.envelope,
                text: 'Continuar con Correo',
                backgroundColor: Colors.transparent,
                isBordered: true,
                onPressed: () {
                   Navigator.push(context, MaterialPageRoute(builder: (context) => const EmailLoginScreen()));
                },
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}


class _SocialButton extends StatelessWidget {
  final dynamic icon;
  final String text;
  final Color backgroundColor;
  final VoidCallback? onPressed;
  final bool isBordered;

  const _SocialButton({
    required this.icon,
    required this.text,
    required this.backgroundColor,
    this.onPressed,
    this.isBordered = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: Colors.white,
          elevation: isBordered ? 0 : 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
            side: isBordered ? const BorderSide(color: Colors.white, width: 1) : BorderSide.none,
          ),
        ),
        child: Row(
          children: [
            const SizedBox(width: 20),
            FaIcon(icon as FaIconData?, size: 20),
            Expanded(
              child: Text(
                text,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 40),
          ],
        ),
      ),
    );
  }
}


