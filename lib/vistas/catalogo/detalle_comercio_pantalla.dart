import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import '../../core/tema_app.dart';
import '../../modelos/comercio_modelo.dart';
import '../../modelos/producto_modelo.dart';
import '../../proveedores/carrito_proveedor.dart';
import '../../servicios/firestore_servicio.dart';
import 'detalle_producto_pantalla.dart';

class DetalleComercioPantalla extends StatelessWidget {
  final Comercio comercio;

  const DetalleComercioPantalla({super.key, required this.comercio});

  @override
  Widget build(BuildContext context) {
    final firestoreServicio = FirestoreServicio();

    return Scaffold(
      backgroundColor: TemaApp.fondoClaro,
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(context),
          SliverToBoxAdapter(child: _buildInfoComercio()),
          SliverToBoxAdapter(
            child: StreamBuilder<List<Producto>>(
              stream: firestoreServicio.obtenerProductosComercio(comercio.id!),
              builder: (ctx, snap) {
                if (snap.connectionState == ConnectionState.waiting) {
                  return const Padding(
                    padding: EdgeInsets.all(40),
                    child: Center(
                      child: CircularProgressIndicator(
                        color: TemaApp.naranjaPrincipal,
                      ),
                    ),
                  );
                }
                final productos = snap.data ?? [];
                if (productos.isEmpty) return _buildSinProductos();

                final Map<String, List<Producto>> porCategoria = {};
                for (final p in productos) {
                  porCategoria.putIfAbsent(p.categoria, () => []).add(p);
                }

                return Padding(
                  padding: const EdgeInsets.fromLTRB(
                    16,
                    0,
                    16,
                    120,
                  ), // Espacio para el botón inferior
                  child: Column(
                    children: porCategoria.entries.map((entry) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildCategoriaHeader(entry.key),
                          ...entry.value.map(
                            (producto) => _ProductoItem(producto: producto),
                          ),
                        ],
                      );
                    }).toList(),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      // Botón estilo "VER CANASTA" de la imagen
      bottomSheet: _buildBarraCarrito(context),
    );
  }

  Widget _buildSliverAppBar(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 220,
      pinned: true,
      elevation: 0,
      leading: IconButton(
        icon: const CircleAvatar(
          backgroundColor: Colors.white,
          child: Icon(Icons.close, color: Colors.black),
        ),
        onPressed: () => Navigator.pop(context),
      ),
      actions: [
        IconButton(
          icon: const CircleAvatar(
            backgroundColor: Colors.white,
            child: Icon(
              Icons.favorite_border,
              color: Colors.black,
            ), // Botón corazón para Favoritos
          ),
          onPressed: () {
            // Lógica de favoritos a futuro
          },
        ),
      ],
      backgroundColor: TemaApp.naranjaPrincipal,
      flexibleSpace: FlexibleSpaceBar(
        background: CachedNetworkImage(
          imageUrl: comercio.imagenUrl,
          fit: BoxFit.cover,
          errorWidget: (_, __, ___) =>
              Container(color: TemaApp.naranjaPrincipal),
        ),
      ),
    );
  }

  Widget _buildInfoComercio() {
    return Container(
      transform: Matrix4.translationValues(
        0,
        -20,
        0,
      ), // Hace que suba un poco sobre la imagen
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            comercio.nombre.toUpperCase(),
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w900,
              fontStyle:
                  FontStyle.italic, // Estilo similar al logo de Little Caesars
            ),
          ),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _InfoText(label: 'ENTREGA', value: comercio.tiempoEntrega),
              _InfoText(
                label: 'ENVÍO',
                value: '\$${comercio.costoEnvio.toStringAsFixed(2)}',
              ),
              _InfoText(
                label: 'CALIF.',
                value: comercio.calificacion.toStringAsFixed(1),
                icon: Icons.star,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCategoriaHeader(String titulo) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            titulo,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: TemaApp.textoOscuro,
            ),
          ),
          Container(height: 3, width: 40, color: TemaApp.naranjaPrincipal),
        ],
      ),
    );
  }

  Widget _buildSinProductos() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(40),
        child: Text('No hay productos disponibles.'),
      ),
    );
  }

  // Widget inferior basado en la imagen: "VER CANASTA"
  Widget _buildBarraCarrito(BuildContext context) {
    return Consumer<CarritoProveedor>(
      builder: (_, carrito, __) {
        if (carrito.cantidadTotal == 0) return const SizedBox.shrink();

        return Container(
          padding: const EdgeInsets.all(16),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: ElevatedButton(
            onPressed: () {
              // Navegar a canasta
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(
                0xFF00C5A1,
              ), // Color turquesa de la imagen
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${carrito.cantidadTotal} productos',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '\$${carrito.precioTotal.toStringAsFixed(2)}',
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ],
                ),
                const Text(
                  'VER CANASTA',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// Widget auxiliar para la info de tiempo/costo
class _InfoText extends StatelessWidget {
  final String label;
  final String value;
  final IconData? icon;

  const _InfoText({required this.label, required this.value, this.icon});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.grey,
            fontSize: 10,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            if (icon != null) Icon(icon, size: 14, color: Colors.orange),
            Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
          ],
        ),
      ],
    );
  }
}

class _ProductoItem extends StatelessWidget {
  final Producto producto;
  const _ProductoItem({required this.producto});

  @override
  Widget build(BuildContext context) {
    return Consumer<CarritoProveedor>(
      builder: (_, carrito, __) {
        final cantidad = carrito.obtenerCantidad(producto.id!);

        return InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => DetalleProductoPantalla(producto: producto),
              ),
            );
          },
          child: Container(
            margin: const EdgeInsets.only(bottom: 15),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        producto.nombre.toUpperCase(),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        '\$${producto.precio.toStringAsFixed(0)}',
                        style: const TextStyle(
                          color: TemaApp.naranjaPrincipal,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Text(
                        "POPULAR • SELECCIONADO",
                        style: TextStyle(fontSize: 10, color: Colors.blueGrey),
                      ),
                    ],
                  ),
                ),
                Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: CachedNetworkImage(
                        imageUrl: producto.imagenUrl,
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => carrito.agregarProducto(producto),
                      child: Container(
                        margin: const EdgeInsets.all(5),
                        decoration: const BoxDecoration(
                          color: Color(0xFF00C5A1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.add,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
