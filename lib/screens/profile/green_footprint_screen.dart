import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:frontend_eco_2/providers/providers.dart';
import 'package:frontend_eco_2/theme/app_colors.dart';
import 'package:frontend_eco_2/widgets/common/custom_app_bar.dart';


// ── Color tokens extracted from Figma ────────────────────────────────────
const _kDark = Color(0xFF10454F);
const _kBg = Color(0xFFF8FAF9);
const _kTextMuted = Color(0xFF807F7F);
const _kTextDark = Color(0xFF0D2B31);
const _kLime = Color(0xFFBDE038);
const _kBarBg = Color(0xFFF0F0F0);

class GreenFootprintScreen extends StatelessWidget {
  const GreenFootprintScreen({super.key});

  // Mock plant CO2 data (gramos/día)
  static const _plants = [
    (name: 'Mi Monstera', grams: 16.4, ratio: 0.85),
    (name: 'Pothos dorado', grams: 11.0, ratio: 0.57),
    (name: 'Aloe vera', grams: 9.1, ratio: 0.47),
  ];

  // Weekly data L M X J V S D
  static const _weekDays = ['L', 'M', 'X', 'J', 'V', 'S', 'D'];
  static const _weekValues = [38.5, 49.0, 59.5, 52.5, 63.0, 56.0, 63.88];
  static const _maxBar = 63.88; // Max bar height ref (pixel heights from Figma)

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _kBg,
      appBar: const CustomAppBar(
        title: 'Mi Huella Verde',
        automaticallyImplyLeading: true,
      ),
      body: Column(
        children: [
          // ── Scrollable content ──────────────────────────────────
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // Hero blanco con número grande
                  _buildHero(),
                  _Divider(),
                  // Aporte por planta
                  _buildPlantContributions(),
                  _Divider(),
                  // Evolución semanal
                  _buildWeeklyChart(),
                  // CTA
                  _buildShareCTA(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHero() {
    return Container(
      width: double.infinity,
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(24, 22, 24, 18),
      child: Column(
        children: [
          // Label
          const Text(
            'CO₂ absorbido hoy',
            style: TextStyle(
              fontFamily: 'DM Sans',
              fontWeight: FontWeight.w500,
              fontSize: 14,
              color: _kTextMuted,
            ),
          ),
          const SizedBox(height: 4),
          // Big number — Syne Bold 64 (using DM Sans Bold as fallback)
          const Text(
            '36.5',
            style: TextStyle(
              fontFamily: 'DM Sans',
              fontWeight: FontWeight.w900,
              fontSize: 72,
              color: _kDark,
              height: 1.0,
            ),
          ),
          const Text(
            'gramos / día',
            style: TextStyle(
              fontFamily: 'DM Sans',
              fontWeight: FontWeight.w500,
              fontSize: 14,
              color: _kTextMuted,
            ),
          ),
          const SizedBox(height: 14),
          // Equivalence pill
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFFA3AB78).withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              '= No recorrer 0.19 km en auto por día',
              style: TextStyle(
                fontFamily: 'DM Sans',
                fontWeight: FontWeight.w500,
                fontSize: 11,
                color: _kTextDark,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlantContributions() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(24, 18, 24, 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Aporte por planta',
            style: TextStyle(
              fontFamily: 'DM Sans',
              fontWeight: FontWeight.w700,
              fontSize: 15,
              color: _kTextDark,
            ),
          ),
          const SizedBox(height: 12),
          ..._plants.map((p) => Padding(
                padding: const EdgeInsets.only(bottom: 14),
                child: Row(
                  children: [
                    // Name column
                    SizedBox(
                      width: 90,
                      child: Text(
                        p.name,
                        style: const TextStyle(
                          fontFamily: 'DM Sans',
                          fontWeight: FontWeight.w500,
                          fontSize: 12,
                          color: _kTextDark,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    // Bar
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(5),
                        child: Stack(
                          children: [
                            Container(height: 10, color: _kBarBg),
                            FractionallySizedBox(
                              widthFactor: p.ratio,
                              child: Container(
                                height: 10,
                                decoration: BoxDecoration(
                                  color: _kDark,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    // Value
                    SizedBox(
                      width: 44,
                      child: Text(
                        '${p.grams} g',
                        textAlign: TextAlign.right,
                        style: const TextStyle(
                          fontFamily: 'DM Sans',
                          fontWeight: FontWeight.w500,
                          fontSize: 12,
                          color: _kTextMuted,
                        ),
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }

  Widget _buildWeeklyChart() {
    const chartHeight = 110.0;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(24, 18, 24, 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Evolución semanal',
            style: TextStyle(
              fontFamily: 'DM Sans',
              fontWeight: FontWeight.w700,
              fontSize: 15,
              color: _kTextDark,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            height: chartHeight + 40,
            padding: const EdgeInsets.fromLTRB(8, 10, 8, 0),
            decoration: BoxDecoration(
              color: const Color(0xFFF0F0F0).withValues(alpha: 0.6),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(_weekDays.length, (i) {
                final barH = (_weekValues[i] / _maxBar) * chartHeight;
                return Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      width: 24,
                      height: barH,
                      decoration: BoxDecoration(
                        color: _kDark,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      _weekDays[i],
                      style: const TextStyle(
                        fontFamily: 'DM Sans',
                        fontWeight: FontWeight.w500,
                        fontSize: 11,
                        color: _kTextMuted,
                      ),
                    ),
                    const SizedBox(height: 4),
                  ],
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShareCTA() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
      child: SizedBox(
        width: double.infinity,
        height: 54,
        child: ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: _kLime,
            foregroundColor: _kTextDark,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(27),
            ),
          ),
          icon: const Icon(Icons.share_rounded, size: 20),
          label: const Text(
            'Compartir mi huella verde',
            style: TextStyle(
              fontFamily: 'DM Sans',
              fontWeight: FontWeight.w700,
              fontSize: 14,
            ),
          ),
          onPressed: () {},
        ),
      ),
    );
  }
}

// ── Thin divider line ─────────────────────────────────────────────────────
class _Divider extends StatelessWidget {
  const _Divider();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 1,
      color: const Color(0xFFE0E1DD),
    );
  }
}
