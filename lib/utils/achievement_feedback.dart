import 'package:flutter/material.dart';
import 'package:frontend_eco_2/models/models.dart';
import 'package:frontend_eco_2/widgets/common/app_toast.dart';

/// Muestra un toast de celebración por cada logro recién desbloqueado, uno
/// tras otro (con una breve pausa entre cada uno) si se desbloquea más de
/// uno a la vez.
void showAchievementUnlockedSnackbars(BuildContext context, List<Achievement> unlocked) {
  if (unlocked.isEmpty || !context.mounted) return;
  _showSequentially(context, unlocked, 0);
}

Future<void> _showSequentially(
  BuildContext context,
  List<Achievement> unlocked,
  int index,
) async {
  if (index >= unlocked.length || !context.mounted) return;
  final achievement = unlocked[index];
  final reward = achievement.seedReward > 0
      ? '+${achievement.xpReward} XP · +${achievement.seedReward} semillas'
      : '+${achievement.xpReward} XP';
  showAppToast(
    context,
    '🏆 ¡Logro desbloqueado! ${achievement.name} ($reward)',
    type: ToastType.success,
    duration: const Duration(seconds: 3),
  );

  if (index + 1 < unlocked.length) {
    await Future.delayed(const Duration(seconds: 3, milliseconds: 300));
    if (context.mounted) {
      await _showSequentially(context, unlocked, index + 1);
    }
  }
}
