import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/material.dart';

import '../core/traducciones.dart';

class AutenticacionServicio with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;

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
      await _googleSignIn.initialize();
    } catch (e) {
      debugPrint("Error al inicializar GoogleSignIn: $e");
    }
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
      await _auth.createUserWithEmailAndPassword(email: email, password: password);
      return null;
    } catch (e) {
      return Traducciones.traducirError(e);
    }
  }

  // Inicio de sesión con Google
  Future<String?> iniciarConGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.authenticate();
      if (googleUser == null) return "Inicio de sesión cancelado.";

      final String? idToken = googleUser.authentication.idToken;
      final clientAuth = await googleUser.authorizationClient.authorizeScopes(['email', 'profile']);
      final String? accessToken = clientAuth.accessToken;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: accessToken,
        idToken: idToken,
      );

      await _auth.signInWithCredential(credential);
      return null;
    } catch (e) {
      return Traducciones.traducirError(e);
    }
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

  // Cerrar Sesión
  Future<void> cerrarSesion() async {
    _usuarioFirebase = null;
    notifyListeners();
    try {
      await _googleSignIn.signOut();
      await _auth.signOut();
    } catch (e) {
      debugPrint("Error al cerrar sesión: $e");
    }
  }
}
