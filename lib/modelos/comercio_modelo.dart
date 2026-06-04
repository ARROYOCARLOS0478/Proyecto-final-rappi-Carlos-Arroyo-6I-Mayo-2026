import 'package:cloud_firestore/cloud_firestore.dart';

class Comercio {
  final String? id;
  final String nombre;
  final String categoria;
  final String direccion;
  final String telefono;
  final String horario;
  final double calificacion;
  final String imagenUrl;
  final bool estaActivo;
  final String duenoId;
  final String tiempoEntrega;
  final double costoEnvio;
  final int descuentoNegocio; // Solo una vez declarada
  final DateTime? fechaRegistro;

  Comercio({
    this.id,
    required this.nombre,
    required this.categoria,
    required this.direccion,
    required this.telefono,
    required this.horario,
    this.calificacion = 0.0,
    this.imagenUrl = '',
    this.estaActivo = true,
    this.duenoId = '',
    this.tiempoEntrega = '20-30 min',
    this.costoEnvio = 0.0,
    this.descuentoNegocio = 0, // Quitamos el duplicado de aquí también
    this.fechaRegistro,
  });

  factory Comercio.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Comercio(
      id: doc.id,
      nombre: data['nombre'] ?? '',
      categoria: data['categoria'] ?? '',
      direccion: data['direccion'] ?? '',
      telefono: data['telefono'] ?? '',
      horario: data['horario'] ?? '',
      calificacion: (data['calificacion'] ?? 0.0).toDouble(),
      imagenUrl: data['imagenUrl'] ?? '',
      estaActivo: data['estaActivo'] ?? data['isActive'] ?? true,
      duenoId: data['duenoId'] ?? data['ownerId'] ?? '',
      tiempoEntrega:
          data['tiempoEntrega'] ?? data['deliveryTime'] ?? '20-30 min',
      costoEnvio: (data['costoEnvio'] ?? data['deliveryCost'] ?? 0.0)
          .toDouble(),
      descuentoNegocio: (data['descuentoNegocio'] ?? data['discount'] ?? 0)
          .toInt(),
      fechaRegistro: (data['fechaRegistro'] as Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'nombre': nombre,
      'categoria': categoria,
      'direccion': direccion,
      'telefono': telefono,
      'horario': horario,
      'calificacion': calificacion,
      'imagenUrl': imagenUrl,
      'estaActivo': estaActivo,
      'duenoId': duenoId,
      'tiempoEntrega': tiempoEntrega,
      'costoEnvio': costoEnvio,
      'descuentoNegocio': descuentoNegocio,
      'fechaRegistro': fechaRegistro ?? FieldValue.serverTimestamp(),
    };
  }
}
