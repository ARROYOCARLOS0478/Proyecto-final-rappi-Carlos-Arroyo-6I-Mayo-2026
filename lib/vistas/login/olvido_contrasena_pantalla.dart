import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../proveedores/autenticacion_proveedor.dart';

class OlvidoContrasenaPantalla extends StatefulWidget {
  const OlvidoContrasenaPantalla({super.key});

  @override
  State<OlvidoContrasenaPantalla> createState() => _OlvidoContrasenaPantallaState();
}

class _OlvidoContrasenaPantallaState extends State<OlvidoContrasenaPantalla> {
  final _emailController = TextEditingController();

  void _recuperarContrasena() async {
    if (_emailController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, ingresa tu correo electrónico'))
      );
      return;
    }

    final authProv = Provider.of<AutenticacionProveedor>(context, listen: false);
    final exito = await authProv.recuperarContrasena(_emailController.text.trim());
    
    if (exito) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Correo de recuperación enviado exitosamente'))
        );
        Navigator.pop(context);
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(authProv.error ?? 'Error al enviar correo de recuperación'))
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProv = Provider.of<AutenticacionProveedor>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Recuperar Contraseña'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Ingresa tu correo para recibir un enlace de recuperación.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 32),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Correo Electrónico',
                prefixIcon: Icon(Icons.email_outlined),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: authProv.estaCargando ? null : _recuperarContrasena,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF6C00), // Rappi Orange
                minimumSize: const Size(double.infinity, 55),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              ),
              child: authProv.estaCargando 
                ? const CircularProgressIndicator(color: Colors.white) 
                : const Text('Enviar Enlace', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
