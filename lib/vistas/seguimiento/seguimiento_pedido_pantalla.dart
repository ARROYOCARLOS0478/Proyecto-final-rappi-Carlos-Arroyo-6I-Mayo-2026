// seguimiento_pedido_pantalla.dart actualizado con diseño Figma Premium
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';

// ── Mapeo estado → progreso (Sincronizado con Figma) ─────────────────────────
double _estadoAProgreso(String? estado) {
  switch (estado) {
    case 'pendiente':
      return 0.15;
    case 'preparando':
      return 0.45;
    case 'en camino':
      return 0.80;
    case 'entregado':
      return 1.0;
    default:
      return 0.05;
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
  Map<String, dynamic>? _repartidorData;

  late AnimationController _checkController;
  late Animation<double> _checkAnimation;
  late AnimationController _progressController;
  late Animation<double> _progressAnimation;

  // Colores exactos de tu diseño
  static const Color _verde = Color(0xFF00C5AB);
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

    _iniciarFlujo();
  }

  Widget _buildBotonDeshacerConProgreso() {
    return StreamBuilder<int>(
      // Creamos un stream que emite valores de 0 a 100 en 3 segundos
      stream: Stream.periodic(const Duration(milliseconds: 30), (x) => x).take(101),
      builder: (context, snapshot) {
        double progreso = (snapshot.data ?? 0) / 100.0;
        
        return GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            width: double.infinity,
            height: 60,
            decoration: BoxDecoration(
              color: const Color(0xFFF1F1F1), // Fondo gris suave
              borderRadius: BorderRadius.circular(20),
            ),
            child: Stack(
              children: [
                // La barra turquesa que se llena
                FractionallySizedBox(
                  widthFactor: progreso,
                  child: Container(
                    decoration: BoxDecoration(
                      color: _verde, // Turquesa clarito
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
                // El texto siempre arriba
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
                      // Opcional: un pequeño contador de segundos
                      Text(
                        "${(3 - (progreso * 3)).toInt()}s",
                        style: const TextStyle(color: _verde, fontWeight: FontWeight.bold),
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
    _timer = Timer(const Duration(seconds: 3), () {
      if (!mounted) return;
      setState(() => _fase = 1);
      _checkController.forward();

      // A los 3 segundos de mostrar el "Check", saltamos al seguimiento vivo
      _timer = Timer(const Duration(seconds: 3), () async {
        if (!mounted) return;
        setState(() => _fase = 2);

        // --- ESTO ES LO NUEVO: SIMULACIÓN ACTIVA ---
        _escucharPedido(); // Empezamos a escuchar

        // Forzamos el primer cambio a "Preparando"
        await FirebaseFirestore.instance
            .collection('pedidos')
            .doc(widget.pedidoId)
            .update({'estado': 'Preparando'});

        // A los 7 segundos, lo mandamos a la calle con un repartidor
        Future.delayed(const Duration(seconds: 7), () async {
          await FirebaseFirestore.instance
              .collection('pedidos')
              .doc(widget.pedidoId)
              .update({
                'estado': 'En camino',
                'repartidorId':
                    'REP123', // Pon un ID que exista o este de prueba
              });
        });
      });
    });
  }

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

          // 1. ASIGNACIÓN AUTOMÁTICA (Si no hay repartidor)
          if (repartidorId == null) {
            final repartidoresSnap = await FirebaseFirestore.instance
                .collection('repartidores')
                .limit(1)
                .get();

            if (repartidoresSnap.docs.isNotEmpty) {
              String idEncontrado = repartidoresSnap.docs.first.id;
              await FirebaseFirestore.instance
                  .collection('pedidos')
                  .doc(widget.pedidoId)
                  .update({
                    'repartidorId': idEncontrado,
                    'estado': 'En camino', // Lo ponemos en camino al asignar
                  });

              // --- SIMULACIÓN DE FINALIZACIÓN ---
              // Esperamos 10 segundos y lo marcamos como Entregado para ver la pantalla final
              Future.delayed(const Duration(seconds: 10), () {
                FirebaseFirestore.instance
                    .collection('pedidos')
                    .doc(widget.pedidoId)
                    .update({'estado': 'Entregado'});
              });
              return;
            }
          }

          // 2. ACTUALIZACIÓN DE INTERFAZ
          final nuevoProg = _estadoAProgreso(estado);
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

          _progressController.reset();
          _progressController.forward();

          if (repartidorId != null) {
            final repSnap = await FirebaseFirestore.instance
                .collection('repartidores')
                .doc(repartidorId)
                .get();
            if (repSnap.exists && mounted) {
              setState(() {
                _repartidorData = repSnap.data();
              });
            }
          }

          if (mounted) {
            setState(() {
              _pedidoData = data;
              // IMPORTANTE: Aquí es donde cambia a la pantalla de Carlos Mendoza
              if (estado == 'Entregado') {
                _fase = 3;
              }
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

  // ── FASE 0: DISEÑO "CREANDO" ───────────────────────────────────────────────
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

  // ── FASE 1: DISEÑO "ÉXITO" ─────────────────────────────────────────────────
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

  // ── FASE 2: DISEÑO "EN CURSO" (FIGMA REAL) ──────────────────────────────────
  Widget _buildEnCurso() {
    final estado = _pedidoData?['estado'] ?? 'Alistando';
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildCloseButton(),
              const SizedBox(height: 30),
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
              const SizedBox(height: 40),
              _buildBarraProgresoFigma(estado),
              const SizedBox(height: 40),
              _buildCardInfo(
                Icons.location_on,
                "YO RECIBO EN",
                _pedidoData?['direccionEntrega'] ?? "Dirección",
              ),
              const SizedBox(height: 15),
              _buildCardInfo(
                Icons.receipt,
                "RESUMEN DEL PEDIDO",
                "PRODUCTOS - \$${_pedidoData?['total'] ?? '0.00'}",
              ),
              const Spacer(),
              if (_repartidorData != null) _buildRepartidorFigma(),
            ],
          ),
        ),
      ),
    );
  }

  // ── ELEMENTOS DE DISEÑO UI ─────────────────────────────────────────────────

  Widget _buildBarraProgresoFigma(String estado) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _stepIcon(Icons.inventory_2, true),
            _stepIcon(Icons.restaurant, estado != 'Alistando'),
            _stepIcon(
              Icons.directions_bike,
              estado == 'En camino' || estado == 'Entregado',
            ),
            _stepIcon(Icons.check_circle, estado == 'Entregado'),
          ],
        ),
        const SizedBox(height: 15),
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: AnimatedBuilder(
            animation: _progressAnimation,
            builder: (context, _) => LinearProgressIndicator(
              value: _progressAnimation.value,
              backgroundColor: _fondoClaro,
              color: _verde,
              minHeight: 8,
            ),
          ),
        ),
      ],
    );
  }

  Widget _stepIcon(IconData icon, bool active) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: active ? const Color(0xFFE0F7F4) : _fondoClaro,
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: active ? _verde : Colors.grey[400], size: 20),
    );
  }

  Widget _buildCardInfo(IconData icon, String title, String value) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: _fondoClaro,
        borderRadius: BorderRadius.circular(25),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.grey[400]),
          const SizedBox(width: 15),
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

  Widget _buildRepartidorFigma() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: Color(0xFFEEEEEE))),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 25,
            backgroundColor: _verde,
            child: const Icon(Icons.person, color: Colors.white),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _repartidorData?['nombre'] ?? 'REPARTIDOR',
                  style: const TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 16,
                  ),
                ),
                const Text(
                  '4.9 ★  •  Repartidor Pro',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          _actionIcon(Icons.chat_bubble),
          const SizedBox(width: 10),
          _actionIcon(Icons.phone),
        ],
      ),
    );
  }

  Widget _actionIcon(IconData icon) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: const BoxDecoration(color: _verde, shape: BoxShape.circle),
      child: Icon(icon, color: Colors.white, size: 18),
    );
  }

  Widget _buildButton(String text, Color color, VoidCallback onTap) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          padding: const EdgeInsets.symmetric(vertical: 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 0,
        ),
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w900,
            fontSize: 16,
          ),
        ),
      ),
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
      padding: const EdgeInsets.symmetric(vertical: 15),
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

  // Placeholder para Fase 3 (Entregado) similar a la Fase 2 pero con el botón CERRAR grande al final.
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
            color: Color(0xFF00C5AB),
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // INFO DEL REPARTIDOR (CARLOS MENDOZA)
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 35,
                  backgroundImage: NetworkImage(
                    _repartidorData?['foto'] ??
                        'https://via.placeholder.com/150',
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
                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.amber, size: 16),
                        Text(
                          " 4.9  •  ${_repartidorData?['pedidosTotales'] ?? '1,240'} PEDIDOS",
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

          // TOTAL
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Text(
                  "TOTAL",
                  style: TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Productos - \$${_pedidoData?['total'] ?? '0.00'}",
                  style: const TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 28,
                  ),
                ),
                const Icon(Icons.keyboard_arrow_down),
              ],
            ),
          ),

          const SizedBox(height: 30),

          // CRONOLOGÍA (LA LISTA DE PUNTOS)
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

          // BOTÓN CERRAR
          Padding(
            padding: const EdgeInsets.all(20),
            child: _buildButton(
              "CERRAR",
              const Color(0xFF00C5AB),
              () => Navigator.pop(context),
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
              color: const Color(0xFF00C5AB),
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
