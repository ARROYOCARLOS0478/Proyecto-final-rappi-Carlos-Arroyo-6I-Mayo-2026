import 'package:cloud_firestore/cloud_firestore.dart';

class Producto {
  final String? id;
  final String comercioId;
  final String nombre;
  final String descripcion;
  final double precio;
  final int stock;
  final String categoria;
  final String imagenUrl;

  Producto({
    this.id,
    required this.comercioId,
    required this.nombre,
    required this.descripcion,
    required this.precio,
    required this.stock,
    required this.categoria,
    required this.imagenUrl,
  });

  factory Producto.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Producto(
      id: doc.id,
      comercioId: data['comercioId'] ?? data['merchantId'] ?? '',
      nombre: data['nombre'] ?? '',
      descripcion: data['descripcion'] ?? '',
      precio: (data['precio'] ?? data['price'] ?? 0.0).toDouble(),
      stock: data['stock'] ?? 0,
      categoria: data['categoria'] ?? '',
      imagenUrl: data['imagenUrl'] ?? '',
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'comercioId': comercioId,
      'nombre': nombre,
      'descripcion': descripcion,
      'precio': precio,
      'stock': stock,
      'categoria': categoria,
      'imagenUrl': imagenUrl,
    };
  }
}
