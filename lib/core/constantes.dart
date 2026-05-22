class Constantes {
  // Nombres de colecciones en Firebase Firestore
  static const String coleccionUsuarios = 'usuarios';
  static const String coleccionComercios = 'restaurantes'; // Mapeado a tu colección existente
  static const String coleccionRepartidores = 'repartidores'; // Mapeado a tu colección existente
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
}
