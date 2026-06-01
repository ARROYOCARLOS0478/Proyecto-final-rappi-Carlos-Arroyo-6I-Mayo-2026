import 'package:flutter/material.dart';
import '../modelos/pedido_modelo.dart';
import '../modelos/pago_modelo.dart';
import '../servicios/firestore_servicio.dart';
import '../core/constantes.dart';

class PedidoProveedor with ChangeNotifier {
  final FirestoreServicio _firestoreServicio = FirestoreServicio();

  List<Pedido> _pedidos = [];
  Pedido? _pedidoActual;
  bool _estaCargando = false;
  String? _error;

  List<Pedido> get pedidos => _pedidos;
  Pedido? get pedidoActual => _pedidoActual;
  bool get estaCargando => _estaCargando;
  String? get error => _error;

  /// Escuchar pedidos del usuario en tiempo real
  Stream<List<Pedido>> escucharPedidosUsuario(String usuarioId) {
    return _firestoreServicio.obtenerPedidosUsuario(usuarioId);
  }

  /// Escuchar un pedido específico en tiempo real (para tracking)
  Stream<Pedido?> escucharPedido(String pedidoId) {
    return _firestoreServicio.escucharPedido(pedidoId);
  }

  /// Crear un nuevo pedido desde el carrito
  Future<String?> crearPedido({
    required String usuarioId,
    required String comercioId,
    required Map<String, Map<String, dynamic>> itemsCarrito,
    required double total,
    required String direccion,
    required String metodoPago,
  }) async {
    _estaCargando = true;
    _error = null;
    notifyListeners();

    try {
      // Convertir items del carrito al formato del modelo
      final List<Map<String, dynamic>> items = itemsCarrito.entries.map((entry) {
        return {
          'productoId': entry.value['productoId'],
          'nombre': entry.value['nombre'],
          'cantidad': entry.value['cantidad'],
          'precio': entry.value['precio'],
          'imagenUrl': entry.value['imagenUrl'] ?? '',
        };
      }).toList();

      final pedido = Pedido(
        usuarioId: usuarioId,
        comercioId: comercioId,
        items: items,
        total: total,
        estado: Constantes.estadoPendiente,
        direccion: direccion,
        fechaCreacion: DateTime.now(),
        fechaActualizacion: DateTime.now(),
      );

      final pedidoId = await _firestoreServicio.guardarPedidoConId(pedido);

      // Registrar el pago
      final pago = Pago(
        pedidoId: pedidoId,
        monto: total,
        metodo: metodoPago,
        estado: 'completado',
        referencia: 'REF-${DateTime.now().millisecondsSinceEpoch}',
        fechaPago: DateTime.now(),
      );
      await _firestoreServicio.registrarPago(pago);

      _pedidoActual = Pedido(
        id: pedidoId,
        usuarioId: usuarioId,
        comercioId: comercioId,
        items: items,
        total: total,
        estado: Constantes.estadoPendiente,
        direccion: direccion,
        fechaCreacion: DateTime.now(),
        fechaActualizacion: DateTime.now(),
      );

      _estaCargando = false;
      notifyListeners();
      return pedidoId;
    } catch (e) {
      _error = 'Error al crear el pedido: $e';
      _estaCargando = false;
      notifyListeners();
      return null;
    }
  }

  void limpiarError() {
    _error = null;
    notifyListeners();
  }
}
