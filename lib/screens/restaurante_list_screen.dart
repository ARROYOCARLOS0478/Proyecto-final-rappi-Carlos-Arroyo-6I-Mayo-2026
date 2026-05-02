import 'package:flutter/material.dart';
import '../models/restaurante_model.dart';
import '../services/firestore_service.dart';
import 'restaurante_form_screen.dart';

import '../utils/translations.dart';

class RestauranteListScreen extends StatelessWidget {
  const RestauranteListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final firestoreService = FirestoreService();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Restaurantes'),
      ),
      body: StreamBuilder<List<Restaurante>>(
        stream: firestoreService.getRestaurantes(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text(TranslationUtils.translateError(snapshot.error)));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No hay restaurantes registrados.'));
          }

          final restaurantes = snapshot.data!;

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: restaurantes.length,
            itemBuilder: (context, index) {
              final restaurante = restaurantes[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: const Color(0xFF00D19D).withOpacity(0.1),
                    child: const Icon(Icons.restaurant, color: Color(0xFF00D19D)),
                  ),
                  title: Text(restaurante.nombre, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text('${restaurante.categoria} • ${restaurante.direccion}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RestauranteFormScreen(restaurante: restaurante),
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _confirmDelete(context, firestoreService, restaurante),
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
          MaterialPageRoute(builder: (context) => const RestauranteFormScreen()),
        ),
        backgroundColor: const Color(0xFF00D19D),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  void _confirmDelete(BuildContext context, FirestoreService service, Restaurante restaurante) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar Restaurante'),
        content: Text('¿Está seguro de que desea eliminar a ${restaurante.nombre}?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
          TextButton(
            onPressed: () {
              service.deleteRestaurante(restaurante.id!);
              Navigator.pop(context);
            },
            child: const Text('Eliminar', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
