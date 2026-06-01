import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../core/traducciones.dart';

class AutenticacionServicio with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // 🚫 GoogleSignIn eliminado para evitar el error de "ClientID not set" en la escuela
  // final GoogleSignIn _googleSignIn = GoogleSignIn.instance;

  User? _usuarioFirebase;
  User? get usuarioFirebase => _usuarioFirebase;

  AutenticacionServicio() {
    _inicializar();
    _auth.authStateChanges().listen((User? user) {
      _usuarioFirebase = user;
      notifyListeners();
    });
  }

  Future<void> _inicializar() async {
    try {
      if (kIsWeb) {
        // Forza a que la sesión no se quede pegada eternamente en Chrome
        await _auth.setPersistence(Persistence.LOCAL);
      }
    } catch (e) {
      debugPrint('Error al configurar Firebase Auth persistence: $e');
    }

    // 🚫 Inicialización de Google removida para que no truene la app
    /* try {
      await _googleSignIn.initialize();
    } catch (e) {
      debugPrint("Error al inicializar GoogleSignIn: $e");
    } 
    */
  }

  // Iniciar sesión con Correo y Contraseña
  Future<String?> iniciarSesion(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return null;
    } catch (e) {
      return Traducciones.traducirError(e);
    }
  }

  // Registrar con Correo y Contraseña
  Future<String?> registrar(String email, String password) async {
    try {
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return null;
    } catch (e) {
      return Traducciones.traducirError(e);
    }
  }

  // ⚠️ Inicio de sesión con Google (Desactivado temporalmente)
  Future<String?> iniciarConGoogle() async {
    return "El inicio con Google no está disponible en este momento por configuración de red.";
  }

  // Recuperar Contraseña
  Future<String?> recuperarContrasena(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return null;
    } catch (e) {
      return Traducciones.traducirError(e);
    }
  }

  // Cerrar Sesión (Limpio y sin errores de Google)
  Future<void> cerrarSesion() async {
    _usuarioFirebase = null;
    notifyListeners();
    
    // Solo cerramos Firebase para evitar que Google tire errores de "appClientId != null"
    try {
      await _auth.signOut();
      debugPrint("✅ Sesión de Firebase cerrada correctamente.");
    } catch (e) {
      debugPrint("Error al cerrar sesión: $e");
    }
  }
}