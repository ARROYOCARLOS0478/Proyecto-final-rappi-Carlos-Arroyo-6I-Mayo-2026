import 'package:cloud_firestore/cloud_firestore.dart';

class Pago {
  final String? id;
  final String pedidoId;
  final String metodo; // 'Tarjeta', 'Efectivo', 'Simulado'
  final String estado; // 'Pendiente', 'Completado', 'Fallido'
  final DateTime? fecha;

  Pago({
    this.id,
    required this.pedidoId,
    required this.metodo,
    required this.estado,
    this.fecha,
  });

  factory Pago.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Pago(
      id: doc.id,
      pedidoId: data['pedidoId'] ?? data['orderId'] ?? '',
      metodo: data['metodo'] ?? data['method'] ?? 'Efectivo',
      estado: data['estado'] ?? data['status'] ?? 'Pendiente',
      fecha: (data['fecha'] ?? data['timestamp'] as Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'pedidoId': pedidoId,
      'metodo': metodo,
      'estado': estado,
      'fecha': fecha ?? FieldValue.serverTimestamp(),
    };
  }
}
