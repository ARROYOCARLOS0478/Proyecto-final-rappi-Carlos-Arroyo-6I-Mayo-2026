import 'package:flutter/material.dart';
import '../../modelos/comercio_modelo.dart';
import '../../servicios/firestore_servicio.dart';
import 'negocio_formulario_pantalla.dart';
import 'producto_lista_pantalla.dart';

class NegocioListaPantalla extends StatelessWidget {
  final String categoriaFiltro;
  const NegocioListaPantalla({super.key, required this.categoriaFiltro});

  @override
  Widget build(BuildContext context) {
    final firestoreServicio = FirestoreServicio();

    return Scaffold(
      appBar: AppBar(
        title: Text('Gestionar: $categoriaFiltro'),
        backgroundColor: Colors.orange,
      ),
      body: StreamBuilder<List<Comercio>>(
        stream: firestoreServicio.obtenerComerciosPorCategoria(categoriaFiltro),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No hay negocios en $categoriaFiltro'));
          }

          final comercios = snapshot.data!;

          return ListView.builder(
            padding: const EdgeInsets.all(10),
            itemCount: comercios.length,
            itemBuilder: (context, index) {
              final c = comercios[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 10),
                child: ListTile(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ProductoListaPantalla(comercio: c),
                    ),
                  ),
                  leading: CircleAvatar(
                    backgroundImage: c.imagenUrl.isNotEmpty
                        ? NetworkImage(c.imagenUrl)
                        : null,
                    child: c.imagenUrl.isEmpty ? const Icon(Icons.store) : null,
                  ),
                  title: Text(
                    c.nombre,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(c.direccion),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => NegocioFormularioPantalla(
                              negocio: c,
                              categoriaAutomatica: categoriaFiltro, // <-- PASAR CATEGORÍA AL EDITAR
                            ),
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () =>
                            _confirmarEliminar(context, firestoreServicio, c),
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
          MaterialPageRoute(
            builder: (_) => NegocioFormularioPantalla(
              categoriaAutomatica: categoriaFiltro, // <-- PASAR CATEGORÍA AL CREAR NUEVO
            ),
          ),
        ),
        backgroundColor: Colors.orange,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  void _confirmarEliminar(
    BuildContext context,
    FirestoreServicio servicio,
    Comercio c,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar'),
        content: Text('¿Borrar "${c.nombre}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('NO'),
          ),
          TextButton(
            onPressed: () {
              servicio.eliminarComercio(c.id!);
              Navigator.pop(context);
            },
            child: const Text('SÍ'),
          ),
        ],
      ),
    );
  }
}