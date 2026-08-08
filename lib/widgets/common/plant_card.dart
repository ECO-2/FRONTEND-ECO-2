import 'package:flutter/material.dart';
import 'package:frontend_eco_2/models/models.dart';
import 'package:frontend_eco_2/theme/app_colors.dart';
import 'package:frontend_eco_2/utils/plant_visuals.dart';

// ── Species metadata ──────────────────────────────────────────────────────────
class PlantSpeciesInfo {
  final String scientificName;
  final List<String> tags;
  final Color imageBackgroundColor;
  final String? assetImage;
  final IconData placeholderIcon;
  final Color placeholderIconColor;

  const PlantSpeciesInfo({
    required this.scientificName,
    required this.tags,
    this.imageBackgroundColor = const Color(0xFFEAF3EC),
    this.assetImage,
    this.placeholderIcon = Icons.local_florist_rounded,
    this.placeholderIconColor = const Color(0xFF10454F),
  });

  // Real catalog species (real UUID from the backend) get a category-based
  // icon/color instead of the single generic placeholder every species
  // used to share — there are no real per-species photos in the database.
  factory PlantSpeciesInfo.fromReal(PlantSpecies species) {
    final visual = visualForCategory(species.category);
    return PlantSpeciesInfo(
      scientificName: species.scientificName,
      tags: species.tags,
      imageBackgroundColor: visual.background,
      placeholderIcon: visual.icon,
      placeholderIconColor: visual.color,
    );
  }
}

const _legacySpeciesInfo = {
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

PlantSpeciesInfo _infoFor(String speciesId, PlantSpecies species) =>
    _legacySpeciesInfo[speciesId] ?? PlantSpeciesInfo.fromReal(species);

// ── Dashboard vertical card ───────────────────────────────────────────────────
class PlantCard extends StatelessWidget {
  final UserPlant plant;
  final PlantSpecies species;
  final VoidCallback onTap;

  const PlantCard({
    super.key,
    required this.plant,
    required this.species,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final daysSinceWater = plant.lastWateredAt != null
        ? DateTime.now().difference(plant.lastWateredAt!).inDays
        : 10;
    final needsWater = daysSinceWater >= 7;
    final info = _infoFor(plant.speciesId, species);

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
                              errorBuilder: (_, _, _) => Icon(
                                info.placeholderIcon,
                                size: 48,
                                color: info.placeholderIconColor.withValues(alpha: 0.55),
                              ),
                            )
                          : Icon(
                              info.placeholderIcon,
                              size: 48,
                              color: info.placeholderIconColor.withValues(alpha: 0.55),
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
                        .take(MediaQuery.of(context).size.width < 360 ? 1 : 2)
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
    final style = styleForTagKind(tagKindFor(text));
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(
        color: style.background,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(style.icon, size: 10, color: style.color),
          const SizedBox(width: 3),
          Text(
            text,
            style: TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.w600,
              color: style.color,
              fontFamily: 'Inter',
            ),
          ),
        ],
      ),
    );
  }
}
