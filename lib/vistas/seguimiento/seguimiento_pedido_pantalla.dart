// seguimiento_pedido_pantalla.dart
//
// Flujo de fases:
//  0 → "Estamos creando tu pedido"  (imagen 4) — 3 seg, botón DESHACER
//  1 → "Tu pedido fue creado con éxito" (imagen 5) — 3 seg, verde claro
//  2 → "Alistando" (imagen 6) — escucha Firestore en tiempo real
//  3 → "Entregado" (imagen 7) — cronología completa
//
// El campo `repartidorId` en el documento de Firestore se usa para mostrar
// los datos reales del repartidor desde la colección `repartidores`.
// El `LinearProgressIndicator` avanza según el campo `estado` del pedido.

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';

// ── Mapeo estado → progreso ──────────────────────────────────────────────────
double _estadoAProgreso(String? estado) {
  switch (estado) {
    case 'Pendiente':
      return 0.0;
    case 'Alistando':
      return 0.25;
    case 'Preparando':
      return 0.50;
    case 'En camino':
      return 0.75;
    case 'Entregado':
      return 1.0;
    default:
      return 0.0;
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
  // ── Fases de UI ─────────────────────────────────────────────────────────────
  int _fase = 0; // 0=cargando, 1=éxito, 2=alistando/en curso, 3=entregado
  Timer? _timer;

  // ── Datos de Firestore ───────────────────────────────────────────────────────
  StreamSubscription<DocumentSnapshot>? _pedidoSub;
  Map<String, dynamic>? _pedidoData;
  Map<String, dynamic>? _repartidorData;

  // ── Animaciones ──────────────────────────────────────────────────────────────
  late AnimationController _checkController;
  late Animation<double> _checkAnimation;
  late AnimationController _progressController;
  late Animation<double> _progressAnimation;

  // ── Colores ──────────────────────────────────────────────────────────────────
  static const Color _verde = Color(0xFF00C5AB);
  static const Color _azulOscuro = Color(0xFF001D3D);

  // ── Cronología de timestamps ─────────────────────────────────────────────────
  // Se genera a partir del estado del pedido
  List<Map<String, dynamic>> get _cronologia {
    final estado = _pedidoData?['estado'] as String? ?? '';
    final estados = ['Alistando', 'Preparando', 'En camino', 'Entregado'];
    final idxActual = estados.indexOf(estado);

    final horas = ['12:30 PM', '12:45 PM', '12:55 PM', '01:10 PM', '01:15 PM'];
    final labels = [
      'PEDIDO RECIBIDO',
      'COMIDA PREPARADA',
      '${_repartidorData?['nombre'] ?? 'REPARTIDOR'} RECOGIÓ TU PEDIDO',
      'LLEGÓ A TU DIRECCIÓN',
      'ENTREGADO',
    ];

    return List.generate(5, (i) {
      // El primer punto (pedido recibido) siempre está completo si llegamos aquí
      final bool listo = i == 0 || (i - 1) <= idxActual;
      return {'label': labels[i], 'hora': horas[i], 'listo': listo};
    });
  }

  @override
  void initState() {
    super.initState();

    // Animación del check
    _checkController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _checkAnimation = CurvedAnimation(
      parent: _checkController,
      curve: Curves.elasticOut,
    );

    // Animación del progress bar (suavizado)
    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _progressAnimation = Tween<double>(begin: 0, end: 0).animate(
      CurvedAnimation(parent: _progressController, curve: Curves.easeInOut),
    );

    _iniciarFlujo();
  }

  void _iniciarFlujo() {
    // Fase 0 → 3 segundos → Fase 1
    _timer = Timer(const Duration(seconds: 3), () {
      if (!mounted) return;
      setState(() => _fase = 1);
      _checkController.forward();

      // Fase 1 → 3 segundos → Fase 2 (escuchar Firestore)
      _timer = Timer(const Duration(seconds: 3), () {
        if (!mounted) return;
        setState(() => _fase = 2);
        _escucharPedido();
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

          // Actualizar progress bar con animación suave
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
          _progressController
            ..reset()
            ..forward();

          // Cargar datos del repartidor si acaba de asignarse
          Map<String, dynamic>? repartidor = _repartidorData;
          if (repartidorId != null && repartidor == null) {
            repartidor = await _obtenerRepartidor(repartidorId);
          }

          if (mounted) {
            setState(() {
              _pedidoData = data;
              _repartidorData = repartidor;
              if (estado == 'Entregado') _fase = 3;
            });
          }
        });
  }

  Future<Map<String, dynamic>?> _obtenerRepartidor(String repartidorId) async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection('repartidores')
          .doc(repartidorId)
          .get();
      return doc.exists ? doc.data() : null;
    } catch (_) {
      return null;
    }
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
        return _buildAlistando();
      case 3:
        return _buildEntregado();
      default:
        return _buildCreandoPedido();
    }
  }

  // ── FASE 0: Creando pedido ──────────────────────────────────────────────────
  Widget _buildCreandoPedido() {
    final estado = _pedidoData?['estado'] as String? ?? 'Pendiente';
    final direccion =
        _pedidoData?['direccionEntrega'] as String? ?? 'Tu dirección';
    final metodoPago = _pedidoData?['metodoPago'] as String? ?? 'Efectivo';
    final tipoEnvio = _pedidoData?['tipoEnvio'] as String? ?? 'Estándar';

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              const Text(
                'Estamos creando tu\npedido',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                (_pedidoData?['comercioId'] as String? ?? 'TU COMERCIO')
                    .toUpperCase(),
                style: const TextStyle(
                  color: _verde,
                  fontWeight: FontWeight.w900,
                  fontSize: 13,
                  letterSpacing: 1,
                ),
              ),
              Text(
                '${_pedidoData?['items']?.length ?? 1} PRODUCTO(S)',
                style: const TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 40),
              _buildInfoRow(
                Icons.location_on_outlined,
                'Entrega en Casa',
                direccion,
              ),
              _buildDivider(),
              _buildInfoRow(
                Icons.access_time_outlined,
                'Llegada estimada',
                tipoEnvio.toUpperCase(),
              ),
              _buildDivider(),
              _buildInfoRow(
                Icons.payments_outlined,
                'Método de Pago',
                metodoPago.toUpperCase(),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    _timer?.cancel();
                    // Opcional: eliminar el pedido en Firestore
                    FirebaseFirestore.instance
                        .collection('pedidos')
                        .doc(widget.pedidoId)
                        .delete()
                        .ignore();
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _verde,
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'DESHACER PEDIDO',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                      fontSize: 15,
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

  // ── FASE 1: Pedido creado con éxito ────────────────────────────────────────
  Widget _buildPedidoCreado() {
    return Scaffold(
      backgroundColor: const Color(0xFFE8FAF7),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ScaleTransition(
                scale: _checkAnimation,
                child: const Icon(
                  Icons.check_circle_outline,
                  color: _verde,
                  size: 40,
                ),
              ),
              const SizedBox(height: 30),
              const Text(
                'Tu pedido fue\ncreado con éxito',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w900,
                  color: _verde,
                  height: 1.2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── FASE 2: Alistando / En curso ───────────────────────────────────────────
  Widget _buildAlistando() {
    final estado = _pedidoData?['estado'] as String? ?? 'Alistando';
    final direccion =
        _pedidoData?['direccionEntrega'] as String? ?? 'Tu dirección';
    final totalStr =
        '\$${((_pedidoData?['total'] as num?)?.toStringAsFixed(2)) ?? '0.00'}';
    final tieneRepartidor = _repartidorData != null;
    final nombreRepartidor =
        _repartidorData?['nombre'] as String? ?? 'Tu repartidor';
    final vehiculoRepartidor = _repartidorData?['vehiculo'] as String? ?? '';

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Botón cerrar
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.close, size: 18),
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'ALISTANDO TU PEDIDO',
                style: TextStyle(fontWeight: FontWeight.w900, fontSize: 22),
              ),
              const SizedBox(height: 4),
              const Text(
                'SIGUE TU ENTREGA EN VIVO',
                style: TextStyle(
                  color: _verde,
                  fontWeight: FontWeight.w900,
                  fontSize: 12,
                  letterSpacing: 1,
                ),
              ),
              const SizedBox(height: 24),

              // ── Barra de progreso dinámica desde Firestore ─────────────────
              _buildBarraProgreso(estado),

              const SizedBox(height: 24),

              // Dirección
              _buildInfoCard(
                icon: Icons.location_on_outlined,
                labelSmall: 'YO RECIBO EN',
                valorGrande: direccion.toUpperCase(),
              ),
              const SizedBox(height: 10),

              // Resumen del pedido
              _buildInfoCard(
                icon: Icons.receipt_long_outlined,
                labelSmall: 'RESUMEN DEL PEDIDO',
                valorGrande: 'PRODUCTOS - $totalStr',
                trailing: const Icon(
                  Icons.keyboard_arrow_down,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 20),

              // Repartidor — aparece cuando repartidorId deja de ser null
              if (tieneRepartidor)
                _buildRepartidorCard(
                  nombre: nombreRepartidor,
                  vehiculo: vehiculoRepartidor,
                )
              else
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.grey.shade100),
                  ),
                  child: const Row(
                    children: [
                      SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: _verde,
                        ),
                      ),
                      SizedBox(width: 14),
                      Text(
                        'Asignando repartidor...',
                        style: TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  // Barra de progreso con 4 iconos y AnimatedBuilder
  Widget _buildBarraProgreso(String estado) {
    final pasos = [
      {'icon': Icons.inventory_2_outlined, 'label': 'Alistando'},
      {'icon': Icons.restaurant_outlined, 'label': 'Preparando'},
      {'icon': Icons.directions_bike_outlined, 'label': 'En camino'},
      {'icon': Icons.check_circle_outline, 'label': 'Entregado'},
    ];
    final estadosOrden = ['Alistando', 'Preparando', 'En camino', 'Entregado'];
    final idxActual = estadosOrden.indexOf(estado);

    return Column(
      children: [
        // Iconos
        Row(
          children: List.generate(pasos.length, (i) {
            final activo = i <= idxActual;
            return Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: Center(
                      child: Icon(
                        pasos[i]['icon'] as IconData,
                        color: activo ? _verde : Colors.grey[300],
                        size: 22,
                      ),
                    ),
                  ),
                  if (i < pasos.length - 1)
                    Expanded(
                      child: Container(
                        height: 3,
                        decoration: BoxDecoration(
                          color: i < idxActual ? _verde : Colors.grey[200],
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                ],
              ),
            );
          }),
        ),
        const SizedBox(height: 10),
        // LinearProgressIndicator animado
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: AnimatedBuilder(
            animation: _progressAnimation,
            builder: (_, __) => LinearProgressIndicator(
              value: _progressAnimation.value,
              backgroundColor: Colors.grey[200],
              color: _verde,
              minHeight: 5,
            ),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          estado.toUpperCase(),
          style: const TextStyle(
            color: _verde,
            fontWeight: FontWeight.w900,
            fontSize: 10,
            letterSpacing: 1.5,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String labelSmall,
    required String valorGrande,
    Widget? trailing,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.grey, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  labelSmall,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  valorGrande,
                  style: const TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          if (trailing != null) trailing,
        ],
      ),
    );
  }

  Widget _buildRepartidorCard({
    required String nombre,
    required String vehiculo,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade100),
        boxShadow: [
          BoxShadow(color: Colors.black.withAlpha(8), blurRadius: 10),
        ],
      ),
      child: Row(
        children: [
          // Avatar genérico (foto de repartidor si la tienes en Firestore)
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.delivery_dining,
              color: Colors.grey,
              size: 26,
            ),
          ),
          const SizedBox(width: 14),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                nombre.toUpperCase(),
                style: const TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 14,
                ),
              ),
              Row(
                children: const [
                  Icon(Icons.star, color: Colors.amber, size: 14),
                  SizedBox(width: 4),
                  Text(
                    '4.9',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                ],
              ),
              if (vehiculo.isNotEmpty)
                Text(
                  vehiculo.toUpperCase(),
                  style: const TextStyle(color: Colors.grey, fontSize: 10),
                ),
            ],
          ),
        ],
      ),
    );
  }

  // ── FASE 3: Entregado ───────────────────────────────────────────────────────
  Widget _buildEntregado() {
    final nombreRepartidor =
        _repartidorData?['nombre'] as String? ?? 'Tu repartidor';
    final totalStr =
        '\$${((_pedidoData?['total'] as num?)?.toStringAsFixed(2)) ?? '0.00'}';
    final comercio = (_pedidoData?['comercioId'] as String? ?? 'Tu pedido')
        .toUpperCase();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              color: Colors.grey[100],
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.close, size: 18),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          comercio,
                          style: const TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    const Padding(
                      padding: EdgeInsets.only(left: 48),
                      child: Text(
                        'PEDIDO ENTREGADO',
                        style: TextStyle(
                          color: _verde,
                          fontWeight: FontWeight.w900,
                          fontSize: 11,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Repartidor
                    Row(
                      children: [
                        Container(
                          width: 52,
                          height: 52,
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.delivery_dining,
                            color: Colors.grey,
                            size: 26,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              nombreRepartidor.toUpperCase(),
                              style: const TextStyle(
                                fontWeight: FontWeight.w900,
                                fontSize: 14,
                              ),
                            ),
                            Row(
                              children: const [
                                Icon(Icons.star, color: Colors.amber, size: 14),
                                SizedBox(width: 4),
                                Text(
                                  '4.9',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                  ),
                                ),
                                SizedBox(width: 8),
                                Text(
                                  '1,248 pedidos entregados',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 11,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),
                    const Divider(height: 1),
                    const SizedBox(height: 20),

                    // Total
                    const Text(
                      'TOTAL',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Productos - $totalStr',
                          style: const TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 22,
                          ),
                        ),
                        const Icon(
                          Icons.keyboard_arrow_down,
                          color: Colors.grey,
                        ),
                      ],
                    ),

                    const SizedBox(height: 28),

                    // Cronología
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.grey[50],
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'CRONOLOGÍA DEL PEDIDO',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1,
                            ),
                          ),
                          const SizedBox(height: 16),
                          ..._cronologia.asMap().entries.map((e) {
                            return _buildCronologiaStep(
                              e.value,
                              e.key == _cronologia.length - 1,
                            );
                          }),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Botón cerrar
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _verde,
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'CERRAR',
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
      ),
    );
  }

  Widget _buildCronologiaStep(Map<String, dynamic> paso, bool isLast) {
    final listo = paso['listo'] as bool;
    final color = listo ? _verde : Colors.grey[300]!;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                color: listo ? _verde : Colors.white,
                shape: BoxShape.circle,
                border: Border.all(color: color, width: 2),
              ),
              child: listo
                  ? const Icon(Icons.check, color: Colors.white, size: 10)
                  : null,
            ),
            if (!isLast) Container(width: 2, height: 34, color: color),
          ],
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  paso['label'],
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    color: listo ? Colors.black : Colors.grey,
                  ),
                ),
                Text(
                  paso['hora'],
                  style: const TextStyle(color: Colors.grey, fontSize: 11),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ── Helpers ─────────────────────────────────────────────────────────────────
  Widget _buildInfoRow(IconData icon, String titulo, String subtitulo) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Row(
        children: [
          Icon(icon, color: Colors.grey, size: 22),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                titulo,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              Text(
                subtitulo,
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

  Widget _buildDivider() => Divider(color: Colors.grey.shade100, height: 1);
}
