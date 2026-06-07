import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../proveedores/autenticacion_proveedor.dart';

class GestionDireccionesPantalla extends StatefulWidget {
  const GestionDireccionesPantalla({super.key});

  @override
  State<GestionDireccionesPantalla> createState() => _GestionDireccionesPantallaState();
}

class _GestionDireccionesPantallaState extends State<GestionDireccionesPantalla> {
  final TextEditingController _direccionController = TextEditingController();

  void _agregarDireccion(AutenticacionProveedor authProv) async {
    if (_direccionController.text.isEmpty) return;

    List<String> nuevasDirecciones = List.from(authProv.usuarioDatos?.direcciones ?? []);
    nuevasDirecciones.add(_direccionController.text.trim());

    try {
      await authProv.actualizarDatosUsuario({'direcciones': nuevasDirecciones});
      _direccionController.clear();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Dirección agregada con éxito')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al guardar: $e')),
        );
      }
    }
  }

  void _eliminarDireccion(AutenticacionProveedor authProv, int index) async {
    List<String> nuevasDirecciones = List.from(authProv.usuarioDatos?.direcciones ?? []);
    nuevasDirecciones.removeAt(index);

    await authProv.actualizarDatosUsuario({'direcciones': nuevasDirecciones});
  }

  @override
  Widget build(BuildContext context) {
    final authProv = Provider.of<AutenticacionProveedor>(context);
    final direcciones = authProv.usuarioDatos?.direcciones ?? [];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('MIS DIRECCIONES', 
          style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16, letterSpacing: 1.2)),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        scrolledUnderElevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        iconTheme: const IconThemeData(color: Colors.black),
        actionsIconTheme: const IconThemeData(color: Colors.black),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          // Input para nueva dirección
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _direccionController,
                    decoration: InputDecoration(
                      hintText: 'Nueva dirección (Ej. Calle 123...)',
                      filled: true,
                      fillColor: Colors.grey[50],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                IconButton(
                  onPressed: () => _agregarDireccion(authProv),
                  icon: const Icon(Icons.add_circle, color: Color(0xFFFF441F), size: 40),
                )
              ],
            ),
          ),
          
          const Divider(),

          // Lista de direcciones
          Expanded(
            child: direcciones.isEmpty
                ? const Center(child: Text('No tienes direcciones registradas'))
                : ListView.builder(
                    itemCount: direcciones.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: const Icon(Icons.location_on, color: Color(0xFFFF441F)),
                        title: Text(direcciones[index]),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete_outline, color: Colors.grey),
                          onPressed: () => _eliminarDireccion(authProv, index),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}