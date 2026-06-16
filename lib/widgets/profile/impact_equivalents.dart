import 'package:flutter/material.dart';
import 'package:frontend_eco_2/theme/app_colors.dart';

class ImpactEquivalentsCard extends StatelessWidget {
  const ImpactEquivalentsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFE8ECE9), width: 1.5),
      ),
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Tu impacto equivale a:',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryDark,
              fontFamily: 'Inter',
            ),
          ),
          const SizedBox(height: 20),
          _buildImpactRow(
            icon: Icons.park_outlined,
            iconBg: const Color(0xFFEAF5EA),
            iconColor: Colors.green,
            title: '12 Árboles',
            subtitle: 'Plantados absorbiendo CO₂ de la atmósfera.',
          ),
          const SizedBox(height: 16),
          _buildImpactRow(
            icon: Icons.lightbulb_outline_rounded,
            iconBg: const Color(0xFFFEF9E7),
            iconColor: AppColors.gold,
            title: '480 Horas',
            subtitle: 'De bombillo LED encendido ahorradas en luz.',
          ),
          const SizedBox(height: 16),
          _buildImpactRow(
            icon: Icons.directions_car_outlined,
            iconBg: const Color(0xFFFDF1EB),
            iconColor: AppColors.orange,
            title: '150 Kilómetros',
            subtitle: 'Evitados de conducción de coche a gasolina.',
          ),
        ],
      ),
    );
  }

  Widget _buildImpactRow({
    required IconData icon,
    required Color iconBg,
    required Color iconColor,
    required String title,
    required String subtitle,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: iconBg,
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: Icon(icon, color: iconColor, size: 20),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: AppColors.primaryDark,
                  fontFamily: 'Inter',
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                  fontFamily: 'Inter',
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
