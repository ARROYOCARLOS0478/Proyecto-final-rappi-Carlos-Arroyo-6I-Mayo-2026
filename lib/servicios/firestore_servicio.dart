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
    return _db.collection(Constantes.coleccionUsuarios).doc(usuario.uid).set(usuario.toFirestore());
  }

  Future<Usuario?> obtenerUsuario(String uid) async {
    final doc = await _db.collection(Constantes.coleccionUsuarios).doc(uid).get();
    if (doc.exists) {
      return Usuario.fromFirestore(doc);
    }
    return null;
  }

  // --- REPARTIDORES (LOGÍSTICA) ---
  
  Stream<List<Repartidor>> obtenerRepartidores() {
    return _db.collection(Constantes.coleccionRepartidores)
        .orderBy('fechaRegistro', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs.map((doc) => Repartidor.fromFirestore(doc)).toList(),
        );
  }

  Future<void> guardarRepartidor(Repartidor repartidor) {
    if (repartidor.id == null || repartidor.id!.isEmpty) {
      return _db.collection(Constantes.coleccionRepartidores).add(repartidor.toFirestore());
    } else {
      return _db.collection(Constantes.coleccionRepartidores).doc(repartidor.id).update(repartidor.toFirestore());
    }
  }

  Future<void> eliminarRepartidor(String id) {
    return _db.collection(Constantes.coleccionRepartidores).doc(id).delete();
  }

  // --- COMERCIOS (RESTAURANTES) ---

  Stream<List<Comercio>> obtenerComercios() {
    return _db.collection(Constantes.coleccionComercios)
        .orderBy('fechaRegistro', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs.map((doc) => Comercio.fromFirestore(doc)).toList(),
        );
  }

  Future<void> guardarComercio(Comercio comercio) {
    if (comercio.id == null || comercio.id!.isEmpty) {
      return _db.collection(Constantes.coleccionComercios).add(comercio.toFirestore());
    } else {
      return _db.collection(Constantes.coleccionComercios).doc(comercio.id).update(comercio.toFirestore());
    }
  }

  Future<void> eliminarComercio(String id) {
    return _db.collection(Constantes.coleccionComercios).doc(id).delete();
  }

  // --- PRODUCTOS ---

  Stream<List<Producto>> obtenerProductosComercio(String comercioId) {
    return _db.collection(Constantes.coleccionProductos)
        .where('comercioId', isEqualTo: comercioId)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs.map((doc) => Producto.fromFirestore(doc)).toList(),
        );
  }

  Future<void> guardarProducto(Producto producto) {
    if (producto.id == null || producto.id!.isEmpty) {
      return _db.collection(Constantes.coleccionProductos).add(producto.toFirestore());
    } else {
      return _db.collection(Constantes.coleccionProductos).doc(producto.id).update(producto.toFirestore());
    }
  }

  Future<void> eliminarProducto(String id) {
    return _db.collection(Constantes.coleccionProductos).doc(id).delete();
  }

  // --- PEDIDOS ---

  Stream<List<Pedido>> obtenerPedidosUsuario(String usuarioId) {
    return _db.collection(Constantes.coleccionPedidos)
        .where('usuarioId', isEqualTo: usuarioId)
        .orderBy('fechaCreacion', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs.map((doc) => Pedido.fromFirestore(doc)).toList(),
        );
  }

  Future<void> guardarPedido(Pedido pedido) {
    if (pedido.id == null || pedido.id!.isEmpty) {
      return _db.collection(Constantes.coleccionPedidos).add(pedido.toFirestore());
    } else {
      return _db.collection(Constantes.coleccionPedidos).doc(pedido.id).update(pedido.toFirestore());
    }
  }

  // --- PAGOS ---

  Future<void> registrarPago(Pago pago) {
    return _db.collection(Constantes.coleccionPagos).add(pago.toFirestore());
  }
}
