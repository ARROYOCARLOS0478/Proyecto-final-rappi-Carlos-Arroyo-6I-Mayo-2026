import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/repartidor_model.dart';
import '../services/firestore_service.dart';
import '../services/auth_service.dart';
import 'repartidor_form_screen.dart';
import 'login_screen.dart';

import '../utils/translations.dart';

class RepartidorListScreen extends StatelessWidget {
  const RepartidorListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final firestoreService = FirestoreService();
    final authService = Provider.of<AuthService>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Panel de Repartidores'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await authService.logout();
              if (context.mounted) {
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginScreen()));
              }
            },
          ),
        ],
      ),
      body: StreamBuilder<List<Repartidor>>(
        stream: firestoreService.getRepartidores(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text(TranslationUtils.translateError(snapshot.error)));
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
                    backgroundColor: r.estado == 'Activo' ? Colors.green : Colors.red,
                    child: Icon(
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
                          MaterialPageRoute(builder: (context) => RepartidorFormScreen(repartidor: r)),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _confirmDelete(context, firestoreService, r.id!),
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
          MaterialPageRoute(builder: (context) => const RepartidorFormScreen()),
        ),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _confirmDelete(BuildContext context, FirestoreService service, String id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar Repartidor'),
        content: const Text('¿Estás seguro de que deseas eliminar este registro?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
          TextButton(
            onPressed: () {
              service.deleteRepartidor(id);
              Navigator.pop(context);
            },
            child: const Text('Eliminar', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
