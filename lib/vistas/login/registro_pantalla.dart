import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../proveedores/autenticacion_proveedor.dart';
import '../admin/admin_home_pantalla.dart';
import '../registro/setup_direccion_pantalla.dart';

class RegistroPantalla extends StatefulWidget {
  const RegistroPantalla({super.key});

  @override
  State<RegistroPantalla> createState() => _RegistroPantallaState();
}

class _RegistroPantallaState extends State<RegistroPantalla> {
  final _emailController = TextEditingController();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  // Función principal de registro con filtro de Rol
  void _register() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final nombre = _nameController.text.trim();
    final telefono = _phoneController.text.trim();
    final confirmarPass = _confirmPasswordController.text.trim();

    // 1. Validaciones básicas de campos vacíos
    if (email.isEmpty || password.isEmpty || nombre.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Completa los campos obligatorios')),
      );
      return;
    }

    // 2. Validación de coincidencia de contraseñas
    if (password != confirmarPass) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Las contraseñas no coinciden')),
      );
      return;
    }

    final authProv = Provider.of<AutenticacionProveedor>(context, listen: false);

    // 3. Lógica de redirección según el tipo de correo
    if (email.toLowerCase().endsWith('@rappi.com')) {
      // --- REGISTRO DE ADMINISTRADOR (Directo) ---
      final exito = await authProv.registro(
        email,
        password,
        nombre,
        telefono,
      );

      if (exito) {
        if (mounted) {
          // Limpia el historial de navegación y va al Home de Admin
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const AdminHomePantalla()),
            (route) => false,
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(authProv.error ?? 'Error al registrar Administrador')),
          );
        }
      }
    } else {
      // --- REGISTRO DE CLIENTE (Pasa por Dirección) ---
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SetupDireccionPantalla(
            datosRegistro: {
              'nombre': nombre,
              'email': email,
              'telefono': telefono,
              'password': password,
            },
          ),
        ),
      );
    }
  }

  @override
  void dispose() {
    // Es buena práctica limpiar los controladores al cerrar la pantalla
    _emailController.dispose();
    _nameController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authProv = Provider.of<AutenticacionProveedor>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Crear Cuenta'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 10),
            const Text(
              '¡Únete a Rappi!',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const Text(
              'Crea una cuenta para empezar a gestionar',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 30),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Nombre Completo *',
                prefixIcon: Icon(Icons.person_outline),
              ),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Correo Electrónico *',
                prefixIcon: Icon(Icons.email_outlined),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 15),
            TextField(
              controller: _phoneController,
              decoration: const InputDecoration(
                labelText: 'Teléfono / Celular',
                prefixIcon: Icon(Icons.phone_outlined),
              ),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 15),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(
                labelText: 'Contraseña *',
                prefixIcon: Icon(Icons.lock_outline),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 15),
            TextField(
              controller: _confirmPasswordController,
              decoration: const InputDecoration(
                labelText: 'Confirmar Contraseña *',
                prefixIcon: Icon(Icons.lock_reset),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 35),
            ElevatedButton(
              onPressed: authProv.estaCargando ? null : _register,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF6C00), // Rappi Orange
                minimumSize: const Size(double.infinity, 55),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: authProv.estaCargando
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                    )
                  : const Text(
                      'Registrarse',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('¿Ya tienes cuenta?'),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    'Inicia sesión',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFFF6C00),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}