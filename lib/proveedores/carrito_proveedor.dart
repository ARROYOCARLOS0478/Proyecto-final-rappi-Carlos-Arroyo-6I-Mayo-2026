// carrito_proveedor.dart

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../modelos/producto_modelo.dart';

class CarritoProveedor with ChangeNotifier {
  Map<String, Map<String, dynamic>> _items = {};

  // Guarda el comercioId activo en el carrito
  String? _comercioIdActivo;
  String? get comercioIdActivo => _comercioIdActivo;

  Map<String, Map<String, dynamic>> get items => _items;

  int get cantidadTotal {
    int total = 0;
    _items.forEach((_, v) => total += v['cantidad'] as int);
    return total;
  }

  double get precioTotal {
    double total = 0.0;
    _items.forEach((_, v) {
      total += (v['precio'] as double) * (v['cantidad'] as int);
    });
    return total;
  }

  CarritoProveedor() {
    _cargarCarrito();
  }

  int obtenerCantidad(String productoId) {
    return (_items[productoId]?['cantidad'] as int?) ?? 0;
  }

  // ── AGREGAR PRODUCTO ────────────────────────────────────────────────────────
  // Retorna un enum para que el caller sepa qué pasó:
  //   ok           → se agregó sin problema
  //   comercioDiferente → el producto es de otro comercio (mostrar diálogo)
  //   adminBloqueado    → el usuario es admin, no puede agregar
  Future<AgregarResultado> agregarProducto(
    Producto producto, {
    String rolUsuario = 'cliente',
    BuildContext? context,
  }) async {
    if (producto.id == null) return AgregarResultado.ok;

    // Bloquear al admin
    if (rolUsuario == 'admin') return AgregarResultado.adminBloqueado;

    // Si el carrito tiene items de otro comercio
    if (_items.isNotEmpty &&
        _comercioIdActivo != null &&
        producto.comercioId != _comercioIdActivo) {
      return AgregarResultado.comercioDiferente;
    }

    if (_items.containsKey(producto.id)) {
      _items[producto.id!]!.update('cantidad', (val) => (val as int) + 1);
    } else {
      _comercioIdActivo = producto.comercioId;
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
    await _guardarCarritoLocal();
    return AgregarResultado.ok;
  }

  // ── VACIAR Y AGREGAR (cuando el usuario acepta cambiar de negocio) ──────────
  Future<void> vaciarYAgregar(Producto producto) async {
    if (producto.id == null) return;
    _items = {};
    _comercioIdActivo = producto.comercioId;
    _items[producto.id!] = {
      'productoId': producto.id,
      'comercioId': producto.comercioId,
      'nombre': producto.nombre,
      'precio': producto.precio,
      'cantidad': 1,
      'imagenUrl': producto.imagenUrl,
    };
    notifyListeners();
    await _guardarCarritoLocal();
  }

  // ── RESTO DE OPERACIONES ────────────────────────────────────────────────────
  void removerProducto(String productoId) {
    if (!_items.containsKey(productoId)) return;
    if ((_items[productoId]!['cantidad'] as int) > 1) {
      _items[productoId]!.update('cantidad', (val) => (val as int) - 1);
    } else {
      _items.remove(productoId);
      if (_items.isEmpty) _comercioIdActivo = null;
    }
    notifyListeners();
    _guardarCarritoLocal();
  }

  void eliminarItem(String productoId) {
    _items.remove(productoId);
    if (_items.isEmpty) _comercioIdActivo = null;
    notifyListeners();
    _guardarCarritoLocal();
  }

  void incrementarDesdeId(String productoId) {
    if (!_items.containsKey(productoId)) return;
    _items[productoId]!.update('cantidad', (val) => (val as int) + 1);
    notifyListeners();
    _guardarCarritoLocal();
  }

  void vaciarCarrito() {
    _items = {};
    _comercioIdActivo = null;
    notifyListeners();
    _guardarCarritoLocal();
  }

  // ── PERSISTENCIA ────────────────────────────────────────────────────────────
  Future<void> _cargarCarrito() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final data = prefs.getString('carrito_guardado');
      if (data != null) {
        final decoded = json.decode(data) as Map<String, dynamic>;
        _items = decoded.map(
          (k, v) => MapEntry(k, Map<String, dynamic>.from(v as Map)),
        );
        // Restaurar comercioId activo si hay items
        if (_items.isNotEmpty) {
          _comercioIdActivo = _items.values.first['comercioId'] as String?;
        }
        notifyListeners();
      }
    } catch (e) {
      debugPrint("Error al cargar carrito: $e");
    }
  }

  Future<void> _guardarCarritoLocal() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('carrito_guardado', json.encode(_items));
    } catch (e) {
      debugPrint("Error al guardar carrito: $e");
    }
  }
}

/// Resultado posible al intentar agregar un producto
enum AgregarResultado { ok, comercioDiferente, adminBloqueado }

/// Helper estático para mostrar el diálogo de conflicto de comercio.
/// Úsalo en cualquier widget que llame a [CarritoProveedor.agregarProducto].
///
/// Ejemplo de uso en un widget:
/// ```dart
/// final resultado = await carrito.agregarProducto(producto, rolUsuario: rol);
/// if (resultado == AgregarResultado.comercioDiferente && context.mounted) {
///   await CarritoDialogos.mostrarConflictoComercio(
///     context: context,
///     carrito: carrito,
///     producto: producto,
///   );
/// }
/// ```
class CarritoDialogos {
  static Future<void> mostrarConflictoComercio({
    required BuildContext context,
    required CarritoProveedor carrito,
    required Producto producto,
  }) async {
    await showDialog<void>(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          'Un pedido a la vez',
          style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16),
        ),
        content: const Text(
          'Solo puedes pedir de un negocio a la vez. '
          '¿Deseas vaciar el carrito actual y empezar uno nuevo?',
          style: TextStyle(color: Colors.grey, fontSize: 13),
        ),
        actionsPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancelar',
              style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              await carrito.vaciarYAgregar(producto);
              if (context.mounted) Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF00C5AB),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
            ),
            child: const Text(
              'Vaciar y agregar',
              style: TextStyle(fontWeight: FontWeight.w900),
            ),
          ),
        ],
      ),
    );
  }

  static void mostrarAdminBloqueado(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text(
          'Los administradores no pueden agregar productos al carrito.',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.black87,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 3),
      ),
    );
  }
}
