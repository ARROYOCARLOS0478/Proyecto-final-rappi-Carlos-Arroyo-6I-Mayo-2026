import 'package:flutter/material.dart';
import 'dart:async';

class SeguimientoPedidoPantalla extends StatefulWidget {
  final String pedidoId;

  const SeguimientoPedidoPantalla({super.key, required this.pedidoId});

  @override
  State<SeguimientoPedidoPantalla> createState() =>
      _SeguimientoPedidoPantallaState();
}

class _SeguimientoPedidoPantallaState extends State<SeguimientoPedidoPantalla> {
  int _faseActual = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _iniciarFlujoEspera();
  }

  void _iniciarFlujoEspera() {
    _timer = Timer(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() => _faseActual = 1);
        _timer = Timer(const Duration(seconds: 3), () {
          if (mounted) {
            setState(() => _faseActual = 2);
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorPrimario = const Color(0xFF00C5AB);
    final colorOscuro = const Color(0xFF001D3D);
    final colorNaranja = const Color(0xFFFF4D00);

    if (_faseActual == 0) return _buildPantallaDeshacer(colorNaranja);
    if (_faseActual == 1) return _buildPantallaAprobado(colorPrimario);

    return _buildCuerpoSeguimiento(colorPrimario, colorOscuro);
  }

  Widget _buildPantallaDeshacer(Color color) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(40.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                width: 60,
                height: 60,
                child: CircularProgressIndicator(
                  color: Colors.grey,
                  strokeWidth: 3,
                ),
              ),
              const SizedBox(height: 40),
              const Text(
                "ESTAMOS CREANDO TU PEDIDO",
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18),
              ),
              const SizedBox(height: 15),
              const Text(
                "Tienes unos segundos para cancelar sin costo.",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 50),
              ElevatedButton(
                onPressed: () {
                  _timer?.cancel();
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: color,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 15,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                child: const Text(
                  "DESHACER",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPantallaAprobado(Color color) {
    return Scaffold(
      backgroundColor: color,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.check_circle_outline,
              size: 100,
              color: Colors.white,
            ),
            const SizedBox(height: 30),
            const Text(
              "¡PEDIDO APROBADO!",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w900,
                fontSize: 22,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "ID: ${widget.pedidoId}",
              style: const TextStyle(color: Colors.white70),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCuerpoSeguimiento(Color colorPrimario, Color colorOscuro) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            color: Colors.grey[200],
            child: const Center(
              child: Icon(Icons.map, size: 80, color: Colors.grey),
            ),
          ),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(20),
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            "LLEGADA ESTIMADA",
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "15 - 25 min",
                            style: TextStyle(
                              color: colorOscuro,
                              fontSize: 24,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(Icons.directions_bike, color: colorPrimario, size: 30),
                  ],
                ),
              ),
            ),
          ),

          DraggableScrollableSheet(
            initialChildSize: 0.4,
            minChildSize: 0.2,
            maxChildSize: 0.8,
            builder: (context, scrollController) {
              return Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(30),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(20),
                      blurRadius: 15,
                    ),
                  ],
                ),
                child: ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.all(30),
                  children: [
                    const Text(
                      "ESTADO DEL PEDIDO",
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 25),
                    _buildStep(
                      colorPrimario,
                      "Pedido recibido",
                      "Procesado correctamente",
                      true,
                    ),
                    _buildStep(
                      colorPrimario,
                      "En preparación",
                      "Little Caesars está cocinando",
                      true,
                    ),
                    _buildStep(
                      Colors.grey[300]!,
                      "En camino",
                      "El repartidor va hacia ti",
                      false,
                    ),
                    _buildStep(
                      Colors.grey[300]!,
                      "Entregado",
                      "¡Que lo disfrutes!",
                      false,
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildStep(
    Color color,
    String titulo,
    String subtitulo,
    bool completado,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 14,
              height: 14,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            ),
            Container(width: 2, height: 35, color: Colors.grey[100]),
          ],
        ),
        const SizedBox(width: 20),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              titulo,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: completado ? Colors.black : Colors.grey,
              ),
            ),
            Text(
              subtitulo,
              style: const TextStyle(color: Colors.grey, fontSize: 11),
            ),
          ],
        ),
      ],
    );
  }
}
