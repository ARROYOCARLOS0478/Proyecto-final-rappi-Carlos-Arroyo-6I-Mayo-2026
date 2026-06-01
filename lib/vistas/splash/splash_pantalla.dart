import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/tema_app.dart';
import '../../core/constantes.dart';
import '../../proveedores/autenticacion_proveedor.dart';
import '../home/home_pantalla.dart';
import '../login/login_pantalla.dart';
import '../admin/admin_home_pantalla.dart';

class SplashPantalla extends StatefulWidget {
  const SplashPantalla({super.key});

  @override
  State<SplashPantalla> createState() => _SplashPantallaState();
}

class _SplashPantallaState extends State<SplashPantalla>
    with TickerProviderStateMixin {
  late AnimationController _logoController;
  late AnimationController _textController;
  late Animation<double> _logoScale;
  late Animation<double> _logoOpacity;
  late Animation<double> _textOpacity;
  late Animation<Offset> _textSlide;

  @override
  void initState() {
    super.initState();

    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _textController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    _logoScale = Tween<double>(begin: 0.4, end: 1.0).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.elasticOut),
    );

    _logoOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _logoController, curve: const Interval(0.0, 0.5)),
    );

    _textOpacity = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _textController, curve: Curves.easeIn));

    _textSlide = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _textController, curve: Curves.easeOut));

    _iniciarAnimaciones();
  }

  Future<void> _iniciarAnimaciones() async {
    await _logoController.forward();
    await Future.delayed(const Duration(milliseconds: 200));
    await _textController.forward();
    await Future.delayed(const Duration(milliseconds: 1200));
    _navegar();
  }

  Future<void> _navegar() async {
    if (!mounted) return;

    // Obtenemos el proveedor
    final authProv = Provider.of<AutenticacionProveedor>(
      context,
      listen: false,
    );

    try {
      // Intentamos esperar la inicialización, pero con un tiempo límite real
      // Si falla o tarda más de 2 segundos, continuamos con lo que tengamos
      await authProv.inicializado.timeout(const Duration(seconds: 2));
    } catch (e) {
      debugPrint("Timeout o error esperando inicialización: $e");
    }

    if (!mounted) return;

    Widget destino;

    // Verificamos si el usuario está autenticado realmente en Firebase
    // y si tenemos sus datos en el proveedor
    if (authProv.usuarioDatos == null) {
      debugPrint("Navegando a Login: Usuario nulo");
      destino = const LoginPantalla();
    } else {
      debugPrint("Usuario detectado: ${authProv.usuarioDatos!.rol}");
      if (authProv.usuarioDatos!.rol == Constantes.rolAdministrador) {
        destino = const AdminHomePantalla();
      } else {
        destino = const HomePantalla();
      }
    }

    // Usamos pushAndRemoveUntil para limpiar la memoria del Splash
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => destino),
      (route) => false,
    );
  }

  @override
  void dispose() {
    _logoController.dispose();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: TemaApp.gradienteNaranja),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo animado
              AnimatedBuilder(
                animation: _logoController,
                builder: (context, child) {
                  return Opacity(
                    opacity: _logoOpacity.value,
                    child: Transform.scale(
                      scale: _logoScale.value,
                      child: child,
                    ),
                  );
                },
                child: Container(
                  width: 140,
                  height: 140,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(36),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha(50),
                        blurRadius: 30,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(36),
                    child: Image.network(
                      Constantes.logoRappiUrl,
                      fit: BoxFit.contain,
                      errorBuilder: (_, __, ___) => const Icon(
                        Icons.delivery_dining,
                        color: TemaApp.naranjaPrincipal,
                        size: 80,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 36),

              // Texto animado
              AnimatedBuilder(
                animation: _textController,
                builder: (context, child) {
                  return Opacity(
                    opacity: _textOpacity.value,
                    child: SlideTransition(position: _textSlide, child: child),
                  );
                },
                child: Column(
                  children: [
                    const Text(
                      'Rappi',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 48,
                        fontWeight: FontWeight.w900,
                        letterSpacing: -2,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Todo a tu puerta',
                      style: TextStyle(
                        color: Colors.white.withAlpha(220),
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 80),

              // Indicador de carga
              AnimatedBuilder(
                animation: _textController,
                builder: (_, __) => Opacity(
                  opacity: _textOpacity.value,
                  child: SizedBox(
                    width: 28,
                    height: 28,
                    child: CircularProgressIndicator(
                      color: Colors.white.withAlpha(200),
                      strokeWidth: 2.5,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
