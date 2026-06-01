class Constantes {
  // Nombres de colecciones en Firebase Firestore
  static const String coleccionUsuarios = 'usuarios';
  static const String coleccionComercios = 'negocios';
  static const String coleccionRepartidores = 'repartidores';
  static const String coleccionProductos = 'productos';
  static const String coleccionPedidos = 'pedidos';
  static const String coleccionPagos = 'pagos';

  // Roles de usuario
  static const String rolCliente = 'cliente';
  static const String rolRepartidor = 'repartidor';
  static const String rolAdministrador = 'administrador';

  // Estados de pedido
  static const String estadoPendiente = 'Pendiente';
  static const String estadoPreparando = 'Preparando';
  static const String estadoEnCamino = 'En Camino';
  static const String estadoEntregado = 'Entregado';
  static const String estadoCancelado = 'Cancelado';

  // Estados de repartidor
  static const String repartidorActivo = 'Activo';
  static const String repartidorInactivo = 'Inactivo';

  // URLs de imágenes desde GitHub del proyecto
  static const String baseImagenesUrl =
      'https://raw.githubusercontent.com/ARROYOCARLOS0478/imagenes/refs/heads/main/';

  static const String logoRappiUrl = '${baseImagenesUrl}logo-rappi.png';

  // Imágenes de comercios de ejemplo (fallback si no hay en Firestore)
  static const List<Map<String, String>> comerciosEjemplo = [
    {
      'nombre': 'McDonald\'s',
      'categoria': 'Comida Rápida',
      'imagenUrl':
          'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=400&q=80',
      'calificacion': '4.5',
      'tiempoEntrega': '20-30 min',
      'costoEnvio': '15.00',
    },
    {
      'nombre': 'Pizza Hut',
      'categoria': 'Pizzas',
      'imagenUrl':
          'https://images.unsplash.com/photo-1565299624946-b28f40a0ae38?w=400&q=80',
      'calificacion': '4.3',
      'tiempoEntrega': '30-45 min',
      'costoEnvio': '20.00',
    },
    {
      'nombre': 'Sushi Roll',
      'categoria': 'Japonesa',
      'imagenUrl':
          'https://images.unsplash.com/photo-1579871494447-9811cf80d66c?w=400&q=80',
      'calificacion': '4.7',
      'tiempoEntrega': '25-40 min',
      'costoEnvio': '25.00',
    },
    {
      'nombre': 'Tacos El Paisa',
      'categoria': 'Mexicana',
      'imagenUrl':
          'https://images.unsplash.com/photo-1565299585323-38d6b0865b47?w=400&q=80',
      'calificacion': '4.8',
      'tiempoEntrega': '15-25 min',
      'costoEnvio': '10.00',
    },
    {
      'nombre': 'KFC',
      'categoria': 'Pollo',
      'imagenUrl':
          'https://images.unsplash.com/photo-1626645738196-c2a7c87a8f58?w=400&q=80',
      'calificacion': '4.2',
      'tiempoEntrega': '20-35 min',
      'costoEnvio': '18.00',
    },
    {
      'nombre': 'Subway',
      'categoria': 'Sándwiches',
      'imagenUrl':
          'https://images.unsplash.com/photo-1509722747041-616f39b57569?w=400&q=80',
      'calificacion': '4.0',
      'tiempoEntrega': '15-25 min',
      'costoEnvio': '12.00',
    },
  ];

  // Categorías de comercios
  static const List<String> categorias = [
    'Todos',
    'Comida Rápida',
    'Pizzas',
    'Japonesa',
    'Mexicana',
    'Pollo',
    'Sándwiches',
    'Postres',
    'Bebidas',
  ];
}
