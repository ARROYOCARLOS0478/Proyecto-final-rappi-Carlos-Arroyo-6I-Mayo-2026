import 'package:cloud_firestore/cloud_firestore.dart';

class Pago {
  final String? id;
  final String pedidoId;
  final double monto;
  final String metodo; // 'Tarjeta', 'Efectivo', 'Simulado'
  final String estado; // 'pendiente', 'completado', 'fallido'
  final String? referencia;
  final DateTime? fechaPago;

  Pago({
    this.id,
    required this.pedidoId,
    required this.monto,
    required this.metodo,
    required this.estado,
    this.referencia,
    this.fechaPago,
  });

  factory Pago.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Pago(
      id: doc.id,
      pedidoId: data['pedidoId'] ?? data['orderId'] ?? '',
      monto: (data['monto'] ?? data['amount'] ?? 0.0).toDouble(),
      metodo: data['metodo'] ?? data['method'] ?? 'Efectivo',
      estado: data['estado'] ?? data['status'] ?? 'pendiente',
      referencia: data['referencia'] ?? data['reference'],
      fechaPago:
          (data['fechaPago'] ?? data['timestamp'] as Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'pedidoId': pedidoId,
      'monto': monto,
      'metodo': metodo,
      'estado': estado,
      'referencia': referencia,
      'fechaPago': fechaPago != null
          ? Timestamp.fromDate(fechaPago!)
          : FieldValue.serverTimestamp(),
    };
  }
}
