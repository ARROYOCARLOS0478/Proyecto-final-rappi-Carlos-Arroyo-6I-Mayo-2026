import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../proveedores/carrito_proveedor.dart';
import '../../proveedores/autenticacion_proveedor.dart';
import '../../proveedores/pedido_proveedor.dart';
import '../seguimiento/seguimiento_pedido_pantalla.dart';

class CheckoutPantalla extends StatefulWidget {
  final double costoEnvio;
  final double total;

  const CheckoutPantalla({
    super.key,
    required this.costoEnvio,
    required this.total,
  });

  @override
  State<CheckoutPantalla> createState() => _CheckoutPantallaState();
}

class _CheckoutPantallaState extends State<CheckoutPantalla> {
  final _direccionController = TextEditingController();
  final String _metodoPago = 'Efectivo'; // Hecho final para evitar el warning
  int _opcionEnvio = 1;
  bool _procesando = false;

  final List<Map<String, dynamic>> _tiposEnvio = [
    {'titulo': 'Más rápido', 'tiempo': '14-34 MIN', 'costo': 26.99},
    {'titulo': 'Estándar', 'tiempo': '28-48 MIN', 'costo': 0.0},
    {'titulo': 'Ahorra', 'tiempo': '43-63 MIN', 'costo': -10.0},
  ];

  @override
  void initState() {
    super.initState();
    _direccionController.text = "CASA - Av. Principal 123, Col. Centro";
  }

  double get _costoEnvioFinal => _tiposEnvio[_opcionEnvio]['costo'];
  double get _totalFinal => widget.total + _costoEnvioFinal;

  Future<void> _confirmarPedido() async {
    setState(() => _procesando = true);

    final pedidoProv = Provider.of<PedidoProveedor>(context, listen: false);
    final authProv = Provider.of<AutenticacionProveedor>(
      context,
      listen: false,
    );
    final carrito = Provider.of<CarritoProveedor>(context, listen: false);

    final pedidoId = await pedidoProv.crearPedido(
      usuarioId: authProv.usuarioDatos?.uid ?? "user_temp",
      comercioId: "LITTLE_CAESARS_01",
      itemsCarrito: carrito.items,
      total: _totalFinal,
      direccion: _direccionController.text,
      metodoPago: _metodoPago,
    );

    if (pedidoId != null && mounted) {
      carrito.vaciarCarrito();
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (_) => SeguimientoPedidoPantalla(pedidoId: pedidoId),
        ),
        (route) => route.isFirst,
      );
    }
    setState(() => _procesando = false);
  }

  @override
  Widget build(BuildContext context) {
    const colorPrimario = Color(0xFF00C5AB);
    const colorAzulFondo = Color(0xFF001D3D);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'FINALIZAR PEDIDO',
          style: TextStyle(
            color: colorAzulFondo,
            fontWeight: FontWeight.w900,
            fontSize: 18,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                _buildCardInformativa(
                  "CASA",
                  _direccionController.text,
                  Icons.location_on,
                ),
                const SizedBox(height: 30),
                const Text(
                  "ENTREGA ESTIMADA",
                  style: TextStyle(fontWeight: FontWeight.w900, fontSize: 14),
                ),
                const SizedBox(height: 15),
                ...List.generate(_tiposEnvio.length, (index) {
                  final opcion = _tiposEnvio[index];
                  return _buildOptionEnvio(
                    index,
                    opcion,
                    _opcionEnvio == index,
                    colorPrimario,
                  );
                }),
                const SizedBox(height: 30),
                const Text(
                  "MÉTODO DE PAGO",
                  style: TextStyle(fontWeight: FontWeight.w900, fontSize: 14),
                ),
                const SizedBox(height: 15),
                _buildCardInformativa(
                  "Efectivo",
                  "Pagas al recibir",
                  Icons.payments_outlined,
                  trailing: const Text(
                    "Cambiar",
                    style: TextStyle(
                      color: colorPrimario,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          _buildFooter(colorPrimario, colorAzulFondo),
        ],
      ),
    );
  }

  Widget _buildFooter(Color primario, Color oscuro) {
    return Container(
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(20),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "TOTAL A PAGAR",
                style: TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
              Text(
                "\$${_totalFinal.toStringAsFixed(2)}",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                  color: oscuro,
                ),
              ),
            ],
          ),
          const SizedBox(width: 20),
          Expanded(
            child: ElevatedButton(
              onPressed: _procesando ? null : _confirmarPedido,
              style: ElevatedButton.styleFrom(
                backgroundColor: primario,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 18),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: _procesando
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : const Text(
                      "SOLICITAR",
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 16,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCardInformativa(
    String titulo,
    String subtitulo,
    IconData icono, {
    Widget? trailing,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF2F4F7),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          Icon(icono, color: const Color(0xFF001D3D)),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
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
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
          ),
          if (trailing != null) trailing,
        ],
      ),
    );
  }

  Widget _buildOptionEnvio(
    int index,
    Map<String, dynamic> opcion,
    bool selected,
    Color primario,
  ) {
    return GestureDetector(
      onTap: () => setState(() => _opcionEnvio = index),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: selected ? primario : Colors.grey.shade200,
            width: 2,
          ),
          color: selected ? primario.withAlpha(15) : Colors.white,
        ),
        child: Row(
          children: [
            Icon(
              selected ? Icons.radio_button_checked : Icons.radio_button_off,
              color: selected ? primario : Colors.grey,
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    opcion['titulo'],
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    opcion['tiempo'],
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ],
              ),
            ),
            Text(
              opcion['costo'] == 0 ? "Gratis" : "\$${opcion['costo']}",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
