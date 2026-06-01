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

      debugPrint('🌱 Sembrando datos iniciales en Firestore...');

      final comerciosData = [
        {
          'nombre': "McDonald's",
          'categoria': 'Comida Rápida',
          'direccion': 'Av. Principal 123, Col. Centro',
          'telefono': '555-1234',
          'horario': '08:00 - 23:00',
          'calificacion': 4.5,
          'imagenUrl':
              'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=400&q=80',
          'estaActivo': true,
          'duenoId': '',
          'tiempoEntrega': '20-30 min',
          'costoEnvio': 15.0,
          'fechaRegistro': FieldValue.serverTimestamp(),
        },
        {
          'nombre': 'Pizza Hut',
          'categoria': 'Pizzas',
          'direccion': 'Calle 5 de Mayo 456',
          'telefono': '555-5678',
          'horario': '10:00 - 24:00',
          'calificacion': 4.3,
          'imagenUrl':
              'https://images.unsplash.com/photo-1565299624946-b28f40a0ae38?w=400&q=80',
          'estaActivo': true,
          'duenoId': '',
          'tiempoEntrega': '30-45 min',
          'costoEnvio': 20.0,
          'fechaRegistro': FieldValue.serverTimestamp(),
        },
        {
          'nombre': 'Sushi Roll',
          'categoria': 'Japonesa',
          'direccion': 'Blvd. Revolución 789',
          'telefono': '555-9012',
          'horario': '12:00 - 22:00',
          'calificacion': 4.7,
          'imagenUrl':
              'https://images.unsplash.com/photo-1579871494447-9811cf80d66c?w=400&q=80',
          'estaActivo': true,
          'duenoId': '',
          'tiempoEntrega': '25-40 min',
          'costoEnvio': 25.0,
          'fechaRegistro': FieldValue.serverTimestamp(),
        },
        {
          'nombre': 'Tacos El Paisa',
          'categoria': 'Mexicana',
          'direccion': 'Mercado Morelos, Local 12',
          'telefono': '555-3456',
          'horario': '09:00 - 21:00',
          'calificacion': 4.8,
          'imagenUrl':
              'https://images.unsplash.com/photo-1565299585323-38d6b0865b47?w=400&q=80',
          'estaActivo': true,
          'duenoId': '',
          'tiempoEntrega': '15-25 min',
          'costoEnvio': 10.0,
          'fechaRegistro': FieldValue.serverTimestamp(),
        },
        {
          'nombre': 'KFC',
          'categoria': 'Pollo',
          'direccion': 'Plaza Las Américas, Local 5',
          'telefono': '555-7890',
          'horario': '10:00 - 23:00',
          'calificacion': 4.2,
          'imagenUrl':
              'https://images.unsplash.com/photo-1626645738196-c2a7c87a8f58?w=400&q=80',
          'estaActivo': true,
          'duenoId': '',
          'tiempoEntrega': '20-35 min',
          'costoEnvio': 18.0,
          'fechaRegistro': FieldValue.serverTimestamp(),
        },
        {
          'nombre': 'Subway',
          'categoria': 'Sándwiches',
          'direccion': 'Calle Hidalgo 321',
          'telefono': '555-2345',
          'horario': '09:00 - 22:00',
          'calificacion': 4.0,
          'imagenUrl':
              'https://images.unsplash.com/photo-1509722747041-616f39b57569?w=400&q=80',
          'estaActivo': true,
          'duenoId': '',
          'tiempoEntrega': '15-25 min',
          'costoEnvio': 12.0,
          'fechaRegistro': FieldValue.serverTimestamp(),
        },
      ];

      final productosData = {
        "McDonald's": [
          {
            'nombre': 'Big Mac',
            'descripcion': 'Hamburguesa doble con lechuga, queso y salsa especial',
            'precio': 89.0,
            'stock': 50,
            'categoria': 'Hamburguesas',
            'imagenUrl':
                'https://images.unsplash.com/photo-1572802419224-296b0aeee0d9?w=300&q=80',
          },
          {
            'nombre': 'McChicken',
            'descripcion': 'Hamburguesa de pollo crujiente con mayonesa',
            'precio': 69.0,
            'stock': 50,
            'categoria': 'Hamburguesas',
            'imagenUrl':
                'https://images.unsplash.com/photo-1525059696034-4967a8e1dca2?w=300&q=80',
          },
          {
            'nombre': 'Papas Medianas',
            'descripcion': 'Papas fritas crujientes con sal',
            'precio': 39.0,
            'stock': 100,
            'categoria': 'Acompañamientos',
            'imagenUrl':
                'https://images.unsplash.com/photo-1576107232684-1279f390859f?w=300&q=80',
          },
          {
            'nombre': 'Coca-Cola Grande',
            'descripcion': 'Refresco de 32 oz con hielo',
            'precio': 29.0,
            'stock': 100,
            'categoria': 'Bebidas',
            'imagenUrl':
                'https://images.unsplash.com/photo-1541014741259-de529411b96a?w=300&q=80',
          },
        ],
        'Pizza Hut': [
          {
            'nombre': 'Pizza Pepperoni Grande',
            'descripcion': 'Pizza con salsa de tomate, queso mozzarella y pepperoni',
            'precio': 189.0,
            'stock': 30,
            'categoria': 'Pizzas',
            'imagenUrl':
                'https://images.unsplash.com/photo-1534308983496-4fabb1a015ee?w=300&q=80',
          },
          {
            'nombre': 'Pizza Hawaiana',
            'descripcion': 'Pizza con jamón, piña y queso mozzarella',
            'precio': 175.0,
            'stock': 30,
            'categoria': 'Pizzas',
            'imagenUrl':
                'https://images.unsplash.com/photo-1565299624946-b28f40a0ae38?w=300&q=80',
          },
          {
            'nombre': 'Alitas BBQ (10 pzas)',
            'descripcion': 'Alitas bañadas en salsa BBQ ahumada',
            'precio': 149.0,
            'stock': 40,
            'categoria': 'Entradas',
            'imagenUrl':
                'https://images.unsplash.com/photo-1527477396000-e27163b481c2?w=300&q=80',
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
          },
          {
            'nombre': 'Sashimi Salmón (6 pzas)',
            'descripcion': 'Finas láminas de salmón fresco',
            'precio': 159.0,
            'stock': 20,
            'categoria': 'Sashimi',
            'imagenUrl':
                'https://images.unsplash.com/photo-1559410545-0bdcd187e0a6?w=300&q=80',
          },
          {
            'nombre': 'Ramen Tonkotsu',
            'descripcion': 'Sopa de fideos con caldo de cerdo y huevo',
            'precio': 145.0,
            'stock': 15,
            'categoria': 'Sopas',
            'imagenUrl':
                'https://images.unsplash.com/photo-1569718212165-3a8278d5f624?w=300&q=80',
          },
        ],
        'Tacos El Paisa': [
          {
            'nombre': 'Orden de Tacos (3 pzas)',
            'descripcion': 'Tacos de pastor con cilantro, cebolla y salsa',
            'precio': 65.0,
            'stock': 80,
            'categoria': 'Tacos',
            'imagenUrl':
                'https://images.unsplash.com/photo-1565299585323-38d6b0865b47?w=300&q=80',
          },
          {
            'nombre': 'Quesadilla de Queso',
            'descripcion': 'Tortilla de harina con queso Oaxaca derretido',
            'precio': 45.0,
            'stock': 60,
            'categoria': 'Quesadillas',
            'imagenUrl':
                'https://images.unsplash.com/photo-1604467794349-0b74285de7e7?w=300&q=80',
          },
          {
            'nombre': 'Agua de Jamaica (1L)',
            'descripcion': 'Agua fresca de flor de jamaica con azúcar',
            'precio': 25.0,
            'stock': 50,
            'categoria': 'Bebidas',
            'imagenUrl':
                'https://images.unsplash.com/photo-1534353473418-4cfa0058de11?w=300&q=80',
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
          },
          {
            'nombre': 'Combo Personal',
            'descripcion': '2 piezas de pollo + papas + refresco',
            'precio': 129.0,
            'stock': 50,
            'categoria': 'Combos',
            'imagenUrl':
                'https://images.unsplash.com/photo-1581169625126-f5fb6ade3d73?w=300&q=80',
          },
        ],
        'Subway': [
          {
            'nombre': 'Sub Italiano',
            'descripcion': 'Jamón, salami, queso provolone y vegetales',
            'precio': 95.0,
            'stock': 45,
            'categoria': 'Subs',
            'imagenUrl':
                'https://images.unsplash.com/photo-1509722747041-616f39b57569?w=300&q=80',
          },
          {
            'nombre': 'Sub Pollo Teriyaki',
            'descripcion': 'Pollo a la parrilla con salsa teriyaki',
            'precio': 105.0,
            'stock': 40,
            'categoria': 'Subs',
            'imagenUrl':
                'https://images.unsplash.com/photo-1592415499556-74fcb9f18667?w=300&q=80',
          },
          {
            'nombre': 'Galleta de Chocochips',
            'descripcion': 'Galleta suave con chips de chocolate',
            'precio': 25.0,
            'stock': 80,
            'categoria': 'Postres',
            'imagenUrl':
                'https://images.unsplash.com/photo-1499636136210-6f4ee915583e?w=300&q=80',
          },
        ],
      };

      // Insertar comercios y sus productos
      final batch = _db.batch();

      for (final comercioData in comerciosData) {
        final docRef = _db.collection(Constantes.coleccionComercios).doc();
        batch.set(docRef, comercioData);

        final nombreComercio = comercioData['nombre'] as String;
        final productosComercio = productosData[nombreComercio] ?? [];

        for (final productoData in productosComercio) {
          final prodRef = _db.collection(Constantes.coleccionProductos).doc();
          batch.set(prodRef, {
            ...productoData,
            'comercioId': docRef.id,
          });
        }
      }

      await batch.commit();
      debugPrint('✅ Datos sembrados exitosamente.');
    } catch (e) {
      debugPrint('❌ Error al sembrar datos: $e');
    }
  }
}
