import 'package:flutter/material.dart';
import '../../modelos/comercio_modelo.dart';
import '../../modelos/producto_modelo.dart';
import '../../servicios/firestore_servicio.dart';
import 'producto_formulario_pantalla.dart';
import '../../core/tema_app.dart';

class ProductoListaPantalla extends StatelessWidget {
  final Comercio comercio;

  const ProductoListaPantalla({super.key, required this.comercio});

  @override
  Widget build(BuildContext context) {
    final firestoreServicio = FirestoreServicio();

    return Scaffold(
      appBar: AppBar(title: Text('Productos: ${comercio.nombre}')),
      body: StreamBuilder<List<Producto>>(
        stream: firestoreServicio.obtenerProductosComercio(comercio.id!),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final productos = snapshot.data ?? [];
          if (productos.isEmpty) {
            return const Center(
              child: Text('Este negocio no tiene productos aún.'),
            );
          }

          return ListView.builder(
            itemCount: productos.length,
            itemBuilder: (context, index) {
              final p = productos[index];
              return ListTile(
                leading: p.imagenUrl.isNotEmpty
                    ? Image.network(
                        p.imagenUrl,
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                      )
                    : const Icon(Icons.fastfood),
                title: Text(p.nombre),
                subtitle: Text(
                  '\$${p.precio.toStringAsFixed(2)} - Stock: ${p.stock}',
                ),
                // --- CAMBIA ESTO ---
                trailing: Row(
                  mainAxisSize: MainAxisSize
                      .min, // Importante para que no use todo el ancho
                  children: [
                    // Botón Editar
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.blue),
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ProductoFormularioPantalla(
                            comercioId: comercio.id!,
                            producto: p,
                          ),
                        ),
                      ),
                    ),
                    // Botón Borrar (Si decides que sí lo quieres ver)
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _confirmarEliminarProducto(
                        context,
                        firestoreServicio,
                        p,
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: TemaApp.naranjaPrincipal,
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) =>
                ProductoFormularioPantalla(comercioId: comercio.id!),
          ),
        ),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  void _confirmarEliminarProducto(
    BuildContext context,
    FirestoreServicio servicio,
    Producto producto,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('¿Eliminar producto?'),
        content: Text('¿Estás seguro de eliminar "${producto.nombre}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('CANCELAR'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              await servicio.eliminarProducto(producto.id!);
              if (context.mounted) Navigator.pop(context);
            },
            child: const Text(
              'ELIMINAR',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
