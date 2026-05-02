import 'package:cloud_firestore/cloud_firestore.dart';

class Restaurante {
  final String? id;
  final String nombre;
  final String categoria;
  final String direccion;
  final String telefono;
  final String horario;
  final double calificacion;
  final DateTime? fechaRegistro;

  Restaurante({
    this.id,
    required this.nombre,
    required this.categoria,
    required this.direccion,
    required this.telefono,
    required this.horario,
    this.calificacion = 0.0,
    this.fechaRegistro,
  });

  factory Restaurante.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Restaurante(
      id: doc.id,
      nombre: data['nombre'] ?? '',
      categoria: data['categoria'] ?? '',
      direccion: data['direccion'] ?? '',
      telefono: data['telefono'] ?? '',
      horario: data['horario'] ?? '',
      calificacion: (data['calificacion'] ?? 0.0).toDouble(),
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
      'fechaRegistro': fechaRegistro ?? FieldValue.serverTimestamp(),
    };
  }
}
