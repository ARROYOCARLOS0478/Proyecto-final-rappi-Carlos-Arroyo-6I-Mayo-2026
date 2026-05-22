import 'package:flutter/material.dart';
import '../../modelos/comercio_modelo.dart';
import '../../servicios/firestore_servicio.dart';
import 'restaurante_formulario_pantalla.dart';
import '../../core/traducciones.dart';

class RestauranteListaPantalla extends StatelessWidget {
  const RestauranteListaPantalla({super.key});

  @override
  Widget build(BuildContext context) {
    final firestoreServicio = FirestoreServicio();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Restaurantes'),
      ),
      body: StreamBuilder<List<Comercio>>(
        stream: firestoreServicio.obtenerComercios(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text(Traducciones.traducirError(snapshot.error)));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No hay restaurantes registrados.'));
          }

          final comercios = snapshot.data!;

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: comercios.length,
            itemBuilder: (context, index) {
              final c = comercios[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: const Color(0xFF00D19D).withOpacity(0.1),
                    child: const Icon(Icons.restaurant, color: Color(0xFF00D19D)),
                  ),
                  title: Text(c.nombre, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text('${c.categoria} • ${c.direccion}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RestauranteFormularioPantalla(comercio: c),
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _confirmarEliminar(context, firestoreServicio, c),
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
          MaterialPageRoute(builder: (context) => const RestauranteFormularioPantalla()),
        ),
        backgroundColor: const Color(0xFF00D19D),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  void _confirmarEliminar(BuildContext context, FirestoreServicio servicio, Comercio comercio) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar Restaurante'),
        content: Text('¿Está seguro de que desea eliminar a ${comercio.nombre}?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
          TextButton(
            onPressed: () {
              servicio.eliminarComercio(comercio.id!);
              Navigator.pop(context);
            },
            child: const Text('Eliminar', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
