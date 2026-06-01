import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../proveedores/autenticacion_proveedor.dart';
import '../home/home_pantalla.dart';

class SetupDireccionPantalla extends StatefulWidget {
  final Map<String, String> datosRegistro; // Recibimos nombre, email, etc.

  const SetupDireccionPantalla({super.key, required this.datosRegistro});

  @override
  State<SetupDireccionPantalla> createState() => _SetupDireccionPantallaState();
}

class _SetupDireccionPantallaState extends State<SetupDireccionPantalla> {
  final _calleController = TextEditingController();
  final _numeroController = TextEditingController();
  final _coloniaController = TextEditingController();
  final _colorController = TextEditingController();
  final _recibeController = TextEditingController();
  String _tipoEdificio = "Casa";

  void _finalizarRegistro() async {
    if (_calleController.text.isEmpty || _coloniaController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, indica al menos calle y colonia'),
        ),
      );
      return;
    }

    final authProv = Provider.of<AutenticacionProveedor>(
      context,
      listen: false,
    );

    // Creamos el mapa de dirección
    Map<String, dynamic> direccionFinal = {
      'calle': _calleController.text.trim(),
      'numero': _numeroController.text.trim(),
      'colonia': _coloniaController.text.trim(),
      'tipoEdificio': _tipoEdificio,
      'colorFachada': _colorController.text.trim(),
      'quienRecibe': _recibeController.text.trim(),
    };

    // Llamamos al registro con los datos de AMBAS pantallas
    final exito = await authProv.registro(
      widget.datosRegistro['email']!,
      widget.datosRegistro['password']!,
      widget.datosRegistro['nombre']!,
      widget.datosRegistro['telefono']!,
      direccion: direccionFinal, // Aquí pasamos el nuevo mapa
    );

    if (exito) {
      if (mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const HomePantalla()),
          (route) => false,
        );
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(authProv.error ?? 'Error al guardar')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProv = Provider.of<AutenticacionProveedor>(context);

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
          'Detalles de entrega',
          style: TextStyle(color: Colors.black, fontSize: 16),
        ),
      ),
      body: authProv.estaCargando
          ? const Center(
              child: CircularProgressIndicator(color: Color(0xFF00CC99)),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  // Icono decorativo (Material Icon en lugar de Lucide)
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF00CC99).withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.location_on,
                      size: 40,
                      color: Color(0xFF00CC99),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    '¿A dónde llegamos?',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900),
                  ),
                  const Text(
                    'Completa la información para tu repartidor',
                    style: TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 32),

                  // Campo Calle
                  _buildField("CALLE", _calleController, "Ej. Av. De la Raza"),
                  const SizedBox(height: 16),

                  // Fila Número y Colonia
                  Row(
                    children: [
                      Expanded(
                        child: _buildField(
                          "NÚMERO",
                          _numeroController,
                          "Ej. 1234",
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildField(
                          "COLONIA",
                          _coloniaController,
                          "Ej. Centro",
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Selector Tipo de Edificio
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "TIPO DE EDIFICIO",
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          color: Colors.grey[50],
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey[200]!),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: _tipoEdificio,
                            isExpanded: true,
                            items:
                                ["Casa", "Departamento", "Oficina", "Privada"]
                                    .map(
                                      (e) => DropdownMenuItem(
                                        value: e,
                                        child: Text(e),
                                      ),
                                    )
                                    .toList(),
                            onChanged: (val) =>
                                setState(() => _tipoEdificio = val!),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  _buildField(
                    "COLOR DE FACHADA",
                    _colorController,
                    "Ej. Portón negro",
                    icon: Icons.palette_outlined,
                  ),
                  const SizedBox(height: 16),
                  _buildField(
                    "¿QUIÉN RECIBE?",
                    _recibeController,
                    "Nombre de la persona",
                    icon: Icons.person_outline,
                  ),

                  const SizedBox(height: 40),

                  // Botón Final
                  ElevatedButton(
                    onPressed: _finalizarRegistro,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF00CC99),
                      minimumSize: const Size(double.infinity, 55),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      elevation: 5,
                      shadowColor: const Color(0xFF00CC99),
                    ),
                    child: const Text(
                      'Guardar y continuar',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
    );
  }

  // Widget auxiliar para los inputs (más limpio)
  Widget _buildField(
    String label,
    TextEditingController controller,
    String hint, {
    IconData? icon,
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
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: icon != null
                ? Icon(icon, size: 20, color: Colors.grey)
                : null,
            filled: true,
            fillColor: Colors.grey[50],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[200]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[200]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF00CC99)),
            ),
          ),
        ),
      ],
    );
  }
}
