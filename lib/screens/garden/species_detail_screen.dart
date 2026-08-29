import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:frontend_eco_2/models/models.dart';
import 'package:frontend_eco_2/providers/providers.dart';
import 'package:frontend_eco_2/theme/app_colors.dart';
import 'package:frontend_eco_2/utils/achievement_feedback.dart';
import 'package:frontend_eco_2/utils/plant_visuals.dart';

// Legacy mock species (s1-s5) still ship a real illustration asset; every
// other (real, catalog-backed) species falls back to a category visual.
const Map<String, String> _kLegacyAssetImages = {
  's1': 'assets/images/monstera.png',
  's2': 'assets/images/potus.png',
  's3': 'assets/images/sansevieria.png',
  's4': 'assets/images/ficus_lira.png',
  's5': 'assets/images/cactus.png',
};

class SpeciesDetailScreen extends StatefulWidget {
  const SpeciesDetailScreen({super.key});

  @override
  State<SpeciesDetailScreen> createState() => _SpeciesDetailScreenState();
}

class _SpeciesDetailScreenState extends State<SpeciesDetailScreen> {
  bool _isFavorited = false;

  @override
  Widget build(BuildContext context) {
    final species = ModalRoute.of(context)?.settings.arguments as PlantSpecies?;
    if (species == null) {
      return const Scaffold(body: Center(child: Text('Especie no encontrada')));
    }

    final visual = visualForCategory(species.category);
    final bgColor = visual.background;
    final assetImage = _kLegacyAssetImages[species.id];
    final bottomNavPadding = MediaQuery.of(context).padding.bottom;

    // air_purification_score is a real DB field on a 0-9 scale (see backend
    // seed data). CO2 grams/day and the "car distance" equivalent are a
    // simple, clearly-labelled illustrative scale derived from that real
    // score — not a separately measured value.
    final purificationScore = species.airPurificationScore ?? 0;
    final co2GramsPerDay = 1.0 + purificationScore * 0.4;
    final carMetersEquivalent = 10 + purificationScore * 8;

    return Scaffold(
      backgroundColor: bgColor,
      body: Column(
        children: [
          Container(
            height: MediaQuery.of(context).padding.top,
            color: const Color(0xFF10454F),
          ),
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.arrow_back_ios_new_rounded,
                    size: 20,
                    color: Color(0xFF10454F),
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
                Row(
                  children: [
                    IconButton(
                      icon: Icon(
                        _isFavorited
                            ? Icons.favorite_rounded
                            : Icons.favorite_border_rounded,
                        size: 22,
                        color: const Color(0xFFE64A19),
                      ),
                      onPressed: () {
                        setState(() {
                          _isFavorited = !_isFavorited;
                        });
                      },
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.share_outlined,
                        size: 22,
                        color: Color(0xFF10454F),
                      ),
                      onPressed: () {},
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    color: Colors.white,
                    padding: const EdgeInsets.only(bottom: 24),
                    child: Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 40,
                            vertical: 10,
                          ),
                          child: SizedBox(
                            height: 240,
                            child: species.imageUrl != null
                                ? Image.network(species.imageUrl!, fit: BoxFit.cover)
                                : assetImage != null
                                    ? Image.asset(assetImage, fit: BoxFit.contain)
                                    : Icon(
                                        visual.icon,
                                        size: 140,
                                        color: visual.color.withValues(alpha: 0.35),
                                      ),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(
                                0xFF263238,
                              ).withValues(alpha: 0.75),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(visual.icon, color: Colors.white, size: 13),
                                const SizedBox(width: 6),
                                Text(
                                  visual.label,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Inter',
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(32),
                      ),
                    ),
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Container(
                            width: 38,
                            height: 5,
                            decoration: BoxDecoration(
                              color: const Color(0xFFE2E7E4),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    species.scientificName,
                                    style: const TextStyle(
                                      fontFamily: 'DM Sans',
                                      fontWeight: FontWeight.w700,
                                      fontSize: 28,
                                      color: Color(0xFF0D2B31),
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    species.commonName,
                                    style: const TextStyle(
                                      fontFamily: 'Inter',
                                      fontSize: 15,
                                      color: Color(0xFF807F7F),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF1F8E9),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(
                                        Icons.air_rounded,
                                        color: Color(0xFF689F38),
                                        size: 16,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        '${species.airPurificationScore ?? 0}/9',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 13,
                                          color: Color(0xFF10454F),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 4),
                                const Text(
                                  'Purificación de aire',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: Color(0xFF807F7F),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Wrap(
                          spacing: 8,
                          runSpacing: 6,
                          children: species.detailTags.map((tag) {
                            final style = styleForTagKind(tagKindFor(tag));
                            return Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: style.background,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(style.icon, size: 13, color: style.color),
                                  const SizedBox(width: 5),
                                  Text(
                                    tag,
                                    style: TextStyle(
                                      color: style.color,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      fontFamily: 'Inter',
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 24),
                        const Text(
                          'Sobre esta planta',
                          style: TextStyle(
                            fontFamily: 'DM Sans',
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Color(0xFF0D2B31),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          species.description,
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 14,
                            height: 1.4,
                            color: Color(0xFF616161),
                          ),
                        ),
                        const SizedBox(height: 24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Dificultad',
                              style: TextStyle(
                                fontFamily: 'DM Sans',
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: Color(0xFF0D2B31),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFFEFF2EF),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                species.difficulty,
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF10454F),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: List.generate(6, (index) {
                            final filled = index < species.difficultySegments;
                            return Expanded(
                              child: Container(
                                height: 8,
                                margin: EdgeInsets.only(
                                  left: index == 0 ? 0 : 3,
                                  right: index == 5 ? 0 : 3,
                                ),
                                decoration: BoxDecoration(
                                  color: filled
                                      ? const Color(0xFF10454F)
                                      : const Color(0xFFE0E5E2),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                            );
                          }),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: const [
                            Text(
                              'Principiante',
                              style: TextStyle(
                                fontSize: 11,
                                color: Color(0xFF807F7F),
                              ),
                            ),
                            Text(
                              'Experto',
                              style: TextStyle(
                                fontSize: 11,
                                color: Color(0xFF807F7F),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 32),
                        const Text(
                          'Cuidados',
                          style: TextStyle(
                            fontFamily: 'DM Sans',
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Color(0xFF0D2B31),
                          ),
                        ),
                        const Text(
                          'Requisitos ideales para esta especie',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 13,
                            color: Color(0xFF807F7F),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: _buildCareCard(
                                icon: Icons.water_drop_rounded,
                                iconColor: const Color(0xFF1565C0),
                                iconBg: const Color(0xFFE3F2FD),
                                label: 'Riego',
                                value: 'c/${species.waterFrequencyDays} días',
                                subText: 'Cuando tierra seca',
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _buildCareCard(
                                icon: Icons.wb_sunny_rounded,
                                iconColor: const Color(0xFFFBC02D),
                                iconBg: const Color(0xFFFFFDE7),
                                label: 'Luz',
                                value: lightLabelEs(species.lightRequirement),
                                subText: lightHintEs(species.lightRequirement),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: _buildCareCard(
                                icon: Icons.thermostat_rounded,
                                iconColor: const Color(0xFFE64A19),
                                iconBg: const Color(0xFFFBE9E7),
                                label: 'Temperatura',
                                value:
                                    '${species.minTemperature ?? 15}-${species.maxTemperature ?? 28}°C',
                                subText: categoryLabelEs(species.category),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _buildCareCard(
                                icon: Icons.opacity_rounded,
                                iconColor: const Color(0xFF00796B),
                                iconBg: const Color(0xFFE0F2F1),
                                label: 'Humedad',
                                value: species.humidityRange,
                                subText: species.humidityLevel,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 16,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFF10454F),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    width: 44,
                                    height: 44,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFBDE038),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: const Center(
                                      child: Icon(
                                        Icons.eco_rounded,
                                        color: Color(0xFF10454F),
                                        size: 24,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 14),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Absorbe ~${co2GramsPerDay.toStringAsFixed(1)}g de CO₂/día',
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                            fontFamily: 'Inter',
                                          ),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          'Equivalente a un auto recorriendo ${carMetersEquivalent}m',
                                          style: const TextStyle(
                                            color: Color(0xFFBDE038),
                                            fontSize: 12,
                                            fontFamily: 'Inter',
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 14),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Nivel de purificación',
                                    style: TextStyle(
                                      color: Colors.white.withValues(alpha: 0.75),
                                      fontSize: 11,
                                      fontFamily: 'Inter',
                                    ),
                                  ),
                                  Text(
                                    '$purificationScore/9',
                                    style: const TextStyle(
                                      color: Color(0xFFBDE038),
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Inter',
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 6),
                              Row(
                                children: List.generate(9, (index) {
                                  final filled = index < purificationScore;
                                  return Expanded(
                                    child: Container(
                                      height: 6,
                                      margin: EdgeInsets.only(
                                        left: index == 0 ? 0 : 2,
                                        right: index == 8 ? 0 : 2,
                                      ),
                                      decoration: BoxDecoration(
                                        color: filled
                                            ? const Color(0xFFBDE038)
                                            : Colors.white.withValues(alpha: 0.15),
                                        borderRadius: BorderRadius.circular(3),
                                      ),
                                    ),
                                  );
                                }),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 32),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const Text(
                                  'Experiencias',
                                  style: TextStyle(
                                    fontFamily: 'DM Sans',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    color: Color(0xFF0D2B31),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFEFF2EF),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: const Text(
                                    '128',
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF10454F),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            TextButton(
                              onPressed: () {},
                              child: const Text(
                                'Ver todas',
                                style: TextStyle(
                                  color: Color(0xFF10454F),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF8FAF9),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: const Color(0xFFEFF2EF),
                              width: 1,
                            ),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 36,
                                height: 36,
                                decoration: const BoxDecoration(
                                  color: Color(0xFFE0E6E3),
                                  shape: BoxShape.circle,
                                ),
                                child: const Center(
                                  child: Icon(
                                    Icons.person_rounded,
                                    color: Color(0xFF10454F),
                                    size: 20,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              const Expanded(
                                child: Text(
                                  'Crece súper rápido en mi sala. Fácil de cuidar, solo necesita luz indirecta y agua cada semana. ¡La recomiendo!',
                                  style: TextStyle(
                                    fontSize: 13,
                                    height: 1.4,
                                    color: Color(0xFF616161),
                                    fontFamily: 'Inter',
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(20, 12, 20, bottomNavPadding + 12),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 10,
                  offset: const Offset(0, -4),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFBDE038),
                      foregroundColor: const Color(0xFF10454F),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(32),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    onPressed: () => _addToGarden(context, species),
                    icon: const Icon(
                      Icons.add,
                      size: 22,
                      color: Color(0xFF10454F),
                    ),
                    label: const Text(
                      'Añadir a mi jardín',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Color(0xFF10454F),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(0xFF10454F),
                      width: 1.5,
                    ),
                  ),
                  child: IconButton(
                    icon: Icon(
                      _isFavorited
                          ? Icons.favorite_rounded
                          : Icons.favorite_border_rounded,
                      color: const Color(0xFF10454F),
                      size: 24,
                    ),
                    onPressed: () {
                      setState(() {
                        _isFavorited = !_isFavorited;
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _addToGarden(BuildContext context, PlantSpecies species) async {
    final plantsProvider = Provider.of<PlantsProvider>(context, listen: false);
    final success = await plantsProvider.addPlantFromSpecies(species);
    if (!context.mounted) return;

    if (!success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(plantsProvider.errorMessage ?? 'No se pudo agregar la planta.'),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
      return;
    }

    final missionsProvider = Provider.of<MissionsProvider>(context, listen: false);
    final unlocked = await missionsProvider.onPlantAdded(plantsProvider.userPlants.length);
    if (!context.mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '¡${species.commonName} añadida a tu jardín! 🌿',
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        backgroundColor: const Color(0xFF10454F),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
    showAchievementUnlockedSnackbars(context, unlocked);
    Navigator.pop(context);
  }

  Widget _buildCareCard({
    required IconData icon,
    required Color iconColor,
    required Color iconBg,
    required String label,
    required String value,
    required String subText,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAF9),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFEFF2EF), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: iconBg,
                  shape: BoxShape.circle,
                ),
                child: Center(child: Icon(icon, color: iconColor, size: 18)),
              ),
              const SizedBox(width: 10),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xFF807F7F),
                  fontFamily: 'Inter',
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: Color(0xFF10454F),
              fontFamily: 'Inter',
            ),
          ),
          const SizedBox(height: 2),
          Text(
            subText,
            style: const TextStyle(
              fontSize: 11,
              color: Color(0xFF807F7F),
              fontFamily: 'Inter',
            ),
          ),
        ],
      ),
    );
  }
}
