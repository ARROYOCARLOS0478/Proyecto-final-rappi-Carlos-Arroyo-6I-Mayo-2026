// pedido_modelo.dart

import 'package:cloud_firestore/cloud_firestore.dart';

class Pedido {
  final String? id;
  final String usuarioId;
  final String comercioId;
  final String comercioNombre;
  final List<Map<String, dynamic>>
  items; // Cada item: { 'productoId', 'nombre', 'cantidad', 'precio' }
  final double total;
  final String
  estado; // e.g., 'Pendiente', 'Preparando', 'En Camino', 'Entregado'
  final String direccion;
  final String? repartidorId;
  final DateTime? fechaCreacion;
  final DateTime? fechaActualizacion;

  Pedido({
    this.id,
    required this.usuarioId,
    required this.comercioId,
    required this.comercioNombre,
    required this.items,
    required this.total,
    required this.estado,
    required this.direccion,
    this.repartidorId,
    this.fechaCreacion,
    this.fechaActualizacion,
  });

  factory Pedido.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Pedido(
      id: doc.id,
      usuarioId: data['usuarioId'] ?? data['userId'] ?? '',
      comercioId: data['comercioId'] ?? data['merchantId'] ?? '',
      comercioNombre: data['comercioNombre'] ?? 'Negocio',
      items: List<Map<String, dynamic>>.from(data['items'] ?? []),
      total: (data['total'] ?? 0.0).toDouble(),
      estado: data['estado'] ?? data['status'] ?? 'Pendiente',
      direccion: data['direccion'] ?? data['direccionEntrega'] ?? data['address'] ?? '',
      repartidorId: data['repartidorId'] ?? data['riderId'],
      fechaCreacion: (data['fechaCreacion'] as Timestamp? ??
                      data['createdAt'] as Timestamp? ??
                      data['creadoEn'] as Timestamp?)?.toDate(),
      fechaActualizacion: (data['fechaActualizacion'] as Timestamp? ??
                           data['updatedAt'] as Timestamp? ??
                           data['actualizadoEn'] as Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'usuarioId': usuarioId,
      'comercioId': comercioId,
      'items': items,
      'total': total,
      'estado': estado,
      'direccion': direccion,
      'repartidorId': repartidorId,
      'fechaCreacion': fechaCreacion ?? FieldValue.serverTimestamp(),
      'fechaActualizacion': fechaActualizacion ?? FieldValue.serverTimestamp(),
    };
  }
}
