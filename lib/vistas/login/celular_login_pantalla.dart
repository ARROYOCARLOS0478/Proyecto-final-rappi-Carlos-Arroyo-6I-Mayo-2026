import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/tema_app.dart';
import '../../core/constantes.dart';
import '../../proveedores/autenticacion_proveedor.dart';
import '../admin/admin_home_pantalla.dart';
import '../home/home_pantalla.dart';

class CelularLoginPantalla extends StatefulWidget {
  const CelularLoginPantalla({super.key});

  @override
  State<CelularLoginPantalla> createState() => _CelularLoginPantallaState();
}

class _CelularLoginPantallaState extends State<CelularLoginPantalla> {
  final _phoneController = TextEditingController();
  bool _estaCargando = false;

  void _continuar() async {
    final telefono = _phoneController.text.trim();
    if (telefono.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ingresa tu número de teléfono')),
      );
      return;
    }

    setState(() => _estaCargando = true);
    final authProv = Provider.of<AutenticacionProveedor>(
      context,
      listen: false,
    );
    final exito = await authProv.loginConTelefono(telefono);
    setState(() => _estaCargando = false);

    if (exito) {
      if (!mounted) return;
      final destino = authProv.usuarioDatos?.rol == Constantes.rolAdministrador
          ? const AdminHomePantalla()
          : const HomePantalla();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => destino),
      );
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(authProv.error ?? 'Número no encontrado')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Iniciar con Celular')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Ingresa tu número para continuar',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 24),
            TextField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                labelText: 'Teléfono',
                prefixIcon: Icon(Icons.phone_outlined),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _estaCargando ? null : _continuar,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 55),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: _estaCargando
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text('Continuar', style: TextStyle(fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }
}
