// pedido_proveedor.dart  (reemplaza / complementa tu PedidoProveedor)
//
// Cambios clave respecto a la versión anterior:
//  • repartidorId va a nivel RAÍZ del documento (no dentro de items)
//  • estado inicial = "Pendiente"
//  • comercioId a nivel raíz
//  • items contienen solo los datos del producto (sin repartidorId)

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class PedidoProveedor with ChangeNotifier {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // ── CREAR PEDIDO ────────────────────────────────────────────────────────────
  /// Devuelve el ID del pedido creado, o null si falla.
  Future<String?> crearPedido({
    required String usuarioId,
    required String comercioId,
    required Map<String, Map<String, dynamic>> itemsCarrito,
    required double total,
    required String direccion,
    required String metodoPago,
    String tipoEnvio = 'Estándar',
  }) async {
    try {
      // Construir lista de items limpia (sin repartidorId)
      final List<Map<String, dynamic>> items = itemsCarrito.values
          .map(
            (item) => {
              'productoId': item['productoId'],
              'comercioId': item['comercioId'],
              'nombre': item['nombre'],
              'precio': item['precio'],
              'cantidad': item['cantidad'],
              'imagenUrl': item['imagenUrl'],
            },
          )
          .toList();

      final docRef = await _db.collection('pedidos').add({
        // ── Campos raíz ────────────────────────────────────────────
        'usuarioId': usuarioId,
        'comercioId': comercioId, // Raíz, no dentro de items
        'repartidorId': null, // Raíz; se actualiza cuando un repartidor acepta
        'estado': 'Pendiente', // Estado inicial requerido
        'metodoPago': metodoPago,
        'tipoEnvio': tipoEnvio,
        'direccionEntrega': direccion,
        'total': total,
        'creadoEn': FieldValue.serverTimestamp(),
        'actualizadoEn': FieldValue.serverTimestamp(),
        // ── Items ───────────────────────────────────────────────────
        'items': items,
      });

      debugPrint('Pedido creado: ${docRef.id}');
      return docRef.id;
    } catch (e) {
      debugPrint('Error al crear pedido: $e');
      return null;
    }
  }

  // ── ESCUCHAR CAMBIOS DEL PEDIDO ─────────────────────────────────────────────
  Stream<DocumentSnapshot<Map<String, dynamic>>> escucharPedido(
    String pedidoId,
  ) {
    return _db.collection('pedidos').doc(pedidoId).snapshots();
  }

  // ── OBTENER DATOS DEL REPARTIDOR ────────────────────────────────────────────
  /// Busca en la colección `repartidores` por el UID del repartidor asignado.
  Future<Map<String, dynamic>?> obtenerRepartidor(String repartidorId) async {
    try {
      final doc = await _db.collection('repartidores').doc(repartidorId).get();
      if (doc.exists) return doc.data();
      return null;
    } catch (e) {
      debugPrint('Error al obtener repartidor: $e');
      return null;
    }
  }
}

// ── EXTENSIÓN ÚTIL: mapeo de estado → progreso ──────────────────────────────
/// Convierte el campo `estado` de Firestore a un valor 0.0 – 1.0
/// para el LinearProgressIndicator.
double estadoAProgreso(String? estado) {
  switch (estado) {
    case 'Pendiente':
      return 0.0;
    case 'Alistando':
      return 0.25;
    case 'Preparando':
      return 0.50;
    case 'En camino':
      return 0.75;
    case 'Entregado':
      return 1.0;
    default:
      return 0.0;
  }
}
