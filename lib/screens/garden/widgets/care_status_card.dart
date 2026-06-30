import 'package:flutter/material.dart';
import 'package:frontend_eco_2/models/models.dart';
import 'species_data.dart';

class CareStatusCard extends StatelessWidget {
  final UserPlant plant;
  final SpeciesData sp;

  const CareStatusCard({
    super.key,
    required this.plant,
    required this.sp,
  });

  @override
  Widget build(BuildContext context) {
    // Calculate dynamic dates
    final lastWatered = plant.lastWateredAt ?? DateTime.now().subtract(const Duration(days: 8));
    final daysSinceWater = DateTime.now().difference(lastWatered).inDays;
    
    final isOverdue = daysSinceWater > sp.waterFreqDays;
    final overdueDays = isOverdue ? daysSinceWater - sp.waterFreqDays : 0;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF0D2B31), width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Estado de cuidado',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: Color(0xFF0D2B31),
                ),
              ),
              if (isOverdue)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF56B1C),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Row(
                    children: [
                      Icon(
                        Icons.warning_amber_rounded,
                        size: 12,
                        color: Colors.white,
                      ),
                      SizedBox(width: 4),
                      Text(
                        'Riego Urgente',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                )
              else
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF2F4EB),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: const Color(0xFF8A9A65)),
                  ),
                  child: const Row(
                    children: [
                      Icon(
                        Icons.check_rounded,
                        size: 12,
                        color: Color(0xFF10454F),
                      ),
                      SizedBox(width: 4),
                      Text(
                        'Al día',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF10454F),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  children: [
                    Text(
                      '$daysSinceWater',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                        color: Color(0xFF0D2B31),
                      ),
                    ),
                    const SizedBox(height: 2),
                    const Text(
                      'días sin riego',
                      style: TextStyle(fontSize: 10, color: Color(0xFF807F7F)),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    Text(
                      sp.waterFreq,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                        color: Color(0xFF0D2B31),
                      ),
                    ),
                    const SizedBox(height: 2),
                    const Text(
                      'frecuencia',
                      style: TextStyle(fontSize: 10, color: Color(0xFF807F7F)),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    Text(
                      isOverdue ? '+$overdueDays\u{0064}' : '0d',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                        color: Color(0xFF0D2B31),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      isOverdue ? 'vencido' : 'de retraso',
                      style: const TextStyle(fontSize: 10, color: Color(0xFF807F7F)),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: (daysSinceWater / sp.waterFreqDays).clamp(0.0, 1.0),
              backgroundColor: const Color(0xFFEBF0EE),
              color: const Color(0xFF0D2B31),
              minHeight: 8,
            ),
          ),
        ],
      ),
    );
  }
}
