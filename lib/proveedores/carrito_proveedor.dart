import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../modelos/producto_modelo.dart';

class CarritoProveedor with ChangeNotifier {
  Map<String, Map<String, dynamic>> _items = {};

  Map<String, Map<String, dynamic>> get items => _items;

  int get cantidadTotal {
    int total = 0;
    _items.forEach((key, value) {
      total += value['cantidad'] as int;
    });
    return total;
  }

  double get precioTotal {
    double total = 0.0;
    _items.forEach((key, value) {
      total += (value['precio'] as double) * (value['cantidad'] as int);
    });
    return total;
  }

  CarritoProveedor() {
    _cargarCarrito();
  }

  // --- MÉTODO AGREGADO PARA SOLUCIONAR EL ERROR ---
  int obtenerCantidad(String productoId) {
    if (_items.containsKey(productoId)) {
      return _items[productoId]!['cantidad'] as int;
    }
    return 0;
  }

  // Cargar el carrito guardado localmente
  Future<void> _cargarCarrito() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      if (prefs.containsKey('carrito_guardado')) {
        final data = prefs.getString('carrito_guardado');
        if (data != null) {
          final Map<String, dynamic> decoded = json.decode(data);
          _items = decoded.map(
            (key, value) => MapEntry(key, Map<String, dynamic>.from(value)),
          );
          notifyListeners();
        }
      }
    } catch (e) {
      debugPrint("Error al cargar carrito: $e");
    }
  }

  // Guardar el carrito localmente
  Future<void> _guardarCarritoLocal() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('carrito_guardado', json.encode(_items));
    } catch (e) {
      debugPrint("Error al guardar carrito: $e");
    }
  }

  // Agregar producto al carrito
  void agregarProducto(Producto producto) {
    if (producto.id == null) return;

    if (_items.containsKey(producto.id)) {
      _items[producto.id!]!.update('cantidad', (val) => (val as int) + 1);
    } else {
      _items[producto.id!] = {
        'productoId': producto.id,
        'comercioId': producto.comercioId,
        'nombre': producto.nombre,
        'precio': producto.precio,
        'cantidad': 1,
        'imagenUrl': producto.imagenUrl,
      };
    }
    notifyListeners();
    _guardarCarritoLocal();
  }

  // Disminuir cantidad o quitar producto
  void removerProducto(String productoId) {
    if (!_items.containsKey(productoId)) return;

    if ((_items[productoId]!['cantidad'] as int) > 1) {
      _items[productoId]!.update('cantidad', (val) => (val as int) - 1);
    } else {
      _items.remove(productoId);
    }
    notifyListeners();
    _guardarCarritoLocal();
  }

  // Eliminar completamente un ítem del carrito
  void eliminarItem(String productoId) {
    _items.remove(productoId);
    notifyListeners();
    _guardarCarritoLocal();
  }

  // Incrementar cantidad de un item ya existente por su ID
  void incrementarDesdeId(String productoId) {
    if (!_items.containsKey(productoId)) return;
    _items[productoId]!.update('cantidad', (val) => (val as int) + 1);
    notifyListeners();
    _guardarCarritoLocal();
  }

  // Vaciar el carrito
  void vaciarCarrito() {
    _items = {};
    notifyListeners();
    _guardarCarritoLocal();
  }
}