import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../proveedores/autenticacion_proveedor.dart';
import '../catalogo/repartidor_lista_pantalla.dart';
import '../home/home_pantalla.dart';
import '../login/login_pantalla.dart';
import '../../core/tema_app.dart';
import '../catalogo/categorias_admin_pantalla.dart';
import 'usuarios_lista_pantalla.dart';
import 'pedidos_lista_pantalla.dart';

class AdminHomePantalla extends StatelessWidget {
  const AdminHomePantalla({super.key});

  @override
  Widget build(BuildContext context) {
    final authProv = Provider.of<AutenticacionProveedor>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Panel de Administración'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              // Primero ejecutamos la limpieza
              await authProv.logout();

              if (context.mounted) {
                // Usamos pushAndRemoveUntil para que no se pueda dar "atrás"
                Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) => const LoginPantalla()),
                  (route) => false,
                );
              }
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (authProv.mensajeSesion != null)
              Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.orange.shade100,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.orange.shade700),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.info_outline, color: Colors.orange),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        authProv.mensajeSesion!,
                        style: const TextStyle(
                          color: Colors.black87,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            const Text(
              'Modo Administrador',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            const Text(
              'Desde aquí puedes gestionar restaurantes, repartidores y ver la vista de usuario.',
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const CategoriasAdminPantalla(),
                ),
              ),
              icon: const Icon(Icons.restaurant),
              label: const Text('Gestionar Negocios'),
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const RepartidorListaPantalla(),
                ),
              ),
              icon: const Icon(Icons.motorcycle),
              label: const Text('Gestionar Repartidores'),
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const UsuariosListaPantalla(),
                ),
              ),
              icon: const Icon(Icons.people_alt_outlined), // Icono de grupo/usuarios
              label: const Text('Gestionar Usuarios'),
              style: ElevatedButton.styleFrom(
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const PedidosListaPantalla(),
                ),
              ),
              icon: const Icon(Icons.receipt_long),
              label: const Text('Gestionar Pedidos'),
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const HomePantalla()),
              ),
              icon: const Icon(Icons.shopping_bag),
              label: const Text('Ver app de usuario'),
              style: ElevatedButton.styleFrom(
                backgroundColor: TemaApp.naranjaPrincipal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
