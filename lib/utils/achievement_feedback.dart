import 'package:flutter/material.dart';
import 'package:frontend_eco_2/models/models.dart';
import 'package:frontend_eco_2/theme/app_colors.dart';

/// Muestra un SnackBar de celebración por cada logro recién desbloqueado.
/// ScaffoldMessenger encola los SnackBars automáticamente, así que varios
/// logros desbloqueados a la vez se muestran uno tras otro sin pisarse.
void showAchievementUnlockedSnackbars(BuildContext context, List<Achievement> unlocked) {
  if (unlocked.isEmpty || !context.mounted) return;
  final messenger = ScaffoldMessenger.of(context);
  for (final achievement in unlocked) {
    messenger.showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.emoji_events_rounded, color: AppColors.gold, size: 20),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                '¡Logro desbloqueado! ${achievement.name} (+${achievement.xpReward} XP)',
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
        backgroundColor: AppColors.primaryDark,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}
