import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:frontend_eco_2/providers/providers.dart';
import 'package:frontend_eco_2/routing/app_routes.dart';
import 'package:frontend_eco_2/theme/app_colors.dart';

class HomeTab extends StatelessWidget {
  final VoidCallback onViewAll;

  const HomeTab({
    super.key,
    required this.onViewAll,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final user = Provider.of<UserProvider>(context).currentUser;
    final plantsProvider = Provider.of<PlantsProvider>(context);
    final missionsProvider = Provider.of<MissionsProvider>(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Greeting & Stats Banner
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
            color: AppColors.primary,
            elevation: 0,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '¡Hola, ${user?.username ?? 'Usuario'}! 🌿',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.accent,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Sigue cuidando tus plantas para ganar más semillas y reducir tu huella verde.',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.85),
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildQuickStat(
                        context,
                        Icons.monetization_on,
                        '${missionsProvider.userSeeds}',
                        'Semillas',
                        isDark: true,
                      ),
                      _buildQuickStat(
                        context,
                        Icons.eco,
                        '${plantsProvider.userPlants.length}',
                        'Plantas',
                        isDark: true,
                      ),
                      _buildQuickStat(
                        context,
                        Icons.co2,
                        '1.2 kg',
                        'Reducido',
                        isDark: true,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Section Title: Action Required
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Necesitan atención',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: onViewAll,
                child: const Text('Ver todas'),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Plants List
          if (plantsProvider.userPlants.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    const Icon(Icons.eco_outlined, size: 64, color: Colors.grey),
                    const SizedBox(height: 16),
                    const Text('No tienes plantas registradas en tu jardín.'),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: () => Navigator.pushNamed(context, AppRoutes.addPlant),
                      icon: const Icon(Icons.add),
                      label: const Text('Añadir Planta'),
                    ),
                  ],
                ),
              ),
            )
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: plantsProvider.userPlants.length,
              itemBuilder: (context, index) {
                final plant = plantsProvider.userPlants[index];
                // Simulating Figma description warning: "Lleva 8 días sin riego"
                final daysSinceWater = plant.lastWateredAt != null
                    ? DateTime.now().difference(plant.lastWateredAt!).inDays
                    : 10;
                final needsWater = daysSinceWater >= 7;

                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  elevation: 0,
                  color: AppColors.cardBackground,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: BorderSide(
                      color: needsWater ? AppColors.orange.withValues(alpha: 0.5) : AppColors.textMuted.withValues(alpha: 0.15),
                      width: needsWater ? 1.5 : 1,
                    ),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(12),
                    leading: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.06),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.local_florist_outlined,
                        color: AppColors.primary,
                      ),
                    ),
                    title: Text(
                      plant.nickname,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          plant.speciesId == 's1' ? 'Monstera deliciosa' : 'Epipremnum aureum',
                          style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
                        ),
                        const SizedBox(height: 4),
                        if (needsWater)
                          Text(
                            '⚠️ Lleva $daysSinceWater días sin riego. Riégala hoy.',
                            style: const TextStyle(color: AppColors.orange, fontSize: 12, fontWeight: FontWeight.bold),
                          )
                        else
                          Text(
                            'Último riego: hace $daysSinceWater días',
                            style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                          ),
                      ],
                    ),
                    trailing: IconButton(
                      icon: Icon(
                        needsWater ? Icons.water_drop : Icons.water_drop_outlined,
                        color: needsWater ? AppColors.orange : AppColors.textSecondary,
                      ),
                      onPressed: () {
                        plantsProvider.waterPlant(plant.id);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('¡Has regado a ${plant.nickname}! 💧'),
                            duration: const Duration(seconds: 2),
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            ),
          const SizedBox(height: 100),
        ],
      ),
    );
  }

  Widget _buildQuickStat(BuildContext context, IconData icon, String value, String label, {bool isDark = false}) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Icon(icon, color: isDark ? AppColors.accent : AppColors.primary, size: 28),
        const SizedBox(height: 4),
        Text(
          value,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : AppColors.textPrimary,
          ),
        ),
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: isDark ? Colors.white.withValues(alpha: 0.7) : AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}
