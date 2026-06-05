import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../modelos/comercio_modelo.dart';
import '../../modelos/pedido_modelo.dart';
import '../../proveedores/autenticacion_proveedor.dart';
import '../../proveedores/carrito_proveedor.dart';
import '../../servicios/firestore_servicio.dart';
import '../catalogo/detalle_comercio_pantalla.dart';
import '../catalogo/seccion_negocios_pantalla.dart';
import '../perfil/perfil_pantalla.dart';
import '../perfil/gestion_direcciones_pantalla.dart';
import '../carrito/carrito_pantalla.dart';
import '../seguimiento/seguimiento_pedido_pantalla.dart';

class HomePantalla extends StatefulWidget {
  const HomePantalla({super.key});

  @override
  State<HomePantalla> createState() => _HomePantallaState();
}

class _HomePantallaState extends State<HomePantalla> {
  int _tabActual = 0;
  final FirestoreServicio _firestoreServicio = FirestoreServicio();
  final PageController _bannerController = PageController(
    viewportFraction: 0.88,
  );
  int _bannerActual = 0;

  static const Color _naranja = Color(0xFFFF441F);
  static const Color _verde = Color(0xFF00C5AB);
  static const Color _azulOscuro = Color(0xFF001D3D);

  final List<Map<String, dynamic>> _categoriasGrandes = [
    {
      'nombre': 'Restaurantes',
      'img':
          'https://raw.githubusercontent.com/ARROYOCARLOS0478/imagenes/refs/heads/main/hamburguesa.png',
      'color': const Color(0xFFFCE4EC),
    },
    {
      'nombre': 'Supermercado',
      'img':
          'https://raw.githubusercontent.com/ARROYOCARLOS0478/imagenes/refs/heads/main/carrito-super.png',
      'color': const Color(0xFFE8F5E9),
    },
  ];

  final List<Map<String, dynamic>> _categoriasChicas = [
    {
      'nombre': 'Farmacia',
      'img':
          'https://raw.githubusercontent.com/ARROYOCARLOS0478/imagenes/refs/heads/main/botiquin.jfif',
    },
    {
      'nombre': 'Tiendas',
      'img':
          'https://images.unsplash.com/photo-1761333477936-56fbc7851c65?w=400',
    },
    {
      'nombre': 'Express',
      'img':
          'https://raw.githubusercontent.com/ARROYOCARLOS0478/imagenes/refs/heads/main/express.jfif',
    },
    {
      'nombre': 'Licor',
      'img':
          'https://raw.githubusercontent.com/ARROYOCARLOS0478/imagenes/refs/heads/main/Licor.jfif',
    },
  ];

  final List<Map<String, dynamic>> _banners = [
    {
      'titulo': 'ENVÍO GRATIS',
      'subtitulo': 'EN TU PRIMER SÚPER',
      'img': 'https://images.unsplash.com/photo-1542838132-92c53300491e?w=800',
      'categoria': 'Supermercado',
    },
    {
      'titulo': 'BUCKET FAMILIAR',
      'subtitulo': 'PRECIO ESPECIAL',
      'img':
          'https://images.unsplash.com/photo-1513639776629-7b61b0ac49cb?w=800',
      'categoria': 'Restaurantes',
    },
    {
      'titulo': 'TEMPORADA DE REGALOS',
      'subtitulo': 'HASTA 15 MESES SIN INTERESES',
      'img': 'https://images.unsplash.com/photo-1560243563-062abb001529?w=800',
      'categoria': 'Tiendas',
    },
  ];

  @override
  void dispose() {
    _bannerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authProv = Provider.of<AutenticacionProveedor>(context);
    final carritoP = Provider.of<CarritoProveedor>(context);
    final bool esAdmin = authProv.usuarioDatos?.rol == 'admin';

    final List<Widget> pantallas = [
      _construirHome(authProv, carritoP),
      _buildOfertasTab(),
      _buildFavoritosTab(authProv),
      const PerfilPantalla(esTab: true),
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            if (esAdmin) _buildAdminBanner(),
            Expanded(
              child: Stack(
                children: [
                  IndexedStack(index: _tabActual, children: pantallas),
                  if (_tabActual == 0)
                    _buildSeguimientoRealTime(authProv.usuarioDatos?.uid),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildSeguimientoRealTime(String? userId) {
    if (userId == null) return const SizedBox.shrink();

    return StreamBuilder<List<Pedido>>(
      stream: _firestoreServicio.obtenerPedidosActivos(userId),
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const SizedBox.shrink();
        }

        final ultimoPedido = snapshot.data!.first;

        return Positioned(
          bottom: 20,
          left: 20,
          right: 20,
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      SeguimientoPedidoPantalla(pedidoId: ultimoPedido.id!),
                ),
              );
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              decoration: BoxDecoration(
                color: _azulOscuro,
                borderRadius: BorderRadius.circular(22),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 16,
                    offset: Offset(0, 6),
                  ),
                ],
              ),
              child: Row(
                children: [
                  const Icon(Icons.delivery_dining, color: _verde, size: 28),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          ultimoPedido.estado.toUpperCase(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w900,
                            fontSize: 12,
                          ),
                        ),
                        Text(
                          'Pedido de ${ultimoPedido.comercioNombre}',
                          style: const TextStyle(
                            color: Colors.white60,
                            fontSize: 10,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  const Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.white,
                    size: 14,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildAdminBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 7),
      color: Colors.black,
      child: const Text(
        'MODO ADMINISTRADOR ACTIVADO',
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.bold,
          letterSpacing: 2,
        ),
      ),
    );
  }

  Widget _construirHome(
    AutenticacionProveedor authProv,
    CarritoProveedor carritoP,
  ) {
    final uid = authProv.usuarioDatos?.uid;
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        SliverToBoxAdapter(child: _buildHeader(authProv, carritoP)),
        if (uid != null)
          SliverToBoxAdapter(child: _buildBannerSeguimientoPremium(uid)),
        SliverToBoxAdapter(child: _buildBanners()),
        SliverToBoxAdapter(child: _buildCategoriasGrandes()),
        SliverToBoxAdapter(child: _buildCategoriasChicas()),
        _buildOfertasSection(),
        SliverToBoxAdapter(child: _buildSectionLabel('CERCA DE TI')),
        _buildListaComercios(),
        const SliverToBoxAdapter(child: SizedBox(height: 120)),
      ],
    );
  }

  Widget _buildHeader(AutenticacionProveedor auth, CarritoProveedor carrito) {
    final direccion = auth.usuarioDatos?.direcciones.isNotEmpty == true
        ? auth.usuarioDatos!.direcciones.first
        : null;
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 10),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const GestionDireccionesPantalla(),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Ciudad Juárez',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              direccion != null
                                  ? direccion.toUpperCase()
                                  : 'AGREGA UNA DIRECCIÓN',
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 11,
                                color: direccion != null
                                    ? Colors.grey[600]
                                    : _naranja,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const Icon(
                            Icons.keyboard_arrow_down,
                            size: 16,
                            color: _naranja,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              if (carrito.cantidadTotal > 0) _buildCartBadge(carrito),
            ],
          ),
          const SizedBox(height: 14),
          _buildSearchBar(),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(16),
      ),
      child: const TextField(
        decoration: InputDecoration(
          icon: Icon(Icons.search, size: 20, color: Colors.grey),
          hintText: '¿Qué quisieras hoy?',
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 14),
        ),
      ),
    );
  }

  Widget _buildCartBadge(CarritoProveedor carrito) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const CarritoPantalla()),
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: _verde,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: _verde.withValues(alpha: 0.3),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            const Icon(
              Icons.shopping_bag_outlined,
              color: Colors.white,
              size: 18,
            ),
            const SizedBox(width: 6),
            Text(
              '${carrito.cantidadTotal}',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 1. Agrega este Widget arriba de tu lista de comercios (Premium Stepper)
  Widget _buildBannerSeguimientoPremium(String usuarioId) {
    return StreamBuilder<List<Pedido>>(
      stream: _firestoreServicio.obtenerPedidosActivos(usuarioId),
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const SizedBox.shrink();
        }

        final pedido = snapshot.data!.first;
        final estado = pedido.estado;

        int stepActual = 0;
        String mensajeEstado = "Alistando tu pedido";
        switch (estado.toLowerCase()) {
          case 'pendiente':
            stepActual = 0;
            mensajeEstado = "Alistando tu pedido";
            break;
          case 'preparando':
            stepActual = 1;
            mensajeEstado = "Preparando tu pedido";
            break;
          case 'en camino':
            stepActual = 2;
            mensajeEstado = "Tu pedido va en camino";
            break;
          case 'entregado':
            stepActual = 3;
            mensajeEstado = "Pedido entregado";
            break;
        }

        final pasos = [
          {'icon': Icons.inventory_2},
          {'icon': Icons.restaurant},
          {'icon': Icons.directions_bike},
          {'icon': Icons.check_circle},
        ];

        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) =>
                    SeguimientoPedidoPantalla(pedidoId: pedido.id!),
              ),
            );
          },
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(28),
              border: Border.all(color: Colors.grey.shade100, width: 1.5),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade200,
                  blurRadius: 16,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "PEDIDO EN CURSO",
                      style: TextStyle(
                        color: _verde,
                        fontWeight: FontWeight.w900,
                        fontSize: 10,
                        letterSpacing: 1.2,
                      ),
                    ),
                    Icon(
                      Icons.keyboard_arrow_right,
                      color: Colors.grey[400],
                      size: 20,
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  pedido.comercioNombre.toUpperCase(),
                  style: const TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 14,
                    color: _azulOscuro,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  mensajeEstado.toUpperCase(),
                  style: TextStyle(
                    color: Colors.grey[800],
                    fontWeight: FontWeight.w900,
                    fontSize: 11,
                    letterSpacing: -0.2,
                  ),
                ),
                const SizedBox(height: 20),

                // Stepper horizontal
                Stack(
                  alignment: Alignment.center,
                  children: [
                    // Línea gris de fondo
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Container(
                        height: 2,
                        color: Colors.grey[100],
                      ),
                    ),
                    // Línea verde activa que avanza
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: FractionallySizedBox(
                          widthFactor: stepActual / 3.0,
                          child: Container(
                            height: 2,
                            color: _verde,
                          ),
                        ),
                      ),
                    ),
                    // Iconos de pasos
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: List.generate(4, (idx) {
                        final activo = idx <= stepActual;
                        return Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: activo ? _verde : Colors.grey.shade200,
                              width: 2,
                            ),
                            boxShadow: activo
                                ? [
                                    BoxShadow(
                                      color: _verde.withAlpha(30),
                                      blurRadius: 4,
                                      spreadRadius: 1,
                                    ),
                                  ]
                                : [],
                          ),
                          child: Icon(
                            pasos[idx]['icon'] as IconData,
                            size: 15,
                            color: activo ? _verde : Colors.grey[300],
                          ),
                        );
                      }),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildBanners() {
    return SizedBox(
      height: 155,
      child: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _bannerController,
              itemCount: _banners.length,
              onPageChanged: (i) => setState(() => _bannerActual = i),
              itemBuilder: (_, i) {
                final b = _banners[i];
                return GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          SeccionNegociosPantalla(categoria: b['categoria']),
                    ),
                  ),
                  child: Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(22),
                      image: DecorationImage(
                        image: NetworkImage(b['img']),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(22),
                        gradient: LinearGradient(
                          colors: [
                            Colors.black.withValues(alpha: 0.7),
                            Colors.transparent,
                          ],
                          begin: Alignment.centerLeft,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: _naranja,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Text(
                              'EXCLUSIVO',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 8,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            b['titulo'],
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w900,
                              fontSize: 18,
                            ),
                          ),
                          Text(
                            b['subtitulo'],
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              _banners.length,
              (i) => AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                margin: const EdgeInsets.symmetric(horizontal: 3),
                width: _bannerActual == i ? 16 : 6,
                height: 6,
                decoration: BoxDecoration(
                  color: _bannerActual == i ? _naranja : Colors.grey[300],
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoriasGrandes() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 0),
      child: Row(
        children: _categoriasGrandes.asMap().entries.map((e) {
          final cat = e.value;
          return Expanded(
            child: GestureDetector(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      SeccionNegociosPantalla(categoria: cat['nombre']),
                ),
              ),
              child: Container(
                height: 115,
                margin: EdgeInsets.only(right: e.key == 0 ? 10 : 0),
                decoration: BoxDecoration(
                  color: cat['color'],
                  borderRadius: BorderRadius.circular(22),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.network(
                      cat['img'],
                      height: 62,
                      errorBuilder: (ctx, _, _) =>
                          const Icon(Icons.store, size: 50),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      cat['nombre'].toString().toUpperCase(),
                      style: const TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildCategoriasChicas() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: _categoriasChicas.map((cat) {
          return GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) =>
                    SeccionNegociosPantalla(categoria: cat['nombre']),
              ),
            ),
            child: Column(
              children: [
                Container(
                  width: 64,
                  height: 64,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Image.network(
                    cat['img'],
                    fit: BoxFit.contain,
                    errorBuilder: (ctx, _, _) => const Icon(Icons.store),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  cat['nombre'].toString().toUpperCase(),
                  style: const TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 8,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildSectionLabel(String texto) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 12),
      child: Row(
        children: [
          const Icon(Icons.bolt, color: _naranja, size: 18),
          const SizedBox(width: 6),
          Text(
            texto,
            style: const TextStyle(
              fontWeight: FontWeight.w900,
              fontSize: 12,
              letterSpacing: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListaComercios() {
    return StreamBuilder<List<Comercio>>(
      stream: _firestoreServicio.obtenerComercios(),
      builder: (context, snap) {
        if (snap.connectionState == ConnectionState.waiting) {
          return const SliverToBoxAdapter(
            child: Center(
              child: Padding(
                padding: EdgeInsets.all(30),
                child: CircularProgressIndicator(color: _naranja),
              ),
            ),
          );
        }
        final comercios = snap.data ?? [];
        return SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, i) => _buildComercioCard(comercios[i]),
              childCount: comercios.length,
            ),
          ),
        );
      },
    );
  }

  Widget _buildOfertasSection() {
    return StreamBuilder<List<Comercio>>(
      stream: _firestoreServicio.obtenerComerciosConOferta(),
      builder: (context, snapshot) {
        final ofertas = snapshot.data ?? [];
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 24),
              child: Center(child: CircularProgressIndicator()),
            ),
          );
        }
        if (ofertas.isEmpty) {
          return const SliverToBoxAdapter(child: SizedBox.shrink());
        }

        return SliverToBoxAdapter(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionLabel('OFERTAS'),
              SizedBox(
                height: 180,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: ofertas.length,
                  itemBuilder: (context, index) {
                    final comercio = ofertas[index];
                    return _buildOfertaMiniCard(comercio);
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildOfertaMiniCard(Comercio comercio) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => DetalleComercioPantalla(comercio: comercio),
        ),
      ),
      child: Container(
        width: 230,
        margin: const EdgeInsets.only(right: 16, bottom: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          image: DecorationImage(
            image: NetworkImage(comercio.imagenUrl),
            fit: BoxFit.cover,
            onError: (_, __) {},
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [Colors.black.withAlpha(180), Colors.transparent],
            ),
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFFF441F).withAlpha(220),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  '-${comercio.descuentoNegocio}% Oferta',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 11,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                comercio.nombre,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOfertasTab() {
    return StreamBuilder<List<Comercio>>(
      stream: _firestoreServicio.obtenerComerciosConOferta(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        final comercios = snapshot.data ?? [];
        if (comercios.isEmpty) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(24),
              child: Text(
                'No hay ofertas activas en este momento.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ),
          );
        }
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: comercios.length,
          itemBuilder: (context, index) => _buildComercioCard(comercios[index]),
        );
      },
    );
  }

  Widget _buildFavoritosTab(AutenticacionProveedor authProv) {
    final uid = authProv.usuarioDatos?.uid ?? authProv.usuarioFirebase?.uid;
    if (uid == null) {
      return const Center(
        child: Text(
          'Inicia sesión para ver tus favoritos.',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      );
    }
    return StreamBuilder<List<Comercio>>(
      stream: _firestoreServicio.obtenerFavoritosUsuario(uid),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        final favoritos = snapshot.data ?? [];
        if (favoritos.isEmpty) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(24),
              child: Text(
                'Aún no tienes favoritos. Marca negocios con el corazón para guardarlos aquí.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ),
          );
        }
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: favoritos.length,
          itemBuilder: (context, index) => _buildComercioCard(favoritos[index]),
        );
      },
    );
  }

  Widget _buildComercioCard(Comercio c) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => DetalleComercioPantalla(comercio: c)),
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: Colors.grey.shade100, width: 1.5),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: Image.network(
                c.imagenUrl,
                width: 72,
                height: 72,
                fit: BoxFit.cover,
                errorBuilder: (ctx, _, _) => Container(
                  width: 72,
                  height: 72,
                  color: Colors.grey[200],
                  child: const Icon(Icons.store),
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    c.nombre.toUpperCase(),
                    style: const TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 13,
                    ),
                  ),
                  Text(
                    c.categoria.toUpperCase(),
                    style: const TextStyle(
                      color: _naranja,
                      fontWeight: FontWeight.w900,
                      fontSize: 9,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(
                        Icons.access_time_filled,
                        size: 12,
                        color: Colors.grey,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${c.tiempoEntrega} MIN',
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 10),
                      const Icon(Icons.star, size: 12, color: Colors.amber),
                      Text(
                        c.calificacion.toStringAsFixed(1),
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNav() {
    return BottomNavigationBar(
      currentIndex: _tabActual,
      onTap: (i) => setState(() => _tabActual = i),
      selectedItemColor: _naranja,
      unselectedItemColor: Colors.grey[400],
      type: BottomNavigationBarType.fixed,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: 'INICIO'),
        BottomNavigationBarItem(
          icon: Icon(Icons.local_offer),
          label: 'OFERTAS',
        ),
        BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'FAVORITOS'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'CUENTA'),
      ],
    );
  }
}
