import 'package:cloud_firestore/cloud_firestore.dart';

class Usuario {
  final String uid;
  final String email;
  final String nombre;
  final String telefono;
  final String rol; // 'cliente' | 'repartidor' | 'administrador'
  final List<String> direcciones;
  final String? fotoUrl;
  final DateTime? fechaCreacion;

  Usuario({
    required this.uid,
    required this.email,
    this.fotoUrl,
    required this.nombre,
    required this.telefono,
    required this.rol,
    required this.direcciones,
    this.fechaCreacion,
  });

  factory Usuario.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Usuario(
      uid: doc.id,
      email: data['email'] ?? '',
      nombre: data['nombre'] ?? data['displayName'] ?? '',
      telefono: data['telefono'] ?? '',
      rol: data['rol'] ?? 'cliente',
      direcciones: List<String>.from(data['direcciones'] ?? []),
      fotoUrl: data['fotoUrl'] as String?,
      fechaCreacion: (data['fechaCreacion'] as Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'email': email,
      'nombre': nombre,
      'telefono': telefono,
      'rol': rol,
      'direcciones': direcciones,
      'fotoUrl': fotoUrl,
      'fechaCreacion': fechaCreacion ?? FieldValue.serverTimestamp(),
    };
  }
}
