import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import '../../core/tema_app.dart';
import '../../proveedores/carrito_proveedor.dart';
import '../../proveedores/autenticacion_proveedor.dart';
import '../checkout/checkout_pantalla.dart';

class CarritoPantalla extends StatelessWidget {
  final bool esTab;

  const CarritoPantalla({super.key, this.esTab = false});

  @override
  Widget build(BuildContext context) {
    final carrito = Provider.of<CarritoProveedor>(context);
    final authProv = Provider.of<AutenticacionProveedor>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'MI CANASTA',
              style: TextStyle(
                color: Color(0xFF001D3D),
                fontWeight: FontWeight.w900,
                fontSize: 18,
              ),
            ),
            Text(
              'LITTLE CAESARS', // Esto podría venir dinámico del carrito
              style: TextStyle(
                color: const Color(0xFF00C5AB),
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      body: carrito.items.isEmpty
          ? _CarritoVacio()
          : _CarritoConItems(carrito: carrito, authProv: authProv),
    );
  }
}

class _CarritoConItems extends StatelessWidget {
  final CarritoProveedor carrito;
  final AutenticacionProveedor authProv;

  const _CarritoConItems({required this.carrito, required this.authProv});

  @override
  Widget build(BuildContext context) {
    // Calculamos el total (En tu Imagen 2 solo se muestra el Total a Pagar abajo)
    final double total = carrito.precioTotal;

    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            itemCount: carrito.items.length,
            itemBuilder: (ctx, i) {
              final entry = carrito.items.entries.elementAt(i);
              final productoId = entry.key;
              final item = entry.value;

              return Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: Row(
                  children: [
                    // Imagen redondeada como Figma
                    ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: CachedNetworkImage(
                        imageUrl: item['imagenUrl'] as String? ?? '',
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(width: 15),
                    // Info del producto
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            (item['nombre'] as String).toUpperCase(),
                            style: const TextStyle(
                              fontWeight: FontWeight.w900,
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            '\$${(item['precio'] as double).toStringAsFixed(2)}',
                            style: const TextStyle(
                              color: Color(0xFFFF4D00),
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Controles Estilo Figma (Píldora Gris)
                    Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFF2F4F7),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          IconButton(
                            icon: const Icon(
                              Icons.delete_outline,
                              color: Color(0xFFFF4D00),
                              size: 20,
                            ),
                            onPressed: () =>
                                carrito.removerProducto(productoId),
                          ),
                          Text(
                            '${item['cantidad']}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.add,
                              color: Colors.grey,
                              size: 20,
                            ),
                            onPressed: () =>
                                carrito.incrementarDesdeId(productoId),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        // Footer con Total y Botón Continuar
        Container(
          padding: const EdgeInsets.all(25),
          decoration: const BoxDecoration(
            color: Colors.white,
            border: Border(top: BorderSide(color: Color(0xFFF2F4F7))),
          ),
          child: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "TOTAL A PAGAR",
                    style: TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                  Text(
                    "\$${total.toStringAsFixed(2)}",
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF001D3D),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 20),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => CheckoutPantalla(
                          costoEnvio: 20.0,
                          total: total + 20.0,
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF00C5AB),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    "CONTINUAR",
                    style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _CarritoVacio extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Center(child: Text("Tu canasta está vacía"));
  }
}
