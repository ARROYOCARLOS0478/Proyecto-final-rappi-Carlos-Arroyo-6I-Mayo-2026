import 'package:cloud_firestore/cloud_firestore.dart';

class Repartidor {
  final String? id;
  final String nombre;
  final String email;
  final String telefono;
  final String vehiculo;
  final String estado; // e.g., 'Activo', 'Inactivo'
  final DateTime? fechaRegistro;

  Repartidor({
    this.id,
    required this.nombre,
    required this.email,
    required this.telefono,
    required this.vehiculo,
    required this.estado,
    this.fechaRegistro,
  });

  factory Repartidor.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Repartidor(
      id: doc.id,
      nombre: data['nombre'] ?? '',
      email: data['email'] ?? '',
      telefono: data['telefono'] ?? '',
      vehiculo: data['vehiculo'] ?? '',
      estado: data['estado'] ?? 'Inactivo',
      fechaRegistro: (data['fechaRegistro'] as Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'nombre': nombre,
      'email': email,
      'telefono': telefono,
      'vehiculo': vehiculo,
      'estado': estado,
      'fechaRegistro': fechaRegistro ?? FieldValue.serverTimestamp(),
    };
  }
}
