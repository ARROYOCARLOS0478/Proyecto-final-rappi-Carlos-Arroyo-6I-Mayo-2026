import 'package:flutter/material.dart';
import '../../modelos/repartidor_modelo.dart';
import '../../servicios/firestore_servicio.dart';
import '../../core/traducciones.dart';

class RepartidorFormularioPantalla extends StatefulWidget {
  final Repartidor? repartidor;

  const RepartidorFormularioPantalla({super.key, this.repartidor});

  @override
  State<RepartidorFormularioPantalla> createState() => _RepartidorFormularioPantallaState();
}

class _RepartidorFormularioPantallaState extends State<RepartidorFormularioPantalla> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nombreController;
  late TextEditingController _emailController;
  late TextEditingController _telefonoController;
  late TextEditingController _fotoUrlController;
  String _vehiculo = 'Moto';
  String _estado = 'Activo';
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nombreController = TextEditingController(text: widget.repartidor?.nombre ?? '');
    _emailController = TextEditingController(text: widget.repartidor?.email ?? '');
    _telefonoController = TextEditingController(text: widget.repartidor?.telefono ?? '');
    _fotoUrlController = TextEditingController(text: widget.repartidor?.fotoUrl ?? '');
    if (widget.repartidor != null) {
      _vehiculo = widget.repartidor!.vehiculo;
      _estado = widget.repartidor!.estado;
    }
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _emailController.dispose();
    _telefonoController.dispose();
    _fotoUrlController.dispose();
    super.dispose();
  }

  void _guardar() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      
      final firestoreServicio = FirestoreServicio();
      final nuevoRepartidor = Repartidor(
        id: widget.repartidor?.id,
        nombre: _nombreController.text.trim(),
        email: _emailController.text.trim(),
        telefono: _telefonoController.text.trim(),
        vehiculo: _vehiculo,
        estado: _estado,
        fechaRegistro: widget.repartidor?.fechaRegistro,
        fotoUrl: _fotoUrlController.text.trim().isEmpty ? null : _fotoUrlController.text.trim(),
      );

      try {
        await firestoreServicio.guardarRepartidor(nuevoRepartidor);
        if (mounted) {
          Navigator.pop(context);
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(Traducciones.traducirError(e))),
          );
        }
      } finally {
        if (mounted) setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.repartidor == null ? 'Agregar Repartidor' : 'Editar Repartidor'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _nombreController,
                decoration: const InputDecoration(labelText: 'Nombre Completo', prefixIcon: Icon(Icons.person)),
                validator: (value) => value!.trim().isEmpty ? 'Campo requerido' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Correo Electrónico', prefixIcon: Icon(Icons.email)),
                keyboardType: TextInputType.emailAddress,
                validator: (value) => value!.trim().isEmpty ? 'Campo requerido' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _telefonoController,
                decoration: const InputDecoration(labelText: 'Teléfono', prefixIcon: Icon(Icons.phone)),
                keyboardType: TextInputType.phone,
                validator: (value) => value!.trim().isEmpty ? 'Campo requerido' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _fotoUrlController,
                decoration: const InputDecoration(labelText: 'Foto de perfil (URL)', prefixIcon: Icon(Icons.image_outlined)),
                keyboardType: TextInputType.url,
              ),
              const SizedBox(height: 24),
              const Text('Vehículo', style: TextStyle(fontWeight: FontWeight.bold)),
              Row(
                children: [
                  Expanded(
                    child: RadioListTile<String>(
                      title: const Text('Moto'),
                      value: 'Moto',
                      groupValue: _vehiculo,
                      onChanged: (val) => setState(() => _vehiculo = val!),
                    ),
                  ),
                  Expanded(
                    child: RadioListTile<String>(
                      title: const Text('Bici'),
                      value: 'Bici',
                      groupValue: _vehiculo,
                      onChanged: (val) => setState(() => _vehiculo = val!),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Text('Estado', style: TextStyle(fontWeight: FontWeight.bold)),
              DropdownButtonFormField<String>(
                value: _estado,
                items: ['Activo', 'Inactivo'].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                onChanged: (val) => setState(() => _estado = val!),
                decoration: const InputDecoration(prefixIcon: Icon(Icons.info_outline)),
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: _isLoading ? null : _guardar,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF6C00), // Rappi Orange
                ),
                child: _isLoading 
                    ? const CircularProgressIndicator(color: Colors.white) 
                    : const Text('Guardar', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
