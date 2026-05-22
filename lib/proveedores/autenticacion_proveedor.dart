import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../servicios/autenticacion_servicio.dart';
import '../servicios/firestore_servicio.dart';
import '../modelos/usuario_modelo.dart';

class AutenticacionProveedor with ChangeNotifier {
  final AutenticacionServicio _authServicio = AutenticacionServicio();
  final FirestoreServicio _firestoreServicio = FirestoreServicio();

  User? _usuarioFirebase;
  Usuario? _usuarioDatos;
  bool _estaCargando = false;
  String? _error;

  User? get usuarioFirebase => _usuarioFirebase;
  Usuario? get usuarioDatos => _usuarioDatos;
  bool get estaCargando => _estaCargando;
  String? get error => _error;

  bool get estaAutenticado => _usuarioFirebase != null;

  AutenticacionProveedor() {
    _authServicio.addListener(_onAuthStateChanged);
  }

  void _onAuthStateChanged() async {
    _usuarioFirebase = _authServicio.usuarioFirebase;
    
    if (_usuarioFirebase != null) {
      _estaCargando = true;
      notifyListeners();
      
      // Intentamos cargar los datos complementarios de Firestore
      _usuarioDatos = await _firestoreServicio.obtenerUsuario(_usuarioFirebase!.uid);
      
      // Si el usuario no tiene documento en Firestore (primer login por ejemplo), lo creamos
      if (_usuarioDatos == null) {
        _usuarioDatos = Usuario(
          uid: _usuarioFirebase!.uid,
          email: _usuarioFirebase!.email ?? '',
          nombre: _usuarioFirebase!.displayName ?? 'Usuario',
          telefono: '',
          rol: 'cliente',
          direcciones: [],
          fechaCreacion: DateTime.now(),
        );
        await _firestoreServicio.guardarUsuario(_usuarioDatos!);
      }
    } else {
      _usuarioDatos = null;
    }
    
    _estaCargando = false;
    notifyListeners();
  }

  // Iniciar Sesión con Correo y Contraseña
  Future<bool> login(String email, String password) async {
    _estaCargando = true;
    _error = null;
    notifyListeners();

    final errorMsg = await _authServicio.iniciarSesion(email, password);
    
    if (errorMsg != null) {
      _error = errorMsg;
      _estaCargando = false;
      notifyListeners();
      return false;
    }

    _estaCargando = false;
    notifyListeners();
    return true;
  }

  // Iniciar Sesión con Google
  Future<bool> loginConGoogle() async {
    _estaCargando = true;
    _error = null;
    notifyListeners();

    final errorMsg = await _authServicio.iniciarConGoogle();
    
    if (errorMsg != null) {
      _error = errorMsg;
      _estaCargando = false;
      notifyListeners();
      return false;
    }

    _estaCargando = false;
    notifyListeners();
    return true;
  }

  // Recuperar Contraseña
  Future<bool> recuperarContrasena(String email) async {
    _estaCargando = true;
    _error = null;
    notifyListeners();

    final errorMsg = await _authServicio.recuperarContrasena(email);
    
    if (errorMsg != null) {
      _error = errorMsg;
      _estaCargando = false;
      notifyListeners();
      return false;
    }

    _estaCargando = false;
    notifyListeners();
    return true;
  }

  // Registrar nuevo usuario
  Future<bool> registro(String email, String password, String nombre, String telefono) async {
    _estaCargando = true;
    _error = null;
    notifyListeners();

    final errorMsg = await _authServicio.registrar(email, password);
    
    if (errorMsg != null) {
      _error = errorMsg;
      _estaCargando = false;
      notifyListeners();
      return false;
    }

    // Una vez registrado con Firebase Auth, guardamos los campos adicionales en Firestore
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      _usuarioDatos = Usuario(
        uid: user.uid,
        email: email,
        nombre: nombre,
        telefono: telefono,
        rol: 'cliente',
        direcciones: [],
        fechaCreacion: DateTime.now(),
      );
      await _firestoreServicio.guardarUsuario(_usuarioDatos!);
    }

    _estaCargando = false;
    notifyListeners();
    return true;
  }

  // Cerrar sesión
  Future<void> logout() async {
    _estaCargando = true;
    notifyListeners();
    await _authServicio.cerrarSesion();
    _usuarioFirebase = null;
    _usuarioDatos = null;
    _estaCargando = false;
    notifyListeners();
  }

  @override
  void dispose() {
    _authServicio.removeListener(_onAuthStateChanged);
    super.dispose();
  }
}
