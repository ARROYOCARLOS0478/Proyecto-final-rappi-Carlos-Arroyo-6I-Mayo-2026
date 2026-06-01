import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../core/tema_app.dart';
import '../../core/constantes.dart';
import '../../modelos/pedido_modelo.dart';
import '../../modelos/usuario_modelo.dart';
import '../../proveedores/autenticacion_proveedor.dart';
import '../../proveedores/pedido_proveedor.dart';
import '../../servicios/firestore_servicio.dart';
import '../login/login_pantalla.dart';
import '../seguimiento/seguimiento_pedido_pantalla.dart';
import '../admin/admin_home_pantalla.dart';
// IMPORTANTE: Asegúrate de que esta ruta sea la correcta para tus direcciones
import 'gestion_direcciones_pantalla.dart'; 

class PerfilPantalla extends StatelessWidget {
  final bool esTab;

  const PerfilPantalla({super.key, this.esTab = false});

  @override
  Widget build(BuildContext context) {
    final authProv = Provider.of<AutenticacionProveedor>(context);
    final firestoreServicio = FirestoreServicio();

    final uid = authProv.usuarioDatos?.uid ?? authProv.usuarioFirebase?.uid;
    final usuario = authProv.usuarioDatos;
    final fotoUrl = authProv.usuarioFirebase?.photoURL;

    Widget cuerpo = Column(
      children: [
        // Header del perfil
        Container(
          decoration: const BoxDecoration(
            gradient: TemaApp.gradienteHeader,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(28),
              bottomRight: Radius.circular(28),
            ),
          ),
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
          child: Column(
            children: [
              if (esTab)
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Mi Perfil',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              if (esTab) const SizedBox(height: 16),
              CircleAvatar(
                radius: 50,
                backgroundColor: Colors.white.withAlpha(40),
                backgroundImage: fotoUrl != null ? NetworkImage(fotoUrl) : null,
                child: fotoUrl == null
                    ? Text(
                        usuario?.nombre.isNotEmpty == true
                            ? usuario!.nombre[0].toUpperCase()
                            : 'U',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    : null,
              ),
              const SizedBox(height: 14),
              Text(
                usuario?.nombre ?? 'Usuario',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                usuario?.email ?? '',
                style: TextStyle(
                  color: Colors.white.withAlpha(200),
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withAlpha(30),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  usuario?.rol == Constantes.rolAdministrador
                      ? '👑 Administrador'
                      : usuario?.rol == Constantes.rolRepartidor
                      ? '🛵 Repartidor'
                      : '🛒 Cliente',
                  style: const TextStyle(color: Colors.white, fontSize: 13),
                ),
              ),
            ],
          ),
        ),

        if (uid != null)
          Expanded(
            child: StreamBuilder<List<Pedido>>(
              stream: firestoreServicio.obtenerPedidosUsuario(uid),
              builder: (ctx, snap) {
                final pedidos = snap.data ?? [];

                return ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    // --- ESTADÍSTICAS ---
                    Row(
                      children: [
                        Expanded(
                          child: _EstaCard(
                            valor: '${pedidos.length}',
                            label: 'Pedidos',
                            icon: Icons.receipt_long,
                            color: TemaApp.naranjaPrincipal,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _EstaCard(
                            valor: pedidos.isEmpty
                                ? '\$0'
                                : '\$${pedidos.fold<double>(0, (sum, p) => sum + p.total).toStringAsFixed(0)}',
                            label: 'Gastado',
                            icon: Icons.payments_outlined,
                            color: TemaApp.verdeRappi,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _EstaCard(
                            valor: '${pedidos.where((p) => p.estado == Constantes.estadoEntregado).length}',
                            label: 'Completados',
                            icon: Icons.check_circle_outline,
                            color: const Color(0xFF6366F1),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // --- NUEVOS BOTONES DE GESTIÓN (Direcciones y Editar) ---
                    Row(
                      children: [
                        Expanded(
                          child: _BotonAccionPerfil(
                            label: 'Mis Direcciones',
                            icon: Icons.location_on_outlined,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) => const GestionDireccionesPantalla()),
                              );
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _BotonAccionPerfil(
                            label: 'Editar Perfil',
                            icon: Icons.edit_outlined,
                            onTap: () => _mostrarFormularioEdicion(context, usuario),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // --- HISTORIAL ---
                    const Text(
                      'Historial de pedidos',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: TemaApp.textoOscuro,
                      ),
                    ),
                    const SizedBox(height: 12),

                    if (snap.connectionState == ConnectionState.waiting)
                      const Center(child: CircularProgressIndicator(color: TemaApp.naranjaPrincipal))
                    else if (pedidos.isEmpty)
                      _buildSinPedidos()
                    else
                      ...pedidos.map((p) => _PedidoHistorialItem(
                        pedido: p,
                        onTap: p.id != null 
                          ? () => Navigator.push(context, MaterialPageRoute(builder: (_) => SeguimientoPedidoPantalla(pedidoId: p.id!)))
                          : null,
                      )),

                    const SizedBox(height: 24),

                    // --- PANEL ADMIN (SI ES ADMIN) ---
                    if (usuario?.rol == Constantes.rolAdministrador) ...[
                      ElevatedButton.icon(
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (_) => const AdminHomePantalla()));
                        },
                        icon: const Icon(Icons.admin_panel_settings),
                        label: const Text('Panel de Administración'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: TemaApp.naranjaPrincipal,
                          foregroundColor: Colors.white,
                          minimumSize: const Size(double.infinity, 50),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],

                    // --- BOTÓN CERRAR SESIÓN ---
                    OutlinedButton.icon(
                      onPressed: () async {
                        await authProv.logout();
                        if (context.mounted) {
                          Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
                            MaterialPageRoute(builder: (_) => const LoginPantalla()),
                            (route) => false,
                          );
                        }
                      },
                      icon: const Icon(Icons.logout, color: TemaApp.rojoAcento),
                      label: const Text('Cerrar sesión', style: TextStyle(color: TemaApp.rojoAcento)),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: TemaApp.rojoAcento),
                        minimumSize: const Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                    ),
                    const SizedBox(height: 40),
                  ],
                );
              },
            ),
          ),
      ],
    );

    if (esTab) return cuerpo;

    return Scaffold(
      backgroundColor: TemaApp.fondoClaro,
      appBar: AppBar(title: const Text('Mi Perfil')),
      body: cuerpo,
    );
  }

  Widget _buildSinPedidos() {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: TemaApp.sombraCard,
      ),
      child: const Column(
        children: [
          Icon(Icons.shopping_bag_outlined, size: 48, color: TemaApp.textoGris),
          SizedBox(height: 12),
          Text('Sin pedidos aún', style: TextStyle(color: TemaApp.textoGris, fontSize: 16)),
        ],
      ),
    );
  }

  // --- FUNCIÓN PARA MOSTRAR EL FORMULARIO DE EDICIÓN ACTUALIZADA ---
  void _mostrarFormularioEdicion(BuildContext context, Usuario? usuario) {
    final authProv = Provider.of<AutenticacionProveedor>(context, listen: false);
    final nombreCtrl = TextEditingController(text: usuario?.nombre);
    final telefonoCtrl = TextEditingController(text: usuario?.telefono);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.fromLTRB(
          20, 
          20, 
          20, 
          MediaQuery.of(context).viewInsets.bottom + 20
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40, 
              height: 4, 
              decoration: BoxDecoration(
                color: Colors.grey[300], 
                borderRadius: BorderRadius.circular(10)
              )
            ),
            const SizedBox(height: 20),
            const Text(
              'Editar Perfil', 
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)
            ),
            const SizedBox(height: 25),
            TextField(
              controller: nombreCtrl,
              decoration: const InputDecoration(
                labelText: 'Nombre Completo', 
                border: OutlineInputBorder(), 
                prefixIcon: Icon(Icons.person_outline)
              ),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: telefonoCtrl,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                labelText: 'Teléfono', 
                border: OutlineInputBorder(), 
                prefixIcon: Icon(Icons.phone_android_outlined)
              ),
            ),
            const SizedBox(height: 25),
            
            // Usamos un StateSetter local para el botón de carga si fuera necesario, 
            // pero por ahora directo al grano:
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: TemaApp.naranjaPrincipal,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              ),
              onPressed: () async {
                if (nombreCtrl.text.trim().isEmpty) return;

                try {
                  // Ejecutamos la actualización en Firebase
                  await authProv.actualizarDatosUsuario({
                    'nombre': nombreCtrl.text.trim(),
                    'telefono': telefonoCtrl.text.trim(),
                  });

                  if (context.mounted) {
                    Navigator.pop(context); // Cierra el modal
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('¡Perfil actualizado!'),
                        backgroundColor: TemaApp.verdeRappi,
                      ),
                    );
                  }
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error: $e')),
                    );
                  }
                }
              },
              child: const Text(
                'Confirmar Cambios', 
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)
              ),
            )
          ],
        ),
      ),
    );
  }
}

// --- WIDGETS AUXILIARES ---

class _BotonAccionPerfil extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  const _BotonAccionPerfil({required this.label, required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: TemaApp.naranjaPrincipal.withAlpha(50)),
          borderRadius: BorderRadius.circular(16),
          boxShadow: TemaApp.sombraCard,
        ),
        child: Column(
          children: [
            Icon(icon, color: TemaApp.naranjaPrincipal, size: 28),
            const SizedBox(height: 8),
            Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: TemaApp.textoOscuro)),
          ],
        ),
      ),
    );
  }
}

class _EstaCard extends StatelessWidget {
  final String valor;
  final String label;
  final IconData icon;
  final Color color;

  const _EstaCard({required this.valor, required this.label, required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: TemaApp.sombraCard,
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 26),
          const SizedBox(height: 8),
          Text(valor, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color)),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(fontSize: 12, color: TemaApp.textoGris)),
        ],
      ),
    );
  }
}

class _PedidoHistorialItem extends StatelessWidget {
  final Pedido pedido;
  final VoidCallback? onTap;

  const _PedidoHistorialItem({required this.pedido, this.onTap});

  @override
  Widget build(BuildContext context) {
    Color colorEstado = _colorEstado(pedido.estado);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: TemaApp.sombraCard,
        ),
        child: Row(
          children: [
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(color: colorEstado.withAlpha(20), borderRadius: BorderRadius.circular(12)),
              child: Icon(Icons.receipt_long_outlined, color: colorEstado, size: 24),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Pedido #${pedido.id?.substring(0, 8).toUpperCase() ?? '---'}',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  const SizedBox(height: 4),
                  Text('${pedido.items.length} producto(s) • \$${pedido.total.toStringAsFixed(2)}',
                      style: const TextStyle(color: TemaApp.textoGris, fontSize: 13)),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: TemaApp.textoGris, size: 20),
          ],
        ),
      ),
    );
  }

  Color _colorEstado(String estado) {
    switch (estado) {
      case Constantes.estadoEntregado: return TemaApp.verdeRappi;
      case Constantes.estadoEnCamino: return TemaApp.naranjaPrincipal;
      case Constantes.estadoCancelado: return TemaApp.rojoAcento;
      default: return TemaApp.textoGris;
    }
  }
}