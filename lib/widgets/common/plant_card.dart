import 'package:flutter/material.dart';
import 'package:frontend_eco_2/models/models.dart';
import 'package:frontend_eco_2/theme/app_colors.dart';

// ── Species metadata ──────────────────────────────────────────────────────────
class PlantSpeciesInfo {
  final String scientificName;
  final List<String> tags;
  final Color imageBackgroundColor;
  final String? assetImage;

  const PlantSpeciesInfo({
    required this.scientificName,
    required this.tags,
    this.imageBackgroundColor = const Color(0xFFEAF3EC),
    this.assetImage,
  });
}

const _speciesInfo = {
  's1': PlantSpeciesInfo(
    scientificName: 'Monstera deliciosa',
    tags: ['Tropical', 'Luz Indirecta', 'Riego semanal'],
    imageBackgroundColor: Color(0xFFF2F7F2),
    assetImage: 'assets/images/monstera.png',
  ),
  's2': PlantSpeciesInfo(
    scientificName: 'Epipremnum aureum',
    tags: ['Tropical', 'Luz Indirecta', 'Riego semanal'],
    imageBackgroundColor: Color(0xFFEAF5EA),
  ),
  's3': PlantSpeciesInfo(
    scientificName: 'Sansevieria',
    tags: ['Desértica', 'Luz Adaptable', 'Riego 2-3 sem.'],
    imageBackgroundColor: Color(0xFFF0F4EC),
  ),
  's4': PlantSpeciesInfo(
    scientificName: 'Ficus lyrata',
    tags: ['Tropical', 'Luz brillante', 'Riego semanal'],
    imageBackgroundColor: Color(0xFFEAF0E8),
  ),
  's5': PlantSpeciesInfo(
    scientificName: 'Cactaceae',
    tags: ['Desértica', 'Pleno sol', 'Riego mensual'],
    imageBackgroundColor: Color(0xFFF5F2E8),
  ),
};

PlantSpeciesInfo _infoFor(String speciesId) =>
    _speciesInfo[speciesId] ??
    const PlantSpeciesInfo(
      scientificName: 'Especie desconocida',
      tags: ['Planta'],
    );

IconData _tagIcon(String tag) {
  final t = tag.toLowerCase();
  if (t.contains('tropical')) return Icons.spa_rounded;
  if (t.contains('luz')) return Icons.center_focus_strong_rounded;
  if (t.contains('riego') || t.contains('agua')) return Icons.water_drop_rounded;
  if (t.contains('sol')) return Icons.wb_sunny_rounded;
  return Icons.eco_rounded;
}

// ── Dashboard vertical card ───────────────────────────────────────────────────
class PlantCard extends StatelessWidget {
  final UserPlant plant;
  final VoidCallback onTap;

  const PlantCard({
    super.key,
    required this.plant,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final daysSinceWater = plant.lastWateredAt != null
        ? DateTime.now().difference(plant.lastWateredAt!).inDays
        : 10;
    final needsWater = daysSinceWater >= 7;
    final info = _infoFor(plant.speciesId);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: const Color(0xFFE5EAE7),
            width: 1.2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Image area ────────────────────────────────────────
            Expanded(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: info.imageBackgroundColor,
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                    ),
                    alignment: Alignment.center,
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: info.assetImage != null
                          ? Image.asset(
                              info.assetImage!,
                              fit: BoxFit.contain,
                              errorBuilder: (_, __, ___) => Icon(
                                Icons.local_florist_rounded,
                                size: 48,
                                color: AppColors.primary.withValues(alpha: 0.55),
                              ),
                            )
                          : Icon(
                              Icons.local_florist_rounded,
                              size: 48,
                              color: AppColors.primary.withValues(alpha: 0.55),
                            ),
                    ),
                  ),
                  // Badge — top right
                  Positioned(
                    top: 10,
                    right: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: needsWater ? AppColors.orange : AppColors.accent,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        '! Riego',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                          fontFamily: 'Inter',
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ── Info area ─────────────────────────────────────────
            Container(
              color: Colors.white,
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    plant.nickname,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                      color: AppColors.textPrimary,
                      fontFamily: 'DM Sans',
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    info.scientificName,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                      fontFamily: 'DM Sans',
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  // Tag chips
                  Wrap(
                    spacing: 4,
                    runSpacing: 4,
                    children: info.tags
                        .take(3)
                        .map((tag) => _buildTag(tag))
                        .toList(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTag(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(
        color: const Color(0xFFEFF2F1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(_tagIcon(text), size: 10, color: AppColors.primary),
          const SizedBox(width: 3),
          Text(
            text,
            style: const TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.w600,
              color: AppColors.primary,
              fontFamily: 'Inter',
            ),
          ),
        ],
      ),
    );
  }
}
