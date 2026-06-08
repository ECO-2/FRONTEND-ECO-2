import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:frontend_eco_2/providers/providers.dart';

class MissionsTab extends StatelessWidget {
  const MissionsTab({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final missionsProvider = Provider.of<MissionsProvider>(context);

    return ListView(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 100),
      children: [
        // Seeds header
        Card(
          color: theme.colorScheme.secondaryContainer.withValues(alpha: 0.4),
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: ListTile(
            leading: const Icon(Icons.monetization_on, color: Colors.orange, size: 36),
            title: const Text(
              'Tus Semillas Acumuladas',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            trailing: Text(
              '${missionsProvider.userSeeds}',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.orange,
              ),
            ),
          ),
        ),
        const SizedBox(height: 24),
        Text(
          'Misiones Activas',
          style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),

        // Missions List
        ...missionsProvider.achievements.map((ach) {
          final isCompleted = missionsProvider.isAchievementCompleted(ach.id);
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: isCompleted
                          ? theme.colorScheme.primary.withValues(alpha: 0.1)
                          : Colors.grey.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      isCompleted ? Icons.check : Icons.assignment_outlined,
                      color: isCompleted ? theme.colorScheme.primary : Colors.grey,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          ach.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          ach.description ?? '',
                          style: TextStyle(
                            fontSize: 12,
                            color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                          ),
                        ),
                        const SizedBox(height: 8),
                        // Progress bar mock
                        LinearProgressIndicator(
                          value: isCompleted ? 1.0 : 0.4,
                          backgroundColor: Colors.grey.withValues(alpha: 0.2),
                          color: theme.colorScheme.primary,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    children: [
                      const Text(
                        'Recompensa',
                        style: TextStyle(fontSize: 10, color: Colors.grey),
                      ),
                      Text(
                        '+${ach.xpReward} XP',
                        style: TextStyle(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }
}
