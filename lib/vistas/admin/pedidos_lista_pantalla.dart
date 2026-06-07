import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'dart:math' as math;
import '../../modelos/pedido_modelo.dart';
import '../../servicios/firestore_servicio.dart';
import '../../proveedores/autenticacion_proveedor.dart';
import '../login/login_pantalla.dart';
import '../../core/traducciones.dart';

class PedidosListaPantalla extends StatelessWidget {
  const PedidosListaPantalla({super.key});

  Color _obtenerColorEstado(String estado) {
    switch (estado.toLowerCase()) {
      case 'pendiente':
        return Colors.orange;
      case 'preparando':
        return Colors.blue;
      case 'en camino':
        return Colors.purple;
      case 'entregado':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final firestoreServicio = FirestoreServicio();
    final authProv = Provider.of<AutenticacionProveedor>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Panel de Pedidos'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await authProv.logout();
              if (context.mounted) {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginPantalla()),
                  (route) => false,
                );
              }
            },
          ),
        ],
      ),
      body: StreamBuilder<List<Pedido>>(
        stream: firestoreServicio.obtenerTodosLosPedidos(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
              child: Text(Traducciones.traducirError(snapshot.error)),
            );
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No hay pedidos registrados.'));
          }

          final pedidos = snapshot.data!;

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: pedidos.length,
            itemBuilder: (context, index) {
              final p = pedidos[index];
              final String fechaFormateada = p.fechaCreacion != null
                  ? DateFormat('dd/MM/yyyy HH:mm').format(p.fechaCreacion!)
                  : 'Sin fecha';

              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 3,
                child: ExpansionTile(
                  leading: CircleAvatar(
                    backgroundColor: _obtenerColorEstado(p.estado).withValues(alpha: 0.2),
                    child: Icon(
                      Icons.receipt,
                      color: _obtenerColorEstado(p.estado),
                    ),
                  ),
                  title: Text(
                    p.comercioNombre.toUpperCase(),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    'Total: \$${p.total.toStringAsFixed(2)} • Estado: ${p.estado}\nID: ${p.id?.substring(0, math.min(p.id!.length, 8)) ?? ""}',
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _confirmarEliminar(context, firestoreServicio, p),
                  ),
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Divider(),
                          const Text(
                            'Detalles del Pedido:',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text('ID Completo: ${p.id ?? "N/A"}'),
                          Text('Cliente ID: ${p.usuarioId}'),
                          if (p.repartidorId != null)
                            Text('Repartidor ID: ${p.repartidorId}'),
                          Text('Fecha: $fechaFormateada'),
                          Text('Dirección: ${p.direccion}'),
                          Text('Método de Pago: ${(p.metodoPago ?? "efectivo").toUpperCase()}'),
                          const SizedBox(height: 12),
                          const Text(
                            'Productos:',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 6),
                          ...p.items.map((item) {
                            final String nombreItem = item['nombre'] ?? 'Producto';
                            final int cantidadItem = item['cantidad'] ?? 1;
                            final double precioItem = (item['precio'] ?? 0.0).toDouble();
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 2.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('$cantidadItem x $nombreItem'),
                                  Text('\$${(precioItem * cantidadItem).toStringAsFixed(2)}'),
                                ],
                              ),
                            );
                          }),
                          const Divider(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'TOTAL:',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text(
                                '\$${p.total.toStringAsFixed(2)}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _confirmarEliminar(
    BuildContext context,
    FirestoreServicio servicio,
    Pedido pedido,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar Pedido'),
        content: Text(
          '¿Estás seguro de eliminar el pedido de ${pedido.comercioNombre}?\nEsta acción no se puede deshacer.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () async {
              await servicio.eliminarPedido(pedido.id!);
              if (context.mounted) Navigator.pop(context);
            },
            child: const Text('Eliminar', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
