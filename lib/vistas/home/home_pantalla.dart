import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../catalogo/repartidor_lista_pantalla.dart';
import '../catalogo/restaurante_lista_pantalla.dart';
import '../../proveedores/autenticacion_proveedor.dart';
import '../login/login_pantalla.dart';

class HomePantalla extends StatelessWidget {
  const HomePantalla({super.key});

  @override
  Widget build(BuildContext context) {
    final authProv = Provider.of<AutenticacionProveedor>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestión Rappi'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Cerrando sesión...'), duration: Duration(seconds: 1)),
              );
              await authProv.logout();
              if (context.mounted) {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginPantalla()),
                  (route) => false,
                );
              }
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 20),
            Text(
              authProv.usuarioDatos != null 
                  ? '¡Hola, ${authProv.usuarioDatos!.nombre}!\n¿Qué deseas gestionar hoy?'
                  : '¿Qué deseas gestionar hoy?',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            _TarjetaMenu(
              title: 'Repartidores',
              subtitle: 'Gestionar flota de reparto',
              icon: Icons.delivery_dining,
              color: const Color(0xFFFF6C00), // Rappi Orange
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const RepartidorListaPantalla()),
              ),
            ),
            const SizedBox(height: 20),
            _TarjetaMenu(
              title: 'Restaurantes',
              subtitle: 'Gestionar establecimientos aliados',
              icon: Icons.restaurant,
              color: const Color(0xFF00D19D), // Rappi Green
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const RestauranteListaPantalla()),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TarjetaMenu extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _TarjetaMenu({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Icon(icon, color: color, size: 40),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      subtitle,
                      style: TextStyle(color: Colors.grey.shade600),
                    ),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios, color: Colors.grey.shade400),
            ],
          ),
        ),
      ),
    );
  }
}
