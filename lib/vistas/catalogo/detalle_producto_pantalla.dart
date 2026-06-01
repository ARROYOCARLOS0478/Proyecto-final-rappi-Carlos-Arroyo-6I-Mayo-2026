import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../modelos/producto_modelo.dart';
import '../../proveedores/carrito_proveedor.dart';
import '../../core/tema_app.dart';

class DetalleProductoPantalla extends StatefulWidget {
  final Producto producto;

  const DetalleProductoPantalla({super.key, required this.producto});

  @override
  State<DetalleProductoPantalla> createState() =>
      _DetalleProductoPantallaState();
}

class _DetalleProductoPantallaState extends State<DetalleProductoPantalla> {
  int cantidad = 1; // Estado local para el contador

  @override
  Widget build(BuildContext context) {
    // Calculamos el precio total según la cantidad seleccionada
    double precioTotal = widget.producto.precio * cantidad;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 350,
                pinned: true,
                backgroundColor: Colors.white,
                elevation: 0,
                flexibleSpace: FlexibleSpaceBar(
                  background: Image.network(
                    widget.producto.imagenUrl,
                    fit: BoxFit.cover,
                  ),
                ),
                leading: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    child: IconButton(
                      icon: const Icon(Icons.close, color: Colors.black),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(25),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "\$${widget.producto.precio.toInt()}",
                        style: const TextStyle(
                          fontSize: 28,
                          color: TemaApp.naranjaPrincipal,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        widget.producto.nombre.toUpperCase(),
                        style: const TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w900,
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 25),
                      const Text(
                        "DETALLES",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        widget.producto.descripcion,
                        style: const TextStyle(
                          fontSize: 16,
                          height: 1.4,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(
                        height: 120,
                      ), // Espacio para no tapar con el botón
                    ],
                  ),
                ),
              ),
            ],
          ),

          // --- BARRA INFERIOR (CONTADOR + BOTÓN AGREGAR) ---
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 15,
                    offset: Offset(0, -5),
                  ),
                ],
              ),
              child: Row(
                children: [
                  // SELECTOR DE CANTIDAD (El cuadro blanco con +/-)
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade200),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            if (cantidad > 1) setState(() => cantidad--);
                          },
                          icon: const Icon(Icons.remove, color: Colors.grey),
                        ),
                        Text(
                          "$cantidad",
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          onPressed: () => setState(() => cantidad++),
                          icon: const Icon(Icons.add, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 15),

                  // BOTÓN AGREGAR (Color Turquesa como Figma)
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        // Agregamos al proveedor N veces
                        for (int i = 0; i < cantidad; i++) {
                          context.read<CarritoProveedor>().agregarProducto(
                            widget.producto,
                          );
                        }
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              "Se agregaron $cantidad ${widget.producto.nombre}",
                            ),
                            backgroundColor: const Color(0xFF00C5AB),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(
                          0xFF00C5AB,
                        ), // Color Turquesa Figma
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        elevation: 0,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            "AGREGAR",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            "\$${precioTotal.toStringAsFixed(2)}",
                            style: const TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
