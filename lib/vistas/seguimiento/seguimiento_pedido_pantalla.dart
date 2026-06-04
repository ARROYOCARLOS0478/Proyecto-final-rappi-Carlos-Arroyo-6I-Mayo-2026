// seguimiento_pedido_pantalla.dart
// ✅ TAREA 1: Repartidor real desde Firestore con nombre, vehículo y ETA
// ✅ TAREA 2: Barra de progreso que avanza con el estado del pedido
// ✅ TAREA 3: Mapa simulado con ruta y marcador animado

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
import 'dart:math' as math;

// ── Mapeo estado → progreso ────────────────────────────────────────────────
double _estadoAProgreso(String? estado) {
  switch (estado?.toLowerCase()) {
    case 'pendiente':
      return 0.0;
    case 'preparando':
      return 0.33;
    case 'en camino':
      return 0.66;
    case 'entregado':
      return 1.0;
    default:
      return 0.0;
  }
}

// ── Mapeo estado → índice del step (0-3) ──────────────────────────────────
int _estadoAStep(String? estado) {
  switch (estado?.toLowerCase()) {
    case 'pendiente':
      return 0;
    case 'preparando':
      return 1;
    case 'en camino':
      return 2;
    case 'entregado':
      return 3;
    default:
      return 0;
  }
}

class SeguimientoPedidoPantalla extends StatefulWidget {
  final String pedidoId;
  const SeguimientoPedidoPantalla({super.key, required this.pedidoId});

  @override
  State<SeguimientoPedidoPantalla> createState() =>
      _SeguimientoPedidoPantallaState();
}

class _SeguimientoPedidoPantallaState extends State<SeguimientoPedidoPantalla>
    with TickerProviderStateMixin {
  int _fase = 0;
  Timer? _timer;
  StreamSubscription<DocumentSnapshot>? _pedidoSub;
  Map<String, dynamic>? _pedidoData;

  // ✅ TAREA 1: Ahora usamos el modelo Repartidor completo
  Map<String, dynamic>? _repartidorData;
  String? _repartidorVehiculo;
  String? _repartidorEta;

  // ✅ TAREA 2: Step actual para el stepper
  int _stepActual = 0;
  DateTime? _ultimaTransicionLocal;

  late AnimationController _checkController;
  late Animation<double> _checkAnimation;
  late AnimationController _progressController;
  late Animation<double> _progressAnimation;

  // ✅ TAREA 3: Animación del marcador en el mapa simulado
  late AnimationController _markerController;
  late Animation<double> _markerAnimation;

  static const Color _verde = Color(0xFF00C5AB);
  static const Color _naranja = Color(0xFFFF441F);
  static const Color _fondoClaro = Color(0xFFF8F9FA);

  @override
  void initState() {
    super.initState();

    _checkController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _checkAnimation = CurvedAnimation(
      parent: _checkController,
      curve: Curves.elasticOut,
    );

    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _progressAnimation = Tween<double>(begin: 0, end: 0).animate(
      CurvedAnimation(parent: _progressController, curve: Curves.easeInOut),
    );

    // ✅ TAREA 3: Controlador para el marcador del mapa
    _markerController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);
    _markerAnimation = Tween<double>(begin: 0.1, end: 0.75).animate(
      CurvedAnimation(parent: _markerController, curve: Curves.easeInOut),
    );

    _escucharPedido();
    _iniciarFlujo();
  }

  Widget _buildBotonDeshacerConProgreso() {
    return StreamBuilder<int>(
      stream: Stream.periodic(
        const Duration(milliseconds: 30),
        (x) => x,
      ).take(101),
      builder: (context, snapshot) {
        double progreso = (snapshot.data ?? 0) / 100.0;
        return GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            width: double.infinity,
            height: 60,
            decoration: BoxDecoration(
              color: const Color(0xFFF1F1F1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Stack(
              children: [
                FractionallySizedBox(
                  widthFactor: progreso,
                  child: Container(
                    decoration: BoxDecoration(
                      color: _verde,
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "DESHACER PEDIDO",
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w900,
                          fontSize: 16,
                          letterSpacing: 1,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        "${(3 - (progreso * 3)).toInt()}s",
                        style: const TextStyle(
                          color: _verde,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _iniciarFlujo() {
    // Secuencia controlada: cada fase dura al menos 3s.
    _timer = Timer(const Duration(seconds: 0), () async {
      try {
        // 1) Espera 3s en 'Pendiente' antes de pasar a 'Preparando'
        await Future.delayed(const Duration(seconds: 3));
        if (!mounted) return;
        // Aplicar cambio localmente primero (optimista) para evitar que
        // fallos remotos o latencia bloqueen la UI.
        _ultimaTransicionLocal = DateTime.now();
        setState(() {
          _fase = 1;
          _stepActual = 1;
          _pedidoData = (_pedidoData ?? {})..['estado'] = 'Preparando';
        });
        // Intentar actualizar en Firestore (no bloqueamos la UI si falla)
        try {
          await FirebaseFirestore.instance
              .collection('pedidos')
              .doc(widget.pedidoId)
              .update({'estado': 'Preparando'});
        } catch (e) {
          debugPrint('Warning: no se pudo escribir estado Preparando: $e');
        }
        _checkController.forward();

        // 2) Esperar al menos 3s en 'Preparando' antes de asignar repartidor y 'En Camino'
        await Future.delayed(const Duration(seconds: 3));
        if (!mounted) return;
        final repartidoresSnap = await FirebaseFirestore.instance
            .collection('repartidores')
            .limit(1)
            .get();

        final updateData = {'estado': 'En Camino'};
        String? asignadoId;
        if (repartidoresSnap.docs.isNotEmpty) {
          asignadoId = repartidoresSnap.docs.first.id;
          updateData['repartidorId'] = asignadoId;
        }

        // Cambio optimista local
        _ultimaTransicionLocal = DateTime.now();
        setState(() {
          _fase = 2;
          _stepActual = 2;
          _pedidoData = (_pedidoData ?? {})..['estado'] = 'En Camino';
          if (asignadoId != null) _pedidoData!['repartidorId'] = asignadoId;
        });
        try {
          await FirebaseFirestore.instance
              .collection('pedidos')
              .doc(widget.pedidoId)
              .update(updateData);
        } catch (e) {
          debugPrint(
            'Warning: no se pudo asignar repartidor/estado En Camino: $e',
          );
        }

        // 3) Esperar al menos 3s en 'En Camino' antes de marcar 'Entregado'
        await Future.delayed(const Duration(seconds: 3));
        if (!mounted) return;
        _ultimaTransicionLocal = DateTime.now();
        setState(() {
          _fase = 3;
          _stepActual = 3;
          _pedidoData = (_pedidoData ?? {})..['estado'] = 'Entregado';
        });
        try {
          await FirebaseFirestore.instance
              .collection('pedidos')
              .doc(widget.pedidoId)
              .update({'estado': 'Entregado'});
        } catch (e) {
          debugPrint('Warning: no se pudo escribir estado Entregado: $e');
        }
      } catch (e) {
        debugPrint('Error en flujo de seguimiento: $e');
      }
    });
  }

  // ✅ TAREA 1 + TAREA 2: Escucha pedido Y carga datos completos del repartidor
  void _escucharPedido() {
    _pedidoSub = FirebaseFirestore.instance
        .collection('pedidos')
        .doc(widget.pedidoId)
        .snapshots()
        .listen((snap) async {
          if (!snap.exists || !mounted) return;

          final data = snap.data()!;
          final estado = data['estado'] as String? ?? 'Pendiente';
          final repartidorId = data['repartidorId'] as String?;

          // ✅ TAREA 2: Actualizar step y barra de progreso según el estado
          final nuevoStep = _estadoAStep(estado);
          final nuevoProg = _estadoAProgreso(estado);

          // Si el cambio remoto avanza fases demasiado rápido, ignóralo
          if (_ultimaTransicionLocal != null) {
            final diff = DateTime.now()
                .difference(_ultimaTransicionLocal!)
                .inMilliseconds;
            if (nuevoStep > _stepActual && diff < 3000) {
              // Ignorar actualización por estar dentro del mínimo de 3s
              return;
            }
          }

          _progressAnimation =
              Tween<double>(
                begin: _progressAnimation.value,
                end: nuevoProg,
              ).animate(
                CurvedAnimation(
                  parent: _progressController,
                  curve: Curves.easeInOut,
                ),
              );
          _progressController
            ..reset()
            ..forward();

          // ✅ TAREA 1: Cargar datos completos del repartidor (nombre, vehículo, ETA)
          if (repartidorId != null) {
            final repSnap = await FirebaseFirestore.instance
                .collection('repartidores')
                .doc(repartidorId)
                .get();

            if (repSnap.exists && mounted) {
              final repData = repSnap.data()!;
              setState(() {
                _repartidorData = repData;
                _repartidorVehiculo = repData['vehiculo'] as String?;
                _repartidorEta = repData['eta'] as String?;
                if (repData['fotoUrl'] != null) {
                  _repartidorData!['fotoUrl'] = repData['fotoUrl'];
                }
              });
            }
          }

          int faseActual;
          switch (estado.toLowerCase()) {
            case 'preparando':
              faseActual = 1;
              if (_checkController.status != AnimationStatus.completed) {
                _checkController.forward();
              }
              break;
            case 'en camino':
              faseActual = 2;
              break;
            case 'entregado':
              faseActual = 3;
              break;
            default:
              faseActual = 0;
          }

          if (mounted) {
            setState(() {
              _pedidoData = data;
              _stepActual = nuevoStep;
              _fase = faseActual;
            });
          }
        });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pedidoSub?.cancel();
    _checkController.dispose();
    _progressController.dispose();
    _markerController.dispose(); // ✅ TAREA 3
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    switch (_fase) {
      case 0:
        return _buildCreandoPedido();
      case 1:
        return _buildPedidoCreado();
      case 2:
        return _buildEnCurso();
      case 3:
        return _buildEntregado();
      default:
        return _buildCreandoPedido();
    }
  }

  // ── FASE 0 ─────────────────────────────────────────────────────────────────
  Widget _buildCreandoPedido() {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Estamos creando tu\npedido',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w900,
                  height: 1.1,
                  letterSpacing: -1,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                (_pedidoData?['comercioNombre'] ?? 'COMERCIO')
                    .toString()
                    .toUpperCase(),
                style: const TextStyle(
                  color: _verde,
                  fontWeight: FontWeight.w900,
                  fontSize: 13,
                  letterSpacing: 1.5,
                ),
              ),
              const SizedBox(height: 40),
              _buildSimpleRow(
                Icons.location_on_outlined,
                'ENTREGA EN',
                _pedidoData?['direccionEntrega'] ?? 'Cargando...',
              ),
              _buildDivider(),
              _buildSimpleRow(
                Icons.access_time,
                'LLEGADA ESTIMADA',
                '35 - 45 MIN',
              ),
              _buildDivider(),
              _buildSimpleRow(
                Icons.payment,
                'MÉTODO DE PAGO',
                _pedidoData?['metodoPago'] ?? 'EFECTIVO',
              ),
              const Spacer(),
              _buildBotonDeshacerConProgreso(),
            ],
          ),
        ),
      ),
    );
  }

  // ── FASE 1 ─────────────────────────────────────────────────────────────────
  Widget _buildPedidoCreado() {
    return Scaffold(
      backgroundColor: const Color(0xFFE8FAF7),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ScaleTransition(
              scale: _checkAnimation,
              child: const Icon(Icons.check_circle, color: _verde, size: 100),
            ),
            const SizedBox(height: 30),
            const Text(
              '¡Tu pedido fue\ncreado con éxito!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w900,
                color: _verde,
                height: 1.1,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── FASE 2: EN CURSO ───────────────────────────────────────────────────────
  Widget _buildEnCurso() {
    final estado = _pedidoData?['estado'] ?? 'Alistando';
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildCloseButton(),
              const SizedBox(height: 20),
              Text(
                estado.toString().toUpperCase(),
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -1,
                ),
              ),
              const Text(
                'SIGUE TU ENTREGA EN VIVO',
                style: TextStyle(
                  color: _verde,
                  fontWeight: FontWeight.w900,
                  fontSize: 12,
                  letterSpacing: 1,
                ),
              ),
              const SizedBox(height: 30),

              // ✅ TAREA 2: Stepper que avanza con el estado de Firebase
              _buildStepperProgreso(estado),

              const SizedBox(height: 30),

              // ✅ TAREA 3: Mapa simulado
              _buildMapaSimulado(),

              const SizedBox(height: 20),
              _buildCardInfo(
                Icons.location_on,
                "YO RECIBO EN",
                _pedidoData?['direccionEntrega'] ?? "Dirección",
              ),
              const SizedBox(height: 12),
              _buildCardInfo(
                Icons.receipt,
                "RESUMEN DEL PEDIDO",
                "PRODUCTOS - \$${_pedidoData?['total'] ?? '0.00'}",
              ),
              const SizedBox(height: 20),

              // ✅ TAREA 1: Tarjeta del repartidor con nombre, vehículo y ETA
              if (_repartidorData != null) _buildRepartidorCard(),
            ],
          ),
        ),
      ),
    );
  }

  // ✅ TAREA 2: Stepper visual con 4 pasos que avanza automáticamente
  Widget _buildStepperProgreso(String estado) {
    final pasos = [
      {'label': 'RECIBIDO', 'icon': Icons.inventory_2},
      {'label': 'PREPARANDO', 'icon': Icons.restaurant},
      {'label': 'EN CAMINO', 'icon': Icons.directions_bike},
      {'label': 'ENTREGADO', 'icon': Icons.check_circle},
    ];

    return Column(
      children: [
        Row(
          children: pasos.asMap().entries.map((entry) {
            final idx = entry.key;
            final paso = entry.value;
            final activo = idx <= _stepActual;
            final esCurrent = idx == _stepActual;

            return Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 400),
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: activo
                                ? (esCurrent
                                      ? _verde
                                      : _verde.withValues(alpha: 0.3))
                                : _fondoClaro,
                            shape: BoxShape.circle,
                            boxShadow: esCurrent
                                ? [
                                    BoxShadow(
                                      color: _verde.withValues(alpha: 0.4),
                                      blurRadius: 8,
                                      spreadRadius: 2,
                                    ),
                                  ]
                                : [],
                          ),
                          child: Icon(
                            paso['icon'] as IconData,
                            color: activo ? Colors.white : Colors.grey[400],
                            size: 20,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          paso['label'] as String,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 8,
                            fontWeight: FontWeight.w900,
                            color: activo ? _verde : Colors.grey[400],
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Línea conectora (excepto el último)
                  if (idx < pasos.length - 1)
                    Expanded(
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 600),
                        height: 3,
                        decoration: BoxDecoration(
                          color: idx < _stepActual ? _verde : Colors.grey[200],
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                ],
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 16),
        // Barra de progreso animada
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: AnimatedBuilder(
            animation: _progressAnimation,
            builder: (context, _) => LinearProgressIndicator(
              value: _progressAnimation.value,
              backgroundColor: _fondoClaro,
              color: _verde,
              minHeight: 6,
            ),
          ),
        ),
        const SizedBox(height: 6),
        Align(
          alignment: Alignment.centerRight,
          child: Text(
            '${(_estadoAProgreso(_pedidoData?['estado']) * 100).toInt()}%',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w900,
              color: _verde,
            ),
          ),
        ),
      ],
    );
  }

  // ✅ TAREA 3: Mapa simulado profesional con ruta y marcador animado
  Widget _buildMapaSimulado() {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: const Color(0xFFE8F5E9),
        border: Border.all(color: Colors.grey.shade200),
      ),
      clipBehavior: Clip.hardEdge,
      child: Stack(
        children: [
          // Fondo tipo mapa con cuadrícula
          CustomPaint(
            size: const Size(double.infinity, 200),
            painter: _MapaGridPainter(),
          ),
          // Ruta animada
          CustomPaint(
            size: const Size(double.infinity, 200),
            painter: _RutaPainter(color: _verde),
          ),
          // Marcador de destino (fijo)
          const Positioned(
            right: 40,
            top: 40,
            child: Column(
              children: [
                Icon(Icons.location_on, color: Colors.red, size: 30),
                Text(
                  'DESTINO',
                  style: TextStyle(
                    fontSize: 8,
                    fontWeight: FontWeight.w900,
                    color: Colors.red,
                  ),
                ),
              ],
            ),
          ),
          // Marcador del repartidor (animado)
          AnimatedBuilder(
            animation: _markerAnimation,
            builder: (context, child) {
              return Positioned(
                left:
                    MediaQuery.of(context).size.width * 0.08 +
                    (_markerAnimation.value *
                        (MediaQuery.of(context).size.width * 0.5)),
                top: 90 + math.sin(_markerAnimation.value * math.pi) * -40,
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: _verde,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: _verde.withValues(alpha: 0.4),
                            blurRadius: 8,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.delivery_dining,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                    Container(width: 2, height: 6, color: _verde),
                  ],
                ),
              );
            },
          ),
          // ETA badge
          Positioned(
            bottom: 12,
            left: 12,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: const [
                  BoxShadow(color: Colors.black12, blurRadius: 6),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.access_time, size: 14, color: _verde),
                  const SizedBox(width: 4),
                  Text(
                    // ✅ TAREA 1: Muestra ETA real si existe
                    _repartidorEta ?? '15-20 min',
                    style: const TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Label "MAPA EN VIVO"
          Positioned(
            top: 12,
            right: 12,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: _verde,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.circle, color: Colors.white, size: 6),
                  SizedBox(width: 4),
                  Text(
                    'EN VIVO',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                      fontSize: 9,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ✅ TAREA 1: Tarjeta del repartidor con nombre, vehículo y ETA reales
  Widget _buildRepartidorCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _fondoClaro,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Row(
        children: [
          // Avatar con manejo de error en imagen
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(shape: BoxShape.circle),
            child: ClipOval(
              child:
                  _repartidorData?['fotoUrl'] != null &&
                      (_repartidorData!['fotoUrl'] as String).isNotEmpty
                  ? Image.network(
                      _repartidorData!['fotoUrl'] as String,
                      width: 56,
                      height: 56,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        color: _verde,
                        child: const Icon(
                          Icons.person,
                          color: Colors.white,
                          size: 28,
                        ),
                      ),
                    )
                  : Container(
                      color: _verde,
                      child: const Icon(
                        Icons.person,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Nombre del repartidor
                Text(
                  (_repartidorData?['nombre'] ?? 'REPARTIDOR')
                      .toString()
                      .toUpperCase(),
                  style: const TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 4),
                // ✅ TAREA 1: Vehículo real desde Firestore
                Row(
                  children: [
                    const Icon(
                      Icons.directions_bike,
                      size: 13,
                      color: Colors.grey,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      _repartidorVehiculo ?? 'Vehículo',
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                // ✅ TAREA 1: ETA real desde Firestore
                Row(
                  children: [
                    const Icon(Icons.access_time, size: 13, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text(
                      'ETA: ${_repartidorEta ?? 'Calculando...'}',
                      style: TextStyle(
                        color: _verde,
                        fontSize: 12,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          _actionIcon(Icons.chat_bubble),
          const SizedBox(width: 8),
          _actionIcon(Icons.phone),
        ],
      ),
    );
  }

  Widget _buildCardInfo(IconData icon, String title, String value) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _fondoClaro,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.grey[400]),
          const SizedBox(width: 14),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 10,
                  fontWeight: FontWeight.w900,
                ),
              ),
              Text(
                value.toUpperCase(),
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _actionIcon(IconData icon) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: const BoxDecoration(color: _verde, shape: BoxShape.circle),
      child: Icon(icon, color: Colors.white, size: 16),
    );
  }

  Widget _buildCloseButton() => GestureDetector(
    onTap: () => Navigator.pop(context),
    child: Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(color: _fondoClaro, shape: BoxShape.circle),
      child: const Icon(Icons.close, size: 20),
    ),
  );

  Widget _buildSimpleRow(IconData icon, String title, String subtitle) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Row(
        children: [
          Icon(icon, color: Colors.grey),
          const SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 14,
                ),
              ),
              Text(
                subtitle,
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() => const Divider(color: Color(0xFFF1F1F1));

  // ── FASE 3: ENTREGADO ──────────────────────────────────────────────────────
  Widget _buildEntregado() {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "PEDIDO ENTREGADO",
          style: TextStyle(
            color: _verde,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                // Avatar final con fallback al icono si la URL falla
                Container(
                  width: 70,
                  height: 70,
                  decoration: const BoxDecoration(shape: BoxShape.circle),
                  child: ClipOval(
                    child:
                        _repartidorData?['fotoUrl'] != null &&
                            (_repartidorData!['fotoUrl'] as String).isNotEmpty
                        ? Image.network(
                            _repartidorData!['fotoUrl'] as String,
                            width: 70,
                            height: 70,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(
                              color: _verde,
                              child: const Icon(
                                Icons.person,
                                color: Colors.white,
                                size: 30,
                              ),
                            ),
                          )
                        : Container(
                            color: _verde,
                            child: const Icon(
                              Icons.person,
                              color: Colors.white,
                              size: 30,
                            ),
                          ),
                  ),
                ),
                const SizedBox(width: 15),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _repartidorData?['nombre'] ?? 'REPARTIDOR',
                      style: const TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 20,
                      ),
                    ),
                    // ✅ TAREA 1: Vehículo en pantalla final
                    if (_repartidorVehiculo != null)
                      Row(
                        children: [
                          const Icon(
                            Icons.directions_bike,
                            size: 14,
                            color: Colors.grey,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            _repartidorVehiculo!,
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "TOTAL",
                  style: TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
                Text(
                  "\$${_pedidoData?['total'] ?? '0.00'}",
                  style: const TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 28,
                    color: _verde,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFFF8F9FA),
                borderRadius: BorderRadius.circular(30),
              ),
              child: ListView(
                children: [
                  const Center(
                    child: Text(
                      "CRONOLOGÍA DEL PEDIDO",
                      style: TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
                        fontSize: 10,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildCronologiaItem("PEDIDO RECIBIDO", "12:30 PM", true),
                  _buildCronologiaItem("COMIDA PREPARADA", "12:45 PM", true),
                  _buildCronologiaItem(
                    "${_repartidorData?['nombre'] ?? 'REPARTIDOR'} RECOGIÓ TU PEDIDO",
                    "12:55 PM",
                    true,
                  ),
                  _buildCronologiaItem(
                    "LLEGÓ A TU DIRECCIÓN",
                    "01:10 PM",
                    true,
                  ),
                  _buildCronologiaItem(
                    "ENTREGADO",
                    "01:15 PM",
                    true,
                    isLast: true,
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _verde,
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  "CERRAR",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCronologiaItem(
    String titulo,
    String hora,
    bool completado, {
    bool isLast = false,
  }) {
    return Row(
      children: [
        Column(
          children: [
            Icon(
              completado ? Icons.check_circle : Icons.radio_button_unchecked,
              color: _verde,
              size: 20,
            ),
            if (!isLast)
              Container(width: 2, height: 30, color: Colors.grey[300]),
          ],
        ),
        const SizedBox(width: 15),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              titulo,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
            ),
            Text(
              hora,
              style: const TextStyle(color: Colors.grey, fontSize: 11),
            ),
          ],
        ),
      ],
    );
  }
}

// ✅ TAREA 3: Painter para la cuadrícula del mapa simulado
class _MapaGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFCFE8CF)
      ..strokeWidth = 1;

    // Líneas horizontales
    for (double y = 0; y < size.height; y += 30) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
    // Líneas verticales
    for (double x = 0; x < size.width; x += 30) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }

    // Simular bloques de "manzanas"
    final blockPaint = Paint()
      ..color = const Color(0xFFB8D8B8).withValues(alpha: 0.5);
    final blocks = [
      const Rect.fromLTWH(30, 30, 60, 50),
      const Rect.fromLTWH(120, 60, 80, 40),
      const Rect.fromLTWH(220, 20, 50, 70),
      const Rect.fromLTWH(30, 120, 70, 40),
      const Rect.fromLTWH(150, 120, 60, 50),
    ];
    for (final b in blocks) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(b, const Radius.circular(4)),
        blockPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ✅ TAREA 3: Painter para la ruta del repartidor
class _RutaPainter extends CustomPainter {
  final Color color;
  _RutaPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final path = Path()
      ..moveTo(size.width * 0.08, size.height * 0.65)
      ..lineTo(size.width * 0.25, size.height * 0.65)
      ..lineTo(size.width * 0.25, size.height * 0.35)
      ..lineTo(size.width * 0.55, size.height * 0.35)
      ..lineTo(size.width * 0.55, size.height * 0.25)
      ..lineTo(size.width * 0.78, size.height * 0.25);

    canvas.drawPath(path, paint);

    // Puntos en los giros
    final dotPaint = Paint()
      ..color = color.withValues(alpha: 0.5)
      ..style = PaintingStyle.fill;
    for (final offset in [
      Offset(size.width * 0.25, size.height * 0.65),
      Offset(size.width * 0.25, size.height * 0.35),
      Offset(size.width * 0.55, size.height * 0.35),
      Offset(size.width * 0.55, size.height * 0.25),
    ]) {
      canvas.drawCircle(offset, 4, dotPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
