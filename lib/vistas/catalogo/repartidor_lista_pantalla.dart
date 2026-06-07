import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../modelos/repartidor_modelo.dart';
import '../../servicios/firestore_servicio.dart';
import '../../proveedores/autenticacion_proveedor.dart';
import 'repartidor_formulario_pantalla.dart';
import '../login/login_pantalla.dart';
import '../../core/traducciones.dart';

class RepartidorListaPantalla extends StatelessWidget {
  const RepartidorListaPantalla({super.key});

  @override
  Widget build(BuildContext context) {
    final firestoreServicio = FirestoreServicio();
    final authProv = Provider.of<AutenticacionProveedor>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Panel de Repartidores'),
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
      body: StreamBuilder<List<Repartidor>>(
        stream: firestoreServicio.obtenerRepartidores(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text(Traducciones.traducirError(snapshot.error)));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No hay repartidores registrados.'));
          }

          final repartidores = snapshot.data!;

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: repartidores.length,
            itemBuilder: (context, index) {
              final r = repartidores[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundImage: r.fotoUrl != null && r.fotoUrl!.isNotEmpty
                        ? NetworkImage(r.fotoUrl!)
                        : null,
                    backgroundColor: r.fotoUrl != null && r.fotoUrl!.isNotEmpty
                        ? Colors.transparent
                        : (r.estado == 'Activo' ? Colors.green : Colors.red),
                    child: r.fotoUrl != null && r.fotoUrl!.isNotEmpty
                        ? null
                        : Icon(
                            r.vehiculo == 'Moto' ? Icons.motorcycle : Icons.directions_bike,
                            color: Colors.white,
                          ),
                  ),
                  title: Text(r.nombre, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text('${r.vehiculo} • ${r.telefono}\nEstado: ${r.estado}'),
                  isThreeLine: true,
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => RepartidorFormularioPantalla(repartidor: r)),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _confirmarEliminar(context, firestoreServicio, r.id!),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const RepartidorFormularioPantalla()),
        ),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  void _confirmarEliminar(BuildContext context, FirestoreServicio servicio, String id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar Repartidor'),
        content: const Text('¿Estás seguro de que deseas eliminar este registro?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
          TextButton(
            onPressed: () {
              servicio.eliminarRepartidor(id);
              Navigator.pop(context);
            },
            child: const Text('Eliminar', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
