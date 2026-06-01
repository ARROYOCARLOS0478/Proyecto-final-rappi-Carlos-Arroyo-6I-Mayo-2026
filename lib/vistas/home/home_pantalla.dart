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
import '../carrito/carrito_pantalla.dart'; // Importante para la navegación
import '../seguimiento/seguimiento_pedido_pantalla.dart';

class HomePantalla extends StatefulWidget {
  const HomePantalla({super.key});

  @override
  State<HomePantalla> createState() => _HomePantallaState();
}

class _HomePantallaState extends State<HomePantalla> {
  int _tabActual = 0;
  final FirestoreServicio _firestoreServicio = FirestoreServicio();

  final List<Map<String, dynamic>> _categoriasDiseno = [
    {
      "nombre": "Restaurantes",
      "img":
          "https://raw.githubusercontent.com/ARROYOCARLOS0478/imagenes/refs/heads/main/hamburguesa.png",
      "color": const Color(0xFFFCE4EC),
      "size": "large",
    },
    {
      "nombre": "Supermercado",
      "img":
          "https://raw.githubusercontent.com/ARROYOCARLOS0478/imagenes/refs/heads/main/carrito-super.png",
      "color": const Color(0xFFE8F5E9),
      "size": "large",
    },
    {
      "nombre": "Farmacia",
      "img":
          "https://raw.githubusercontent.com/ARROYOCARLOS0478/imagenes/refs/heads/main/botiquin.jfif",
      "size": "small",
    },
    {
      "nombre": "Tiendas",
      "img":
          "https://images.unsplash.com/photo-1761333477936-56fbc7851c65?w=400",
      "size": "small",
    },
    {
      "nombre": "Express",
      "img":
          "https://raw.githubusercontent.com/ARROYOCARLOS0478/imagenes/refs/heads/main/express.jfif",
      "size": "small",
    },
    {
      "nombre": "Licor",
      "img":
          "https://raw.githubusercontent.com/ARROYOCARLOS0478/imagenes/refs/heads/main/Licor.jfif",
      "size": "small",
    },
  ];

  @override
  Widget build(BuildContext context) {
    final authProv = Provider.of<AutenticacionProveedor>(context);
    final carritoP = Provider.of<CarritoProveedor>(context);
    bool esAdmin = authProv.usuarioDatos?.rol == 'admin';

    final List<Widget> pantallas = [
      _construirHome(authProv, carritoP),
      const Center(child: Text("Pantalla de Ofertas")),
      const Center(child: Text("Pantalla de Favoritos")),
      const PerfilPantalla(esTab: true),
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          // Stack para que la ventana de seguimiento flote arriba
          children: [
            Column(
              children: [
                if (esAdmin) _buildAdminBanner(),
                Expanded(
                  child: IndexedStack(index: _tabActual, children: pantallas),
                ),
              ],
            ),
            // Ventana flotante de seguimiento (solo si hay items o un pedido simulado)
            if (carritoP.cantidadTotal > 0 && _tabActual == 0)
              _buildSeguimientoFlotante(),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  // --- NUEVA VENTANA DE SEGUIMIENTO ESTILO FIGMA ---
  Widget _buildSeguimientoFlotante() {
    return Positioned(
      bottom: 20,
      left: 20,
      right: 20,
      child: GestureDetector(
        onTap: () {
          // Aquí podrías navegar a la pantalla de seguimiento real
          // Navigator.push(context, MaterialPageRoute(builder: (_) => const SeguimientoPedidoPantalla(pedidoId: "TEMP123")));
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          decoration: BoxDecoration(
            color: const Color(0xFF001D3D), // Azul oscuro Figma
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(40),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Row(
            children: [
              const Icon(
                Icons.delivery_dining,
                color: Color(0xFF00C5AB),
                size: 30,
              ),
              const SizedBox(width: 15),
              const Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "TU PEDIDO ESTÁ EN CAMINO",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                        fontSize: 12,
                      ),
                    ),
                    Text(
                      "Llegada estimada: 15-20 min",
                      style: TextStyle(color: Colors.white70, fontSize: 10),
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
  }

  Widget _buildAdminBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 6),
      color: Colors.black,
      child: const Text(
        "MODO ADMINISTRADOR ACTIVADO",
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
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        SliverToBoxAdapter(child: _buildHeader(authProv, carritoP)),
        SliverToBoxAdapter(child: _buildHeroBanner()),

        // Categorías Grandes
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            child: Row(
              children: _categoriasDiseno
                  .where((c) => c['size'] == 'large')
                  .map((cat) {
                    return Expanded(child: _buildCategoryCardLarge(cat));
                  })
                  .toList(),
            ),
          ),
        ),

        // Categorías Pequeñas
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: _categoriasDiseno
                  .where((c) => c['size'] == 'small')
                  .map((cat) {
                    return _buildCategoryCardSmall(cat);
                  })
                  .toList(),
            ),
          ),
        ),

        const SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.fromLTRB(20, 25, 20, 15),
            child: Text(
              "CERCA DE TI",
              style: TextStyle(
                fontWeight: FontWeight.w900,
                fontSize: 13,
                letterSpacing: 1.5,
              ),
            ),
          ),
        ),

        StreamBuilder<List<Comercio>>(
          stream: _firestoreServicio.obtenerComercios(),
          builder: (context, snap) {
            if (snap.connectionState == ConnectionState.waiting)
              return const SliverToBoxAdapter(
                child: Center(child: CircularProgressIndicator()),
              );
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
        ),
        const SliverToBoxAdapter(
          child: SizedBox(height: 120),
        ), // Espacio extra para que no tape la ventana flotante
      ],
    );
  }

  Widget _buildHeader(AutenticacionProveedor auth, CarritoProveedor carrito) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
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
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          auth.usuarioDatos?.direcciones.firstOrNull ??
                              'AV. DE LA RAZA 1234',
                          style: const TextStyle(
                            fontSize: 11,
                            color: Colors.grey,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Icon(
                          Icons.keyboard_arrow_down,
                          size: 16,
                          color: Color(0xFFFF441F),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // CORRECCIÓN: Botón del carrito que SI funciona
              _buildCartBadge(carrito),
            ],
          ),
          const SizedBox(height: 15),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(15),
            ),
            child: const TextField(
              decoration: InputDecoration(
                icon: Icon(Icons.search, size: 20),
                hintText: '¿Qué quisieras hoy?',
                border: InputBorder.none,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCartBadge(CarritoProveedor carrito) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const CarritoPantalla()),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: const Color(0xFF00C5AB), // Verde Rappi
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF00C5AB).withAlpha(60),
              blurRadius: 8,
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
            if (carrito.cantidadTotal > 0) ...[
              const SizedBox(width: 5),
              Text(
                '${carrito.cantidadTotal}',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  // --- RESTO DE WIDGETS DE DISEÑO ---
  Widget _buildHeroBanner() {
    return AspectRatio(
      aspectRatio: 16 / 7,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          image: const DecorationImage(
            image: NetworkImage(
              "https://images.unsplash.com/photo-1542838132-92c53300491e?w=800",
            ),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            gradient: LinearGradient(
              colors: [Colors.black.withAlpha(180), Colors.transparent],
              begin: Alignment.centerLeft,
            ),
          ),
          child: const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "ENVÍO GRATIS",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                  fontSize: 18,
                ),
              ),
              Text(
                "En tu primer pedido",
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryCardLarge(Map<String, dynamic> cat) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => SeccionNegociosPantalla(categoria: cat['nombre']),
        ),
      ),
      child: Container(
        height: 100,
        margin: EdgeInsets.only(
          right: cat['nombre'] == 'Restaurantes' ? 10 : 0,
        ),
        decoration: BoxDecoration(
          color: cat['color'],
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.network(cat['img'], height: 50),
            Text(
              cat['nombre'].toUpperCase(),
              style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 10),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryCardSmall(Map<String, dynamic> cat) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => SeccionNegociosPantalla(categoria: cat['nombre']),
        ),
      ),
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(18),
            ),
            child: Image.network(cat['img'], fit: BoxFit.contain),
          ),
          const SizedBox(height: 5),
          Text(
            cat['nombre'].toUpperCase(),
            style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 8),
          ),
        ],
      ),
    );
  }

  Widget _buildComercioCard(Comercio c) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => DetalleComercioPantalla(comercio: c)),
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 15),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
          border: Border.all(color: Colors.grey.shade100),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Image.network(
                c.imagenUrl,
                width: 70,
                height: 70,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 15),
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
                      color: Color(0xFFFF441F),
                      fontWeight: FontWeight.w900,
                      fontSize: 9,
                    ),
                  ),
                  const SizedBox(height: 5),
                  const Row(
                    children: [
                      Icon(
                        Icons.access_time_filled,
                        size: 14,
                        color: Colors.grey,
                      ),
                      SizedBox(width: 4),
                      Text(
                        "15-25 MIN • 4.5 ★",
                        style: TextStyle(
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
      selectedItemColor: const Color(0xFFFF441F),
      unselectedItemColor: Colors.grey[300],
      type: BottomNavigationBarType.fixed,
      backgroundColor: Colors.white,
      elevation: 10,
      selectedLabelStyle: const TextStyle(
        fontWeight: FontWeight.w900,
        fontSize: 10,
      ),
      unselectedLabelStyle: const TextStyle(
        fontWeight: FontWeight.w900,
        fontSize: 10,
      ),
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: "INICIO"),
        BottomNavigationBarItem(
          icon: Icon(Icons.local_offer),
          label: "OFERTAS",
        ),
        BottomNavigationBarItem(icon: Icon(Icons.favorite), label: "FAVORITOS"),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: "CUENTA"),
      ],
    );
  }
}
