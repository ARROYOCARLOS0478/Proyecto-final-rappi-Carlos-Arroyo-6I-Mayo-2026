import 'package:flutter/material.dart';
import 'negocio_lista_pantalla.dart';
import '../../core/tema_app.dart';

class CategoriasAdminPantalla extends StatelessWidget {
  const CategoriasAdminPantalla({super.key});

  final List<Map<String, dynamic>> categorias = const [
    {
      'nombre': 'Restaurantes',
      'icon': Icons.restaurant,
      'color': Colors.orange,
    },
    {
      'nombre': 'Supermercado',
      'icon': Icons.shopping_cart,
      'color': Colors.green,
    },
    {'nombre': 'Farmacia', 'icon': Icons.local_pharmacy, 'color': Colors.blue},
    {'nombre': 'Tiendas', 'icon': Icons.store, 'color': Colors.purple},
    {'nombre': 'Express', 'icon': Icons.delivery_dining, 'color': Colors.red},
    {'nombre': 'Licor', 'icon': Icons.local_bar, 'color': Colors.brown},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Categorías de Negocio')),
      body: GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(), // Bloquea el scroll para que quepa en una pantalla
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3, // 3 columnas
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 1.70, // Ajusta este número para reducir la altura de las tarjetas
          ),
          itemCount: 6,
          itemBuilder: (context, index) {
          // Extraemos el nombre para que el código sea más limpio
          final String nombreCategoria = categorias[index]['nombre'];

          return InkWell(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                // Cambiamos categorias[index] por nombreCategoria
                builder: (_) =>
                    NegocioListaPantalla(categoriaFiltro: nombreCategoria),
              ),
            ),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.grey.shade200),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black,
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.orange.shade50,
                    radius: 20,
                    child: const Icon(
                      Icons.storefront,
                      color: Colors.orange,
                      size: 20,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    // AQUÍ ESTABA EL ERROR: Accedemos al nombre antes del toUpperCase
                    nombreCategoria.toUpperCase(),
                    style: const TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 12,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
