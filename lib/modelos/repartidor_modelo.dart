import 'package:cloud_firestore/cloud_firestore.dart';

class Repartidor {
  final String? id;
  final String nombre;
  final String email;
  final String telefono;
  final String vehiculo;
  final String estado; // e.g., 'Activo', 'Inactivo'
  final String? ubicacion; // Coordenadas o descripción de ubicación mock
  final String? eta; // Tiempo estimado de entrega
  final DateTime? fechaRegistro;
  final String? fotoUrl;

  Repartidor({
    this.id,
    required this.nombre,
    required this.email,
    required this.telefono,
    required this.vehiculo,
    required this.estado,
    this.ubicacion,
    this.eta,
    this.fechaRegistro,
    this.fotoUrl,
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
      ubicacion: data['ubicacion'] ?? data['location'],
      eta: data['eta'],
      fechaRegistro: (data['fechaRegistro'] as Timestamp?)?.toDate(),
      fotoUrl: data['fotoUrl'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'nombre': nombre,
      'email': email,
      'telefono': telefono,
      'vehiculo': vehiculo,
      'estado': estado,
      'ubicacion': ubicacion,
      'eta': eta,
      'fechaRegistro': fechaRegistro ?? FieldValue.serverTimestamp(),
      'fotoUrl': fotoUrl,
    };
  }
}
