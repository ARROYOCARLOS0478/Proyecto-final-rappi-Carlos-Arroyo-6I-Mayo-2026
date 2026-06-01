import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../proveedores/autenticacion_proveedor.dart';
import '../home/home_pantalla.dart';
import 'correo_login_pantalla.dart';
import 'celular_login_pantalla.dart';
import '../admin/admin_home_pantalla.dart';
import '../../core/constantes.dart';

class LoginPantalla extends StatefulWidget {
  const LoginPantalla({super.key});

  @override
  State<LoginPantalla> createState() => _LoginPantallaState();
}

class _LoginPantallaState extends State<LoginPantalla> {
  @override
  Widget build(BuildContext context) {
    final authProv = Provider.of<AutenticacionProveedor>(context);

    return Scaffold(
      backgroundColor: const Color(0xFFFF6C00), // Rappi Orange
      body: SafeArea(
        child: authProv.estaCargando
            ? const Center(
                child: CircularProgressIndicator(color: Colors.white),
              )
            : Padding(
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
                          child: const Icon(
                            Icons.delivery_dining,
                            color: Color(0xFFFF6C00),
                            size: 60,
                          ),
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
                    const SizedBox(height: 12),
                    if (authProv.mensajeSesion != null)
                      Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.white24),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.info_outline, color: Colors.white),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                authProv.mensajeSesion!,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                            TextButton(
                              onPressed: () async {
                                await authProv.logout();
                                if (mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Sesión cerrada'),
                                    ),
                                  );
                                }
                              },
                              child: const Text(
                                'Cerrar sesión',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ),
                    const Spacer(),

                    // Phone Button (mocked/informational)
                    _BotonSocial(
                      icon: FontAwesomeIcons.phone,
                      text: 'Continuar con Celular',
                      backgroundColor: const Color(0xFF00D19D),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const CelularLoginPantalla(),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 16),
                    // Email Button
                    _BotonSocial(
                      icon: FontAwesomeIcons.envelope,
                      text: 'Continuar con Correo',
                      backgroundColor: Colors.transparent,
                      isBordered: true,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const CorreoLoginPantalla(),
                          ),
                        );
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

class _BotonSocial extends StatelessWidget {
  final dynamic icon;
  final String text;
  final Color backgroundColor;
  final VoidCallback? onPressed;
  final bool isBordered;

  const _BotonSocial({
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
            side: isBordered
                ? const BorderSide(color: Colors.white, width: 1)
                : BorderSide.none,
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
