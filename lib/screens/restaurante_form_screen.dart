import 'package:flutter/material.dart';
import '../models/restaurante_model.dart';
import '../services/firestore_service.dart';
import '../utils/translations.dart';

class RestauranteFormScreen extends StatefulWidget {
  final Restaurante? restaurante;

  const RestauranteFormScreen({super.key, this.restaurante});

  @override
  State<RestauranteFormScreen> createState() => _RestauranteFormScreenState();
}

class _RestauranteFormScreenState extends State<RestauranteFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();
  final _categoriaController = TextEditingController();
  final _direccionController = TextEditingController();
  final _telefonoController = TextEditingController();
  final _horarioController = TextEditingController();
  double _calificacion = 0.0;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    if (widget.restaurante != null) {
      _nombreController.text = widget.restaurante!.nombre;
      _categoriaController.text = widget.restaurante!.categoria;
      _direccionController.text = widget.restaurante!.direccion;
      _telefonoController.text = widget.restaurante!.telefono;
      _horarioController.text = widget.restaurante!.horario;
      _calificacion = widget.restaurante!.calificacion;
    }
  }

  void _save() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isSaving = true);
      
      final restaurante = Restaurante(
        id: widget.restaurante?.id,
        nombre: _nombreController.text,
        categoria: _categoriaController.text,
        direccion: _direccionController.text,
        telefono: _telefonoController.text,
        horario: _horarioController.text,
        calificacion: _calificacion,
      );

      try {
        await FirestoreService().saveRestaurante(restaurante);
        if (mounted) Navigator.pop(context);
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(TranslationUtils.translateError(e))),
          );
        }
      } finally {
        setState(() => _isSaving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.restaurante == null ? 'Nuevo Restaurante' : 'Editar Restaurante'),
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
                decoration: const InputDecoration(labelText: 'Nombre del Restaurante', prefixIcon: Icon(Icons.restaurant)),
                validator: (value) => value!.isEmpty ? 'Campo requerido' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _categoriaController,
                decoration: const InputDecoration(labelText: 'Categoría (Pizza, Burger, etc.)', prefixIcon: Icon(Icons.category)),
                validator: (value) => value!.isEmpty ? 'Campo requerido' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _direccionController,
                decoration: const InputDecoration(labelText: 'Dirección', prefixIcon: Icon(Icons.location_on)),
                validator: (value) => value!.isEmpty ? 'Campo requerido' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _telefonoController,
                decoration: const InputDecoration(labelText: 'Teléfono', prefixIcon: Icon(Icons.phone)),
                keyboardType: TextInputType.phone,
                validator: (value) => value!.isEmpty ? 'Campo requerido' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _horarioController,
                decoration: const InputDecoration(labelText: 'Horario', prefixIcon: Icon(Icons.access_time)),
                validator: (value) => value!.isEmpty ? 'Campo requerido' : null,
              ),
              const SizedBox(height: 24),
              const Text('Calificación:', style: TextStyle(fontWeight: FontWeight.bold)),
              Slider(
                value: _calificacion,
                min: 0,
                max: 5,
                divisions: 10,
                label: _calificacion.toString(),
                activeColor: const Color(0xFF00D19D),
                onChanged: (value) => setState(() => _calificacion = value),
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _isSaving ? null : _save,
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF00D19D)),
                child: _isSaving ? const CircularProgressIndicator(color: Colors.white) : const Text('Guardar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
