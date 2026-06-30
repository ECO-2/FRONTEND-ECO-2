import 'package:flutter/material.dart';

class CareHistoryList extends StatelessWidget {
  final DateTime lastWatered;
  final int daysSinceWater;

  const CareHistoryList({
    super.key,
    required this.lastWatered,
    required this.daysSinceWater,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildCareHistoryItem(
          title: 'Riego',
          dateText: _formatDate(lastWatered),
          timeAgoText: daysSinceWater == 0
              ? 'hoy'
              : daysSinceWater == 1
                  ? 'ayer'
                  : 'hace $daysSinceWater días',
          icon: Icons.water_drop_rounded,
          iconColor: const Color(0xFF4A90D9),
          iconBgColor: const Color(0xFFEAF3FC),
        ),
        _buildCareHistoryItem(
          title: 'Fertilización',
          dateText: _formatDate(DateTime.now().subtract(const Duration(days: 27))),
          timeAgoText: 'hace 27 días',
          icon: Icons.wb_sunny_rounded,
          iconColor: const Color(0xFFFABF2E),
          iconBgColor: const Color(0xFFFFF9E6),
        ),
        _buildCareHistoryItem(
          title: 'Riego',
          dateText: _formatDate(DateTime.now().subtract(const Duration(days: 15))),
          timeAgoText: 'hace 15 días',
          icon: Icons.water_drop_rounded,
          iconColor: const Color(0xFF4A90D9),
          iconBgColor: const Color(0xFFEAF3FC),
        ),
      ],
    );
  }

  String _formatDate(DateTime dt) {
    final months = [
      'Ene', 'Feb', 'Mar', 'Abr', 'May', 'Jun',
      'Jul', 'Ago', 'Sep', 'Oct', 'Nov', 'Dic'
    ];
    return '${dt.day.toString().padLeft(2, '0')} ${months[dt.month - 1]} ${dt.year}';
  }

  Widget _buildCareHistoryItem({
    required String title,
    required String dateText,
    required String timeAgoText,
    required IconData icon,
    required Color iconColor,
    required Color iconBgColor,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: iconBgColor,
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: iconColor,
              size: 18,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: Color(0xFF0D2B31),
                    fontFamily: 'Inter',
                  ),
                ),
                Text(
                  dateText,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF807F7F),
                    fontFamily: 'Inter',
                  ),
                ),
              ],
            ),
          ),
          Text(
            timeAgoText,
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF807F7F),
              fontFamily: 'Inter',
            ),
          ),
        ],
      ),
    );
  }
}
