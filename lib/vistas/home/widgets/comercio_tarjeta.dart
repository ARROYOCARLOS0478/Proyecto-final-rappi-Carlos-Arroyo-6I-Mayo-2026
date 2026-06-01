import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../core/tema_app.dart';
import '../../../modelos/comercio_modelo.dart';

class ComercioTarjeta extends StatelessWidget {
  final Comercio comercio;
  final VoidCallback onTap;

  const ComercioTarjeta({
    super.key,
    required this.comercio,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: TemaApp.sombraCard,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Imagen del comercio
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
              child: Stack(
                children: [
                  CachedNetworkImage(
                    imageUrl: comercio.imagenUrl,
                    height: 140,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    placeholder: (_, __) => Container(
                      height: 140,
                      color: Colors.grey.shade100,
                      child: const Center(
                        child: CircularProgressIndicator(
                          color: TemaApp.naranjaPrincipal,
                          strokeWidth: 2,
                        ),
                      ),
                    ),
                    errorWidget: (_, __, ___) => Container(
                      height: 140,
                      color: Colors.grey.shade100,
                      child: const Icon(
                        Icons.restaurant,
                        color: TemaApp.naranjaPrincipal,
                        size: 48,
                      ),
                    ),
                  ),
                  // Badge de categoría
                  Positioned(
                    top: 10,
                    left: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withAlpha(230),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        comercio.categoria,
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: TemaApp.textoOscuro,
                        ),
                      ),
                    ),
                  ),
                  // Badge activo/inactivo
                  if (!comercio.estaActivo)
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.black.withAlpha(120),
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20),
                          ),
                        ),
                        child: const Center(
                          child: Text(
                            'CERRADO',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),

            // Información del comercio
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    comercio.nombre,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: TemaApp.textoOscuro,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      // Rating
                      const Icon(
                        Icons.star_rounded,
                        color: Color(0xFFFFB800),
                        size: 16,
                      ),
                      const SizedBox(width: 3),
                      Text(
                        comercio.calificacion.toStringAsFixed(1),
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: TemaApp.textoOscuro,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        width: 3,
                        height: 3,
                        decoration: const BoxDecoration(
                          color: TemaApp.textoGris,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      // Tiempo de entrega
                      const Icon(
                        Icons.access_time_rounded,
                        color: TemaApp.textoGris,
                        size: 14,
                      ),
                      const SizedBox(width: 3),
                      Text(
                        comercio.tiempoEntrega,
                        style: const TextStyle(
                          fontSize: 12,
                          color: TemaApp.textoGris,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  // Costo de envío
                  Text(
                    comercio.costoEnvio == 0.0
                        ? '🎉 Envío gratis'
                        : '🛵 Envío \$${comercio.costoEnvio.toStringAsFixed(0)}',
                    style: TextStyle(
                      fontSize: 12,
                      color: comercio.costoEnvio == 0.0
                          ? TemaApp.verdeRappi
                          : TemaApp.textoGris,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
