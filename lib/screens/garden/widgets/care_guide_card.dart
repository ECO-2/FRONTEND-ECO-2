import 'package:flutter/material.dart';
import 'species_data.dart';

/// Tarjeta de orientación: a diferencia de [SpeciesCareGrid] (datos crudos:
/// frecuencia, temperatura, luz...) esto traduce esos datos a lenguaje
/// llano — dónde ubicar la planta y cómo regarla — para alguien que recién
/// la agregó y no sabe por dónde empezar.
class CareGuideCard extends StatelessWidget {
  final SpeciesData sp;

  const CareGuideCard({super.key, required this.sp});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAF9),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E7E4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.tips_and_updates_rounded, size: 18, color: Color(0xFF10454F)),
              SizedBox(width: 8),
              Text(
                'Cómo cuidar tu planta',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: Color(0xFF0D2B31),
                  fontFamily: 'Inter',
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _hintRow(Icons.wb_sunny_rounded, const Color(0xFFB8860B), sp.placementHint),
          const SizedBox(height: 14),
          Text(
            sp.careGuide,
            style: const TextStyle(
              fontSize: 13,
              color: Color(0xFF3A534E),
              fontFamily: 'Inter',
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _hintRow(IconData icon, Color color, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Color(0xFF0D2B31),
              fontFamily: 'Inter',
            ),
          ),
        ),
      ],
    );
  }
}
