import 'package:flutter/material.dart';
import '../../modelos/producto_modelo.dart';
import '../../servicios/firestore_servicio.dart';
import '../../core/tema_app.dart';

class ProductoFormularioPantalla extends StatefulWidget {
  final String comercioId;
  final Producto? producto;

  const ProductoFormularioPantalla({super.key, required this.comercioId, this.producto});

  @override
  State<ProductoFormularioPantalla> createState() => _ProductoFormularioPantallaState();
}

class _ProductoFormularioPantallaState extends State<ProductoFormularioPantalla> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nombreCtrl;
  late TextEditingController _descCtrl;
  late TextEditingController _precioCtrl;
  late TextEditingController _stockCtrl;
  late TextEditingController _imgCtrl;
  String _categoriaSeleccionada = 'General';

  final List<String> _categorias = [
    'General',
    'Pizzas',
    'Bebidas',
    'Postres',
    'Hamburguesas',
    'Entradas',
    'Tacos',
    'Quesadillas',
    'Burritos',
    'Cubetas',
    'Combos',
    'Sandwiches',
    'Acompañamientos',
    'Rolls',
    'Sashimi',
    'Sopas',
    'Lácteos',
    'Frutas y Verduras',
    'Panadería',
    'Limpieza',
    'Abarrotes',
    'Carnes',
    'Medicamentos',
    'Primeros Auxilios',
    'Vitaminas',
    'Cuidado Personal',
    'Equipos',
    'Higiene Bucal',
    'Higiene',
    'Hidratación',
    'Perfumería',
    'Calzado',
    'Moda',
    'Ropa',
    'Telefonía',
    'Electrónica',
    'Audio',
    'Hogar',
    'Muebles',
    'Línea Blanca',
    'Joyería',
    'Cocina',
    'Snacks',
    'Dulces',
    'Comida Rápida',
    'Tabaco',
    'Whisky',
    'Vinos',
    'Cervezas',
    'Tequila',
    'Champagne',
    'Espumosos',
    'Ron',
    'Vodka',
    'Gin',
    'Mezcal',
    'Cognac',
    'Packs',
    'Envíos',
    'Documentos',
    'Servicios'
  ];

  @override
  void initState() {
    super.initState();
    _nombreCtrl = TextEditingController(text: widget.producto?.nombre ?? '');
    _descCtrl = TextEditingController(text: widget.producto?.descripcion ?? '');
    _precioCtrl = TextEditingController(text: widget.producto?.precio.toString() ?? '');
    _stockCtrl = TextEditingController(text: widget.producto?.stock.toString() ?? '10');
    _imgCtrl = TextEditingController(text: widget.producto?.imagenUrl ?? '');
    
    if (widget.producto != null) {
      _categoriaSeleccionada = widget.producto!.categoria;
      if (!_categorias.contains(_categoriaSeleccionada)) {
        _categorias.add(_categoriaSeleccionada);
      }
    }
  }

  Future<void> _guardar() async {
    if (!_formKey.currentState!.validate()) return;

    final nuevoProducto = Producto(
      id: widget.producto?.id,
      comercioId: widget.comercioId,
      nombre: _nombreCtrl.text.trim(),
      descripcion: _descCtrl.text.trim(),
      precio: double.parse(_precioCtrl.text),
      stock: int.parse(_stockCtrl.text),
      categoria: _categoriaSeleccionada,
      imagenUrl: _imgCtrl.text.trim(),
    );

    if (widget.producto == null) {
      await FirestoreServicio().crearProducto(nuevoProducto);
    } else {
      await FirestoreServicio().actualizarProducto(nuevoProducto);
    }

    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.producto == null ? 'Nuevo Producto' : 'Editar Producto')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            TextFormField(
              controller: _nombreCtrl,
              decoration: const InputDecoration(labelText: 'Nombre del producto'),
              validator: (v) => v!.isEmpty ? 'Requerido' : null,
            ),
            const SizedBox(height: 15),
            DropdownButtonFormField<String>(
              value: _categoriaSeleccionada,
              decoration: const InputDecoration(labelText: 'Categoría'),
              items: _categorias.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
              onChanged: (val) => setState(() => _categoriaSeleccionada = val!),
            ),
            const SizedBox(height: 15),
            TextFormField(
              controller: _precioCtrl,
              decoration: const InputDecoration(labelText: 'Precio', prefixText: '\$ '),
              keyboardType: TextInputType.number,
              validator: (v) => double.tryParse(v!) == null ? 'Precio inválido' : null,
            ),
            const SizedBox(height: 15),
            TextFormField(
              controller: _stockCtrl,
              decoration: const InputDecoration(labelText: 'Stock inicial'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 15),
            TextFormField(
              controller: _descCtrl,
              decoration: const InputDecoration(labelText: 'Descripción'),
              maxLines: 2,
            ),
            const SizedBox(height: 15),
            TextFormField(
              controller: _imgCtrl,
              decoration: const InputDecoration(labelText: 'URL de Imagen (Link)'),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: _guardar,
              style: ElevatedButton.styleFrom(
                backgroundColor: TemaApp.naranjaPrincipal,
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text('GUARDAR PRODUCTO', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}