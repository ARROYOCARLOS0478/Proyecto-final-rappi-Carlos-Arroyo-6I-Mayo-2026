import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import '../servicios/autenticacion_servicio.dart';
import '../servicios/firestore_servicio.dart';
import '../modelos/usuario_modelo.dart';
import '../core/constantes.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AutenticacionProveedor with ChangeNotifier {
  final AutenticacionServicio _authServicio = AutenticacionServicio();
  final FirestoreServicio _firestoreServicio = FirestoreServicio();

  User? _usuarioFirebase;
  Usuario? _usuarioDatos;
  bool _estaCargando = false;
  String? _error;
  bool _sesionLocalActiva = false;
  String? mensajeSesion;

  // Getters
  User? get usuarioFirebase => _usuarioFirebase;
  Usuario? get usuarioDatos => _usuarioDatos;
  bool get estaCargando => _estaCargando;
  String? get error => _error;
  bool get estaAutenticado => _usuarioFirebase != null || _usuarioDatos != null;

  AutenticacionProveedor() {
    _authServicio.addListener(_onAuthStateChanged);
    _inicializar();
  }

  final Completer<void> _inicializacionCompleter = Completer<void>();
  Future<void> get inicializado => _inicializacionCompleter.future;

  Future<void> _inicializar() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await Future.delayed(const Duration(milliseconds: 300));
      final usuarioGuardado = prefs.getString('usuario_guardado');
      final tipoSesion = prefs.getString('tipo_sesion') ?? 'firebase';

      if (usuarioGuardado != null) {
        final Map<String, dynamic> data = Map.from(jsonDecode(usuarioGuardado));
        _usuarioDatos = Usuario(
          uid: data['uid'],
          email: data['email'],
          nombre: data['nombre'],
          telefono: data['telefono'],
          rol: data['rol'],
          direcciones: List.from(data['direcciones'] ?? []),
          fechaCreacion: data['fechaCreacion'] != null
              ? DateTime.parse(data['fechaCreacion'] as String)
              : DateTime.now(),
        );
        _sesionLocalActiva = tipoSesion == 'local';
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error al restaurar sesión: $e');
    }
    if (!_inicializacionCompleter.isCompleted) {
      _inicializacionCompleter.complete();
    }
  }

  bool _esEmailAdministrador(String email) =>
      email.toLowerCase().endsWith('@rappi.com');

  String _rolPorEmail(String email) => _esEmailAdministrador(email)
      ? Constantes.rolAdministrador
      : Constantes.rolCliente;

  Future<void> _onAuthStateChanged() async {
    _usuarioFirebase = _authServicio.usuarioFirebase;

    if (_usuarioFirebase != null) {
      _estaCargando = true;
      notifyListeners();

      _usuarioDatos = await _firestoreServicio.obtenerUsuario(
        _usuarioFirebase!.uid,
      );

      if (_usuarioDatos == null) {
        _usuarioDatos = Usuario(
          uid: _usuarioFirebase!.uid,
          email: _usuarioFirebase!.email ?? '',
          nombre: _usuarioFirebase!.displayName ?? 'Usuario',
          telefono: '',
          rol: _rolPorEmail(_usuarioFirebase!.email ?? ''),
          direcciones: [],
          fechaCreacion: DateTime.now(),
        );
        await _firestoreServicio.guardarUsuario(_usuarioDatos!);
      }

      _sesionLocalActiva = false;
      _estaCargando = false;
      notifyListeners();
      _guardarSesion();
    } else {
      if (_usuarioDatos != null && _sesionLocalActiva) {
        _estaCargando = false;
        notifyListeners();
        return;
      }
      _usuarioDatos = null;
      _estaCargando = false;
      notifyListeners();
      _limpiarSesion();
    }
  }

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
    await _onAuthStateChanged();
    return true;
  }

  Future<bool> loginConTelefono(String telefono) async {
    _estaCargando = true;
    _error = null;
    notifyListeners();

    final usuario = await _firestoreServicio.obtenerUsuarioPorTelefono(
      telefono.trim(),
    );
    if (usuario == null) {
      _error = 'No se encontró un usuario con ese número';
      _estaCargando = false;
      notifyListeners();
      return false;
    }

    _usuarioFirebase = null;
    _usuarioDatos = usuario;
    _sesionLocalActiva = true;
    _estaCargando = false;
    notifyListeners();
    await _guardarSesion();
    return true;
  }

  Future<bool> recuperarContrasena(String email) async {
    _estaCargando = true;
    _error = null;
    notifyListeners();
    final errorMsg = await _authServicio.recuperarContrasena(email);
    _estaCargando = false;
    if (errorMsg != null) _error = errorMsg;
    notifyListeners();
    return errorMsg == null;
  }

  // ✅ MÉTODO DE REGISTRO CORREGIDO
  Future<bool> registro(
    String email,
    String password,
    String nombre,
    String telefono, {
    Map<String, dynamic>? direccion,
  }) async {
    _estaCargando = true;
    _error = null;
    notifyListeners();

    try {
      // 1. Usar el servicio para crear el usuario en Auth
      final errorMsg = await _authServicio.registrar(email, password);

      if (errorMsg != null) {
        _error = errorMsg;
        _estaCargando = false;
        notifyListeners();
        return false;
      }

      // 2. Obtener el ID del usuario recién creado
      final user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        // Convertimos el mapa de dirección a un String legible
        String? direccionTexto;
        if (direccion != null) {
          direccionTexto =
              "${direccion['calle']} ${direccion['numero']}, ${direccion['colonia']} (${direccion['tipoEdificio']})";
        }

        final nuevoUsuario = Usuario(
          uid: user.uid,
          nombre: nombre,
          email: email,
          telefono: telefono,
          rol: _rolPorEmail(email),
          // ✅ AHORA SÍ: Pasamos una lista de Strings, no de Mapas
          direcciones: direccionTexto != null ? [direccionTexto] : [],
          fechaCreacion: DateTime.now(),
        );

        await _firestoreServicio.guardarUsuario(nuevoUsuario);
        _usuarioDatos = nuevoUsuario;
      }

      _estaCargando = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _estaCargando = false;
      notifyListeners();
      return false;
    }
  }

  // --- AÑADE ESTO DENTRO DE LA CLASE AutenticacionProveedor ---

  Future<void> actualizarDatosUsuario(Map<String, dynamic> nuevosDatos) async {
    if (_usuarioDatos == null) return;

    try {
      // 1. Actualizar en Firestore
      await FirebaseFirestore.instance
          .collection('usuarios')
          .doc(_usuarioDatos!.uid)
          .update(nuevosDatos);

      // 2. Actualizar el modelo localmente
      // Creamos un nuevo objeto Usuario con los datos actualizados
      _usuarioDatos = Usuario(
        uid: _usuarioDatos!.uid,
        email: _usuarioDatos!.email,
        nombre: nuevosDatos['nombre'] ?? _usuarioDatos!.nombre,
        telefono: nuevosDatos['telefono'] ?? _usuarioDatos!.telefono,
        rol: nuevosDatos['rol'] ?? _usuarioDatos!.rol,
        direcciones: nuevosDatos['direcciones'] != null 
            ? List<String>.from(nuevosDatos['direcciones']) 
            : _usuarioDatos!.direcciones,
        fechaCreacion: _usuarioDatos!.fechaCreacion,
      );

      // 3. Guardar en SharedPreferences y notificar a la UI
      await _guardarSesion();
      notifyListeners();
    } catch (e) {
      debugPrint('Error al actualizar usuario: $e');
      rethrow;
    }
  }

  Future<void> logout() async {
    _estaCargando = true;
    notifyListeners();
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
      await _authServicio.cerrarSesion();

      _usuarioFirebase = null;
      _usuarioDatos = null;
      _sesionLocalActiva = false;
      _error = null;
    } catch (e) {
      debugPrint('❌ Error: $e');
    } finally {
      _estaCargando = false;
      notifyListeners();
    }
  }

  Future<void> _guardarSesion() async {
    if (_usuarioDatos == null) return;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      'usuario_guardado',
      jsonEncode({
        'uid': _usuarioDatos!.uid,
        'email': _usuarioDatos!.email,
        'nombre': _usuarioDatos!.nombre,
        'telefono': _usuarioDatos!.telefono,
        'rol': _usuarioDatos!.rol,
        'direcciones': _usuarioDatos!.direcciones,
        'fechaCreacion': _usuarioDatos!.fechaCreacion?.toIso8601String(),
      }),
    );
    await prefs.setString(
      'tipo_sesion',
      _sesionLocalActiva ? 'local' : 'firebase',
    );
  }

  Future<void> _limpiarSesion() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('usuario_guardado');
    await prefs.remove('tipo_sesion');
  }

  @override
  void dispose() {
    _authServicio.removeListener(_onAuthStateChanged);
    super.dispose();
  }
}
