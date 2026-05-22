import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';

// Importaciones del Núcleo y Estructura en Español
import 'core/tema_app.dart';
import 'proveedores/autenticacion_proveedor.dart';
import 'proveedores/carrito_proveedor.dart';
import 'vistas/login/login_pantalla.dart';
import 'vistas/home/home_pantalla.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    debugPrint('Error de inicialización de Firebase: $e');
  }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AutenticacionProveedor()),
        ChangeNotifierProvider(create: (_) => CarritoProveedor()),
      ],
      child: const RappiApp(),
    ),
  );
}

class RappiApp extends StatelessWidget {
  const RappiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gestión Rappi',
      debugShowCheckedModeBanner: false,
      theme: TemaApp.temaClaro,
      home: const EnvoltorioAutenticacion(),
    );
  }
}

class EnvoltorioAutenticacion extends StatelessWidget {
  const EnvoltorioAutenticacion({super.key});

  @override
  Widget build(BuildContext context) {
    final authProv = Provider.of<AutenticacionProveedor>(context);
    
    // Si el usuario está cargando datos de Firestore, mostramos un cargador circular
    if (authProv.estaCargando && authProv.usuarioFirebase != null) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(color: TemaApp.naranjaPrincipal),
        ),
      );
    }

    // Si el usuario está autenticado, muestra la pantalla principal (Home), si no, la de Login.
    return authProv.estaAutenticado ? const HomePantalla() : const LoginPantalla();
  }
}
