import 'package:flutter/material.dart';

class TemaApp {
  // 🎨 Paleta Corporativa Rappi
  static const Color naranjaPrincipal = Color(0xFFFF6C00);
  static const Color naranjaOscuro = Color(0xFFE55A00);
  static const Color rojoAcento = Color(0xFFE53935);
  static const Color amarilloResaltado = Color(0xFFFFD700);
  static const Color verdeRappi = Color(0xFF00D19D);
  static const Color fondoClaro = Color(0xFFF8F9FA);
  static const Color fondoCard = Color(0xFFFFFFFF);
  static const Color textoOscuro = Color(0xFF1A1A1A);
  static const Color textoGris = Color(0xFF6B7280);
  static const Color textoClaro = Color(0xFFFFFFFF);
  static const Color separador = Color(0xFFE5E7EB);

  // 🎨 Gradientes
  static const LinearGradient gradienteNaranja = LinearGradient(
    colors: [naranjaPrincipal, naranjaOscuro],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient gradienteHeader = LinearGradient(
    colors: [Color(0xFFFF6C00), Color(0xFFFF8C42)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  // 🎨 Sombras
  static List<BoxShadow> sombraCard = [
    BoxShadow(
      color: Colors.black.withAlpha(15),
      blurRadius: 12,
      offset: const Offset(0, 4),
    ),
  ];

  static List<BoxShadow> sombraBoton = [
    BoxShadow(
      color: naranjaPrincipal.withAlpha(80),
      blurRadius: 16,
      offset: const Offset(0, 6),
    ),
  ];

  static ThemeData temaClaro = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: naranjaPrincipal,
      primary: naranjaPrincipal,
      secondary: verdeRappi,
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
        minimumSize: const Size(double.infinity, 54),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        elevation: 0,
        textStyle: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: Colors.grey.shade200, width: 1.5),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: naranjaPrincipal, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: rojoAcento, width: 1.5),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: rojoAcento, width: 2),
      ),
      labelStyle: const TextStyle(color: Colors.grey),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    ),
    cardTheme: CardThemeData(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: Colors.white,
    ),
    chipTheme: ChipThemeData(
      selectedColor: naranjaPrincipal,
      backgroundColor: Colors.white,
      labelStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
        side: const BorderSide(color: separador),
      ),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Colors.white,
      selectedItemColor: naranjaPrincipal,
      unselectedItemColor: Color(0xFF9CA3AF),
      selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
      unselectedLabelStyle: TextStyle(fontWeight: FontWeight.w500, fontSize: 12),
      type: BottomNavigationBarType.fixed,
      elevation: 0,
    ),
  );
}
