import 'package:flutter/material.dart';
import 'package:frontend_eco_2/theme/app_colors.dart';
import 'package:frontend_eco_2/utils/avatar_catalog.dart';

/// Avatar del usuario, recortado en círculo.
///
/// Si no ha elegido ninguno muestra el icono genérico en vez de asignarle uno
/// por defecto: enseñar un personaje que la persona no eligió da la impresión
/// de que ya lo tiene puesto.
class UserAvatar extends StatelessWidget {
  /// Id guardado en el perfil (`agronoma`, `granjero`…).
  final String? avatarId;
  final double size;

  /// Aro de color alrededor. Se omite en tamaños pequeños, donde estorba.
  final bool ring;

  const UserAvatar({
    super.key,
    required this.avatarId,
    this.size = 56,
    this.ring = true,
  });

  @override
  Widget build(BuildContext context) {
    final asset = avatarAssetFor(avatarId);

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: const Color(0xFFE2E7E4),
        border: ring
            ? Border.all(color: AppColors.primary, width: size * 0.03 + 1)
            : null,
      ),
      clipBehavior: Clip.antiAlias,
      child: asset == null
          ? Icon(Icons.person, size: size * 0.6, color: AppColors.primary)
          : Image.asset(
              asset,
              fit: BoxFit.cover,
              // El PNG es de 348 px; a tamaños grandes conviene que el filtrado
              // suavice en vez de dejar el borde escalonado.
              filterQuality: FilterQuality.medium,
              errorBuilder: (_, _, _) => Icon(
                Icons.person,
                size: size * 0.6,
                color: AppColors.primary,
              ),
            ),
    );
  }
}

/// Hoja para elegir avatar. Devuelve el id elegido, o null si se cierra sin
/// elegir; el llamante distingue así "no cambió nada" de "quitó el avatar".
Future<String?> showAvatarPicker(
  BuildContext context, {
  required String? current,
  required String title,
}) {
  return showModalBottomSheet<String>(
    context: context,
    backgroundColor: Colors.transparent,
    builder: (sheetContext) => SafeArea(
      child: Container(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
                fontFamily: 'DM Sans',
              ),
            ),
            const SizedBox(height: 16),
            GridView.count(
              crossAxisCount: 4,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 0.82,
              children: [
                for (final option in kAvatars)
                  GestureDetector(
                    onTap: () => Navigator.pop(sheetContext, option.id),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Stack(
                          alignment: Alignment.bottomRight,
                          children: [
                            UserAvatar(avatarId: option.id, size: 64),
                            if (option.id == current)
                              Container(
                                decoration: const BoxDecoration(
                                  color: AppColors.primary,
                                  shape: BoxShape.circle,
                                ),
                                padding: const EdgeInsets.all(3),
                                child: const Icon(Icons.check_rounded,
                                    size: 12, color: Colors.white),
                              ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          avatarName(context, option.id),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 11,
                            color: AppColors.textSecondary,
                            fontFamily: 'Inter',
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}
