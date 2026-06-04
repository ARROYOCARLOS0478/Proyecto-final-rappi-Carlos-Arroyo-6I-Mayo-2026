import 'package:cloud_firestore/cloud_firestore.dart';
import '../modelos/repartidor_modelo.dart';
import '../modelos/comercio_modelo.dart';
import '../modelos/usuario_modelo.dart';
import '../modelos/producto_modelo.dart';
import '../modelos/pedido_modelo.dart';
import '../modelos/pago_modelo.dart';
import '../core/constantes.dart';

class FirestoreServicio {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // --- USUARIOS ---

  Future<void> guardarUsuario(Usuario usuario) {
    return _db
        .collection(Constantes.coleccionUsuarios)
        .doc(usuario.uid)
        .set(usuario.toFirestore());
  }

  Future<Usuario?> obtenerUsuario(String uid) async {
    final doc = await _db
        .collection(Constantes.coleccionUsuarios)
        .doc(uid)
        .get();
    if (!doc.exists) return null;
    return Usuario.fromFirestore(doc);
  }

  Future<Usuario?> obtenerUsuarioPorTelefono(String telefono) async {
    final query = await _db
        .collection(Constantes.coleccionUsuarios)
        .where('telefono', isEqualTo: telefono)
        .limit(1)
        .get();

    if (query.docs.isEmpty) return null;
    return Usuario.fromFirestore(query.docs.first);
  }

  // --- REPARTIDORES (LOGÍSTICA) ---

  Stream<List<Repartidor>> obtenerRepartidores() {
    return _db
        .collection(Constantes.coleccionRepartidores)
        .orderBy('fechaRegistro', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => Repartidor.fromFirestore(doc))
              .toList(),
        );
  }

  Future<void> guardarRepartidor(Repartidor repartidor) {
    if (repartidor.id == null || repartidor.id!.isEmpty) {
      return _db
          .collection(Constantes.coleccionRepartidores)
          .add(repartidor.toFirestore());
    } else {
      return _db
          .collection(Constantes.coleccionRepartidores)
          .doc(repartidor.id)
          .update(repartidor.toFirestore());
    }
  }

  Future<void> eliminarRepartidor(String id) {
    return _db.collection(Constantes.coleccionRepartidores).doc(id).delete();
  }

  // --- COMERCIOS (RESTAURANTES) ---

  Stream<List<Comercio>> obtenerComercios() {
    return _db
        .collection(Constantes.coleccionComercios)
        .orderBy('fechaRegistro', descending: true)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs.map((doc) => Comercio.fromFirestore(doc)).toList(),
        );
  }

  Stream<List<Comercio>> obtenerComerciosPorCategoria(String categoria) {
    return _db
        .collection(Constantes.coleccionComercios) // Usa la constante siempre
        .where('categoria', isEqualTo: categoria)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs.map((doc) => Comercio.fromFirestore(doc)).toList(),
        );
  }

  Future<void> guardarComercio(Comercio comercio) {
    if (comercio.id == null || comercio.id!.isEmpty) {
      return _db
          .collection(Constantes.coleccionComercios)
          .add(comercio.toFirestore());
    } else {
      return _db
          .collection(Constantes.coleccionComercios)
          .doc(comercio.id)
          .update(comercio.toFirestore());
    }
  }

  Future<void> eliminarComercio(String id) {
    return _db.collection(Constantes.coleccionComercios).doc(id).delete();
  }

  Future<Comercio?> obtenerComercio(String comercioId) async {
    final doc = await _db
        .collection(Constantes.coleccionComercios)
        .doc(comercioId)
        .get();
    if (!doc.exists) return null;
    return Comercio.fromFirestore(doc);
  }

  Stream<List<Comercio>> obtenerComerciosConOferta() {
    return _db
        .collection(Constantes.coleccionComercios)
        .where('descuentoNegocio', isGreaterThan: 0)
        .orderBy('descuentoNegocio', descending: true)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs.map((doc) => Comercio.fromFirestore(doc)).toList(),
        );
  }

  Stream<List<Comercio>> obtenerFavoritosUsuario(String uid) {
    return _db
        .collection(Constantes.coleccionUsuarios)
        .doc(uid)
        .snapshots()
        .asyncMap((userDoc) async {
          if (!userDoc.exists) return <Comercio>[];
          final favoritos = List<String>.from(
            userDoc.data()?['favoritos'] ?? [],
          );
          if (favoritos.isEmpty) return <Comercio>[];
          final List<Comercio> result = [];
          for (int i = 0; i < favoritos.length; i += 10) {
            final chunk = favoritos.sublist(
              i,
              i + 10 > favoritos.length ? favoritos.length : i + 10,
            );
            final snap = await _db
                .collection(Constantes.coleccionComercios)
                .where(FieldPath.documentId, whereIn: chunk)
                .get();
            result.addAll(snap.docs.map((doc) => Comercio.fromFirestore(doc)));
          }
          return result;
        });
  }

  /// Verificar si hay comercios en Firestore
  Future<bool> hayComerciosEnFirestore() async {
    final snap = await _db
        .collection(Constantes.coleccionComercios)
        .limit(1)
        .get();
    return snap.docs.isNotEmpty;
  }

  // --- PRODUCTOS ---

  Stream<List<Producto>> obtenerProductosComercio(String comercioId) {
    return _db
        .collection('productos')
        .where('comercioId', isEqualTo: comercioId)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs.map((doc) => Producto.fromFirestore(doc)).toList(),
        );
  }

  // Crear un nuevo producto
  Future<void> crearProducto(Producto producto) async {
    try {
      await _db.collection('productos').add(producto.toFirestore());
    } catch (e) {
      print("Error al crear producto: $e");
      rethrow;
    }
  }

  // Actualizar un producto existente
  Future<void> actualizarProducto(Producto producto) async {
    try {
      await _db
          .collection('productos')
          .doc(producto.id)
          .update(producto.toFirestore());
    } catch (e) {
      print("Error al actualizar producto: $e");
      rethrow;
    }
  }

  // Eliminar un producto
  Future<void> eliminarProducto(String productoId) async {
    try {
      await _db.collection('productos').doc(productoId).delete();
    } catch (e) {
      print("Error al eliminar producto: $e");
      rethrow;
    }
  }
  // --- PEDIDOS ---

  // Este sirve para el Banner del Home (Solo los que están en proceso)
  Stream<List<Pedido>> obtenerPedidosActivos(String usuarioId) {
    return _db
        .collection(Constantes.coleccionPedidos)
        .where('usuarioId', isEqualTo: usuarioId)
        .where('estado', whereIn: ['Pendiente', 'Preparando', 'En Camino'])
        .orderBy('fechaCreacion', descending: true)
        .snapshots()
        .map(
          (snap) => snap.docs.map((doc) => Pedido.fromFirestore(doc)).toList(),
        );
  }

  // Este sirve para el Perfil (Todo el historial de pedidos)
  Stream<List<Pedido>> obtenerPedidosUsuario(String usuarioId) {
    return _db
        .collection(Constantes.coleccionPedidos)
        .where('usuarioId', isEqualTo: usuarioId)
        .orderBy('fechaCreacion', descending: true)
        .snapshots()
        .map(
          (snap) => snap.docs.map((doc) => Pedido.fromFirestore(doc)).toList(),
        );
  }

  /// Escuchar un pedido específico en tiempo real
  Stream<Pedido?> escucharPedido(String pedidoId) {
    return _db
        .collection(Constantes.coleccionPedidos)
        .doc(pedidoId)
        .snapshots()
        .map((doc) {
          if (doc.exists) return Pedido.fromFirestore(doc);
          return null;
        });
  }

  Future<void> guardarPedido(Pedido pedido) {
    if (pedido.id == null || pedido.id!.isEmpty) {
      return _db
          .collection(Constantes.coleccionPedidos)
          .add(pedido.toFirestore());
    } else {
      return _db
          .collection(Constantes.coleccionPedidos)
          .doc(pedido.id)
          .update(pedido.toFirestore());
    }
  }

  /// Guardar pedido y retornar el ID generado
  Future<String> guardarPedidoConId(Pedido pedido) async {
    final docRef = await _db
        .collection(Constantes.coleccionPedidos)
        .add(pedido.toFirestore());
    return docRef.id;
  }

  // --- PAGOS ---

  Future<void> registrarPago(Pago pago) {
    return _db.collection(Constantes.coleccionPagos).add(pago.toFirestore());
  }

  // --- GESTIÓN DE USUARIOS (ADMIN) ---
  Stream<List<Usuario>> obtenerTodosLosUsuarios() {
    return _db
        .collection(Constantes.coleccionUsuarios)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs.map((doc) => Usuario.fromFirestore(doc)).toList(),
        );
  }

  Future<void> eliminarUsuario(String uid) {
    return _db.collection(Constantes.coleccionUsuarios).doc(uid).delete();
  }
}
