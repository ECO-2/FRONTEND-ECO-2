import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:frontend_eco_2/providers/providers.dart';

// ── Color tokens ─────────────────────────────────────────────────────────
const _kDark = Color(0xFF10454F);
const _kTextMuted = Color(0xFF807F7F);
const _kTextDark = Color(0xFF0D2B31);
const _kLime = Color(0xFFBDE038);
const _kCardBorder = Color(0xFFE5E5E5);

// ── Mock upcoming missions ─────────────────────────────────────────────────
const _upcomingMissions = [
  (
    title: 'Coleccionista Tropical',
    desc: 'Añade 3 especies tropicales distintas',
    icon: Icons.park_rounded,
    progress: 0.33,
  ),
  (
    title: 'Cuidadora Experta',
    desc: 'Completa 10 cuidados sin atrasos',
    icon: Icons.water_drop_rounded,
    progress: 0.0,
  ),
  (
    title: 'Exploradora del Bosque',
    desc: 'Escanea 5 plantas silvestres',
    icon: Icons.search_rounded,
    progress: 0.0,
  ),
];

class MissionsTab extends StatefulWidget {
  const MissionsTab({super.key});

  @override
  State<MissionsTab> createState() => _MissionsTabState();
}

class _MissionsTabState extends State<MissionsTab> {
  int _selectedTab = 0; // 0: Activa, 1: Completadas, 2: Bloqueadas

  @override
  Widget build(BuildContext context) {
    final missionsProvider = Provider.of<MissionsProvider>(context);

    return Column(
      children: [
        // ── Tabs row ───────────────────────────────────────────
        _buildTabs(),
        // ── Content ────────────────────────────────────────────
        Expanded(
          child: ListView(
            padding:
                const EdgeInsets.only(left: 24, right: 24, top: 16, bottom: 100),
            children: [
              if (_selectedTab == 0) ...[
                _buildActiveMissionCard(missionsProvider),
                const SizedBox(height: 24),
                _buildUpcomingHeader(),
                const SizedBox(height: 12),
                ..._upcomingMissions.map((m) => Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: _buildUpcomingCard(m),
                    )),
              ] else if (_selectedTab == 1) ...[
                const SizedBox(height: 40),
                const Center(
                  child: Text(
                    'No hay misiones completadas aún',
                    style: TextStyle(color: _kTextMuted, fontFamily: 'DM Sans'),
                  ),
                ),
              ] else ...[
                const SizedBox(height: 40),
                const Center(
                  child: Text(
                    'Completa misiones activas para desbloquear más',
                    style: TextStyle(color: _kTextMuted, fontFamily: 'DM Sans'),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
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

  // ── Active Mission card (dark green bg, Figma: #10454F, borderRadius 18) ──
  Widget _buildActiveMissionCard(MissionsProvider mp) {
    return Container(
      decoration: BoxDecoration(
        color: _kDark,
        borderRadius: BorderRadius.circular(18),
      ),
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header row: text + icon square
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Badge "• EN PROGRESO" (lime bg, dark text)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: _kLime,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Text(
                        '• EN PROGRESO',
                        style: TextStyle(
                          fontFamily: 'DM Sans',
                          fontWeight: FontWeight.w700,
                          fontSize: 8,
                          color: _kTextDark,
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    // Mission title (large, white)
                    const Text(
                      'Jardín Urbano',
                      style: TextStyle(
                        fontFamily: 'DM Sans',
                        fontWeight: FontWeight.w700,
                        fontSize: 22,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 2),
                    // Subtitle (lime)
                    const Text(
                      'Registra 5 plantas en tu colección',
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
              // Trophy icon square (white translucent)
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(16),
                ),
                alignment: Alignment.center,
                child: const Icon(
                  Icons.emoji_events_rounded,
                  color: Colors.white,
                  size: 28,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          // Progress labels
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '2 de 5 plantas',
                style: TextStyle(
                  fontFamily: 'DM Sans',
                  fontWeight: FontWeight.w500,
                  fontSize: 11,
                  color: _kLime,
                ),
              ),
              Text(
                '40%',
                style: TextStyle(
                  fontFamily: 'DM Sans',
                  fontWeight: FontWeight.w700,
                  fontSize: 11,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Progress bar (white translucent bg, white fill)
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
                widthFactor: 0.4,
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
          // Badges row: +50 semillas | 12 días
          Row(
            children: [
              // Semillas badge (lime bg)
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: _kLime,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.eco_rounded, size: 12, color: _kTextDark),
                    SizedBox(width: 6),
                    Text(
                      '+50 semillas',
                      style: TextStyle(
                        fontFamily: 'DM Sans',
                        fontWeight: FontWeight.w600,
                        fontSize: 11,
                        color: _kTextDark,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              // Time badge (white translucent)
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.access_time_rounded,
                        size: 12, color: Colors.white),
                    SizedBox(width: 4),
                    Text(
                      '12 días',
                      style: TextStyle(
                        fontFamily: 'DM Sans',
                        fontWeight: FontWeight.w500,
                        fontSize: 11,
                        color: Colors.white,
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

  // ── "Próximas misiones" header ────────────────────────────────────────
  Widget _buildUpcomingHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Próximas misiones',
          style: TextStyle(
            fontFamily: 'DM Sans',
            fontWeight: FontWeight.w700,
            fontSize: 15,
            color: _kTextDark,
          ),
        ),
        Row(
          children: [
            Text(
              'Ver todas',
              style: TextStyle(
                fontFamily: 'DM Sans',
                fontWeight: FontWeight.w500,
                fontSize: 11,
                color: _kTextMuted,
              ),
            ),
            const Icon(Icons.chevron_right_rounded,
                size: 16, color: _kTextMuted),
          ],
        ),
      ],
    );
  }

  // ── Upcoming mission card (white, bordered) ───────────────────────────
  Widget _buildUpcomingCard(
      ({String title, String desc, IconData icon, double progress}) m) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _kCardBorder),
      ),
      child: Row(
        children: [
          // Lime icon square
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: _kLime,
              borderRadius: BorderRadius.circular(12),
            ),
            alignment: Alignment.center,
            child: Icon(m.icon, color: _kTextDark, size: 22),
          ),
          const SizedBox(width: 12),
          // Text + dots
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  m.title,
                  style: const TextStyle(
                    fontFamily: 'DM Sans',
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                    color: _kTextDark,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  m.desc,
                  style: const TextStyle(
                    fontFamily: 'DM Sans',
                    fontWeight: FontWeight.w400,
                    fontSize: 11,
                    color: _kTextMuted,
                  ),
                ),
                if (m.progress > 0) ...[
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: _kLime,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      const SizedBox(width: 4),
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: _kCardBorder,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
          const Icon(Icons.chevron_right_rounded,
              size: 18, color: _kTextMuted),
        ],
      ),
    );
  }
}
