import 'package:flutter/material.dart';
import '../models/repartidor_model.dart';
import '../services/firestore_service.dart';
import '../utils/translations.dart';

class RepartidorFormScreen extends StatefulWidget {
  final Repartidor? repartidor;

  const RepartidorFormScreen({super.key, this.repartidor});

  @override
  State<RepartidorFormScreen> createState() => _RepartidorFormScreenState();
}

class _RepartidorFormScreenState extends State<RepartidorFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nombreController;
  late TextEditingController _emailController;
  late TextEditingController _telefonoController;
  String _vehiculo = 'Moto';
  String _estado = 'Activo';
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nombreController = TextEditingController(text: widget.repartidor?.nombre ?? '');
    _emailController = TextEditingController(text: widget.repartidor?.email ?? '');
    _telefonoController = TextEditingController(text: widget.repartidor?.telefono ?? '');
    if (widget.repartidor != null) {
      _vehiculo = widget.repartidor!.vehiculo;
      _estado = widget.repartidor!.estado;
    }
  }
  void _save() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      
      final firestoreService = FirestoreService();
      final newRepartidor = Repartidor(
        id: widget.repartidor?.id,
        nombre: _nombreController.text,
        email: _emailController.text,
        telefono: _telefonoController.text,
        vehiculo: _vehiculo,
        estado: _estado,
        fechaRegistro: widget.repartidor?.fechaRegistro,
      );

      try {
        await firestoreService.saveRepartidor(newRepartidor);
        if (mounted) {
          Navigator.pop(context);
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(TranslationUtils.translateError(e))),
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
      appBar: AppBar(title: Text(widget.repartidor == null ? 'Agregar Repartidor' : 'Editar Repartidor')),
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
                validator: (value) => value!.isEmpty ? 'Campo requerido' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Correo Electrónico', prefixIcon: Icon(Icons.email)),
                keyboardType: TextInputType.emailAddress,
                validator: (value) => value!.isEmpty ? 'Campo requerido' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _telefonoController,
                decoration: const InputDecoration(labelText: 'Teléfono', prefixIcon: Icon(Icons.phone)),
                keyboardType: TextInputType.phone,
                validator: (value) => value!.isEmpty ? 'Campo requerido' : null,
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
                onPressed: _isLoading ? null : _save,
                child: _isLoading ? const CircularProgressIndicator(color: Colors.white) : const Text('Guardar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
