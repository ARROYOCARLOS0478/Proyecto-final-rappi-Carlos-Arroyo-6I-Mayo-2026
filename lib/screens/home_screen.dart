import 'package:flutter/material.dart';
import 'repartidor_list_screen.dart';
import 'restaurante_list_screen.dart';
import '../services/auth_service.dart';
import 'package:provider/provider.dart';
import 'login_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestión Rappi'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              // Feedback visual inmediato
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Cerrando sesión...'), duration: Duration(seconds: 1)),
              );
              
              // Llamamos al logout (que ahora es instantáneo en la UI)
              authService.logout();
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              '¿Qué deseas gestionar hoy?',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            _MenuCard(
              title: 'Repartidores',
              subtitle: 'Gestionar flota de reparto',
              icon: Icons.delivery_dining,
              color: const Color(0xFFFF441F),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const RepartidorListScreen()),
              ),
            ),
            const SizedBox(height: 20),
            _MenuCard(
              title: 'Restaurantes',
              subtitle: 'Gestionar establecimientos aliados',
              icon: Icons.restaurant,
              color: const Color(0xFF00D19D),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const RestauranteListScreen()),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MenuCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _MenuCard({
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
