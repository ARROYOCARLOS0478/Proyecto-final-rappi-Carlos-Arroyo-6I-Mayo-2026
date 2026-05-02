import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/material.dart';

import '../utils/translations.dart';

class AuthService with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;

  User? _user;
  User? get user => _user;

  AuthService() {
    _initialize();
    _auth.authStateChanges().listen((User? user) {
      _user = user;
      notifyListeners();
    });
  }

  Future<void> _initialize() async {
    try {
      await _googleSignIn.initialize();
    } catch (e) {
      debugPrint("Error initializing GoogleSignIn: $e");
    }
  }

  // Login with Email and Password
  Future<String?> login(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return null;
    } catch (e) {
      return TranslationUtils.translateError(e);
    }
  }

  // Register with Email and Password
  Future<String?> register(String email, String password) async {
    try {
      await _auth.createUserWithEmailAndPassword(email: email, password: password);
      return null;
    } catch (e) {
      return TranslationUtils.translateError(e);
    }
  }

  // Google Sign In
  Future<String?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.authenticate();
      if (googleUser == null) return "Inicio de sesión cancelado.";

      // En la versión 7.x, la autenticación y autorización son pasos separados
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
      return TranslationUtils.translateError(e);
    }
  }

  // Forgot Password
  Future<String?> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return null;
    } catch (e) {
      return TranslationUtils.translateError(e);
    }
  }

  // Logout
  Future<void> logout() async {
    _user = null;
    notifyListeners();
    try {
      await _googleSignIn.signOut();
      await _auth.signOut();
    } catch (e) {
      debugPrint("Error al cerrar sesión: $e");
    }
  }
}
