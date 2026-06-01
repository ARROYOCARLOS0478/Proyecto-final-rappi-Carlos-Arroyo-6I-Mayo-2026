import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';

// Núcleo
import 'core/tema_app.dart';

// Proveedores
import 'proveedores/autenticacion_proveedor.dart';
import 'proveedores/carrito_proveedor.dart';
import 'proveedores/pedido_proveedor.dart';

// Servicios
import 'servicios/datos_semilla_servicio.dart';

// Pantallas
import 'vistas/splash/splash_pantalla.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    await FirebaseAuth.instance.setPersistence(Persistence.LOCAL);

    // ✅ CAMBIO AQUÍ: No uses 'await' para los datos semilla.
    /*
    DatosSemillaServicio()
        .sembrarDatos()
        .then((_) {
          debugPrint("✅ Datos semilla verificados");
        })
        .catchError((e) {
          debugPrint("❌ Error en datos semilla: $e");
        });
    */
  } catch (e) {
    debugPrint('Error de inicialización de Firebase: $e');
  }

  // ✅ Esto DEBE ejecutarse sí o sí
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AutenticacionProveedor()),
        ChangeNotifierProvider(create: (_) => CarritoProveedor()),
        ChangeNotifierProvider(create: (_) => PedidoProveedor()),
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
      title: 'Rappi — Proyecto Final',
      debugShowCheckedModeBanner: false,
      theme: TemaApp.temaClaro,
      home: const SplashPantalla(),
    );
  }
}
