import 'package:flutter/material.dart';
import '../../modelos/comercio_modelo.dart';
import '../../servicios/firestore_servicio.dart';
import '../../core/traducciones.dart';

class RestauranteFormularioPantalla extends StatefulWidget {
  final Comercio? comercio;

  const RestauranteFormularioPantalla({super.key, this.comercio});

  @override
  State<RestauranteFormularioPantalla> createState() => _RestauranteFormularioPantallaState();
}

class _RestauranteFormularioPantallaState extends State<RestauranteFormularioPantalla> {
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
    if (widget.comercio != null) {
      _nombreController.text = widget.comercio!.nombre;
      _categoriaController.text = widget.comercio!.categoria;
      _direccionController.text = widget.comercio!.direccion;
      _telefonoController.text = widget.comercio!.telefono;
      _horarioController.text = widget.comercio!.horario;
      _calificacion = widget.comercio!.calificacion;
    }
  }

  void _save() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isSaving = true);
      
      final nuevoComercio = Comercio(
        id: widget.comercio?.id,
        nombre: _nombreController.text.trim(),
        categoria: _categoriaController.text.trim(),
        direccion: _direccionController.text.trim(),
        telefono: _telefonoController.text.trim(),
        horario: _horarioController.text.trim(),
        calificacion: _calificacion,
        imagenUrl: widget.comercio?.imagenUrl ?? '',
        estaActivo: widget.comercio?.estaActivo ?? true,
        duenoId: widget.comercio?.duenoId ?? '',
        fechaRegistro: widget.comercio?.fechaRegistro,
      );

      try {
        await FirestoreServicio().guardarComercio(nuevoComercio);
        if (mounted) Navigator.pop(context);
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(Traducciones.traducirError(e))),
          );
        }
      } finally {
        if (mounted) setState(() => _isSaving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.comercio == null ? 'Nuevo Restaurante' : 'Editar Restaurante'),
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
                validator: (value) => value!.trim().isEmpty ? 'Campo requerido' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _categoriaController,
                decoration: const InputDecoration(labelText: 'Categoría (Pizza, Burger, etc.)', prefixIcon: Icon(Icons.category)),
                validator: (value) => value!.trim().isEmpty ? 'Campo requerido' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _direccionController,
                decoration: const InputDecoration(labelText: 'Dirección', prefixIcon: Icon(Icons.location_on)),
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
                controller: _horarioController,
                decoration: const InputDecoration(labelText: 'Horario', prefixIcon: Icon(Icons.access_time)),
                validator: (value) => value!.trim().isEmpty ? 'Campo requerido' : null,
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
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF00D19D),
                ),
                child: _isSaving 
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
