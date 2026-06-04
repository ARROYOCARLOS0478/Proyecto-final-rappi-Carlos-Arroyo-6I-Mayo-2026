import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constantes.dart';
import '../../proveedores/carrito_proveedor.dart';
import '../../proveedores/autenticacion_proveedor.dart';
import '../../proveedores/pedido_proveedor.dart';
import '../seguimiento/seguimiento_pedido_pantalla.dart';

class CheckoutPantalla extends StatefulWidget {
  final double costoEnvio;
  final double total;
  final int descuentoNegocio;

  const CheckoutPantalla({
    super.key,
    required this.costoEnvio,
    required this.total,
    this.descuentoNegocio = 0,
  });

  @override
  State<CheckoutPantalla> createState() => _CheckoutPantallaState();
}

class _CheckoutPantallaState extends State<CheckoutPantalla> {
  static const Color _verde = Color(0xFF00C5AB);
  static const Color _azulOscuro = Color(0xFF001D3D);

  int _opcionEnvio = 1; // 0=Más rápido, 1=Estándar, 2=Ahorra
  bool _procesando = false;
  bool _resumenExpandido = false;

  // Método de pago: 'efectivo' | 'tarjeta'
  String _metodoPago = 'efectivo';
  // Datos de tarjeta (opcionales)
  String? _numeroTarjeta;
  String? _nombreTarjeta;
  String? _vencimiento;

  final List<Map<String, dynamic>> _tiposEnvio = [
    {'titulo': 'Más rápido', 'tiempo': '14-34 MIN', 'costo': 26.99},
    {'titulo': 'Estándar', 'tiempo': '28-48 MIN', 'costo': 0.0},
    {'titulo': 'Ahorra', 'tiempo': '43-63 MIN', 'costo': -9.90},
  ];

  double get _costoEnvioFinal => _tiposEnvio[_opcionEnvio]['costo'];
  double get _subtotalConDescuento =>
      widget.total * (1 - widget.descuentoNegocio / 100);
  double get _montoDescuento => widget.total - _subtotalConDescuento;
  double get _totalFinal => _subtotalConDescuento + _costoEnvioFinal;

  Future<void> _confirmarPedido() async {
    setState(() => _procesando = true);

    final pedidoProv = Provider.of<PedidoProveedor>(context, listen: false);
    final authProv = Provider.of<AutenticacionProveedor>(
      context,
      listen: false,
    );
    final carrito = Provider.of<CarritoProveedor>(context, listen: false);
    final auth = Provider.of<AutenticacionProveedor>(context, listen: false);

    final direccion = auth.usuarioDatos?.direcciones.isNotEmpty == true
        ? auth.usuarioDatos!.direcciones.first
        : 'Sin dirección';

    final comercioId = carrito.items.values.first['comercioId'] as String;
    final comercioSnap = await FirebaseFirestore.instance
        .collection(Constantes.coleccionComercios)
        .doc(comercioId)
        .get();
    final comercioNombre =
        comercioSnap.data()?['nombre'] as String? ?? 'Negocio';

    final pedidoId = await pedidoProv.crearPedido(
      usuarioId: authProv.usuarioDatos?.uid ?? "user_temp",
      comercioId: comercioId,
      comercioNombre: comercioNombre,
      itemsCarrito: carrito.items,
      total: _totalFinal,
      direccion: direccion,
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
    if (mounted) setState(() => _procesando = false);
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AutenticacionProveedor>(context);
    final carrito = Provider.of<CarritoProveedor>(context);
    final direccion = auth.usuarioDatos?.direcciones.isNotEmpty == true
        ? auth.usuarioDatos!.direcciones.first
        : 'Sin dirección registrada';

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
            color: _azulOscuro,
            fontWeight: FontWeight.w900,
            fontSize: 17,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                // ── Dirección ─────────────────────────────────────────────
                _buildSectionTitle("DIRECCIÓN DE ENTREGA"),
                const SizedBox(height: 10),
                _buildInfoCard(
                  icon: Icons.location_on_outlined,
                  title: "CASA",
                  subtitle: direccion.toUpperCase(),
                ),

                const SizedBox(height: 24),

                // ── Entrega estimada ──────────────────────────────────────
                Row(
                  children: [
                    _buildSectionTitle("ENTREGA ESTIMADA"),
                    const SizedBox(width: 6),
                    const Icon(
                      Icons.info_outline,
                      size: 14,
                      color: Colors.grey,
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                ..._tiposEnvio.asMap().entries.map((e) {
                  return _buildOpcionEnvio(e.key, e.value);
                }),

                const SizedBox(height: 24),

                // ── Método de pago ────────────────────────────────────────
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildSectionTitle("MÉTODO DE PAGO"),
                    GestureDetector(
                      onTap: _mostrarSelectorPago,
                      child: const Text(
                        "CAMBIAR",
                        style: TextStyle(
                          color: _verde,
                          fontWeight: FontWeight.w900,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _buildMetodoPagoCard(),

                const SizedBox(height: 24),

                // ── Resumen del pedido ────────────────────────────────────
                GestureDetector(
                  onTap: () =>
                      setState(() => _resumenExpandido = !_resumenExpandido),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _buildSectionTitle("RESUMEN DEL PEDIDO"),
                            Row(
                              children: [
                                Text(
                                  '${carrito.cantidadTotal} producto${carrito.cantidadTotal != 1 ? 's' : ''}',
                                  style: const TextStyle(
                                    color: Colors.grey,
                                    fontSize: 12,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Icon(
                                  _resumenExpandido
                                      ? Icons.keyboard_arrow_up
                                      : Icons.keyboard_arrow_down,
                                  color: Colors.grey,
                                ),
                              ],
                            ),
                          ],
                        ),
                        if (_resumenExpandido) ...[
                          const SizedBox(height: 12),
                          const Divider(height: 1),
                          const SizedBox(height: 12),
                          ...carrito.items.entries.map((entry) {
                            final productoId = entry.key; // El ID o nombre
                            final datos = entry
                                .value; // El Map con cantidad, precio, etc.

                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 8.0,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFF00C5AB),
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                        child: Text(
                                          "${datos['cantidad']}x", // Acceso correcto al Map
                                          style: const TextStyle(
                                            color: Color(0xFF00C5AB),
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Text(
                                        datos['nombre'] ??
                                            productoId, // Usa el nombre del producto
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    "\$${(datos['precio'] * datos['cantidad']).toStringAsFixed(2)}",
                                    style: const TextStyle(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }),
                          const Divider(height: 1),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Subtotal',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 12,
                                ),
                              ),
                              Text(
                                '\$${widget.total.toStringAsFixed(2)}',
                                style: const TextStyle(fontSize: 12),
                              ),
                            ],
                          ),
                          if (widget.descuentoNegocio > 0) ...[
                            const SizedBox(height: 4),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Descuento ${widget.descuentoNegocio}%',
                                  style: const TextStyle(
                                    color: Colors.green,
                                    fontSize: 12,
                                  ),
                                ),
                                Text(
                                  '-\$${_montoDescuento.toStringAsFixed(2)}',
                                  style: const TextStyle(
                                    color: Colors.green,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ],
                          const SizedBox(height: 4),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Envío',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 12,
                                ),
                              ),
                              Text(
                                _costoEnvioFinal == 0
                                    ? 'Gratis'
                                    : _costoEnvioFinal < 0
                                    ? '-\$${_costoEnvioFinal.abs().toStringAsFixed(2)}'
                                    : '+\$${_costoEnvioFinal.toStringAsFixed(2)}',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: _costoEnvioFinal < 0
                                      ? Colors.green
                                      : Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),

          // ── Footer con total y botón ───────────────────────────────────
          _buildFooter(),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontWeight: FontWeight.w900,
        fontSize: 13,
        letterSpacing: 0.5,
      ),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required String subtitle,
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
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Icon(icon, color: const Color(0xFF001D3D), size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOpcionEnvio(int index, Map<String, dynamic> opcion) {
    final selected = _opcionEnvio == index;
    final costo = opcion['costo'] as double;
    final costoTexto = costo == 0.0
        ? 'Gratis'
        : costo < 0
        ? '-\$${costo.abs().toStringAsFixed(2)}'
        : '+\$${costo.toStringAsFixed(2)}';

    return GestureDetector(
      onTap: () => setState(() => _opcionEnvio = index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: selected ? _verde : Colors.grey.shade200,
            width: selected ? 2 : 1,
          ),
          color: selected ? _verde.withAlpha(12) : Colors.white,
        ),
        child: Row(
          children: [
            Icon(
              selected ? Icons.radio_button_checked : Icons.radio_button_off,
              color: selected ? _verde : Colors.grey,
              size: 20,
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    opcion['titulo'],
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: selected ? Colors.black : Colors.grey[700],
                    ),
                  ),
                  Text(
                    opcion['tiempo'],
                    style: const TextStyle(color: Colors.grey, fontSize: 11),
                  ),
                ],
              ),
            ),
            Text(
              costoTexto,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: costo < 0 ? Colors.green : Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetodoPagoCard() {
    if (_metodoPago == 'efectivo') {
      return _buildInfoCard(
        icon: Icons.payments_outlined,
        title: 'Efectivo',
        subtitle: 'Pagas al recibir',
      );
    } else {
      return _buildInfoCard(
        icon: Icons.credit_card,
        title: _numeroTarjeta != null
            ? 'Tarjeta •••• ${_numeroTarjeta!.replaceAll(' ', '').substring(_numeroTarjeta!.replaceAll(' ', '').length - 4)}'
            : 'Tarjeta',
        subtitle: _nombreTarjeta ?? 'Titular',
      );
    }
  }

  void _mostrarSelectorPago() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => _PagoBottomSheet(
        metodoPagoActual: _metodoPago,
        onEfectivo: () {
          setState(() {
            _metodoPago = 'efectivo';
            _numeroTarjeta = null;
            _nombreTarjeta = null;
            _vencimiento = null;
          });
          Navigator.pop(context);
        },
        onTarjeta: (numero, nombre, vencimiento) {
          setState(() {
            _metodoPago = 'tarjeta';
            _numeroTarjeta = numero;
            _nombreTarjeta = nombre;
            _vencimiento = vencimiento;
          });
          Navigator.pop(context);
        },
      ),
    );
  }

  Widget _buildFooter() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(15),
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
                "TOTAL FINAL",
                style: TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                  fontSize: 11,
                ),
              ),
              Text(
                "\$${_totalFinal.toStringAsFixed(2)}",
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                  color: _azulOscuro,
                ),
              ),
            ],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: ElevatedButton(
              onPressed: _procesando ? null : _confirmarPedido,
              style: ElevatedButton.styleFrom(
                backgroundColor: _verde,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 18),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
                elevation: 0,
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
                      "CONTINUAR",
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
}

// ── Bottom Sheet para elegir método de pago ───────────────────────────────────
class _PagoBottomSheet extends StatefulWidget {
  final String metodoPagoActual;
  final VoidCallback onEfectivo;
  final void Function(String numero, String nombre, String vencimiento)
  onTarjeta;

  const _PagoBottomSheet({
    required this.metodoPagoActual,
    required this.onEfectivo,
    required this.onTarjeta,
  });

  @override
  State<_PagoBottomSheet> createState() => _PagoBottomSheetState();
}

class _PagoBottomSheetState extends State<_PagoBottomSheet> {
  static const Color _verde = Color(0xFF00C5AB);
  bool _mostrandoFormTarjeta = false;

  final _numeroCtrl = TextEditingController();
  final _nombreCtrl = TextEditingController();
  final _vencCtrl = TextEditingController();
  final _cvvCtrl = TextEditingController();

  @override
  void dispose() {
    _numeroCtrl.dispose();
    _nombreCtrl.dispose();
    _vencCtrl.dispose();
    _cvvCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 30,
      ),
      child: _mostrandoFormTarjeta ? _buildFormTarjeta() : _buildOpciones(),
    );
  }

  Widget _buildOpciones() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "MÉTODO DE PAGO",
          style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16),
        ),
        const SizedBox(height: 20),
        // Efectivo
        _buildOpcionPago(
          icon: Icons.payments_outlined,
          titulo: 'Efectivo',
          subtitulo: 'Pagas al recibir',
          seleccionado: widget.metodoPagoActual == 'efectivo',
          onTap: widget.onEfectivo,
        ),
        const SizedBox(height: 12),
        // Tarjeta
        _buildOpcionPago(
          icon: Icons.credit_card,
          titulo: 'Tarjeta de crédito/débito',
          subtitulo: 'Agrega una tarjeta',
          seleccionado: widget.metodoPagoActual == 'tarjeta',
          onTap: () => setState(() => _mostrandoFormTarjeta = true),
        ),
        const SizedBox(height: 8),
      ],
    );
  }

  Widget _buildOpcionPago({
    required IconData icon,
    required String titulo,
    required String subtitulo,
    required bool seleccionado,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: seleccionado ? _verde : Colors.grey.shade200,
            width: seleccionado ? 2 : 1,
          ),
          color: seleccionado ? _verde.withAlpha(12) : Colors.white,
        ),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: Colors.black87, size: 22),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    titulo,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    subtitulo,
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ],
              ),
            ),
            Icon(
              seleccionado ? Icons.check_circle : Icons.chevron_right,
              color: seleccionado ? _verde : Colors.grey,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFormTarjeta() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            GestureDetector(
              onTap: () => setState(() => _mostrandoFormTarjeta = false),
              child: const Icon(Icons.arrow_back),
            ),
            const SizedBox(width: 12),
            const Text(
              "AGREGAR TARJETA",
              style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16),
            ),
          ],
        ),
        const SizedBox(height: 20),
        _buildCampo(
          "Número de tarjeta",
          _numeroCtrl,
          hint: "1234 5678 9012 3456",
          keyboard: TextInputType.number,
        ),
        const SizedBox(height: 12),
        _buildCampo(
          "Nombre del titular",
          _nombreCtrl,
          hint: "Como aparece en la tarjeta",
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildCampo("Vencimiento", _vencCtrl, hint: "MM/AA"),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildCampo(
                "CVV",
                _cvvCtrl,
                hint: "•••",
                keyboard: TextInputType.number,
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              if (_numeroCtrl.text.isNotEmpty && _nombreCtrl.text.isNotEmpty) {
                widget.onTarjeta(
                  _numeroCtrl.text,
                  _nombreCtrl.text,
                  _vencCtrl.text,
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: _verde,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 0,
            ),
            child: const Text(
              "AGREGAR TARJETA",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCampo(
    String label,
    TextEditingController controller, {
    String? hint,
    TextInputType keyboard = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.bold,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          keyboardType: keyboard,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: Colors.grey),
            filled: true,
            fillColor: Colors.grey[50],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade200),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade200),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: _verde, width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 14,
            ),
          ),
        ),
      ],
    );
  }
}
