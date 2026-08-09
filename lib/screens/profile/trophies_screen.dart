import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:frontend_eco_2/models/models.dart';
import 'package:frontend_eco_2/providers/providers.dart';
import 'package:frontend_eco_2/widgets/common/custom_app_bar.dart';

// ── Figma color tokens ────────────────────────────────────────────────────
const _kDark = Color(0xFF10454F);
const _kBg = Color(0xFFF8FAF9);
const _kTextMuted = Color(0xFF807F7F);
const _kTextDark = Color(0xFF0D2B31);
const _kLime = Color(0xFFBDE038);
const _kCardBorder = Color(0xFFE5E5E5);

// Mismo criterio que missions_tab.dart: solo estas condiciones tienen un
// contador real hoy; el resto se muestra como logro "sin progreso visible"
// en vez de fingir datos.
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

class TrophiesScreen extends StatefulWidget {
  const TrophiesScreen({super.key});

  @override
  State<TrophiesScreen> createState() => _TrophiesScreenState();
}

class _TrophiesScreenState extends State<TrophiesScreen> {
  int _selectedTab = 0; // 0: Trofeos, 1: Misiones (en progreso), 2: Logros (completados)

  @override
  Widget build(BuildContext context) {
    final mp = Provider.of<MissionsProvider>(context);
    final userProvider = Provider.of<UserProvider>(context);
    final achievements = mp.achievements;
    final completed =
        achievements.where((a) => mp.isAchievementCompleted(a.id)).toList();
    final inProgress = mp.lockedAchievements
      ..sort((a, b) => (a.conditionValue - mp.progressFor(a))
          .compareTo(b.conditionValue - mp.progressFor(b)));

    final total = achievements.isEmpty ? 0 : achievements.length;
    final pct = total == 0 ? 0 : ((completed.length / total) * 100).round();

    return Scaffold(
      backgroundColor: _kBg,
      appBar: const CustomAppBar(
        title: 'Trofeos',
        automaticallyImplyLeading: true,
      ),
      body: mp.isLoading && achievements.isEmpty
          ? const Center(child: CircularProgressIndicator(color: _kDark))
          : Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.only(bottom: 32),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
                          child: _buildLevelHero(mp, userProvider, completed.length),
                        ),
                        const SizedBox(height: 16),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: _buildStatsRow(completed.length, total, pct),
                        ),
                        const SizedBox(height: 20),
                        _buildTabs(),
                        const SizedBox(height: 16),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: _buildTabContent(mp, achievements, completed, inProgress),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildTabContent(
    MissionsProvider mp,
    List<Achievement> all,
    List<Achievement> completed,
    List<Achievement> inProgress,
  ) {
    if (_selectedTab == 0) {
      // Trofeos: todos los logros, como grid de insignias.
      if (all.isEmpty) return _buildEmpty('Todavía no hay logros configurados.');
      final screenWidth = MediaQuery.of(context).size.width;
      final childAspectRatio = screenWidth < 360 ? 0.58 : 0.68;
      return GridView.builder(
        padding: EdgeInsets.zero,
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: all.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: childAspectRatio,
        ),
        itemBuilder: (context, i) =>
            _buildTrophyCard(all[i], mp.isAchievementCompleted(all[i].id)),
      );
    } else if (_selectedTab == 1) {
      // Misiones: logros aún no desbloqueados, con progreso real si es rastreable.
      if (inProgress.isEmpty) return _buildEmpty('¡Ya desbloqueaste todos los logros!');
      return Column(
        children: inProgress
            .map((a) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: _buildProgressCard(mp, a),
                ))
            .toList(),
      );
    } else {
      // Logros: los ya completados.
      if (completed.isEmpty) return _buildEmpty('No has completado logros todavía.');
      return Column(
        children: completed
            .map((a) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: _buildCompletedTile(a),
                ))
            .toList(),
      );
    }
  }

  Widget _buildEmpty(String message) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 32),
        child: Center(
          child: Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(color: _kTextMuted, fontFamily: 'DM Sans'),
          ),
        ),
      );

  // ── Level Hero card ────────────────────────────────────────────────────
  Widget _buildLevelHero(MissionsProvider mp, UserProvider userProvider, int trophyCount) {
    final level = mp.progress?.level ?? 1;
    final xp = mp.progress?.xp ?? 0;
    final username = userProvider.currentUser?.username ?? 'Jardinera';

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: _kDark,
        borderRadius: BorderRadius.circular(18),
      ),
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: const BoxDecoration(shape: BoxShape.circle, color: _kLime),
            alignment: Alignment.center,
            child: Text(
              '$level',
              style: const TextStyle(
                fontFamily: 'DM Sans',
                fontWeight: FontWeight.w900,
                fontSize: 28,
                color: _kTextDark,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  username,
                  style: const TextStyle(
                    fontFamily: 'DM Sans',
                    fontWeight: FontWeight.w700,
                    fontSize: 18,
                    color: Colors.white,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  'Nivel $level · $xp XP · $trophyCount trofeos',
                  style: const TextStyle(
                    fontFamily: 'DM Sans',
                    fontWeight: FontWeight.w500,
                    fontSize: 12,
                    color: _kLime,
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: Colors.white.withValues(alpha: 0.12),
            ),
            alignment: Alignment.center,
            child: const Icon(Icons.emoji_events_rounded, color: _kLime, size: 24),
          ),
        ],
      ),
    );
  }

  // ── Stats row ─────────────────────────────────────────────────────────
  Widget _buildStatsRow(int completedCount, int total, int pct) {
    return Row(
      children: [
        _statCard('$completedCount', 'Obtenidos'),
        const SizedBox(width: 10),
        _statCard('$total', 'Disponibles'),
        const SizedBox(width: 10),
        _statCard('$pct%', 'Completado'),
      ],
    );
  }

  Widget _statCard(String value, String label) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: _kCardBorder),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: const TextStyle(
                fontFamily: 'DM Sans',
                fontWeight: FontWeight.w700,
                fontSize: 20,
                color: _kTextDark,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: const TextStyle(
                fontFamily: 'DM Sans',
                fontSize: 11,
                color: _kTextMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Tabs ─────────────────────────────────────────────────────────────
  Widget _buildTabs() {
    const tabs = ['Trofeos', 'Misiones', 'Logros'];
    return Container(
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFFEEEEEE))),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24),
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
                        fontWeight: selected
                            ? FontWeight.w700
                            : FontWeight.w400,
                        fontSize: 14,
                        color: selected ? _kTextDark : _kTextMuted,
                      ),
                    ),
                  ),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    height: 2,
                    width: selected ? 32 : 0,
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

  // ── Trophy card (grid, "Trofeos" tab) ──────────────────────────────────
  Widget _buildTrophyCard(Achievement a, bool unlocked) {
    final circleBg = unlocked ? const Color(0xFFFEF8E7) : const Color(0xFFECECEC);
    final iconColor = unlocked ? const Color(0xFFFABF2E) : const Color(0xFF909090);
    final iconData = unlocked ? _iconForCondition(a.conditionType) : Icons.lock_rounded;

    return Container(
      decoration: BoxDecoration(
        color: unlocked ? Colors.white : const Color(0xFFF4F5F4),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: _kCardBorder),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(shape: BoxShape.circle, color: circleBg),
            alignment: Alignment.center,
            child: Icon(iconData, color: iconColor, size: 26),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: Text(
              a.name,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'DM Sans',
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: unlocked ? _kTextDark : const Color(0xFF808080),
                height: 1.2,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: circleBg,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              '+${a.xpReward} XP',
              style: TextStyle(
                fontFamily: 'DM Sans',
                fontSize: 9,
                fontWeight: FontWeight.w700,
                color: iconColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Progress card ("Misiones" tab) ─────────────────────────────────────
  Widget _buildProgressCard(MissionsProvider mp, Achievement a) {
    final trackable = _kTrackableConditions.contains(a.conditionType);
    final current = mp.progressFor(a);
    final progress = !trackable || a.conditionValue == 0
        ? 0.0
        : (current / a.conditionValue).clamp(0.0, 1.0);

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
            width: 44,
            height: 44,
            decoration: BoxDecoration(color: _kLime.withValues(alpha: 0.25), borderRadius: BorderRadius.circular(12)),
            alignment: Alignment.center,
            child: Icon(_iconForCondition(a.conditionType), color: _kDark, size: 20),
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
                const SizedBox(height: 4),
                if (trackable)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(3),
                    child: LinearProgressIndicator(
                      value: progress,
                      minHeight: 5,
                      backgroundColor: const Color(0xFFECECEC),
                      valueColor: const AlwaysStoppedAnimation<Color>(_kLime),
                    ),
                  )
                else
                  Text(
                    'Próximamente',
                    style: const TextStyle(fontFamily: 'DM Sans', fontSize: 11, color: _kTextMuted),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text(
            '+${a.xpReward} XP',
            style: const TextStyle(
              fontFamily: 'DM Sans',
              fontWeight: FontWeight.w700,
              fontSize: 11,
              color: _kDark,
            ),
          ),
        ],
      ),
    );
  }

  // ── Completed tile ("Logros" tab) ──────────────────────────────────────
  Widget _buildCompletedTile(Achievement a) {
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
            width: 44,
            height: 44,
            decoration: const BoxDecoration(color: Color(0xFFFEF8E7), shape: BoxShape.circle),
            alignment: Alignment.center,
            child: const Icon(Icons.emoji_events_rounded, color: Color(0xFFFABF2E), size: 20),
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
                    style: const TextStyle(fontFamily: 'DM Sans', fontSize: 11, color: _kTextMuted),
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
