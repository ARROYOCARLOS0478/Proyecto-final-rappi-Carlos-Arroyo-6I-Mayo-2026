import 'package:flutter/material.dart';
import '../../modelos/comercio_modelo.dart';
import '../../servicios/firestore_servicio.dart';
import '../../core/traducciones.dart';
import '../../core/tema_app.dart';

class NegocioFormularioPantalla extends StatefulWidget {
  final Comercio? negocio;
  final String categoriaAutomatica; // Agregado para recibir la categoría

  const NegocioFormularioPantalla({
    super.key, 
    this.negocio, 
    required this.categoriaAutomatica // Requerido ahora
  });

  @override
  State<NegocioFormularioPantalla> createState() => _NegocioFormularioPantallaState();
}

class _NegocioFormularioPantallaState extends State<NegocioFormularioPantalla> {
  final _formKey = GlobalKey<FormState>();
  
  // Controllers
  final _nombreController = TextEditingController();
  final _direccionController = TextEditingController();
  final _telefonoController = TextEditingController();
  final _horarioController = TextEditingController();
  final _imagenUrlController = TextEditingController();
  
  double _calificacion = 0.0;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    if (widget.negocio != null) {
      _nombreController.text = widget.negocio!.nombre;
      _direccionController.text = widget.negocio!.direccion;
      _telefonoController.text = widget.negocio!.telefono;
      _horarioController.text = widget.negocio!.horario;
      _imagenUrlController.text = widget.negocio!.imagenUrl;
      _calificacion = widget.negocio!.calificacion;
    }
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _direccionController.dispose();
    _telefonoController.dispose();
    _horarioController.dispose();
    _imagenUrlController.dispose();
    super.dispose();
  }

  void _save() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isSaving = true);
      
      final nuevoNegocio = Comercio(
        id: widget.negocio?.id,
        nombre: _nombreController.text.trim(),
        // Se usa la categoría que viene del constructor automáticamente
        categoria: widget.categoriaAutomatica, 
        direccion: _direccionController.text.trim(),
        telefono: _telefonoController.text.trim(),
        horario: _horarioController.text.trim(),
        calificacion: _calificacion,
        imagenUrl: _imagenUrlController.text.trim().isEmpty 
            ? 'https://via.placeholder.com/150' 
            : _imagenUrlController.text.trim(),
        estaActivo: widget.negocio?.estaActivo ?? true,
        duenoId: widget.negocio?.duenoId ?? '',
        fechaRegistro: widget.negocio?.fechaRegistro ?? DateTime.now(),
        costoEnvio: widget.negocio?.costoEnvio ?? 0.0,
        tiempoEntrega: widget.negocio?.tiempoEntrega ?? '15-25 min',
      );

      try {
        await FirestoreServicio().guardarComercio(nuevoNegocio);
        if (mounted) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Datos guardados correctamente')),
          );
        }
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
        title: Text(widget.negocio == null ? 'Nuevo Negocio' : 'Editar Negocio'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Indicador visual de la categoría actual
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: TemaApp.naranjaPrincipal.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.category, color: TemaApp.naranjaPrincipal, size: 20),
                    const SizedBox(width: 10),
                    Text(
                      "CATEGORÍA: ${widget.categoriaAutomatica.toUpperCase()}",
                      style: const TextStyle(fontWeight: FontWeight.bold, color: TemaApp.naranjaPrincipal),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              _buildSectionTitle('Información General'),
              TextFormField(
                controller: _nombreController,
                decoration: const InputDecoration(
                  labelText: 'Nombre del Negocio', 
                  prefixIcon: Icon(Icons.storefront)
                ),
                validator: (value) => value!.trim().isEmpty ? 'Campo requerido' : null,
              ),
              
              const SizedBox(height: 24),
              _buildSectionTitle('Contacto y Ubicación'),
              TextFormField(
                controller: _direccionController,
                decoration: const InputDecoration(
                  labelText: 'Dirección Completa', 
                  prefixIcon: Icon(Icons.location_on)
                ),
                validator: (value) => value!.trim().isEmpty ? 'Campo requerido' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _telefonoController,
                decoration: const InputDecoration(
                  labelText: 'Teléfono de contacto', 
                  prefixIcon: Icon(Icons.phone)
                ),
                keyboardType: TextInputType.phone,
                validator: (value) => value!.trim().isEmpty ? 'Campo requerido' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _horarioController,
                decoration: const InputDecoration(
                  labelText: 'Horario (ej: 08:00 - 22:00)', 
                  prefixIcon: Icon(Icons.access_time)
                ),
                validator: (value) => value!.trim().isEmpty ? 'Campo requerido' : null,
              ),
              const SizedBox(height: 24),
              _buildSectionTitle('Apariencia'),
              TextFormField(
                controller: _imagenUrlController,
                decoration: const InputDecoration(
                  labelText: 'URL de la Imagen (Logo/Portada)', 
                  prefixIcon: Icon(Icons.image)
                ),
                keyboardType: TextInputType.url,
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Calificación inicial:', style: TextStyle(fontWeight: FontWeight.bold)),
                  Text(_calificacion.toStringAsFixed(1), style: const TextStyle(color: TemaApp.naranjaPrincipal, fontWeight: FontWeight.bold)),
                ],
              ),
              Slider(
                value: _calificacion,
                min: 0, max: 5, divisions: 50,
                activeColor: TemaApp.naranjaPrincipal,
                onChanged: (value) => setState(() => _calificacion = value),
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _isSaving ? null : _save,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  backgroundColor: TemaApp.naranjaPrincipal, // Aseguramos el color del tema
                ),
                child: _isSaving 
                    ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                    : const Text('GUARDAR NEGOCIO', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, top: 8),
      child: Text(
        title.toUpperCase(),
        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey, letterSpacing: 1.2),
      ),
    );
  }
}