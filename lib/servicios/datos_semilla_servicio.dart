import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../core/constantes.dart';

class DatosSemillaServicio {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// Insertar comercios y productos de ejemplo si Firestore está vacío
  Future<void> sembrarDatos() async {
    try {
      final snap =
          await _db.collection(Constantes.coleccionComercios).limit(1).get();
      if (snap.docs.isNotEmpty) {
        debugPrint('✅ Ya existen datos en Firestore. No se siembra.');
        return;
      }
      await _sembrarTodo();
    } catch (e) {
      debugPrint('❌ Error al sembrar datos: $e');
      rethrow;
    }
  }

  /// Forzar siembra aunque ya existan datos (útil para admin)
  Future<void> sembrarDatosForzado() async {
    await _sembrarTodo();
  }

  Future<void> _sembrarTodo() async {
    debugPrint('🌱 Sembrando datos iniciales en Firestore...');

    // =======================
    // CATEGORÍA: Restaurantes
    // =======================
    final restaurantes = [
        {
          'nombre': "McDonald's",
          'categoria': 'Restaurantes',
          'direccion': 'Av. Tecnológico 1234, Col. Centro',
          'telefono': '656-100-1234',
          'horario': '07:00 - 23:00',
          'calificacion': 4.5,
          'imagenUrl':
              'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=400&q=80',
          'estaActivo': true,
          'duenoId': '',
          'tiempoEntrega': '20-30 min',
          'costoEnvio': 15.0,
          'descuentoNegocio': 20,
          'fechaRegistro': FieldValue.serverTimestamp(),
        },
        {
          'nombre': 'Pizza Hut',
          'categoria': 'Restaurantes',
          'direccion': 'Calle 16 de Septiembre 456',
          'telefono': '656-100-5678',
          'horario': '10:00 - 24:00',
          'calificacion': 4.3,
          'imagenUrl':
              'https://images.unsplash.com/photo-1565299624946-b28f40a0ae38?w=400&q=80',
          'estaActivo': true,
          'duenoId': '',
          'tiempoEntrega': '30-45 min',
          'costoEnvio': 20.0,
          'descuentoNegocio': 0,
          'fechaRegistro': FieldValue.serverTimestamp(),
        },
        {
          'nombre': 'Tacos El Paisa',
          'categoria': 'Restaurantes',
          'direccion': 'Mercado Morelos, Local 12',
          'telefono': '656-100-3456',
          'horario': '09:00 - 21:00',
          'calificacion': 4.8,
          'imagenUrl':
              'https://images.unsplash.com/photo-1565299585323-38d6b0865b47?w=400&q=80',
          'estaActivo': true,
          'duenoId': '',
          'tiempoEntrega': '15-25 min',
          'costoEnvio': 10.0,
          'descuentoNegocio': 15,
          'fechaRegistro': FieldValue.serverTimestamp(),
        },
        {
          'nombre': 'KFC',
          'categoria': 'Restaurantes',
          'direccion': 'Plaza Las Américas, Local 5',
          'telefono': '656-100-7890',
          'horario': '10:00 - 23:00',
          'calificacion': 4.2,
          'imagenUrl':
              'https://images.unsplash.com/photo-1626645738196-c2a7c87a8f58?w=400&q=80',
          'estaActivo': true,
          'duenoId': '',
          'tiempoEntrega': '20-35 min',
          'costoEnvio': 18.0,
          'descuentoNegocio': 0,
          'fechaRegistro': FieldValue.serverTimestamp(),
        },
        {
          'nombre': 'Sushi Roll',
          'categoria': 'Restaurantes',
          'direccion': 'Blvd. Revolución 789',
          'telefono': '656-100-9012',
          'horario': '12:00 - 22:00',
          'calificacion': 4.7,
          'imagenUrl':
              'https://images.unsplash.com/photo-1579871494447-9811cf80d66c?w=400&q=80',
          'estaActivo': true,
          'duenoId': '',
          'tiempoEntrega': '25-40 min',
          'costoEnvio': 25.0,
          'descuentoNegocio': 10,
          'fechaRegistro': FieldValue.serverTimestamp(),
        },
      ];

      // =======================
      // CATEGORÍA: Supermercado
      // =======================
      final supermercados = [
        {
          'nombre': 'Walmart Express',
          'categoria': 'Supermercado',
          'direccion': 'Av. de las Torres 1000',
          'telefono': '656-200-1111',
          'horario': '07:00 - 23:00',
          'calificacion': 4.1,
          'imagenUrl':
              'https://images.unsplash.com/photo-1542838132-92c53300491e?w=400&q=80',
          'estaActivo': true,
          'duenoId': '',
          'tiempoEntrega': '30-50 min',
          'costoEnvio': 30.0,
          'descuentoNegocio': 5,
          'fechaRegistro': FieldValue.serverTimestamp(),
        },
        {
          'nombre': 'Chedraui',
          'categoria': 'Supermercado',
          'direccion': 'Blvd. Independencia 500',
          'telefono': '656-200-2222',
          'horario': '08:00 - 22:00',
          'calificacion': 4.0,
          'imagenUrl':
              'https://images.unsplash.com/photo-1578916171728-46686eac8d58?w=400&q=80',
          'estaActivo': true,
          'duenoId': '',
          'tiempoEntrega': '35-55 min',
          'costoEnvio': 28.0,
          'descuentoNegocio': 0,
          'fechaRegistro': FieldValue.serverTimestamp(),
        },
        {
          'nombre': 'La Comer',
          'categoria': 'Supermercado',
          'direccion': 'Av. Ejercito Nacional 300',
          'telefono': '656-200-3333',
          'horario': '08:00 - 22:00',
          'calificacion': 4.3,
          'imagenUrl':
              'https://images.unsplash.com/photo-1604719312566-8912e9227c6a?w=400&q=80',
          'estaActivo': true,
          'duenoId': '',
          'tiempoEntrega': '40-60 min',
          'costoEnvio': 25.0,
          'descuentoNegocio': 0,
          'fechaRegistro': FieldValue.serverTimestamp(),
        },
        {
          'nombre': 'Soriana',
          'categoria': 'Supermercado',
          'direccion': 'Paseo de la Victoria 200',
          'telefono': '656-200-4444',
          'horario': '07:00 - 23:00',
          'calificacion': 4.2,
          'imagenUrl':
              'https://images.unsplash.com/photo-1588964895597-cfccd6e2dbf9?w=400&q=80',
          'estaActivo': true,
          'duenoId': '',
          'tiempoEntrega': '30-50 min',
          'costoEnvio': 22.0,
          'descuentoNegocio': 12,
          'fechaRegistro': FieldValue.serverTimestamp(),
        },
      ];

      // =======================
      // CATEGORÍA: Farmacia
      // =======================
      final farmacias = [
        {
          'nombre': 'Farmacias del Ahorro',
          'categoria': 'Farmacia',
          'direccion': 'Av. Juárez 123, Col. Centro',
          'telefono': '656-300-1111',
          'horario': '08:00 - 22:00',
          'calificacion': 4.4,
          'imagenUrl':
              'https://images.unsplash.com/photo-1584308666744-24d5c474f2ae?w=400&q=80',
          'estaActivo': true,
          'duenoId': '',
          'tiempoEntrega': '15-25 min',
          'costoEnvio': 12.0,
          'descuentoNegocio': 15,
          'fechaRegistro': FieldValue.serverTimestamp(),
        },
        {
          'nombre': 'Farmacia Guadalajara',
          'categoria': 'Farmacia',
          'direccion': 'Blvd. Zaragoza 450',
          'telefono': '656-300-2222',
          'horario': '24 horas',
          'calificacion': 4.6,
          'imagenUrl':
              'https://images.unsplash.com/photo-1563213126-a4273aed2016?w=400&q=80',
          'estaActivo': true,
          'duenoId': '',
          'tiempoEntrega': '20-30 min',
          'costoEnvio': 10.0,
          'descuentoNegocio': 0,
          'fechaRegistro': FieldValue.serverTimestamp(),
        },
        {
          'nombre': 'Benavides',
          'categoria': 'Farmacia',
          'direccion': 'Calle Vicente Guerrero 88',
          'telefono': '656-300-3333',
          'horario': '09:00 - 21:00',
          'calificacion': 4.1,
          'imagenUrl':
              'https://images.unsplash.com/photo-1471864190281-a93a3070b6de?w=400&q=80',
          'estaActivo': true,
          'duenoId': '',
          'tiempoEntrega': '25-35 min',
          'costoEnvio': 15.0,
          'descuentoNegocio': 0,
          'fechaRegistro': FieldValue.serverTimestamp(),
        },
        {
          'nombre': 'Cruz Verde',
          'categoria': 'Farmacia',
          'direccion': 'Av. López Mateos 670',
          'telefono': '656-300-4444',
          'horario': '08:00 - 23:00',
          'calificacion': 4.3,
          'imagenUrl':
              'https://images.unsplash.com/photo-1516574187841-cb9cc2ca948b?w=400&q=80',
          'estaActivo': true,
          'duenoId': '',
          'tiempoEntrega': '20-35 min',
          'costoEnvio': 8.0,
          'descuentoNegocio': 10,
          'fechaRegistro': FieldValue.serverTimestamp(),
        },
      ];

      // =======================
      // CATEGORÍA: Tiendas
      // =======================
      final tiendas = [
        {
          'nombre': 'Liverpool',
          'categoria': 'Tiendas',
          'direccion': 'Plaza Las Misiones, Av. de las Torres 3000',
          'telefono': '656-400-1111',
          'horario': '11:00 - 21:00',
          'calificacion': 4.5,
          'imagenUrl':
              'https://images.unsplash.com/photo-1555529669-e69e7aa0ba9a?w=400&q=80',
          'estaActivo': true,
          'duenoId': '',
          'tiempoEntrega': '40-60 min',
          'costoEnvio': 50.0,
          'descuentoNegocio': 20,
          'fechaRegistro': FieldValue.serverTimestamp(),
        },
        {
          'nombre': 'Electra',
          'categoria': 'Tiendas',
          'direccion': 'Blvd. Juan Pablo II 4150',
          'telefono': '656-400-2222',
          'horario': '10:00 - 20:00',
          'calificacion': 4.1,
          'imagenUrl':
              'https://images.unsplash.com/photo-1491553895911-0055eca6402d?w=400&q=80',
          'estaActivo': true,
          'duenoId': '',
          'tiempoEntrega': '30-50 min',
          'costoEnvio': 35.0,
          'descuentoNegocio': 10,
          'fechaRegistro': FieldValue.serverTimestamp(),
        },
        {
          'nombre': 'Coppel',
          'categoria': 'Tiendas',
          'direccion': 'Av. Juárez 1800, Col. Bellavista',
          'telefono': '656-400-3333',
          'horario': '10:00 - 21:00',
          'calificacion': 4.0,
          'imagenUrl':
              'https://images.unsplash.com/photo-1607082348824-0a96f2a4b9da?w=400&q=80',
          'estaActivo': true,
          'duenoId': '',
          'tiempoEntrega': '30-50 min',
          'costoEnvio': 40.0,
          'descuentoNegocio': 0,
          'fechaRegistro': FieldValue.serverTimestamp(),
        },
        {
          'nombre': 'Sears',
          'categoria': 'Tiendas',
          'direccion': 'Plaza Sendero, Blvd. Zaragoza 9000',
          'telefono': '656-400-4444',
          'horario': '11:00 - 21:00',
          'calificacion': 4.3,
          'imagenUrl':
              'https://images.unsplash.com/photo-1441986300917-64674bd600d8?w=400&q=80',
          'estaActivo': true,
          'duenoId': '',
          'tiempoEntrega': '40-60 min',
          'costoEnvio': 45.0,
          'descuentoNegocio': 15,
          'fechaRegistro': FieldValue.serverTimestamp(),
        },
      ];

      // =======================
      // CATEGORÍA: Express
      // =======================
      final express = [
        {
          'nombre': 'OXXO',
          'categoria': 'Express',
          'direccion': 'Av. Tecnológico 555',
          'telefono': '656-500-1111',
          'horario': '24 horas',
          'calificacion': 4.0,
          'imagenUrl':
              'https://images.unsplash.com/photo-1565793288593-b6e53f84c5e6?w=400&q=80',
          'estaActivo': true,
          'duenoId': '',
          'tiempoEntrega': '10-20 min',
          'costoEnvio': 8.0,
          'descuentoNegocio': 0,
          'fechaRegistro': FieldValue.serverTimestamp(),
        },
        {
          'nombre': '7-Eleven',
          'categoria': 'Express',
          'direccion': 'Paseo de la Victoria 90',
          'telefono': '656-500-2222',
          'horario': '24 horas',
          'calificacion': 3.9,
          'imagenUrl':
              'https://images.unsplash.com/photo-1584435405208-a1ee4eb3d5c0?w=400&q=80',
          'estaActivo': true,
          'duenoId': '',
          'tiempoEntrega': '10-20 min',
          'costoEnvio': 9.0,
          'descuentoNegocio': 0,
          'fechaRegistro': FieldValue.serverTimestamp(),
        },
        {
          'nombre': 'Extra',
          'categoria': 'Express',
          'direccion': 'Av. Hermanos Escobar 120',
          'telefono': '656-500-3333',
          'horario': '06:00 - 24:00',
          'calificacion': 4.0,
          'imagenUrl':
              'https://images.unsplash.com/photo-1556742049-0cfed4f6a45d?w=400&q=80',
          'estaActivo': true,
          'duenoId': '',
          'tiempoEntrega': '15-25 min',
          'costoEnvio': 7.0,
          'descuentoNegocio': 5,
          'fechaRegistro': FieldValue.serverTimestamp(),
        },
        {
          'nombre': 'Círculo K',
          'categoria': 'Express',
          'direccion': 'Calle Lerdo de Tejada 200',
          'telefono': '656-500-4444',
          'horario': '24 horas',
          'calificacion': 4.1,
          'imagenUrl':
              'https://images.unsplash.com/photo-1604719312566-8912e9227c6a?w=400&q=80',
          'estaActivo': true,
          'duenoId': '',
          'tiempoEntrega': '10-20 min',
          'costoEnvio': 8.0,
          'descuentoNegocio': 0,
          'fechaRegistro': FieldValue.serverTimestamp(),
        },
      ];

      // =======================
      // CATEGORÍA: Licor
      // =======================
      final licores = [
        {
          'nombre': 'La Europea',
          'categoria': 'Licor',
          'direccion': 'Av. Francisco Villa 800',
          'telefono': '656-600-1111',
          'horario': '10:00 - 22:00',
          'calificacion': 4.6,
          'imagenUrl':
              'https://images.unsplash.com/photo-1510812431401-41d2bd2722f3?w=400&q=80',
          'estaActivo': true,
          'duenoId': '',
          'tiempoEntrega': '20-35 min',
          'costoEnvio': 25.0,
          'descuentoNegocio': 0,
          'fechaRegistro': FieldValue.serverTimestamp(),
        },
        {
          'nombre': 'Vinoteca Juárez',
          'categoria': 'Licor',
          'direccion': 'Blvd. Tomás Fernández 350',
          'telefono': '656-600-2222',
          'horario': '11:00 - 23:00',
          'calificacion': 4.5,
          'imagenUrl':
              'https://images.unsplash.com/photo-1474722883778-792e7990302f?w=400&q=80',
          'estaActivo': true,
          'duenoId': '',
          'tiempoEntrega': '25-40 min',
          'costoEnvio': 20.0,
          'descuentoNegocio': 15,
          'fechaRegistro': FieldValue.serverTimestamp(),
        },
        {
          'nombre': 'Bar & Spirits Express',
          'categoria': 'Licor',
          'direccion': 'Calle 3ra. Oriente 90',
          'telefono': '656-600-3333',
          'horario': '12:00 - 23:00',
          'calificacion': 4.2,
          'imagenUrl':
              'https://images.unsplash.com/photo-1550950158-d0d960dff51b?w=400&q=80',
          'estaActivo': true,
          'duenoId': '',
          'tiempoEntrega': '20-30 min',
          'costoEnvio': 30.0,
          'descuentoNegocio': 0,
          'fechaRegistro': FieldValue.serverTimestamp(),
        },
        {
          'nombre': 'Bodegas Alianza',
          'categoria': 'Licor',
          'direccion': 'Av. Insurgentes 610',
          'telefono': '656-600-4444',
          'horario': '10:00 - 22:00',
          'calificacion': 4.3,
          'imagenUrl':
              'https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=400&q=80',
          'estaActivo': true,
          'duenoId': '',
          'tiempoEntrega': '30-45 min',
          'costoEnvio': 28.0,
          'descuentoNegocio': 8,
          'fechaRegistro': FieldValue.serverTimestamp(),
        },
      ];

      // ============================
      // PRODUCTOS POR COMERCIO
      // ============================
      final productosData = {
        // --- Restaurantes ---
        "McDonald's": [
          {
            'nombre': 'Big Mac',
            'descripcion':
                'Hamburguesa doble con lechuga, queso y salsa especial',
            'precio': 89.0,
            'stock': 50,
            'categoria': 'Hamburguesas',
            'imagenUrl':
                'https://images.unsplash.com/photo-1572802419224-296b0aeee0d9?w=300&q=80',
            'descuento': 0,
          },
          {
            'nombre': 'McChicken',
            'descripcion': 'Hamburguesa de pollo crujiente con mayonesa',
            'precio': 69.0,
            'stock': 50,
            'categoria': 'Hamburguesas',
            'imagenUrl':
                'https://images.unsplash.com/photo-1525059696034-4967a8e1dca2?w=300&q=80',
            'descuento': 10,
          },
          {
            'nombre': 'Papas Medianas',
            'descripcion': 'Papas fritas crujientes con sal',
            'precio': 39.0,
            'stock': 100,
            'categoria': 'Acompañamientos',
            'imagenUrl':
                'https://images.unsplash.com/photo-1576107232684-1279f390859f?w=300&q=80',
            'descuento': 0,
          },
          {
            'nombre': 'Coca-Cola Grande',
            'descripcion': 'Refresco de 32 oz con hielo',
            'precio': 29.0,
            'stock': 100,
            'categoria': 'Bebidas',
            'imagenUrl':
                'https://images.unsplash.com/photo-1541014741259-de529411b96a?w=300&q=80',
            'descuento': 0,
          },
          {
            'nombre': 'McFlurry Oreo',
            'descripcion': 'Helado suave con trozos de galleta Oreo',
            'precio': 49.0,
            'stock': 40,
            'categoria': 'Postres',
            'imagenUrl':
                'https://images.unsplash.com/photo-1551024506-0bccd828d307?w=300&q=80',
            'descuento': 15,
          },
        ],
        'Pizza Hut': [
          {
            'nombre': 'Pizza Pepperoni Grande',
            'descripcion':
                'Pizza con salsa de tomate, queso mozzarella y pepperoni',
            'precio': 189.0,
            'stock': 30,
            'categoria': 'Pizzas',
            'imagenUrl':
                'https://images.unsplash.com/photo-1534308983496-4fabb1a015ee?w=300&q=80',
            'descuento': 0,
          },
          {
            'nombre': 'Pizza Hawaiana',
            'descripcion': 'Pizza con jamón, piña y queso mozzarella',
            'precio': 175.0,
            'stock': 30,
            'categoria': 'Pizzas',
            'imagenUrl':
                'https://images.unsplash.com/photo-1565299624946-b28f40a0ae38?w=300&q=80',
            'descuento': 0,
          },
          {
            'nombre': 'Alitas BBQ (10 pzas)',
            'descripcion': 'Alitas bañadas en salsa BBQ ahumada',
            'precio': 149.0,
            'stock': 40,
            'categoria': 'Entradas',
            'imagenUrl':
                'https://images.unsplash.com/photo-1527477396000-e27163b481c2?w=300&q=80',
            'descuento': 10,
          },
          {
            'nombre': 'Pan de Ajo',
            'descripcion': 'Pan horneado con mantequilla de ajo y perejil',
            'precio': 45.0,
            'stock': 50,
            'categoria': 'Entradas',
            'imagenUrl':
                'https://images.unsplash.com/photo-1573140247632-f8fd74997d5c?w=300&q=80',
            'descuento': 0,
          },
        ],
        'Tacos El Paisa': [
          {
            'nombre': 'Orden de Tacos Pastor (3 pzas)',
            'descripcion': 'Tacos de pastor con cilantro, cebolla y salsa',
            'precio': 65.0,
            'stock': 80,
            'categoria': 'Tacos',
            'imagenUrl':
                'https://images.unsplash.com/photo-1565299585323-38d6b0865b47?w=300&q=80',
            'descuento': 0,
          },
          {
            'nombre': 'Quesadilla de Queso',
            'descripcion': 'Tortilla de harina con queso Oaxaca derretido',
            'precio': 45.0,
            'stock': 60,
            'categoria': 'Quesadillas',
            'imagenUrl':
                'https://images.unsplash.com/photo-1604467794349-0b74285de7e7?w=300&q=80',
            'descuento': 0,
          },
          {
            'nombre': 'Burrito de Carne Asada',
            'descripcion': 'Burrito relleno de carne asada, arroz y frijoles',
            'precio': 85.0,
            'stock': 40,
            'categoria': 'Burritos',
            'imagenUrl':
                'https://images.unsplash.com/photo-1561758033-d89a9ad46330?w=300&q=80',
            'descuento': 15,
          },
          {
            'nombre': 'Agua de Jamaica (1L)',
            'descripcion': 'Agua fresca de flor de jamaica con azúcar',
            'precio': 25.0,
            'stock': 50,
            'categoria': 'Bebidas',
            'imagenUrl':
                'https://images.unsplash.com/photo-1534353473418-4cfa0058de11?w=300&q=80',
            'descuento': 0,
          },
        ],
        'KFC': [
          {
            'nombre': 'Cubeta 8 pzas',
            'descripcion': '8 piezas de pollo original crispy',
            'precio': 199.0,
            'stock': 40,
            'categoria': 'Cubetas',
            'imagenUrl':
                'https://images.unsplash.com/photo-1626645738196-c2a7c87a8f58?w=300&q=80',
            'descuento': 0,
          },
          {
            'nombre': 'Combo Personal',
            'descripcion': '2 piezas de pollo + papas + refresco',
            'precio': 129.0,
            'stock': 50,
            'categoria': 'Combos',
            'imagenUrl':
                'https://images.unsplash.com/photo-1581169625126-f5fb6ade3d73?w=300&q=80',
            'descuento': 0,
          },
          {
            'nombre': 'Sandwich Pollo Crujiente',
            'descripcion': 'Sandwich con pechuga de pollo crispy y coleslaw',
            'precio': 89.0,
            'stock': 45,
            'categoria': 'Sandwiches',
            'imagenUrl':
                'https://images.unsplash.com/photo-1525059696034-4967a8e1dca2?w=300&q=80',
            'descuento': 10,
          },
          {
            'nombre': 'Puré de Papa',
            'descripcion': 'Cremoso puré de papa con salsa KFC',
            'precio': 39.0,
            'stock': 70,
            'categoria': 'Acompañamientos',
            'imagenUrl':
                'https://images.unsplash.com/photo-1574126154517-d1e0d89ef734?w=300&q=80',
            'descuento': 0,
          },
        ],
        'Sushi Roll': [
          {
            'nombre': 'Roll California (8 pzas)',
            'descripcion': 'Surimi, aguacate y pepino en arroz de sushi',
            'precio': 129.0,
            'stock': 25,
            'categoria': 'Rolls',
            'imagenUrl':
                'https://images.unsplash.com/photo-1617196034183-421b4040ed20?w=300&q=80',
            'descuento': 0,
          },
          {
            'nombre': 'Sashimi Salmón (6 pzas)',
            'descripcion': 'Finas láminas de salmón fresco',
            'precio': 159.0,
            'stock': 20,
            'categoria': 'Sashimi',
            'imagenUrl':
                'https://images.unsplash.com/photo-1559410545-0bdcd187e0a6?w=300&q=80',
            'descuento': 10,
          },
          {
            'nombre': 'Ramen Tonkotsu',
            'descripcion': 'Sopa de fideos con caldo de cerdo y huevo',
            'precio': 145.0,
            'stock': 15,
            'categoria': 'Sopas',
            'imagenUrl':
                'https://images.unsplash.com/photo-1569718212165-3a8278d5f624?w=300&q=80',
            'descuento': 0,
          },
          {
            'nombre': 'Gyozas (6 pzas)',
            'descripcion': 'Dumplings de cerdo y vegetales al vapor',
            'precio': 95.0,
            'stock': 30,
            'categoria': 'Entradas',
            'imagenUrl':
                'https://images.unsplash.com/photo-1563245372-f21724e3856d?w=300&q=80',
            'descuento': 0,
          },
        ],

        // --- Supermercado ---
        'Walmart Express': [
          {
            'nombre': 'Leche Entera 1L',
            'descripcion': 'Leche entera pasteurizada marca Lala',
            'precio': 22.0,
            'stock': 100,
            'categoria': 'Lácteos',
            'imagenUrl':
                'https://images.unsplash.com/photo-1563636619-e9143da7973b?w=300&q=80',
            'descuento': 0,
          },
          {
            'nombre': 'Aguacate (kg)',
            'descripcion': 'Aguacate Hass fresco de temporada',
            'precio': 45.0,
            'stock': 60,
            'categoria': 'Frutas y Verduras',
            'imagenUrl':
                'https://images.unsplash.com/photo-1523049673857-eb18f1d7b578?w=300&q=80',
            'descuento': 5,
          },
          {
            'nombre': 'Pan de Caja Bimbo',
            'descripcion': 'Pan blanco en caja familiar 680g',
            'precio': 38.0,
            'stock': 80,
            'categoria': 'Panadería',
            'imagenUrl':
                'https://images.unsplash.com/photo-1509440159596-0249088772ff?w=300&q=80',
            'descuento': 0,
          },
          {
            'nombre': 'Detergente Ariel 1kg',
            'descripcion': 'Detergente en polvo para ropa blanca y de color',
            'precio': 55.0,
            'stock': 40,
            'categoria': 'Limpieza',
            'imagenUrl':
                'https://images.unsplash.com/photo-1585421514738-01798e348b17?w=300&q=80',
            'descuento': 10,
          },
        ],
        'Chedraui': [
          {
            'nombre': 'Huevo blanco (12 pzas)',
            'descripcion': 'Huevo blanco tamaño A fresco',
            'precio': 35.0,
            'stock': 80,
            'categoria': 'Abarrotes',
            'imagenUrl':
                'https://images.unsplash.com/photo-1582169505937-b9992bd01ed8?w=300&q=80',
            'descuento': 0,
          },
          {
            'nombre': 'Tortillas de Maíz 1kg',
            'descripcion': 'Tortillas de maíz nixtamalizado',
            'precio': 20.0,
            'stock': 100,
            'categoria': 'Abarrotes',
            'imagenUrl':
                'https://images.unsplash.com/photo-1618449840665-9ed506d73a34?w=300&q=80',
            'descuento': 0,
          },
          {
            'nombre': 'Pollo entero (kg)',
            'descripcion': 'Pollo fresco entero listo para preparar',
            'precio': 65.0,
            'stock': 30,
            'categoria': 'Carnes',
            'imagenUrl':
                'https://images.unsplash.com/photo-1604503468506-a8da13d82791?w=300&q=80',
            'descuento': 0,
          },
          {
            'nombre': 'Yogurt Yoplait 900g',
            'descripcion': 'Yogurt natural con cultivos activos',
            'precio': 42.0,
            'stock': 50,
            'categoria': 'Lácteos',
            'imagenUrl':
                'https://images.unsplash.com/photo-1488477181946-6428a0291777?w=300&q=80',
            'descuento': 8,
          },
        ],
        'La Comer': [
          {
            'nombre': 'Arroz SOS 1kg',
            'descripcion': 'Arroz largo grano extra',
            'precio': 28.0,
            'stock': 60,
            'categoria': 'Abarrotes',
            'imagenUrl':
                'https://images.unsplash.com/photo-1536304929831-ee1ca9d44906?w=300&q=80',
            'descuento': 0,
          },
          {
            'nombre': 'Aceite Nutrioli 1L',
            'descripcion': 'Aceite de maíz para cocinar',
            'precio': 49.0,
            'stock': 50,
            'categoria': 'Abarrotes',
            'imagenUrl':
                'https://images.unsplash.com/photo-1474979266404-7eaacbcd87c5?w=300&q=80',
            'descuento': 0,
          },
          {
            'nombre': 'Queso Manchego 500g',
            'descripcion': 'Queso manchego rebanado en empaque',
            'precio': 68.0,
            'stock': 35,
            'categoria': 'Lácteos',
            'imagenUrl':
                'https://images.unsplash.com/photo-1486297678162-eb2a19b0a32d?w=300&q=80',
            'descuento': 0,
          },
          {
            'nombre': 'Detergente Roma 900g',
            'descripcion': 'Detergente en polvo multiusos',
            'precio': 32.0,
            'stock': 45,
            'categoria': 'Limpieza',
            'imagenUrl':
                'https://images.unsplash.com/photo-1585421514738-01798e348b17?w=300&q=80',
            'descuento': 12,
          },
        ],
        'Soriana': [
          {
            'nombre': 'Carne molida (500g)',
            'descripcion': 'Carne molida de res fresca',
            'precio': 75.0,
            'stock': 40,
            'categoria': 'Carnes',
            'imagenUrl':
                'https://images.unsplash.com/photo-1558030137-a56c1b004fa3?w=300&q=80',
            'descuento': 0,
          },
          {
            'nombre': 'Manzana Roja (kg)',
            'descripcion': 'Manzanas rojas importadas seleccionadas',
            'precio': 40.0,
            'stock': 70,
            'categoria': 'Frutas y Verduras',
            'imagenUrl':
                'https://images.unsplash.com/photo-1560806887-1e4cd0b6cbd6?w=300&q=80',
            'descuento': 5,
          },
          {
            'nombre': 'Mantequilla Lala 90g',
            'descripcion': 'Mantequilla con sal en barra',
            'precio': 25.0,
            'stock': 60,
            'categoria': 'Lácteos',
            'imagenUrl':
                'https://images.unsplash.com/photo-1589985270826-4b7bb135bc9d?w=300&q=80',
            'descuento': 0,
          },
          {
            'nombre': 'Pasta Barilla 500g',
            'descripcion': 'Pasta spaghetti italiana #5',
            'precio': 30.0,
            'stock': 80,
            'categoria': 'Abarrotes',
            'imagenUrl':
                'https://images.unsplash.com/photo-1551183053-bf91798d792b?w=300&q=80',
            'descuento': 0,
          },
        ],

        // --- Farmacia ---
        'Farmacias del Ahorro': [
          {
            'nombre': 'Paracetamol 500mg (20 tab)',
            'descripcion': 'Analgésico y antipirético de uso común',
            'precio': 28.0,
            'stock': 100,
            'categoria': 'Medicamentos',
            'imagenUrl':
                'https://images.unsplash.com/photo-1584308666744-24d5c474f2ae?w=300&q=80',
            'descuento': 15,
          },
          {
            'nombre': 'Alcohol 96° 250ml',
            'descripcion': 'Alcohol isopropílico para desinfección',
            'precio': 35.0,
            'stock': 80,
            'categoria': 'Primeros Auxilios',
            'imagenUrl':
                'https://images.unsplash.com/photo-1583947215259-38e31be8751f?w=300&q=80',
            'descuento': 0,
          },
          {
            'nombre': 'Vitamina C 1000mg (30 tab)',
            'descripcion': 'Suplemento de vitamina C efervescente',
            'precio': 65.0,
            'stock': 60,
            'categoria': 'Vitaminas',
            'imagenUrl':
                'https://images.unsplash.com/photo-1559076294-ad5d4b4b7b68?w=300&q=80',
            'descuento': 10,
          },
          {
            'nombre': 'Ibuprofeno 400mg (20 tab)',
            'descripcion': 'Antiinflamatorio no esteroideo',
            'precio': 42.0,
            'stock': 90,
            'categoria': 'Medicamentos',
            'imagenUrl':
                'https://images.unsplash.com/photo-1584308666744-24d5c474f2ae?w=300&q=80',
            'descuento': 0,
          },
        ],
        'Farmacia Guadalajara': [
          {
            'nombre': 'Omeprazol 20mg (14 cap)',
            'descripcion': 'Protector gástrico para gastritis',
            'precio': 55.0,
            'stock': 70,
            'categoria': 'Medicamentos',
            'imagenUrl':
                'https://images.unsplash.com/photo-1471864190281-a93a3070b6de?w=300&q=80',
            'descuento': 0,
          },
          {
            'nombre': 'Crema hidratante 200ml',
            'descripcion': 'Crema humectante para piel seca',
            'precio': 79.0,
            'stock': 45,
            'categoria': 'Cuidado Personal',
            'imagenUrl':
                'https://images.unsplash.com/photo-1556228578-8c89e6adf883?w=300&q=80',
            'descuento': 0,
          },
          {
            'nombre': 'Termómetro Digital',
            'descripcion': 'Termómetro de punta flexible para uso oral',
            'precio': 120.0,
            'stock': 30,
            'categoria': 'Equipos',
            'imagenUrl':
                'https://images.unsplash.com/photo-1587854692152-cbe660dbde88?w=300&q=80',
            'descuento': 10,
          },
          {
            'nombre': 'Antigripal (24 cap)',
            'descripcion': 'Alivio síntomas de gripe y catarro',
            'precio': 95.0,
            'stock': 60,
            'categoria': 'Medicamentos',
            'imagenUrl':
                'https://images.unsplash.com/photo-1584308666744-24d5c474f2ae?w=300&q=80',
            'descuento': 0,
          },
        ],
        'Benavides': [
          {
            'nombre': 'Shampoo Pantene 400ml',
            'descripcion': 'Shampoo reparador para cabello dañado',
            'precio': 65.0,
            'stock': 55,
            'categoria': 'Cuidado Personal',
            'imagenUrl':
                'https://images.unsplash.com/photo-1631729371254-42c2892f0e6e?w=300&q=80',
            'descuento': 0,
          },
          {
            'nombre': 'Listerine 500ml',
            'descripcion': 'Enjuague bucal antiséptico sabor menta',
            'precio': 72.0,
            'stock': 40,
            'categoria': 'Higiene Bucal',
            'imagenUrl':
                'https://images.unsplash.com/photo-1559181567-c3190958d3b7?w=300&q=80',
            'descuento': 0,
          },
          {
            'nombre': 'Antidiarreico Lomotil (12 tab)',
            'descripcion': 'Control de diarrea aguda',
            'precio': 80.0,
            'stock': 50,
            'categoria': 'Medicamentos',
            'imagenUrl':
                'https://images.unsplash.com/photo-1584308666744-24d5c474f2ae?w=300&q=80',
            'descuento': 5,
          },
          {
            'nombre': 'Jabón Líquido Antibacterial 500ml',
            'descripcion': 'Jabón de manos con triclosan',
            'precio': 45.0,
            'stock': 65,
            'categoria': 'Higiene',
            'imagenUrl':
                'https://images.unsplash.com/photo-1584308666744-24d5c474f2ae?w=300&q=80',
            'descuento': 0,
          },
        ],
        'Cruz Verde': [
          {
            'nombre': 'Loratadina 10mg (10 tab)',
            'descripcion': 'Antihistamínico para alergias',
            'precio': 38.0,
            'stock': 80,
            'categoria': 'Medicamentos',
            'imagenUrl':
                'https://images.unsplash.com/photo-1584308666744-24d5c474f2ae?w=300&q=80',
            'descuento': 10,
          },
          {
            'nombre': 'Suero Oral 500ml',
            'descripcion': 'Sales de rehidratación oral sabor naranja',
            'precio': 28.0,
            'stock': 100,
            'categoria': 'Hidratación',
            'imagenUrl':
                'https://images.unsplash.com/photo-1559181567-c3190958d3b7?w=300&q=80',
            'descuento': 0,
          },
          {
            'nombre': 'Vendas elásticas 3"',
            'descripcion': 'Venda elástica para lesiones musculares',
            'precio': 55.0,
            'stock': 45,
            'categoria': 'Primeros Auxilios',
            'imagenUrl':
                'https://images.unsplash.com/photo-1583947215259-38e31be8751f?w=300&q=80',
            'descuento': 0,
          },
          {
            'nombre': 'Multivitamínico Centrum (30 tab)',
            'descripcion': 'Suplemento multivitamínico completo',
            'precio': 145.0,
            'stock': 35,
            'categoria': 'Vitaminas',
            'imagenUrl':
                'https://images.unsplash.com/photo-1559076294-ad5d4b4b7b68?w=300&q=80',
            'descuento': 0,
          },
        ],

        // --- Tiendas (Departamentales) ---
        'Liverpool': [
          {
            'nombre': 'Perfume Chanel No 5 100ml',
            'descripcion': 'Fragancia clásica para dama, notas florales y aldehídicas',
            'precio': 2800.0,
            'stock': 15,
            'categoria': 'Perfumería',
            'imagenUrl':
                'https://images.unsplash.com/photo-1541643600914-78b084683601?w=300&q=80',
            'descuento': 20,
          },
          {
            'nombre': 'Tenis Nike Air Max',
            'descripcion': 'Tenis deportivos para correr con amortiguación premium',
            'precio': 2499.0,
            'stock': 20,
            'categoria': 'Calzado',
            'imagenUrl':
                'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=300&q=80',
            'descuento': 0,
          },
          {
            'nombre': 'Bolsa Michael Kors',
            'descripcion': 'Bolsa de mano de piel color café con detalles dorados',
            'precio': 4500.0,
            'stock': 10,
            'categoria': 'Moda',
            'imagenUrl':
                'https://images.unsplash.com/photo-1584917865442-de89df76afd3?w=300&q=80',
            'descuento': 15,
          },
          {
            'nombre': 'Playera Polo Ralph Lauren',
            'descripcion': 'Playera de algodón tipo polo para caballero',
            'precio': 1200.0,
            'stock': 30,
            'categoria': 'Ropa',
            'imagenUrl':
                'https://images.unsplash.com/photo-1586363104862-3a5e2ab60d99?w=300&q=80',
            'descuento': 0,
          },
        ],
        'Electra': [
          {
            'nombre': 'Samsung Galaxy A54 128GB',
            'descripcion': 'Pantalla de 6.4", triple cámara de 50MP y 8GB RAM',
            'precio': 6499.0,
            'stock': 25,
            'categoria': 'Telefonía',
            'imagenUrl':
                'https://images.unsplash.com/photo-1610945265064-0e34e5519bbf?w=300&q=80',
            'descuento': 10,
          },
          {
            'nombre': 'Smart TV Hisense 50" 4K',
            'descripcion': 'Pantalla LED con Google TV y control por voz',
            'precio': 7899.0,
            'stock': 12,
            'categoria': 'Electrónica',
            'imagenUrl':
                'https://images.unsplash.com/photo-1593305841991-05c297ba4575?w=300&q=80',
            'descuento': 0,
          },
          {
            'nombre': 'Bocina JBL Flip 6',
            'descripcion': 'Bocina portátil Bluetooth resistente al agua',
            'precio': 2199.0,
            'stock': 35,
            'categoria': 'Audio',
            'imagenUrl':
                'https://images.unsplash.com/photo-1608043152269-423dbba4e7e1?w=300&q=80',
            'descuento': 5,
          },
          {
            'nombre': 'Licuadora Oster 10 Vel',
            'descripcion': 'Licuadora con vaso de vidrio y cuchillas de acero',
            'precio': 899.0,
            'stock': 40,
            'categoria': 'Hogar',
            'imagenUrl':
                'https://images.unsplash.com/photo-1578643463396-0997cb5328c1?w=300&q=80',
            'descuento': 0,
          },
        ],
        'Coppel': [
          {
            'nombre': 'Colchón Restonic Matrimonial',
            'descripcion': 'Colchón ortopédico de resortes con colchoneta',
            'precio': 3999.0,
            'stock': 8,
            'categoria': 'Muebles',
            'imagenUrl':
                'https://images.unsplash.com/photo-1505693416388-ac5ce068fe85?w=300&q=80',
            'descuento': 0,
          },
          {
            'nombre': 'Horno Microondas Daewoo 1.1',
            'descripcion': 'Horno de microondas con 6 programas de auto cocción',
            'precio': 1899.0,
            'stock': 15,
            'categoria': 'Línea Blanca',
            'imagenUrl':
                'https://images.unsplash.com/photo-1584269600464-37b1b58a9fe7?w=300&q=80',
            'descuento': 0,
          },
          {
            'nombre': 'Ventilador Lasko de Pedestal',
            'descripcion': 'Ventilador de 3 velocidades con oscilación amplia',
            'precio': 799.0,
            'stock': 50,
            'categoria': 'Hogar',
            'imagenUrl':
                'https://images.unsplash.com/photo-1618944847023-38aa001235f0?w=300&q=80',
            'descuento': 10,
          },
          {
            'nombre': 'Plancha de Vapor Oster',
            'descripcion': 'Plancha con suela antiadherente y golpe de vapor',
            'precio': 459.0,
            'stock': 30,
            'categoria': 'Hogar',
            'imagenUrl':
                'https://images.unsplash.com/photo-1597175924767-f4728ad72e3a?w=300&q=80',
            'descuento': 0,
          },
        ],
        'Sears': [
          {
            'nombre': 'Reloj Casio Edifice',
            'descripcion': 'Reloj análogo de acero inoxidable resistente al agua',
            'precio': 2100.0,
            'stock': 15,
            'categoria': 'Joyería',
            'imagenUrl':
                'https://images.unsplash.com/photo-1524805444758-089113d48a6d?w=300&q=80',
            'descuento': 15,
          },
          {
            'nombre': 'Cafetera Nespresso Vertuo',
            'descripcion': 'Cafetera de cápsulas para espressos y cafés largos',
            'precio': 3499.0,
            'stock': 10,
            'categoria': 'Hogar',
            'imagenUrl':
                'https://images.unsplash.com/photo-1579888944880-d98341245703?w=300&q=80',
            'descuento': 0,
          },
          {
            'nombre': 'Set de Sartenes T-Fal (3 pzas)',
            'descripcion': 'Sartenes con antiadherente de alta duración',
            'precio': 1599.0,
            'stock': 20,
            'categoria': 'Cocina',
            'imagenUrl':
                'https://images.unsplash.com/photo-1599940824399-b87987ceb72a?w=300&q=80',
            'descuento': 20,
          },
          {
            'nombre': 'Saco de Vestir J.BEHAR',
            'descripcion': 'Saco corte slim fit para caballero',
            'precio': 1899.0,
            'stock': 18,
            'categoria': 'Ropa',
            'imagenUrl':
                'https://images.unsplash.com/photo-1598808503746-f34c53b29ef3?w=300&q=80',
            'descuento': 0,
          },
        ],

        // --- Express ---
        'OXXO': [
          {
            'nombre': 'Refresco Coca-Cola 600ml',
            'descripcion': 'Refresco de cola en botella de vidrio',
            'precio': 18.0,
            'stock': 120,
            'categoria': 'Bebidas',
            'imagenUrl':
                'https://images.unsplash.com/photo-1554866585-cd94860890b7?w=300&q=80',
            'descuento': 0,
          },
          {
            'nombre': 'Sabritas Original 45g',
            'descripcion': 'Papas fritas sabor natural',
            'precio': 15.0,
            'stock': 80,
            'categoria': 'Snacks',
            'imagenUrl':
                'https://images.unsplash.com/photo-1566478989037-eec170784d0b?w=300&q=80',
            'descuento': 0,
          },
          {
            'nombre': 'Gansito Marinela',
            'descripcion': 'Pastelito relleno de crema y mermelada',
            'precio': 12.0,
            'stock': 100,
            'categoria': 'Dulces',
            'imagenUrl':
                'https://images.unsplash.com/photo-1558961363-fa8fdf82db35?w=300&q=80',
            'descuento': 0,
          },
          {
            'nombre': 'Agua embotellada 1.5L',
            'descripcion': 'Agua purificada sin gas',
            'precio': 14.0,
            'stock': 150,
            'categoria': 'Bebidas',
            'imagenUrl':
                'https://images.unsplash.com/photo-1548839140-29a749e1cf4d?w=300&q=80',
            'descuento': 5,
          },
        ],
        '7-Eleven': [
          {
            'nombre': 'Hot Dog con Pan',
            'descripcion': 'Salchicha de pavo en pan con mostaza y ketchup',
            'precio': 22.0,
            'stock': 60,
            'categoria': 'Comida Rápida',
            'imagenUrl':
                'https://images.unsplash.com/photo-1612392062631-94440c87c4e5?w=300&q=80',
            'descuento': 0,
          },
          {
            'nombre': 'Café mediano',
            'descripcion': 'Café americano caliente tamaño mediano',
            'precio': 28.0,
            'stock': 100,
            'categoria': 'Bebidas',
            'imagenUrl':
                'https://images.unsplash.com/photo-1509042239860-f550ce710b93?w=300&q=80',
            'descuento': 0,
          },
          {
            'nombre': 'Slurpee Fresa 22oz',
            'descripcion': 'Bebida helada sabor fresa',
            'precio': 25.0,
            'stock': 80,
            'categoria': 'Bebidas',
            'imagenUrl':
                'https://images.unsplash.com/photo-1499638673689-79a0b5115d87?w=300&q=80',
            'descuento': 10,
          },
          {
            'nombre': 'Sandwich de Pollo',
            'descripcion': 'Sandwich frío de pollo con vegetales',
            'precio': 38.0,
            'stock': 45,
            'categoria': 'Comida Rápida',
            'imagenUrl':
                'https://images.unsplash.com/photo-1592415499556-74fcb9f18667?w=300&q=80',
            'descuento': 0,
          },
        ],
        'Extra': [
          {
            'nombre': 'Cerveza Corona 355ml',
            'descripcion': 'Cerveza clara en lata',
            'precio': 22.0,
            'stock': 80,
            'categoria': 'Bebidas',
            'imagenUrl':
                'https://images.unsplash.com/photo-1608270586620-248524c67de9?w=300&q=80',
            'descuento': 0,
          },
          {
            'nombre': 'Cigarros Marlboro (cajetilla)',
            'descripcion': 'Cigarros rubios cajetilla de 20',
            'precio': 58.0,
            'stock': 50,
            'categoria': 'Tabaco',
            'imagenUrl':
                'https://images.unsplash.com/photo-1559181567-c3190958d3b7?w=300&q=80',
            'descuento': 0,
          },
          {
            'nombre': 'Doritos Flamin Hot 65g',
            'descripcion': 'Totopos sabor picante intenso',
            'precio': 18.0,
            'stock': 70,
            'categoria': 'Snacks',
            'imagenUrl':
                'https://images.unsplash.com/photo-1566478989037-eec170784d0b?w=300&q=80',
            'descuento': 5,
          },
          {
            'nombre': 'Leche Condensada La Lechera 397g',
            'descripcion': 'Leche condensada azucarada en lata',
            'precio': 48.0,
            'stock': 40,
            'categoria': 'Abarrotes',
            'imagenUrl':
                'https://images.unsplash.com/photo-1563636619-e9143da7973b?w=300&q=80',
            'descuento': 0,
          },
        ],
        'Círculo K': [
          {
            'nombre': 'Energética Monster 473ml',
            'descripcion': 'Bebida energizante sabor original',
            'precio': 38.0,
            'stock': 90,
            'categoria': 'Bebidas',
            'imagenUrl':
                'https://images.unsplash.com/photo-1626016572574-2f5aaa26a6fb?w=300&q=80',
            'descuento': 0,
          },
          {
            'nombre': 'Gomitas Haribo 200g',
            'descripcion': 'Gomitas de ositos surtidas',
            'precio': 25.0,
            'stock': 60,
            'categoria': 'Dulces',
            'imagenUrl':
                'https://images.unsplash.com/photo-1582450871972-ab5ca641643d?w=300&q=80',
            'descuento': 0,
          },
          {
            'nombre': 'Galletas Oreo 126g',
            'descripcion': 'Galletas rellenas de crema sabor chocolate',
            'precio': 22.0,
            'stock': 70,
            'categoria': 'Dulces',
            'imagenUrl':
                'https://images.unsplash.com/photo-1558961363-fa8fdf82db35?w=300&q=80',
            'descuento': 0,
          },
          {
            'nombre': 'Jugo Del Valle 1L',
            'descripcion': 'Jugo de naranja sin pulpa',
            'precio': 28.0,
            'stock': 55,
            'categoria': 'Bebidas',
            'imagenUrl':
                'https://images.unsplash.com/photo-1621506289937-a8e4df240d0b?w=300&q=80',
            'descuento': 8,
          },
        ],

        // --- Express ---
        'Rappi Express': [
          {
            'nombre': 'Paquete Básico (hasta 2kg)',
            'descripcion': 'Envío de paquetes hasta 2kg en la ciudad',
            'precio': 50.0,
            'stock': 999,
            'categoria': 'Envíos',
            'imagenUrl':
                'https://images.unsplash.com/photo-1526367790999-0150786686a2?w=300&q=80',
            'descuento': 0,
          },
          {
            'nombre': 'Paquete Estándar (2-5kg)',
            'descripcion': 'Envío de paquetes de 2 a 5kg',
            'precio': 80.0,
            'stock': 999,
            'categoria': 'Envíos',
            'imagenUrl':
                'https://images.unsplash.com/photo-1601972599720-36938d4ecd31?w=300&q=80',
            'descuento': 0,
          },
          {
            'nombre': 'Documentos Urgentes',
            'descripcion': 'Entrega de documentos en menos de 2 horas',
            'precio': 120.0,
            'stock': 999,
            'categoria': 'Documentos',
            'imagenUrl':
                'https://images.unsplash.com/photo-1568219557405-376e23e4f7cf?w=300&q=80',
            'descuento': 10,
          },
          {
            'nombre': 'Compra Express (servicio)',
            'descripcion': 'Compramos lo que necesitas en tiendas locales',
            'precio': 150.0,
            'stock': 999,
            'categoria': 'Servicios',
            'imagenUrl':
                'https://images.unsplash.com/photo-1556742049-0cfed4f6a45d?w=300&q=80',
            'descuento': 0,
          },
        ],
        'Mensajería Rápida JRZ': [
          {
            'nombre': 'Sobre Documentos',
            'descripcion': 'Entrega de sobres y cartas en el día',
            'precio': 40.0,
            'stock': 999,
            'categoria': 'Documentos',
            'imagenUrl':
                'https://images.unsplash.com/photo-1568219557405-376e23e4f7cf?w=300&q=80',
            'descuento': 10,
          },
          {
            'nombre': 'Caja Pequeña (hasta 5kg)',
            'descripcion': 'Envío de cajas hasta 5kg',
            'precio': 90.0,
            'stock': 999,
            'categoria': 'Paquetes',
            'imagenUrl':
                'https://images.unsplash.com/photo-1551836022-d5d88e9218df?w=300&q=80',
            'descuento': 0,
          },
          {
            'nombre': 'Caja Grande (hasta 15kg)',
            'descripcion': 'Envío de cajas de mayor tamaño',
            'precio': 150.0,
            'stock': 999,
            'categoria': 'Paquetes',
            'imagenUrl':
                'https://images.unsplash.com/photo-1617153141905-b27fb1f17d88?w=300&q=80',
            'descuento': 0,
          },
          {
            'nombre': 'Recolección a domicilio',
            'descripcion': 'Recolectamos tu paquete en tu casa u oficina',
            'precio': 35.0,
            'stock': 999,
            'categoria': 'Servicios',
            'imagenUrl':
                'https://images.unsplash.com/photo-1601972599720-36938d4ecd31?w=300&q=80',
            'descuento': 0,
          },
        ],
        'Flash Delivery': [
          {
            'nombre': 'Entrega Flash (30 min)',
            'descripcion': 'Garantizamos entrega en 30 minutos',
            'precio': 200.0,
            'stock': 999,
            'categoria': 'Envíos',
            'imagenUrl':
                'https://images.unsplash.com/photo-1617153141905-b27fb1f17d88?w=300&q=80',
            'descuento': 0,
          },
          {
            'nombre': 'Paquete Frágil',
            'descripcion': 'Manejo especial para objetos frágiles',
            'precio': 120.0,
            'stock': 999,
            'categoria': 'Paquetes',
            'imagenUrl':
                'https://images.unsplash.com/photo-1526367790999-0150786686a2?w=300&q=80',
            'descuento': 0,
          },
          {
            'nombre': 'Mensajería Médica',
            'descripcion': 'Entrega de medicamentos y muestras médicas',
            'precio': 80.0,
            'stock': 999,
            'categoria': 'Especial',
            'imagenUrl':
                'https://images.unsplash.com/photo-1584308666744-24d5c474f2ae?w=300&q=80',
            'descuento': 0,
          },
          {
            'nombre': 'Compras Online (recoge y entrega)',
            'descripcion': 'Recogemos tu pedido online y lo llevamos a ti',
            'precio': 100.0,
            'stock': 999,
            'categoria': 'Servicios',
            'imagenUrl':
                'https://images.unsplash.com/photo-1556742049-0cfed4f6a45d?w=300&q=80',
            'descuento': 15,
          },
        ],
        'EnvíoYa': [
          {
            'nombre': 'Moto Express (hasta 2kg)',
            'descripcion': 'Entrega en moto en menos de 1 hora',
            'precio': 60.0,
            'stock': 999,
            'categoria': 'Envíos',
            'imagenUrl':
                'https://images.unsplash.com/photo-1601972599720-36938d4ecd31?w=300&q=80',
            'descuento': 20,
          },
          {
            'nombre': 'Auto Estándar (hasta 10kg)',
            'descripcion': 'Entrega en auto para paquetes más grandes',
            'precio': 100.0,
            'stock': 999,
            'categoria': 'Envíos',
            'imagenUrl':
                'https://images.unsplash.com/photo-1526367790999-0150786686a2?w=300&q=80',
            'descuento': 0,
          },
          {
            'nombre': 'Mismo Día',
            'descripcion': 'Garantizamos entrega el mismo día antes de las 8pm',
            'precio': 80.0,
            'stock': 999,
            'categoria': 'Envíos',
            'imagenUrl':
                'https://images.unsplash.com/photo-1568219557405-376e23e4f7cf?w=300&q=80',
            'descuento': 0,
          },
          {
            'nombre': 'Mudanza pequeña',
            'descripcion': 'Traslado de muebles y cajas para cambio de casa',
            'precio': 500.0,
            'stock': 999,
            'categoria': 'Servicios',
            'imagenUrl':
                'https://images.unsplash.com/photo-1601972599720-36938d4ecd31?w=300&q=80',
            'descuento': 0,
          },
        ],

        // --- Licor ---
        'La Europea': [
          {
            'nombre': 'Whisky Jack Daniel\'s 750ml',
            'descripcion': 'Whisky Tennessee Old No. 7',
            'precio': 350.0,
            'stock': 25,
            'categoria': 'Whisky',
            'imagenUrl':
                'https://images.unsplash.com/photo-1527281400683-1aade076f5ee?w=300&q=80',
            'descuento': 0,
          },
          {
            'nombre': 'Vino Tinto Casillero del Diablo 750ml',
            'descripcion': 'Vino Cabernet Sauvignon chileno',
            'precio': 185.0,
            'stock': 30,
            'categoria': 'Vinos',
            'imagenUrl':
                'https://images.unsplash.com/photo-1474722883778-792e7990302f?w=300&q=80',
            'descuento': 0,
          },
          {
            'nombre': 'Cerveza Heineken 12 pack',
            'descripcion': 'Caja de 12 latas de cerveza holandesa',
            'precio': 220.0,
            'stock': 40,
            'categoria': 'Cervezas',
            'imagenUrl':
                'https://images.unsplash.com/photo-1608270586620-248524c67de9?w=300&q=80',
            'descuento': 0,
          },
          {
            'nombre': 'Tequila Don Julio Blanco 750ml',
            'descripcion': 'Tequila blanco 100% de agave azul',
            'precio': 420.0,
            'stock': 20,
            'categoria': 'Tequila',
            'imagenUrl':
                'https://images.unsplash.com/photo-1551538827-9c037cb4f32a?w=300&q=80',
            'descuento': 0,
          },
        ],
        'Vinoteca Juárez': [
          {
            'nombre': 'Vino Blanco Santa Helena 750ml',
            'descripcion': 'Vino Sauvignon Blanc fresco y afrutado',
            'precio': 145.0,
            'stock': 35,
            'categoria': 'Vinos',
            'imagenUrl':
                'https://images.unsplash.com/photo-1474722883778-792e7990302f?w=300&q=80',
            'descuento': 15,
          },
          {
            'nombre': 'Champagne Moët 750ml',
            'descripcion': 'Champagne francés Brut Imperial',
            'precio': 850.0,
            'stock': 15,
            'categoria': 'Champagne',
            'imagenUrl':
                'https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=300&q=80',
            'descuento': 0,
          },
          {
            'nombre': 'Vino Rosé Mateus 750ml',
            'descripcion': 'Vino rosado portugués semi-seco',
            'precio': 135.0,
            'stock': 28,
            'categoria': 'Vinos',
            'imagenUrl':
                'https://images.unsplash.com/photo-1560148218-1a83060f7b32?w=300&q=80',
            'descuento': 10,
          },
          {
            'nombre': 'Cava Freixenet Cordon Negro',
            'descripcion': 'Cava española con burbujas finas',
            'precio': 280.0,
            'stock': 20,
            'categoria': 'Espumosos',
            'imagenUrl':
                'https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=300&q=80',
            'descuento': 0,
          },
        ],
        'Bar & Spirits Express': [
          {
            'nombre': 'Ron Bacardí Blanco 750ml',
            'descripcion': 'Ron blanco cubano superior',
            'precio': 210.0,
            'stock': 30,
            'categoria': 'Ron',
            'imagenUrl':
                'https://images.unsplash.com/photo-1527281400683-1aade076f5ee?w=300&q=80',
            'descuento': 0,
          },
          {
            'nombre': 'Vodka Smirnoff 750ml',
            'descripcion': 'Vodka triple destilado sabor original',
            'precio': 195.0,
            'stock': 35,
            'categoria': 'Vodka',
            'imagenUrl':
                'https://images.unsplash.com/photo-1550950158-d0d960dff51b?w=300&q=80',
            'descuento': 0,
          },
          {
            'nombre': 'Gin Hendrick\'s 750ml',
            'descripcion': 'Gin escocés con pepino y rosas',
            'precio': 520.0,
            'stock': 12,
            'categoria': 'Gin',
            'imagenUrl':
                'https://images.unsplash.com/photo-1527281400683-1aade076f5ee?w=300&q=80',
            'descuento': 0,
          },
          {
            'nombre': 'Six Pack Modelo Especial',
            'descripcion': 'Six pack de cervezas Modelo Especial 355ml c/u',
            'precio': 90.0,
            'stock': 50,
            'categoria': 'Cervezas',
            'imagenUrl':
                'https://images.unsplash.com/photo-1608270586620-248524c67de9?w=300&q=80',
            'descuento': 8,
          },
        ],
        'Bodegas Alianza': [
          {
            'nombre': 'Tequila Herradura Reposado 750ml',
            'descripcion': 'Tequila reposado premium 46% alc.',
            'precio': 480.0,
            'stock': 18,
            'categoria': 'Tequila',
            'imagenUrl':
                'https://images.unsplash.com/photo-1551538827-9c037cb4f32a?w=300&q=80',
            'descuento': 8,
          },
          {
            'nombre': 'Mezcal Del Maguey 750ml',
            'descripcion': 'Mezcal artesanal 100% agave',
            'precio': 380.0,
            'stock': 15,
            'categoria': 'Mezcal',
            'imagenUrl':
                'https://images.unsplash.com/photo-1527281400683-1aade076f5ee?w=300&q=80',
            'descuento': 0,
          },
          {
            'nombre': 'Cognac Rémy Martin VSOP',
            'descripcion': 'Cognac fino de champagne 40% alc.',
            'precio': 690.0,
            'stock': 10,
            'categoria': 'Cognac',
            'imagenUrl':
                'https://images.unsplash.com/photo-1527281400683-1aade076f5ee?w=300&q=80',
            'descuento': 0,
          },
          {
            'nombre': 'Pack Botanero (cervezas + snacks)',
            'descripcion': '6 cervezas + 3 botanas surtidas',
            'precio': 175.0,
            'stock': 25,
            'categoria': 'Packs',
            'imagenUrl':
                'https://images.unsplash.com/photo-1608270586620-248524c67de9?w=300&q=80',
            'descuento': 10,
          },
        ],
      };

      // Combinar todas las categorías
      final allComercios = [
        ...restaurantes,
        ...supermercados,
        ...farmacias,
        ...tiendas,
        ...express,
        ...licores,
      ];

      // Insertar en lotes (Firestore limita 500 ops por batch)
      // Primero insertamos negocios y guardamos sus IDs
      for (final comercioData in allComercios) {
        final docRef = _db.collection(Constantes.coleccionComercios).doc();

        await docRef.set(comercioData);

        final nombreComercio = comercioData['nombre'] as String;
        final productosComercio = productosData[nombreComercio] ?? [];

        final batch = _db.batch();
        for (final productoData in productosComercio) {
          final prodRef = _db.collection(Constantes.coleccionProductos).doc();
          batch.set(prodRef, {
            ...productoData,
            'comercioId': docRef.id,
          });
        }
        await batch.commit();
      }

    debugPrint('✅ Datos sembrados exitosamente: ${allComercios.length} negocios.');
  }
}
