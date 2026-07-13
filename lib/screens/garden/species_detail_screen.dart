import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:frontend_eco_2/models/models.dart';
import 'package:frontend_eco_2/providers/plants_provider.dart';
import 'package:frontend_eco_2/theme/app_colors.dart';

class SpeciesDetailScreen extends StatelessWidget {
  const SpeciesDetailScreen({super.key});

  Color _getBackgroundColor(String id) {
    switch (id) {
      case 's1':
        return const Color(0xFFF2F7F2);
      case 's2':
        return const Color(0xFFEAF5EA);
      case 's3':
        return const Color(0xFFF0F4EC);
      case 's4':
        return const Color(0xFFEAF0E8);
      case 's5':
        return const Color(0xFFF5F2E8);
      default:
        return const Color(0xFFF0F4F2);
    }
  }

  String? _getAssetImage(String id) {
    if (id == 's1') {
      return 'assets/images/monstera.png';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final species = ModalRoute.of(context)?.settings.arguments as PlantSpecies?;
    if (species == null) {
      return const Scaffold(
        body: Center(child: Text('Especie no encontrada')),
      );
    }

    final bgColor = _getBackgroundColor(species.id);
    final assetImage = _getAssetImage(species.id);
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.arrow_back_ios_new_rounded,
              size: 16,
              color: AppColors.primary,
            ),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.favorite_border_rounded,
                size: 18,
                color: AppColors.primary,
              ),
            ),
            onPressed: () {},
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Stack(
        children: [
          // ── Background Image Header ──
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: screenHeight * 0.4,
            child: Container(
              color: bgColor,
              child: SafeArea(
                bottom: false,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 24, 24, 40),
                    child: assetImage != null
                        ? Image.asset(
                            assetImage,
                            fit: BoxFit.contain,
                          )
                        : Icon(
                            Icons.local_florist_rounded,
                            size: 120,
                            color: AppColors.primary.withValues(alpha: 0.25),
                          ),
                  ),
                ),
              ),
            ),
          ),

          // ── Scrollable detail content ──
          Positioned.fill(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: screenHeight * 0.35),
                  Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(32),
                      ),
                    ),
                    padding: const EdgeInsets.fromLTRB(24, 32, 24, 120),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Common Name & Scientific Name
                        Text(
                          species.commonName,
                          style: const TextStyle(
                            fontFamily: 'DM Sans',
                            fontWeight: FontWeight.bold,
                            fontSize: 28,
                            color: AppColors.primaryDark,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          species.scientificName,
                          style: const TextStyle(
                            fontFamily: 'DM Sans',
                            fontStyle: FontStyle.italic,
                            fontSize: 15,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Badges Row
                        Row(
                          children: [
                            _buildBadge(species.category ?? 'Planta', AppColors.primary.withValues(alpha: 0.08), AppColors.primary),
                            const SizedBox(width: 8),
                            _buildBadge(
                              species.difficulty,
                              species.difficulty == 'Muy fácil'
                                  ? const Color(0xFFF2F4EB)
                                  : const Color(0xFFFFF4EC),
                              species.difficulty == 'Muy fácil'
                                  ? const Color(0xFF10454F)
                                  : const Color(0xFFB94E13),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        const Divider(color: Color(0xFFE2E7E4)),
                        const SizedBox(height: 24),

                        // Care parameters grid
                        const Text(
                          'Cuidados requeridos',
                          style: TextStyle(
                            fontFamily: 'DM Sans',
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: AppColors.primaryDark,
                          ),
                        ),
                        const SizedBox(height: 16),
                        _buildCareGrid(species),
                        const SizedBox(height: 32),

                        // Step by step care guide
                        const Text(
                          'Guía de Cuidado Paso a Paso',
                          style: TextStyle(
                            fontFamily: 'DM Sans',
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: AppColors.primaryDark,
                          ),
                        ),
                        const SizedBox(height: 16),
                        _buildCareGuideSection(species),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ── Bottom Action Button Bar ──
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: SafeArea(
                top: false,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  onPressed: () {
                    Provider.of<PlantsProvider>(context, listen: false)
                        .addPlantFromSpecies(species);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          '¡${species.commonName} añadida a tu jardín! 🌿',
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                        backgroundColor: AppColors.primary,
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    );
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.add_circle_outline_rounded, size: 20),
                  label: const Text(
                    'Añadir a mi jardín',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBadge(String label, Color bg, Color text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: text,
          fontSize: 12,
          fontWeight: FontWeight.bold,
          fontFamily: 'Inter',
        ),
      ),
    );
  }

  Widget _buildCareGrid(PlantSpecies species) {
    final co2Text = species.id == 's1'
        ? '3.2 g/día'
        : species.id == 's2'
            ? '2.5 g/día'
            : species.id == 's3'
                ? '1.8 g/día'
                : '${(1.5 + (species.airPurificationScore ?? 50) / 100 * 2).toStringAsFixed(1)} g/día';

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildCareItem(
                Icons.water_drop_outlined,
                const Color(0xFF4A90D9),
                'Riego',
                'Cada ${species.waterFrequencyDays} días',
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildCareItem(
                Icons.wb_sunny_outlined,
                const Color(0xFFFABF2E),
                'Luz solar',
                species.lightRequirement ?? 'Adaptable',
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildCareItem(
                Icons.thermostat_outlined,
                const Color(0xFFF56B1C),
                'Temperatura',
                '${species.minTemperature ?? 15}-${species.maxTemperature ?? 30}°C',
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildCareItem(
                Icons.eco_outlined,
                AppColors.primary,
                'Absorción CO₂',
                co2Text,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCareItem(
    IconData icon,
    Color iconColor,
    String label,
    String value,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAF9),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E7E4), width: 1.0),
      ),
      child: Row(
        children: [
          Icon(icon, color: iconColor, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                    fontFamily: 'Inter',
                  ),
                ),
                const SizedBox(height: 2),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    value,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: AppColors.primaryDark,
                      fontFamily: 'Inter',
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCareGuideSection(PlantSpecies species) {
    final lightAdvice = species.lightRequirement == 'Pleno sol'
        ? 'Requiere luz solar directa durante al menos 6 horas al día. Ideal para terrazas, balcones o ventanas muy soleadas.'
        : species.lightRequirement == 'Luz adaptable'
            ? 'Tolera tanto lugares con poca iluminación como espacios con luz brillante indirecta. Evitar el sol directo del mediodía.'
            : 'Prefiere luz indirecta y brillante. Colócala cerca de una ventana con cortina translúcida. Evita el sol directo directo para no quemar las hojas.';

    final waterAdvice = species.waterFrequencyDays >= 20
        ? 'Riego muy espaciado. Deja secar el sustrato por completo antes de volver a regar. En invierno, reduce el riego a una vez al mes.'
        : species.waterFrequencyDays >= 10
            ? 'Riego moderado. Riega solo cuando los primeros 3-5 cm de tierra estén completamente secos. Soporta periodos cortos de sequía.'
            : 'Riego regular. Mantén el sustrato ligeramente húmedo, pero nunca encharcado. Riega cuando la superficie del sustrato comience a secarse.';

    return Column(
      children: [
        _buildGuideStep('1. Ubicación y Luz', lightAdvice),
        const SizedBox(height: 12),
        _buildGuideStep('2. Rutina de Riego', waterAdvice),
        const SizedBox(height: 12),
        _buildGuideStep('3. Sustrato y Drenaje', 'Utiliza una mezcla ligera y bien aireada. Se recomienda una base de turba mezclada con perlita y fibra de coco para asegurar un excelente drenaje y evitar la pudrición de raíces.'),
        const SizedBox(height: 12),
        _buildGuideStep('4. Fertilización', 'Abona con un fertilizante líquido equilibrado una vez al mes durante el periodo de crecimiento activo (primavera y verano). En otoño e invierno, suspende la fertilización.'),
      ],
    );
  }

  Widget _buildGuideStep(String title, String content) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAF9),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E7E4), width: 1.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: AppColors.primary,
              fontFamily: 'Inter',
            ),
          ),
          const SizedBox(height: 6),
          Text(
            content,
            style: const TextStyle(
              fontSize: 13,
              height: 1.4,
              color: AppColors.textPrimary,
              fontFamily: 'Inter',
            ),
          ),
        ],
      ),
    );
  }
}
