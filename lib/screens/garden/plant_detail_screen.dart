import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:frontend_eco_2/models/models.dart';
import 'package:frontend_eco_2/providers/providers.dart';
import 'package:frontend_eco_2/theme/app_colors.dart';

// ── Mock care history records ─────────────────────────────────────────────
class _CareRecord {
  final String type;  // 'water' | 'fertilize' | 'prune'
  final String label;
  final DateTime date;

  const _CareRecord({
    required this.type,
    required this.label,
    required this.date,
  });
}

final _mockCareHistory = [
  _CareRecord(
    type: 'water',
    label: 'Riego',
    date: DateTime.now().subtract(const Duration(days: 2)),
  ),
  _CareRecord(
    type: 'fertilize',
    label: 'Abonado',
    date: DateTime.now().subtract(const Duration(days: 10)),
  ),
  _CareRecord(
    type: 'prune',
    label: 'Poda',
    date: DateTime.now().subtract(const Duration(days: 20)),
  ),
];

// ── Species info (reused from plant_card.dart logic) ─────────────────────
const _speciesData = {
  's1': (
    scientific: 'Monstera deliciosa',
    bg: Color(0xFFDCEDDC),
    health: 0.9,
    tags: ['Tropical', 'Luz indirecta', 'Riego semanal'],
  ),
  's2': (
    scientific: 'Epipremnum aureum',
    bg: Color(0xFFDCEDDC),
    health: 0.75,
    tags: ['Tropical', 'Luz indirecta', 'Fácil'],
  ),
  's3': (
    scientific: 'Sansevieria trifasciata',
    bg: Color(0xFFF0F4EC),
    health: 0.85,
    tags: ['Desértica', 'Luz adaptable', 'Riego 2-3 sem.'],
  ),
};

class PlantDetailScreen extends StatelessWidget {
  const PlantDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final plant = ModalRoute.of(context)?.settings.arguments as UserPlant?;
    if (plant == null) {
      return const Scaffold(
        body: Center(child: Text('Planta no encontrada')),
      );
    }

    final species = _speciesData[plant.speciesId];
    final scientificName = species?.scientific ?? 'Especie desconocida';
    final bgColor = species?.bg ?? const Color(0xFFEAF3EC);
    final healthLevel = species?.health ?? 0.5;
    final tags = species?.tags ?? ['Planta'];
    final daysSince = plant.lastWateredAt != null
        ? DateTime.now().difference(plant.lastWateredAt!).inDays
        : 0;
    final needsWater = daysSince >= 7;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // ── App Bar (green gradient) ──────────────────
          SliverAppBar(
            expandedHeight: 260,
            pinned: true,
            backgroundColor: AppColors.primaryDark,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_rounded, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.more_horiz_rounded, color: Colors.white),
                onPressed: () {},
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              collapseMode: CollapseMode.parallax,
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColors.primaryDark, AppColors.primary],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 40),
                    // Plant image circle
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        color: bgColor,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.12),
                            blurRadius: 20,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      alignment: Alignment.center,
                      child: Icon(
                        Icons.local_florist_rounded,
                        size: 60,
                        color: AppColors.primary.withValues(alpha: 0.7),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      plant.nickname,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'DM Sans',
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      scientificName,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 13,
                        fontStyle: FontStyle.italic,
                        fontFamily: 'Inter',
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Tags ────────────────────────────────
                  Wrap(
                    spacing: 6,
                    children: tags
                        .map((t) => _buildTag(t))
                        .toList(),
                  ),
                  const SizedBox(height: 24),

                  // ── Health indicators ────────────────────
                  const Text(
                    'Estado de la Planta',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                      fontFamily: 'Inter',
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _buildIndicator(
                          icon: Icons.water_drop_outlined,
                          label: 'Riego',
                          value: needsWater ? 0.2 : 0.8,
                          color: needsWater ? AppColors.orange : AppColors.primary,
                          sublabel: needsWater
                              ? 'Hace $daysSince días'
                              : 'Hace $daysSince días',
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _buildIndicator(
                          icon: Icons.wb_sunny_outlined,
                          label: 'Luz',
                          value: 0.85,
                          color: const Color(0xFFFFBF00),
                          sublabel: 'Indirecta',
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _buildIndicator(
                          icon: Icons.local_florist_outlined,
                          label: 'Salud',
                          value: healthLevel,
                          color: AppColors.primary,
                          sublabel:
                              '${(healthLevel * 100).round()}%',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // ── Care history ──────────────────────────
                  const Text(
                    'Historial de Cuidados',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                      fontFamily: 'Inter',
                    ),
                  ),
                  const SizedBox(height: 12),
                  ..._mockCareHistory.map((c) => _buildCareRow(c)),
                  const SizedBox(height: 80),
                ],
              ),
            ),
          ),
        ],
      ),

      // ── Floating "Registrar Cuidado" button ───────────
      floatingActionButton: SizedBox(
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: FloatingActionButton.extended(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            elevation: 4,
            onPressed: () => _showCareSheet(context, plant),
            icon: const Icon(Icons.add_circle_outline_rounded),
            label: const Text(
              'Registrar Cuidado',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
                fontFamily: 'Inter',
              ),
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _buildTag(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: AppColors.primary,
          fontFamily: 'Inter',
        ),
      ),
    );
  }

  Widget _buildIndicator({
    required IconData icon,
    required String label,
    required double value,
    required Color color,
    required String sublabel,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8E4)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(height: 6),
          Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              color: AppColors.textSecondary,
              fontFamily: 'Inter',
            ),
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(3),
            child: LinearProgressIndicator(
              value: value,
              minHeight: 4,
              backgroundColor: const Color(0xFFE8ECE9),
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            sublabel,
            style: const TextStyle(
              fontSize: 9,
              color: AppColors.textMuted,
              fontFamily: 'Inter',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCareRow(_CareRecord record) {
    final daysAgo = DateTime.now().difference(record.date).inDays;
    final iconData = switch (record.type) {
      'water' => Icons.water_drop_outlined,
      'fertilize' => Icons.eco_outlined,
      'prune' => Icons.content_cut_outlined,
      _ => Icons.check_circle_outline,
    };
    final color = switch (record.type) {
      'water' => const Color(0xFF4A90D9),
      'fertilize' => AppColors.primary,
      'prune' => const Color(0xFF8B6C2E),
      _ => AppColors.primary,
    };

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            alignment: Alignment.center,
            child: Icon(iconData, size: 18, color: color),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              record.label,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 13,
                color: AppColors.textPrimary,
                fontFamily: 'Inter',
              ),
            ),
          ),
          Text(
            daysAgo == 0
                ? 'Hoy'
                : daysAgo == 1
                    ? 'Ayer'
                    : 'Hace $daysAgo días',
            style: const TextStyle(
              fontSize: 11,
              color: AppColors.textSecondary,
              fontFamily: 'Inter',
            ),
          ),
        ],
      ),
    );
  }

  void _showCareSheet(BuildContext context, UserPlant plant) {
    final plantsProvider =
        Provider.of<PlantsProvider>(context, listen: false);
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 36,
                  height: 4,
                  decoration: BoxDecoration(
                    color: const Color(0xFFDDDDDD),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Registrar Cuidado',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'DM Sans',
                ),
              ),
              const SizedBox(height: 16),
              _careOption(
                context: ctx,
                icon: Icons.water_drop_rounded,
                label: 'Regar planta',
                color: const Color(0xFF4A90D9),
                onTap: () {
                  plantsProvider.waterPlant(plant.id);
                  Navigator.pop(ctx);
                },
              ),
              _careOption(
                context: ctx,
                icon: Icons.eco_rounded,
                label: 'Abonar planta',
                color: AppColors.primary,
                onTap: () => Navigator.pop(ctx),
              ),
              _careOption(
                context: ctx,
                icon: Icons.content_cut_rounded,
                label: 'Podar planta',
                color: const Color(0xFF8B6C2E),
                onTap: () => Navigator.pop(ctx),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _careOption({
    required BuildContext context,
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        alignment: Alignment.center,
        child: Icon(icon, color: color, size: 20),
      ),
      title: Text(
        label,
        style: const TextStyle(
          fontWeight: FontWeight.w500,
          fontFamily: 'Inter',
        ),
      ),
      onTap: onTap,
    );
  }
}
