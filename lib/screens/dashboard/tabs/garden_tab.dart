import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:frontend_eco_2/models/models.dart';
import 'package:frontend_eco_2/providers/providers.dart';
import 'package:frontend_eco_2/routing/app_routes.dart';
import 'package:frontend_eco_2/theme/app_colors.dart';
import 'package:frontend_eco_2/widgets/garden/add_plant_modal.dart';

// ── Figma color tokens ────────────────────────────────────────────────────
const _kDark = Color(0xFF10454F);
const _kBg = Color(0xFFF8FAF9);
const _kTextMuted = Color(0xFF807F7F);
const _kTextDark = Color(0xFF0D2B31);
const _kLime = Color(0xFFBDE038);

// Figma: Alert Banner fill = rgba(163,171,120,0.15), stroke = #10454F
const _kAlertBg = Color(0x26A3AB78); // ~15% opacity green-olive
const _kAlertBorder = _kDark;

// Chip filter labels
const _kFilters = ['Todas', 'Riegos', 'Interior', 'Exterior'];

class GardenTab extends StatefulWidget {
  const GardenTab({super.key});

  @override
  State<GardenTab> createState() => _GardenTabState();
}

class _GardenTabState extends State<GardenTab> {
  int _selectedFilter = 0;

  @override
  Widget build(BuildContext context) {
    final plantsProvider = Provider.of<PlantsProvider>(context);
    final plants = plantsProvider.userPlants;

    // Plants that need watering (not watered in >7 days)
    final plantsNeedingWater = plants.where((p) {
      if (p.lastWateredAt == null) return true;
      return DateTime.now().difference(p.lastWateredAt!).inDays >= 7;
    }).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Title section ─────────────────────────────────────
        _buildTitleSection(plants.length),

        // ── Filter chips ──────────────────────────────────────
        _buildFilterChips(),

        // ── Alert Banner ──────────────────────────────────────
        if (plantsNeedingWater.isNotEmpty)
          _buildAlertBanner(plantsNeedingWater.first.name),

        // ── Plants list ───────────────────────────────────────
        Expanded(
          child: ListView(
            padding: const EdgeInsets.only(
                left: 16, right: 16, top: 12, bottom: 100),
            children: [
              ...plants.map((plant) => Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: _PlantListCard(
                      plant: plant,
                      onTap: () => Navigator.pushNamed(
                        context,
                        AppRoutes.plantDetail,
                        arguments: plant,
                      ),
                      onWater: () => plantsProvider.waterPlant(plant.id),
                    ),
                  )),
              // Add plant button at the bottom
              _buildAddPlantButton(context, plants.length),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTitleSection(int plantCount) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Mi Jardín',
            style: TextStyle(
              fontFamily: 'DM Sans',
              fontWeight: FontWeight.w700,
              fontSize: 26,
              color: _kTextDark,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            '$plantCount plantas en tu colección',
            style: const TextStyle(
              fontFamily: 'DM Sans',
              fontWeight: FontWeight.w400,
              fontSize: 13,
              color: _kTextMuted,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChips() {
    return SizedBox(
      height: 48,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        itemCount: _kFilters.length,
        itemBuilder: (context, i) {
          final selected = _selectedFilter == i;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: GestureDetector(
              onTap: () => setState(() => _selectedFilter = i),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 6),
                decoration: BoxDecoration(
                  color: selected ? _kDark : Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: selected ? _kDark : const Color(0xFFDDE5E3),
                  ),
                ),
                child: Text(
                  _kFilters[i],
                  style: TextStyle(
                    fontFamily: 'DM Sans',
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                    color: selected ? Colors.white : _kTextMuted,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildAlertBanner(String plantName) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        // Figma: rgba(163,171,120,0.15) bg, 1px stroke #10454F, borderRadius 10
        color: const Color(0xFFA3AB78).withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: _kAlertBorder, width: 1),
      ),
      child: Row(
        children: [
          const Icon(Icons.warning_amber_rounded,
              color: _kDark, size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              '$plantName necesita riego',
              style: const TextStyle(
                fontFamily: 'DM Sans',
                fontWeight: FontWeight.w600,
                fontSize: 12,
                color: _kTextDark,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddPlantButton(BuildContext context, int plantCount) {
    return GestureDetector(
      onTap: () => showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (_) => const AddPlantModal(),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFF8FAF9),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Stack(
          children: [
            const Positioned.fill(
              child: CustomPaint(
                painter: _DashedCornerPainter(color: Color(0xFF8FA89F)),
              ),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Top: Plus + Icon Box
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          '+',
                          style: TextStyle(
                            fontFamily: 'DM Sans',
                            fontWeight: FontWeight.w500,
                            fontSize: 20,
                            color: _kDark,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: const Color(0xFF8FA89F),
                              width: 1.2,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.spa_rounded,
                            color: _kDark,
                            size: 20,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    // Text Title
                    const Text(
                      'Añadir Planta',
                      style: TextStyle(
                        fontFamily: 'DM Sans',
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                        color: _kTextDark,
                      ),
                    ),
                    const SizedBox(height: 2),
                    // Text Muted Subtitle
                    Text(
                      '[$plantCount macetas de 10 gratis]',
                      style: const TextStyle(
                        fontFamily: 'DM Sans',
                        fontSize: 11,
                        color: Color(0xFF8FA89F),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DashedCornerPainter extends CustomPainter {
  final Color color;
  const _DashedCornerPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round;

    final double r = 16.0; // Corner radius
    final double l = 8.0;  // Extension length
    final double w = size.width;
    final double h = size.height;

    final path = Path();

    // Top-left
    path.moveTo(r + l, 0);
    path.lineTo(r, 0);
    path.arcToPoint(Offset(0, r), radius: Radius.circular(r), clockwise: false);
    path.lineTo(0, r + l);

    // Top-right
    path.moveTo(w - (r + l), 0);
    path.lineTo(w - r, 0);
    path.arcToPoint(Offset(w, r), radius: Radius.circular(r), clockwise: true);
    path.lineTo(w, r + l);

    // Bottom-left
    path.moveTo(0, h - (r + l));
    path.lineTo(0, h - r);
    path.arcToPoint(Offset(r, h), radius: Radius.circular(r), clockwise: false);
    path.lineTo(r + l, h);

    // Bottom-right
    path.moveTo(w, h - (r + l));
    path.lineTo(w, h - r);
    path.arcToPoint(Offset(w - r, h), radius: Radius.circular(r), clockwise: true);
    path.lineTo(w - (r + l), h);

    _drawDashedPath(canvas, path, paint, 3.0, 3.0);
  }

  void _drawDashedPath(Canvas canvas, Path path, Paint paint, double dashLength, double gapLength) {
    for (final pathMetric in path.computeMetrics()) {
      double distance = 0.0;
      while (distance < pathMetric.length) {
        final length = dashLength;
        final drawLength = (distance + length < pathMetric.length) ? length : pathMetric.length - distance;
        canvas.drawPath(pathMetric.extractPath(distance, distance + drawLength), paint);
        distance += length + gapLength;
      }
    }
  }

  @override
  bool shouldRepaint(covariant _DashedCornerPainter oldDelegate) => color != oldDelegate.color;
}

// ── Species data (mirrors plant_card.dart) ───────────────────────────────────
const _kSpeciesData = {
  's1': _GardenSpecies(
    scientificName: 'Monstera deliciosa',
    tags: ['Tropical', 'Luz indirecta', 'Riego semanal'],
    imageBg: Color(0xFFF2F7F2),
    assetImage: 'assets/images/monstera.png',
  ),
  's2': _GardenSpecies(
    scientificName: 'Epipremnum aureum',
    tags: ['Tropical', 'Luz indirecta', 'Riego semanal'],
    imageBg: Color(0xFFEAF5EA),
  ),
  's3': _GardenSpecies(
    scientificName: 'Sansevieria',
    tags: ['Desértica', 'Luz Adaptable', 'Riego 2-3 sem.'],
    imageBg: Color(0xFFF0F4EC),
  ),
  's4': _GardenSpecies(
    scientificName: 'Ficus lyrata',
    tags: ['Tropical', 'Luz brillante', 'Riego semanal'],
    imageBg: Color(0xFFEAF0E8),
  ),
  's5': _GardenSpecies(
    scientificName: 'Cactaceae',
    tags: ['Desértica', 'Pleno sol', 'Riego mensual'],
    imageBg: Color(0xFFF5F2E8),
  ),
};

const _kDefaultSpecies = _GardenSpecies(
  scientificName: 'Especie desconocida',
  tags: ['Planta'],
  imageBg: Color(0xFFEAF3EC),
);

class _GardenSpecies {
  final String scientificName;
  final List<String> tags;
  final Color imageBg;
  final String? assetImage;
  const _GardenSpecies({
    required this.scientificName,
    required this.tags,
    required this.imageBg,
    this.assetImage,
  });
}

IconData _tagIcon(String tag) {
  final t = tag.toLowerCase();
  if (t.contains('tropical')) return Icons.spa_rounded;
  if (t.contains('luz')) return Icons.center_focus_strong_rounded;
  if (t.contains('riego') || t.contains('agua')) return Icons.water_drop_rounded;
  if (t.contains('sol')) return Icons.wb_sunny_rounded;
  return Icons.eco_rounded;
}

// ── Plant list card — Mi Jardín horizontal ────────────────────────────────────
class _PlantListCard extends StatelessWidget {
  final UserPlant plant;
  final VoidCallback onTap;
  final VoidCallback onWater;

  const _PlantListCard({
    required this.plant,
    required this.onTap,
    required this.onWater,
  });

  @override
  Widget build(BuildContext context) {
    final daysSinceWater = plant.lastWateredAt == null
        ? 99
        : DateTime.now().difference(plant.lastWateredAt!).inDays;
    final needsWater = daysSinceWater >= 7;
    final sp = _kSpeciesData[plant.speciesId] ?? _kDefaultSpecies;

    // Badge on image: "! Riego" in lime green when needs water, "✓ Riego" in sage green when up-to-date
    final riegoBadgeBg = needsWater ? const Color(0xFFBDE038) : const Color(0xFF789D8C);
    final riegoBadgeText = needsWater ? '! Riego' : '✓ Riego';
    final riegoBadgeColor = Colors.white;

    // Status pill
    final statusBg = needsWater ? const Color(0xFFFFF4EC) : const Color(0xFFF2F4EB);
    final statusBorderColor = needsWater ? const Color(0xFFFFCCA0) : const Color(0xFF8A9A65);
    final statusTextColor = needsWater ? const Color(0xFFB94E13) : const Color(0xFF10454F);
    final statusText = needsWater ? 'Necesita riego' : 'Al día';
    final statusIcon = needsWater ? Icons.warning_amber_rounded : Icons.check_rounded;

    final daysLabel = '${daysSinceWater}d sin riego · c/7d';

    return GestureDetector(
      onTap: onTap,
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ── LEFT CONTAINER: Image box ─────────────────────────
            Container(
              width: 145,
              constraints: const BoxConstraints(minHeight: 145),
              decoration: BoxDecoration(
                color: sp.imageBg,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: const Color(0xFF5E7A82),
                  width: 1.5,
                ),
              ),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  // Image
                  Positioned.fill(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: sp.assetImage != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.asset(
                                sp.assetImage!,
                                fit: BoxFit.contain,
                                errorBuilder: (_, _, _) => Icon(
                                  Icons.local_florist_rounded,
                                  size: 56,
                                  color: AppColors.primary.withValues(alpha: 0.5),
                                ),
                              ),
                            )
                          : Icon(
                              Icons.local_florist_rounded,
                              size: 56,
                              color: AppColors.primary.withValues(alpha: 0.5),
                            ),
                    ),
                  ),
                  // "! Riego" Badge — top-right
                  Positioned(
                    top: 10,
                    right: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: riegoBadgeBg,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        riegoBadgeText,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                          color: riegoBadgeColor,
                          fontFamily: 'Inter',
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),

            // ── RIGHT CONTAINER: Info card ────────────────────────
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    // Title + Chevron
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Text(
                            plant.nickname,
                            style: const TextStyle(
                              fontFamily: 'DM Sans',
                              fontWeight: FontWeight.w700,
                              fontSize: 22,
                              color: _kTextDark,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Icon(
                          Icons.chevron_right_rounded,
                          size: 24,
                          color: _kTextDark,
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),

                    // Scientific name
                    Text(
                      sp.scientificName,
                      style: const TextStyle(
                        fontFamily: 'DM Sans',
                        fontWeight: FontWeight.w400,
                        fontSize: 15,
                        color: _kTextMuted,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 12),

                    // Status Row (Status Pill + Days Label)
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: statusBg,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: statusBorderColor,
                              width: 1.2,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                statusIcon,
                                size: 12,
                                color: statusTextColor,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                statusText,
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w700,
                                  fontSize: 11,
                                  color: statusTextColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            daysLabel,
                            style: const TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 12,
                              color: Color(0xFF807F7F),
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Tags Row
                    Wrap(
                      spacing: 4,
                      runSpacing: 4,
                      children: sp.tags
                          .take(3)
                          .map((tag) => _buildTag(tag))
                          .toList(),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTag(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: const Color(0xFFEFF2F1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(_tagIcon(text), size: 12, color: const Color(0xFF10454F)),
          const SizedBox(width: 4),
          Text(
            text,
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: Color(0xFF10454F),
              fontFamily: 'Inter',
            ),
          ),
        ],
      ),
    );
  }
}
