import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import '../../core/tema_app.dart';
import '../../modelos/comercio_modelo.dart';
import '../../modelos/producto_modelo.dart';
import '../../proveedores/carrito_proveedor.dart';
import '../../servicios/firestore_servicio.dart';
import '../carrito/carrito_pantalla.dart';
import 'detalle_producto_pantalla.dart';
import 'package:gestionrappi/proveedores/autenticacion_proveedor.dart';

class DetalleComercioPantalla extends StatelessWidget {
  final Comercio comercio;

  const DetalleComercioPantalla({super.key, required this.comercio});

  static const Color _verde = Color(0xFF00C5AB);
  static const Color _naranja = Color(0xFFFF441F);

  @override
  Widget build(BuildContext context) {
    final firestoreServicio = FirestoreServicio();

    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(context),
          SliverToBoxAdapter(child: _buildInfoComercio()),
          SliverToBoxAdapter(child: _buildTabsSelector()),
          SliverToBoxAdapter(
            child: StreamBuilder<List<Producto>>(
              stream: firestoreServicio.obtenerProductosComercio(comercio.id!),
              builder: (ctx, snap) {
                if (snap.connectionState == ConnectionState.waiting) {
                  return const Padding(
                    padding: EdgeInsets.all(40),
                    child: Center(
                      child: CircularProgressIndicator(color: _verde),
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
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 130),
                  child: Column(
                    children: porCategoria.entries.map((entry) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildCategoriaHeader(entry.key),
                          // Grid de 2 columnas para los productos
                          GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  childAspectRatio: 0.82,
                                  crossAxisSpacing: 12,
                                  mainAxisSpacing: 12,
                                ),
                            itemCount: entry.value.length,
                            itemBuilder: (_, i) =>
                                _ProductoCard(producto: entry.value[i]),
                          ),
                          const SizedBox(height: 10),
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
      bottomSheet: _buildBarraCarrito(context),
    );
  }

  Widget _buildSliverAppBar(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 240,
      pinned: true,
      elevation: 0,
      backgroundColor: Colors.white,
      leading: Padding(
        padding: const EdgeInsets.all(8),
        child: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.close, color: Colors.black, size: 20),
          ),
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.all(8),
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(
                Icons.favorite_border,
                color: Colors.black,
                size: 20,
              ),
              onPressed: () {},
            ),
          ),
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: CachedNetworkImage(
          imageUrl: comercio.imagenUrl,
          fit: BoxFit.cover,
          errorWidget: (_, __, ___) => Container(color: Colors.orange.shade200),
        ),
      ),
    );
  }

  Widget _buildInfoComercio() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            comercio.nombre.toUpperCase(),
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w900,
              fontStyle: FontStyle.italic,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey.shade100),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _InfoChip(
                  icon: Icons.access_time_outlined,
                  label: 'ENTREGA',
                  value: comercio.tiempoEntrega,
                ),
                Container(width: 1, height: 30, color: Colors.grey.shade200),
                _InfoChip(
                  icon: Icons.delivery_dining_outlined,
                  label: 'ENVÍO',
                  value: '\$${comercio.costoEnvio.toStringAsFixed(0)}',
                  valueColor: Colors.black,
                ),
                Container(width: 1, height: 30, color: Colors.grey.shade200),
                _InfoChip(
                  icon: Icons.star,
                  label: 'CALIF.',
                  value: comercio.calificacion.toStringAsFixed(1),
                  iconColor: Colors.amber,
                ),
              ],
            ),
          ),
          const SizedBox(height: 6),
        ],
      ),
    );
  }

  Widget _buildTabsSelector() {
    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          const TabBar(
            indicatorColor: _naranja,
            indicatorWeight: 3,
            labelColor: _naranja,
            unselectedLabelColor: Colors.grey,
            labelStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            tabs: [
              Tab(text: 'Menú'),
              Tab(text: 'Combos'),
            ],
          ),
          Container(height: 1, color: Colors.grey.shade100),
        ],
      ),
    );
  }

  Widget _buildCategoriaHeader(String titulo) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 14),
      child: Text(
        titulo,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
      ),
    );
  }

  Widget _buildSinProductos() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(40),
        child: Column(
          children: [
            Icon(Icons.restaurant_menu, size: 50, color: Colors.grey),
            SizedBox(height: 12),
            Text(
              'No hay productos disponibles.',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBarraCarrito(BuildContext context) {
    return Consumer<CarritoProveedor>(
      builder: (_, carrito, __) {
        if (carrito.cantidadTotal == 0) return const SizedBox.shrink();

        return Container(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(20),
                blurRadius: 15,
                offset: const Offset(0, -5),
              ),
            ],
          ),
          child: ElevatedButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const CarritoPantalla()),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: _verde,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
              elevation: 0,
            ),
            child: Row(
              children: [
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: Colors.white.withAlpha(50),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      '${carrito.cantidadTotal}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ),
                const Expanded(
                  child: Text(
                    'VER CANASTA',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                      fontSize: 16,
                    ),
                  ),
                ),
                Text(
                  '\$${carrito.precioTotal.toStringAsFixed(2)}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
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

// ── Chip de info del comercio ─────────────────────────────────────────────────
class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color? valueColor;
  final Color? iconColor;

  const _InfoChip({
    required this.icon,
    required this.label,
    required this.value,
    this.valueColor,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.grey,
            fontSize: 9,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 13, color: iconColor ?? Colors.grey),
            const SizedBox(width: 3),
            Text(
              value,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 13,
                color: valueColor ?? Colors.black,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// ── Tarjeta de producto en grid ───────────────────────────────────────────────
class _ProductoCard extends StatelessWidget {
  final Producto producto;
  const _ProductoCard({required this.producto});

  static const Color _verde = Color(0xFF00C5AB);

  @override
  Widget build(BuildContext context) {
    return Consumer<CarritoProveedor>(
      builder: (_, carrito, __) {
        final cantidad = carrito.obtenerCantidad(producto.id!);

        return GestureDetector(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => DetalleProductoPantalla(producto: producto),
            ),
          ),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey.shade100),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Imagen con botón +
                Expanded(
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(16),
                        ),
                        child: CachedNetworkImage(
                          imageUrl: producto.imagenUrl,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorWidget: (_, __, ___) => Container(
                            color: Colors.grey[100],
                            child: const Icon(
                              Icons.fastfood,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ),
                      // Botón + en la esquina inferior derecha
                      Positioned(
                        bottom: 8,
                        right: 8,
                        child: GestureDetector(
                          onTap: () {
                            // 1. Obtenemos el provider
                            final authProv = context
                                .read<AutenticacionProveedor>();

                            // 2. Bloqueo con el rol "administrador"
                            if (authProv.usuarioDatos?.rol?.toLowerCase() ==
                                'administrador') {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    "Modo Administrador: No tienes permisos para realizar compras.",
                                  ),
                                  backgroundColor: Colors.redAccent,
                                  behavior: SnackBarBehavior.floating,
                                  duration: Duration(seconds: 2),
                                ),
                              );
                              return; // Detiene la ejecución para que no se agregue al carrito
                            }

                            // 3. Lógica normal para clientes
                            context.read<CarritoProveedor>().agregarProducto(
                              producto,
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: const BoxDecoration(
                              color: Color(
                                0xFF00C5AB,
                              ), // Tu color verde de Rappi
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.add,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // Info del producto
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 8, 10, 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        producto.nombre.toUpperCase(),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          Text(
                            '\$${producto.precio.toStringAsFixed(0)}',
                            style: const TextStyle(
                              color: Colors.orange,
                              fontWeight: FontWeight.w900,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                      const Text(
                        "POPULAR • SELECCIONADO",
                        style: TextStyle(fontSize: 8, color: Colors.blueGrey),
                      ),
                    ],
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
