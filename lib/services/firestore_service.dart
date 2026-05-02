import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/repartidor_model.dart';
import '../models/restaurante_model.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final String collectionRepartidores = 'repartidores';
  final String collectionRestaurantes = 'restaurantes';

  // --- REPARTIDORES ---
  
  Stream<List<Repartidor>> getRepartidores() {
    return _db.collection(collectionRepartidores).orderBy('fechaRegistro', descending: true).snapshots().map(
          (snapshot) => snapshot.docs.map((doc) => Repartidor.fromFirestore(doc)).toList(),
        );
  }

  Future<void> saveRepartidor(Repartidor repartidor) {
    if (repartidor.id == null || repartidor.id!.isEmpty) {
      return _db.collection(collectionRepartidores).add(repartidor.toFirestore());
    } else {
      return _db.collection(collectionRepartidores).doc(repartidor.id).update(repartidor.toFirestore());
    }
  }

  Future<void> deleteRepartidor(String id) {
    return _db.collection(collectionRepartidores).doc(id).delete();
  }

  // --- RESTAURANTES ---

  Stream<List<Restaurante>> getRestaurantes() {
    return _db.collection(collectionRestaurantes).orderBy('fechaRegistro', descending: true).snapshots().map(
          (snapshot) => snapshot.docs.map((doc) => Restaurante.fromFirestore(doc)).toList(),
        );
  }

  Future<void> saveRestaurante(Restaurante restaurante) {
    if (restaurante.id == null || restaurante.id!.isEmpty) {
      return _db.collection(collectionRestaurantes).add(restaurante.toFirestore());
    } else {
      return _db.collection(collectionRestaurantes).doc(restaurante.id).update(restaurante.toFirestore());
    }
  }

  Future<void> deleteRestaurante(String id) {
    return _db.collection(collectionRestaurantes).doc(id).delete();
  }
}

