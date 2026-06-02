// home_pantalla.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../modelos/comercio_modelo.dart';
import '../../proveedores/autenticacion_proveedor.dart';
import '../../proveedores/carrito_proveedor.dart';
import '../../servicios/firestore_servicio.dart';
import '../catalogo/detalle_comercio_pantalla.dart';
import '../catalogo/seccion_negocios_pantalla.dart';
import '../perfil/perfil_pantalla.dart';
import '../perfil/gestion_direcciones_pantalla.dart';
import '../carrito/carrito_pantalla.dart';

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
      const Center(child: Text('Pantalla de Ofertas')),
      const Center(child: Text('Pantalla de Favoritos')),
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
                  if (carritoP.cantidadTotal > 0 && _tabActual == 0)
                    _buildSeguimientoFlotante(),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNav(),
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

  Widget _buildSeguimientoFlotante() {
    return Positioned(
      bottom: 20,
      left: 20,
      right: 20,
      child: GestureDetector(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const CarritoPantalla()),
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          decoration: BoxDecoration(
            color: _azulOscuro,
            borderRadius: BorderRadius.circular(22),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(60),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: const Row(
            children: [
              Icon(Icons.delivery_dining, color: _verde, size: 28),
              SizedBox(width: 14),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'TU PEDIDO ESTÁ EN CAMINO',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                        fontSize: 12,
                      ),
                    ),
                    Text(
                      'Llegada estimada: 15-20 min',
                      style: TextStyle(color: Colors.white60, fontSize: 10),
                    ),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios, color: Colors.white, size: 14),
            ],
          ),
        ),
      ),
    );
  }

  Widget _construirHome(
    AutenticacionProveedor authProv,
    CarritoProveedor carritoP,
  ) {
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        SliverToBoxAdapter(child: _buildHeader(authProv, carritoP)),
        SliverToBoxAdapter(child: _buildBanners()),
        SliverToBoxAdapter(child: _buildCategoriasGrandes()),
        SliverToBoxAdapter(child: _buildCategoriasChicas()),
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
            crossAxisAlignment: CrossAxisAlignment.center,
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
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 2),
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
                          const SizedBox(width: 2),
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
              const SizedBox(width: 12),
              // Carrito reactivo: SOLO aparece si hay items
              if (carrito.cantidadTotal > 0) _buildCartBadge(carrito),
            ],
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(16),
            ),
            child: const TextField(
              decoration: InputDecoration(
                icon: Icon(Icons.search, size: 20, color: Colors.grey),
                hintText: '¿Qué quisieras hoy?',
                hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(vertical: 14),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCartBadge(CarritoProveedor carrito) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const CarritoPantalla()),
      ),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: _verde,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: _verde.withAlpha(80),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
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
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
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
                            Colors.black.withAlpha(200),
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
                                letterSpacing: 1.5,
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
          final isFirst = e.key == 0;
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
                margin: EdgeInsets.only(right: isFirst ? 10 : 0),
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
                      errorBuilder: (_, __, ___) =>
                          const Icon(Icons.store, size: 50),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      cat['nombre'].toString().toUpperCase(),
                      style: const TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 10,
                        letterSpacing: 0.5,
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
                    errorBuilder: (_, __, ___) => const Icon(Icons.store),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  cat['nombre'].toString().toUpperCase(),
                  style: const TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 8,
                    letterSpacing: 0.3,
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
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(8),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
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
                errorBuilder: (_, __, ___) => Container(
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
                  const SizedBox(height: 2),
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
                      const SizedBox(width: 2),
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
      backgroundColor: Colors.white,
      elevation: 14,
      selectedLabelStyle: const TextStyle(
        fontWeight: FontWeight.w900,
        fontSize: 10,
      ),
      unselectedLabelStyle: const TextStyle(
        fontWeight: FontWeight.w900,
        fontSize: 10,
      ),
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
