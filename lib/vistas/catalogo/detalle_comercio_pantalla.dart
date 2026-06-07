// detalle_comercio_pantalla.dart
// ✅ TAREA 4: Descuentos con precio tachado y precio final
// ✅ TAREA 5: Botón favorito que guarda/elimina en Firestore

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../modelos/comercio_modelo.dart';
import '../../modelos/producto_modelo.dart';
import '../../proveedores/carrito_proveedor.dart';
import '../../proveedores/autenticacion_proveedor.dart';
import '../../servicios/firestore_servicio.dart';
import '../carrito/carrito_pantalla.dart';
import 'detalle_producto_pantalla.dart';

class DetalleComercioPantalla extends StatefulWidget {
  final Comercio comercio;
  const DetalleComercioPantalla({super.key, required this.comercio});

  @override
  State<DetalleComercioPantalla> createState() =>
      _DetalleComercioPantallaState();
}

class _DetalleComercioPantallaState extends State<DetalleComercioPantalla> {
  static const Color _verde = Color(0xFF00C5AB);
  static const Color _naranja = Color(0xFFFF441F);

  // ✅ TAREA 5: Estado local del favorito para respuesta inmediata en UI
  bool _esFavorito = false;
  bool _cargandoFavorito = true;

  @override
  void initState() {
    super.initState();
    _verificarFavorito();
  }

  // ✅ TAREA 5: Verifica si este comercio ya está en favoritos del usuario
  Future<void> _verificarFavorito() async {
    final authProv = Provider.of<AutenticacionProveedor>(
      context,
      listen: false,
    );
    final uid = authProv.usuarioDatos?.uid ?? authProv.usuarioFirebase?.uid;
    if (uid == null) {
      setState(() => _cargandoFavorito = false);
      return;
    }

    try {
      final doc = await FirebaseFirestore.instance
          .collection('usuarios')
          .doc(uid)
          .get();
      if (doc.exists) {
        final favoritos = List<String>.from(doc.data()?['favoritos'] ?? []);
        setState(() {
          _esFavorito = favoritos.contains(widget.comercio.id);
          _cargandoFavorito = false;
        });
      } else {
        setState(() => _cargandoFavorito = false);
      }
    } catch (_) {
      setState(() => _cargandoFavorito = false);
    }
  }

  // ✅ TAREA 5: Alterna favorito y actualiza Firestore
  Future<void> _toggleFavorito() async {
    final authProv = Provider.of<AutenticacionProveedor>(
      context,
      listen: false,
    );
    final uid = authProv.usuarioDatos?.uid ?? authProv.usuarioFirebase?.uid;
    if (uid == null) return;

    final nuevoEstado = !_esFavorito;
    setState(() => _esFavorito = nuevoEstado); // Respuesta inmediata en UI

    try {
      await FirebaseFirestore.instance.collection('usuarios').doc(uid).update({
        'favoritos': nuevoEstado
            ? FieldValue.arrayUnion([widget.comercio.id])
            : FieldValue.arrayRemove([widget.comercio.id]),
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              nuevoEstado
                  ? '❤️ Agregado a favoritos'
                  : '💔 Eliminado de favoritos',
            ),
            behavior: SnackBarBehavior.floating,
            backgroundColor: nuevoEstado ? _verde : Colors.grey[700],
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      // Revertir si falla
      setState(() => _esFavorito = !nuevoEstado);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error al actualizar favoritos')),
        );
      }
    }
  }

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
              stream: firestoreServicio.obtenerProductosComercio(
                widget.comercio.id!,
              ),
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
                          GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  childAspectRatio:
                                      0.80, // ligeramente más alto para el precio
                                  crossAxisSpacing: 12,
                                  mainAxisSpacing: 12,
                                ),
                            itemCount: entry.value.length,
                            itemBuilder: (_, i) => _ProductoCard(
                              producto: entry.value[i],
                              descuentoNegocio:
                                  widget.comercio.descuentoNegocio,
                            ),
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
        // ✅ TAREA 5: Botón favorito funcional
        Padding(
          padding: const EdgeInsets.all(8),
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: _cargandoFavorito
                ? const Padding(
                    padding: EdgeInsets.all(10),
                    child: SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: _naranja,
                      ),
                    ),
                  )
                : IconButton(
                    icon: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      transitionBuilder: (child, anim) =>
                          ScaleTransition(scale: anim, child: child),
                      child: Icon(
                        _esFavorito ? Icons.favorite : Icons.favorite_border,
                        key: ValueKey(_esFavorito),
                        color: _esFavorito ? Colors.red : Colors.black,
                        size: 22,
                      ),
                    ),
                    onPressed: _toggleFavorito,
                  ),
          ),
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: CachedNetworkImage(
          imageUrl: widget.comercio.imagenUrl,
          fit: BoxFit.cover,
          errorWidget: (_, _, _) => Container(color: Colors.orange.shade200),
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
            widget.comercio.nombre.toUpperCase(),
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
                  value: widget.comercio.tiempoEntrega,
                ),
                Container(width: 1, height: 30, color: Colors.grey.shade200),
                _InfoChip(
                  icon: Icons.delivery_dining_outlined,
                  label: 'ENVÍO',
                  value: '\$${widget.comercio.costoEnvio.toStringAsFixed(0)}',
                  valueColor: Colors.black,
                ),
                Container(width: 1, height: 30, color: Colors.grey.shade200),
                _InfoChip(
                  icon: Icons.star,
                  label: 'CALIF.',
                  value: widget.comercio.calificacion.toStringAsFixed(1),
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
      builder: (_, carrito, _) {
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

// ── Info chip ─────────────────────────────────────────────────────────────────
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

// ── Tarjeta de producto con descuento ─────────────────────────────────────────
class _ProductoCard extends StatelessWidget {
  final Producto producto;
  final int descuentoNegocio;
  const _ProductoCard({required this.producto, required this.descuentoNegocio});

  static const Color _naranja = Color(0xFFFF441F);

  @override
  Widget build(BuildContext context) {
    // ✅ TAREA 4: Calcular precio con descuento usando el mayor descuento disponible
    final int descuentoProducto = (producto.descuento ?? 0).toInt();
    final int descuentoAplicado = descuentoNegocio > descuentoProducto
        ? descuentoNegocio
        : descuentoProducto;
    final bool tieneDescuento = descuentoAplicado > 0;
    final double precioFinal = tieneDescuento
        ? producto.precio * (1 - descuentoAplicado / 100)
        : producto.precio;

    return Consumer<CarritoProveedor>(
      builder: (_, carrito, _) {
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
                          errorWidget: (_, _, _) => Container(
                            color: Colors.grey[100],
                            child: const Icon(
                              Icons.fastfood,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ),
                      // ✅ TAREA 4: Badge de descuento sobre la imagen
                      if (tieneDescuento)
                        Positioned(
                          top: 8,
                          left: 8,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: _naranja,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              '-$descuentoAplicado%',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w900,
                                fontSize: 11,
                              ),
                            ),
                          ),
                        ),
                      // Botón +
                      Positioned(
                        bottom: 8,
                        right: 8,
                        child: GestureDetector(
                          onTap: () {
                            final authProv = context
                                .read<AutenticacionProveedor>();
                            if (authProv.usuarioDatos?.rol.toLowerCase() ==
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
                              return;
                            }
                            final carrito = context.read<CarritoProveedor>();
                            carrito.agregarProducto(producto).then((resultado) {
                              if (resultado == AgregarResultado.comercioDiferente && context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("Vacía el carrito para agregar el producto."),
                                    backgroundColor: Colors.redAccent,
                                  ),
                                );
                              }
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: const BoxDecoration(
                              color: Color(0xFF00C5AB),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
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
                      const SizedBox(height: 4),
                      // ✅ TAREA 4: Precio original tachado + precio con descuento
                      if (tieneDescuento) ...[
                        Row(
                          children: [
                            // Precio original tachado
                            Text(
                              '\$${producto.precio.toStringAsFixed(0)}',
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 11,
                                decoration: TextDecoration.lineThrough,
                                decorationColor: Colors.grey,
                              ),
                            ),
                            const SizedBox(width: 6),
                            // Precio con descuento
                            Text(
                              '\$${precioFinal.toStringAsFixed(0)}',
                              style: const TextStyle(
                                color: _naranja,
                                fontWeight: FontWeight.w900,
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                      ] else ...[
                        // Precio normal sin descuento
                        Text(
                          '\$${producto.precio.toStringAsFixed(0)}',
                          style: const TextStyle(
                            color: Colors.orange,
                            fontWeight: FontWeight.w900,
                            fontSize: 14,
                          ),
                        ),
                      ],
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
