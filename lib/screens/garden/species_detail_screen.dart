import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:frontend_eco_2/models/models.dart';
import 'package:frontend_eco_2/providers/providers.dart';
import 'package:frontend_eco_2/utils/achievement_feedback.dart';
import 'package:frontend_eco_2/utils/plant_visuals.dart';
import 'package:frontend_eco_2/utils/cloudinary_transform.dart';
import 'package:frontend_eco_2/utils/top_clamping_scroll_physics.dart';
import 'package:frontend_eco_2/widgets/common/app_toast.dart';
import 'package:frontend_eco_2/widgets/common/custom_status_bar.dart';
import 'package:frontend_eco_2/widgets/garden/last_watered_sheet.dart';

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

    final statusBarHeight = MediaQuery.of(context).padding.top;
    const appBarHeight = 56.0;
    // Alto real del bloque de imagen: padding vertical (10+10) del recuadro
    // + alto del SizedBox de la imagen (240) + padding inferior del
    // contenedor (24). Se usa para reservar el mismo espacio en el scroll.
    const imageBlockHeight = 284.0;

    return Scaffold(
      backgroundColor: bgColor,
      body: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                // ── CAPA 1: imagen fija de fondo ──
                Positioned(
                  top: statusBarHeight + appBarHeight,
                  left: 0,
                  right: 0,
                  child: Container(
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
                                ? CachedNetworkImage(
                                    imageUrl: withTransparentBackground(species.imageUrl!),
                                    fit: BoxFit.contain,
                                    placeholder: (_, _) => const Center(
                                      child: SizedBox(
                                        width: 28,
                                        height: 28,
                                        child: CircularProgressIndicator(strokeWidth: 2),
                                      ),
                                    ),
                                    errorWidget: (_, _, _) => Icon(
                                      visual.icon,
                                      size: 140,
                                      color: visual.color.withValues(alpha: 0.35),
                                    ),
                                  )
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
                ),
                // ── CAPA 2: contenido desplazable (sobre la imagen) ──
                Positioned.fill(
                  child: SingleChildScrollView(
                    physics: const TopClampingScrollPhysics(),
                    child: Column(
                      children: [
                        SizedBox(height: statusBarHeight + appBarHeight + imageBlockHeight),
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
                // ── CAPA 3: Custom Status Bar (al frente) ──
                const Positioned(top: 0, left: 0, right: 0, child: CustomStatusBar()),
                // ── CAPA 4: AppBar traslúcido con desenfoque (al frente y fija) ──
                Positioned(
                  top: statusBarHeight,
                  left: 0,
                  right: 0,
                  child: ClipRect(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
                      child: Container(
                        color: Colors.white.withValues(alpha: 0.55),
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        child: Row(
                          children: [
                            IconButton(
                              icon: const Icon(
                                Icons.arrow_back_ios_new_rounded,
                                size: 20,
                                color: Color(0xFF10454F),
                              ),
                              onPressed: () => Navigator.pop(context),
                            ),
                            const Expanded(
                              child: Text(
                                'Jardín',
                                style: TextStyle(
                                  fontFamily: 'DM Sans',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  color: Color(0xFF0D2B31),
                                ),
                              ),
                            ),
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
                      ),
                    ),
                  ),
                ),
              ],
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

    // El último riego previo define cuándo toca el primero: sin preguntarlo,
    // una planta que ya venía cuidada esperaría un ciclo completo de más.
    final answer = await askLastWatered(
      context,
      plantName: species.commonName,
      imageUrl: species.imageUrl,
    );
    if (answer == null || !context.mounted) return;

    final success = await plantsProvider.addPlantFromSpecies(
      species,
      lastWateredAt: answer.date,
    );
    if (!context.mounted) return;

    if (!success) {
      showAppToast(
        context,
        plantsProvider.errorMessage ?? 'No se pudo agregar la planta.',
        type: ToastType.error,
      );
      return;
    }

    final missionsProvider = Provider.of<MissionsProvider>(context, listen: false);
    final unlocked = await missionsProvider.onPlantAdded(plantsProvider.userPlants.length);
    if (!context.mounted) return;

    showAppToast(
      context,
      '¡${species.commonName} añadida a tu jardín! 🌿',
      type: ToastType.success,
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
