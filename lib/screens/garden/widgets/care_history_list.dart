import 'package:flutter/material.dart';
import 'package:frontend_eco_2/l10n/app_localizations.dart';
import 'package:frontend_eco_2/models/models.dart';
import 'package:frontend_eco_2/utils/care_task_labels.dart';

/// Historial real de cuidados de una planta (GET /care/plants/{id}/logs).
/// Antes esto mostraba 2 de 3 entradas completamente inventadas
/// (`DateTime.now().subtract(Duration(days: 27))` fijo, sin relación con la
/// planta real) — ahora refleja lo que el usuario realmente registró.
class CareHistoryList extends StatelessWidget {
  final List<CareLog> logs;

  const CareHistoryList({super.key, required this.logs});

  @override
  Widget build(BuildContext context) {
    if (logs.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        decoration: BoxDecoration(
          color: const Color(0xFFF8FAF9),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFE2E7E4)),
        ),
        child: const Text(
          'Aún no has registrado cuidados para esta planta.',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 12, color: Color(0xFF807F7F), fontFamily: 'Inter'),
        ),
      );
    }

    final sorted = [...logs]..sort((a, b) => b.performedAt.compareTo(a.performedAt));
    final recent = sorted.take(5);

    return Column(
      children: recent.map((log) => _buildCareHistoryItem(context, log)).toList(),
    );
  }

  Widget _buildCareHistoryItem(BuildContext context, CareLog log) {
    final visual = careTaskVisual(log.taskType);
    final daysAgo = DateTime.now().difference(log.performedAt).inDays;
    final timeAgoText = daysAgo <= 0 ? 'hoy' : daysAgo == 1 ? 'ayer' : AppLocalizations.of(context)!.timeAgoDays(daysAgo);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(color: visual.background, shape: BoxShape.circle),
            child: Icon(visual.icon, color: visual.color, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  visual.label,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: Color(0xFF0D2B31),
                    fontFamily: 'Inter',
                  ),
                ),
                Text(
                  _formatDate(log.performedAt),
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
            style: const TextStyle(fontSize: 12, color: Color(0xFF807F7F), fontFamily: 'Inter'),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime dt) {
    const months = [
      'Ene', 'Feb', 'Mar', 'Abr', 'May', 'Jun',
      'Jul', 'Ago', 'Sep', 'Oct', 'Nov', 'Dic',
    ];
    return '${dt.day.toString().padLeft(2, '0')} ${months[dt.month - 1]} ${dt.year}';
  }
}
