import 'package:flutter/material.dart';

class TemaApp {
  static const Color naranjaPrincipal = Color(0xFFFF6C00); // Rappi Orange
  static const Color rojoAcento = Color(0xFFE53935);
  static const Color amarilloResaltado = Color(0xFFFFD700);
  static const Color fondoClaro = Color(0xFFF8F9FA);
  static const Color textoOscuro = Color(0xFF1A1A1A);
  static const Color textoClaro = Color(0xFFFFFFFF);

  static ThemeData temaClaro = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: naranjaPrincipal,
      primary: naranjaPrincipal,
      secondary: rojoAcento,
      surface: Colors.white,
    ),
    scaffoldBackgroundColor: fondoClaro,
    appBarTheme: const AppBarTheme(
      backgroundColor: naranjaPrincipal,
      foregroundColor: textoClaro,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 20,
        color: textoClaro,
      ),
      iconTheme: IconThemeData(color: textoClaro),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: naranjaPrincipal,
        foregroundColor: textoClaro,
        minimumSize: const Size(double.infinity, 50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: naranjaPrincipal, width: 2),
      ),
      labelStyle: const TextStyle(color: Colors.grey),
    ),
    cardTheme: CardThemeData(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: Colors.white,
    ),
  );
}
