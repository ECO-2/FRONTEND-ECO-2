import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:frontend_eco_2/models/models.dart';
import 'package:frontend_eco_2/providers/providers.dart';

// ── Color tokens ─────────────────────────────────────────────────────────
const _kDark = Color(0xFF10454F);
const _kTextMuted = Color(0xFF807F7F);
const _kTextDark = Color(0xFF0D2B31);
const _kLime = Color(0xFFBDE038);
const _kCardBorder = Color(0xFFE5E5E5);

// Condiciones para las que hoy existe un contador real en la app. El resto
// (plant_scans, rooms_created) no tiene una feature real detrás todavía —
// se muestran aparte como "próximamente" en vez de fingir progreso.
const _kTrackableConditions = {
  AchievementConditions.userPlants,
  AchievementConditions.careLogs,
  AchievementConditions.onboardingCompleted,
};

IconData _iconForCondition(String conditionType) {
  switch (conditionType) {
    case AchievementConditions.userPlants:
      return Icons.park_rounded;
    case AchievementConditions.careLogs:
      return Icons.water_drop_rounded;
    case AchievementConditions.onboardingCompleted:
      return Icons.flag_rounded;
    case AchievementConditions.plantScans:
      return Icons.search_rounded;
    case AchievementConditions.roomsCreated:
      return Icons.home_rounded;
    default:
      return Icons.emoji_events_rounded;
  }
}

String _progressLabel(Achievement a, int current) {
  switch (a.conditionType) {
    case AchievementConditions.userPlants:
      return '$current de ${a.conditionValue} plantas';
    case AchievementConditions.careLogs:
      return '$current de ${a.conditionValue} cuidados';
    case AchievementConditions.onboardingCompleted:
      return current >= a.conditionValue ? 'Completado' : 'Pendiente';
    default:
      return 'Próximamente';
  }
}

class MissionsTab extends StatefulWidget {
  const MissionsTab({super.key});

  @override
  State<MissionsTab> createState() => _MissionsTabState();
}

class _MissionsTabState extends State<MissionsTab> {
  int _selectedTab = 0; // 0: Activa, 1: Completadas, 2: Bloqueadas

  @override
  Widget build(BuildContext context) {
    final mp = Provider.of<MissionsProvider>(context);
    final achievements = mp.achievements;

    final completed =
        achievements.where((a) => mp.isAchievementCompleted(a.id)).toList();
    final locked = mp.lockedAchievements;
    final trackableLocked = locked.where((a) => _kTrackableConditions.contains(a.conditionType)).toList()
      ..sort((a, b) => (a.conditionValue - mp.progressFor(a))
          .compareTo(b.conditionValue - mp.progressFor(b)));
    final comingSoon = locked.where((a) => !_kTrackableConditions.contains(a.conditionType)).toList();

    final featured = trackableLocked.isNotEmpty ? trackableLocked.first : null;
    final upcoming = trackableLocked.skip(1).toList();

    return Column(
      children: [
        _buildTabs(),
        Expanded(
          child: mp.isLoading && achievements.isEmpty
              ? const Center(child: CircularProgressIndicator(color: _kDark))
              : ListView(
                  padding: const EdgeInsets.only(left: 24, right: 24, top: 16, bottom: 100),
                  children: [
                    if (_selectedTab == 0) ...[
                      if (featured != null) ...[
                        _buildActiveMissionCard(mp, featured),
                        const SizedBox(height: 24),
                      ] else
                        _buildEmptyState('¡Completaste todos los logros disponibles!'),
                      if (upcoming.isNotEmpty) ...[
                        _buildSectionHeader('Próximos logros'),
                        const SizedBox(height: 12),
                        ...upcoming.map((a) => Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: _buildUpcomingCard(mp, a),
                            )),
                      ],
                    ] else if (_selectedTab == 1) ...[
                      if (completed.isEmpty)
                        _buildEmptyState('No hay logros completados aún')
                      else
                        ...completed.map((a) => Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: _buildCompletedCard(a),
                            )),
                    ] else ...[
                      if (comingSoon.isEmpty)
                        _buildEmptyState('No hay logros bloqueados por ahora')
                      else ...[
                        Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: Text(
                            'Estos logros dependen de funciones que todavía no están disponibles en la app.',
                            style: TextStyle(color: _kTextMuted, fontSize: 12, fontFamily: 'DM Sans'),
                          ),
                        ),
                        ...comingSoon.map((a) => Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: _buildUpcomingCard(mp, a, locked: true),
                            )),
                      ],
                    ],
                  ],
                ),
        ),
      ],
    );
  }

  Widget _buildEmptyState(String message) {
    return Padding(
      padding: const EdgeInsets.only(top: 40),
      child: Center(
        child: Text(
          message,
          textAlign: TextAlign.center,
          style: const TextStyle(color: _kTextMuted, fontFamily: 'DM Sans'),
        ),
      ),
    );
  }

  // ── Tabs row ─────────────────────────────────────────────────────────
  Widget _buildTabs() {
    const tabs = ['Activa', 'Completadas', 'Bloqueadas'];
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.only(left: 24, right: 24, top: 4),
      child: Row(
        children: List.generate(tabs.length, (i) {
          final selected = _selectedTab == i;
          return GestureDetector(
            onTap: () => setState(() => _selectedTab = i),
            child: Padding(
              padding: const EdgeInsets.only(right: 24),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Text(
                      tabs[i],
                      style: TextStyle(
                        fontFamily: 'DM Sans',
                        fontWeight:
                            selected ? FontWeight.w600 : FontWeight.w400,
                        fontSize: 13,
                        color: selected ? _kDark : _kTextMuted,
                      ),
                    ),
                  ),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    height: 2,
                    width: selected ? 40 : 0,
                    decoration: BoxDecoration(
                      color: _kDark,
                      borderRadius: BorderRadius.circular(1),
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontFamily: 'DM Sans',
        fontWeight: FontWeight.w700,
        fontSize: 15,
        color: _kTextDark,
      ),
    );
  }

  // ── Active/featured achievement card (dark green bg) ──────────────────
  Widget _buildActiveMissionCard(MissionsProvider mp, Achievement a) {
    final current = mp.progressFor(a);
    final progress = a.conditionValue == 0 ? 1.0 : (current / a.conditionValue).clamp(0.0, 1.0);

    return Container(
      decoration: BoxDecoration(
        color: _kDark,
        borderRadius: BorderRadius.circular(18),
      ),
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: _kLime,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Text(
                        '• MÁS CERCANO',
                        style: TextStyle(
                          fontFamily: 'DM Sans',
                          fontWeight: FontWeight.w700,
                          fontSize: 8,
                          color: _kTextDark,
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      a.name,
                      style: const TextStyle(
                        fontFamily: 'DM Sans',
                        fontWeight: FontWeight.w700,
                        fontSize: 22,
                        color: Colors.white,
                      ),
                    ),
                    if (a.description != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        a.description!,
                        style: const TextStyle(
                          fontFamily: 'DM Sans',
                          fontWeight: FontWeight.w500,
                          fontSize: 12,
                          color: _kLime,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(16),
                ),
                alignment: Alignment.center,
                child: Icon(_iconForCondition(a.conditionType), color: Colors.white, size: 28),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _progressLabel(a, current),
                style: const TextStyle(
                  fontFamily: 'DM Sans',
                  fontWeight: FontWeight.w500,
                  fontSize: 11,
                  color: _kLime,
                ),
              ),
              Text(
                '${(progress * 100).round()}%',
                style: const TextStyle(
                  fontFamily: 'DM Sans',
                  fontWeight: FontWeight.w700,
                  fontSize: 11,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Stack(
            children: [
              Container(
                height: 8,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              FractionallySizedBox(
                widthFactor: progress,
                child: Container(
                  height: 8,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: _kLime,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.bolt_rounded, size: 12, color: _kTextDark),
                    const SizedBox(width: 6),
                    Text(
                      '+${a.xpReward} XP',
                      style: const TextStyle(
                        fontFamily: 'DM Sans',
                        fontWeight: FontWeight.w600,
                        fontSize: 11,
                        color: _kTextDark,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ── Upcoming achievement card (white, bordered) ────────────────────────
  Widget _buildUpcomingCard(MissionsProvider mp, Achievement a, {bool locked = false}) {
    final current = mp.progressFor(a);
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: locked ? const Color(0xFFF7F8F7) : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _kCardBorder),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: locked ? const Color(0xFFECECEC) : _kLime,
              borderRadius: BorderRadius.circular(12),
            ),
            alignment: Alignment.center,
            child: Icon(
              locked ? Icons.lock_rounded : _iconForCondition(a.conditionType),
              color: locked ? const Color(0xFF909090) : _kTextDark,
              size: 22,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  a.name,
                  style: const TextStyle(
                    fontFamily: 'DM Sans',
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                    color: _kTextDark,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  locked ? (a.description ?? 'Próximamente') : _progressLabel(a, current),
                  style: const TextStyle(
                    fontFamily: 'DM Sans',
                    fontWeight: FontWeight.w400,
                    fontSize: 11,
                    color: _kTextMuted,
                  ),
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right_rounded, size: 18, color: _kTextMuted),
        ],
      ),
    );
  }

  // ── Completed achievement card ─────────────────────────────────────────
  Widget _buildCompletedCard(Achievement a) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _kCardBorder),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: const BoxDecoration(color: Color(0xFFFEF8E7), shape: BoxShape.circle),
            alignment: Alignment.center,
            child: const Icon(Icons.emoji_events_rounded, color: Color(0xFFFABF2E), size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  a.name,
                  style: const TextStyle(
                    fontFamily: 'DM Sans',
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                    color: _kTextDark,
                  ),
                ),
                if (a.description != null)
                  Text(
                    a.description!,
                    style: const TextStyle(
                      fontFamily: 'DM Sans',
                      fontSize: 11,
                      color: _kTextMuted,
                    ),
                  ),
              ],
            ),
          ),
          Text(
            '+${a.xpReward} XP',
            style: const TextStyle(
              fontFamily: 'DM Sans',
              fontWeight: FontWeight.w700,
              fontSize: 12,
              color: _kDark,
            ),
          ),
        ],
      ),
    );
  }
}
