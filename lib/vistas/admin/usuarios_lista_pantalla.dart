import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../modelos/usuario_modelo.dart';
import '../../servicios/firestore_servicio.dart';
import '../../proveedores/autenticacion_proveedor.dart';
import '../login/login_pantalla.dart';
import '../../core/traducciones.dart'; // Importamos traducciones como en repartidores

class UsuariosListaPantalla extends StatelessWidget {
  const UsuariosListaPantalla({super.key});

  @override
  Widget build(BuildContext context) {
    final firestoreServicio = FirestoreServicio();
    final authProv = Provider.of<AutenticacionProveedor>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Panel de Usuarios'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
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
      body: StreamBuilder<List<Usuario>>(
        // Usamos el método que agregamos al servicio
        stream: firestoreServicio.obtenerTodosLosUsuarios(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            // Usamos tu clase de traducciones para los errores
            return Center(child: Text(Traducciones.traducirError(snapshot.error)));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No hay usuarios registrados.'));
          }

          final usuarios = snapshot.data!;

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: usuarios.length,
            itemBuilder: (context, index) {
              final u = usuarios[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  leading: CircleAvatar(
                    // Color dinámico según el rol (Admin o Cliente)
                    backgroundColor: u.rol == 'ADMIN' ? Colors.orange : Colors.blueGrey,
                    child: Icon(
                      u.rol == 'ADMIN' ? Icons.admin_panel_settings : Icons.person,
                      color: Colors.white,
                    ),
                  ),
                  title: Text(u.nombre, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text('${u.email}\nRol: ${u.rol}'),
                  isThreeLine: true,
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _confirmarEliminar(context, firestoreServicio, u),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _confirmarEliminar(BuildContext context, FirestoreServicio servicio, Usuario usuario) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar Usuario'),
        content: Text('¿Estás seguro de eliminar a ${usuario.nombre}?\nEsta acción no se puede deshacer.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
          TextButton(
            onPressed: () async {
              await servicio.eliminarUsuario(usuario.uid);
              if (context.mounted) Navigator.pop(context);
            },
            child: const Text('Eliminar', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}