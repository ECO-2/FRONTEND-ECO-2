import 'package:flutter/material.dart';
import 'package:frontend_eco_2/widgets/common/custom_app_bar.dart';

// ── Figma color tokens ────────────────────────────────────────────────────
const _kDark = Color(0xFF10454F);
const _kBg = Color(0xFFF8FAF9);
const _kTextMuted = Color(0xFF807F7F);
const _kTextDark = Color(0xFF0D2B31);
const _kLime = Color(0xFFBDE038);
const _kCardBorder = Color(0xFFE5E5E5);

class TrophiesScreen extends StatefulWidget {
  const TrophiesScreen({super.key});

  @override
  State<TrophiesScreen> createState() => _TrophiesScreenState();
}

class _TrophiesScreenState extends State<TrophiesScreen> {
  int _selectedTab = 0; // 0: Trofeos, 1: Misiones, 2: Logros

  final List<_TrophyItem> _trophies = const [
    _TrophyItem(
      title: 'Primera Planta',
      category: 'Bronce',
      isUnlocked: true,
      desc: 'Añade tu primera planta',
    ),
    _TrophyItem(
      title: 'Coleccionista',
      category: 'Plata',
      isUnlocked: true,
      desc: 'Añade 5 plantas distintas',
    ),
    _TrophyItem(
      title: 'Cuidadora Fiel',
      category: 'Oro',
      isUnlocked: true,
      desc: 'Completa 30 riegos',
    ),
    _TrophyItem(
      title: 'Explorer x10',
      category: 'Plata',
      isUnlocked: true,
      desc: 'Escanea 10 plantas',
    ),
    _TrophyItem(
      title: 'Riego Master',
      category: 'Bronce',
      isUnlocked: false,
      desc: 'Completa 100 riegos',
    ),
    _TrophyItem(
      title: 'Verde Total',
      category: 'Oro',
      isUnlocked: false,
      desc: 'Alcanza nivel 10',
    ),
    _TrophyItem(
      title: 'Jardín Pro',
      category: 'Oro',
      isUnlocked: false,
      desc: 'Añade 20 plantas',
    ),
    _TrophyItem(
      title: 'Escáner',
      category: 'Plata',
      isUnlocked: false,
      desc: 'Escanea 25 plantas',
    ),
    _TrophyItem(
      title: 'Sembradora',
      category: 'Bronce',
      isUnlocked: false,
      desc: 'Acumula 500 semillas',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final filtered = _trophies;
    final double screenWidth = MediaQuery.of(context).size.width;
    final double childAspectRatio = screenWidth < 360 ? 0.58 : 0.68;

    return Scaffold(
      backgroundColor: _kBg,
      appBar: const CustomAppBar(
        title: 'Trofeos',
        automaticallyImplyLeading: true,
      ),
      body: Column(
        children: [
          // ── Scrollable body ────────────────────────────────────
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 32),
              child: Column(
                children: [
                  // Level Hero card
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
                    child: _buildLevelHero(),
                  ),
                  const SizedBox(height: 16),
                  // Stats row
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: _buildStatsRow(),
                  ),
                  const SizedBox(height: 20),
                  // Tabs
                  _buildTabs(),
                  const SizedBox(height: 16),
                  // Trophy grid
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: GridView.builder(
                      padding: EdgeInsets.zero,
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: filtered.length,
                      gridDelegate:
                          SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            mainAxisSpacing: 12,
                            crossAxisSpacing: 12,
                            childAspectRatio: childAspectRatio,
                          ),
                      itemBuilder: (context, i) =>
                          _buildTrophyCard(filtered[i]),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Level Hero card (dark green, borderRadius 18) ────────────────────
  Widget _buildLevelHero() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: _kDark,
        borderRadius: BorderRadius.circular(18),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Row(
            children: [
              // Level circle (lime)
              Container(
                width: 64,
                height: 64,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: _kLime,
                ),
                alignment: Alignment.center,
                child: const Text(
                  '5',
                  style: TextStyle(
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
                  children: const [
                    Text(
                      'Jardinera Dedicada',
                      style: TextStyle(
                        fontFamily: 'DM Sans',
                        fontWeight: FontWeight.w700,
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Nivel 5 · 12 trofeos desbloqueados',
                      style: TextStyle(
                        fontFamily: 'DM Sans',
                        fontWeight: FontWeight.w500,
                        fontSize: 12,
                        color: _kLime,
                      ),
                    ),
                  ],
                ),
              ),
              // Trophy icon
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: Colors.white.withValues(alpha: 0.12),
                ),
                alignment: Alignment.center,
                child: const Icon(
                  Icons.emoji_events_rounded,
                  color: _kLime,
                  size: 24,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          // XP bar labels
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Próximo: Guardiana Verde',
                style: TextStyle(
                  fontFamily: 'DM Sans',
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                  color: _kLime,
                ),
              ),
              Text(
                '340 / 500 XP',
                style: TextStyle(
                  fontFamily: 'DM Sans',
                  fontWeight: FontWeight.w700,
                  fontSize: 12,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // XP progress bar
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: 340 / 500,
              minHeight: 6,
              backgroundColor: Colors.white.withValues(alpha: 0.15),
              valueColor: const AlwaysStoppedAnimation<Color>(_kLime),
            ),
          ),
        ],
      ),
    );
  }

  // ── Stats row ─────────────────────────────────────────────────────────
  Widget _buildStatsRow() {
    return Row(
      children: [
        _statCard('12', 'Obtenidos'),
        const SizedBox(width: 10),
        _statCard('28', 'Disponibles'),
        const SizedBox(width: 10),
        _statCard('43%', 'Completado'),
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

  // ── Trophy card ───────────────────────────────────────────────────────
  Widget _buildTrophyCard(_TrophyItem t) {
    Color circleBg;
    Color iconColor;
    IconData iconData;
    String badgeText;
    Color badgeTextCol;
    Color badgeBg;

    if (!t.isUnlocked) {
      circleBg = const Color(0xFFECECEC);
      iconColor = const Color(0xFF909090);
      iconData = Icons.lock_rounded;
      badgeText = 'Bloqueado';
      badgeTextCol = const Color(0xFF707070);
      badgeBg = const Color(0xFFECECEC);
    } else {
      iconData = Icons.emoji_events_rounded;
      if (t.category == 'Oro') {
        circleBg = const Color(0xFFFEF8E7);
        iconColor = const Color(0xFFFABF2E);
        badgeText = 'Oro';
        badgeTextCol = const Color(0xFFC6920C);
        badgeBg = const Color(0xFFFEF8E7);
      } else if (t.category == 'Plata') {
        circleBg = const Color(0xFFF1F3F2);
        iconColor = const Color(0xFF818274);
        badgeText = 'Plata';
        badgeTextCol = const Color(0xFF5A5B52);
        badgeBg = const Color(0xFFF1F3F2);
      } else {
        circleBg = const Color(0xFFFDF0E7);
        iconColor = const Color(0xFFE26B26);
        badgeText = 'Bronce';
        badgeTextCol = const Color(0xFFB94E13);
        badgeBg = const Color(0xFFFDF0E7);
      }
    }

    return Container(
      decoration: BoxDecoration(
        color: t.isUnlocked ? Colors.white : const Color(0xFFF4F5F4),
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
              t.title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'DM Sans',
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: t.isUnlocked ? _kTextDark : const Color(0xFF808080),
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
              color: badgeBg,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              badgeText,
              style: TextStyle(
                fontFamily: 'DM Sans',
                fontSize: 9,
                fontWeight: FontWeight.w700,
                color: badgeTextCol,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TrophyItem {
  final String title;
  final String category;
  final bool isUnlocked;
  final String desc;

  const _TrophyItem({
    required this.title,
    required this.category,
    required this.isUnlocked,
    required this.desc,
  });
}
