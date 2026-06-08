import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:frontend_eco_2/providers/providers.dart';
import 'package:frontend_eco_2/routing/app_routes.dart';
import 'package:frontend_eco_2/widgets/common/plant_card.dart';
import 'package:frontend_eco_2/widgets/common/custom_bottom_nav_bar.dart';
import 'package:frontend_eco_2/theme/app_colors.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _currentIndex = 2; // Default to Dashboard (center tab)

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final userProvider = Provider.of<UserProvider>(context);

    // If user is not authenticated, redirect to WelcomeScreen
    if (!userProvider.isAuthenticated) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacementNamed(context, AppRoutes.welcome);
      });
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final tabs = [
      _buildMissionsTab(context), // O2+ -> Index 0
      _buildGardenTab(context),   // Jardin -> Index 1
      _buildHomeTab(context),     // Dashboard -> Index 2
      _buildScannerTab(context),  // Escaner -> Index 3
      _buildProfileTab(context),  // Perfil -> Index 4
    ];

    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        title: Text(_getTabTitle(_currentIndex)),
        actions: [
          IconButton(
            icon: Stack(
              children: [
                const Icon(Icons.notifications_outlined),
                Consumer<NotificationsProvider>(
                  builder: (context, notifProvider, _) {
                    final count = notifProvider.unreadCount;
                    if (count == 0) return const SizedBox.shrink();
                    return Positioned(
                      right: 0,
                      top: 0,
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 12,
                          minHeight: 12,
                        ),
                        child: Text(
                          '$count',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 8,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
            onPressed: () {
              Navigator.pushNamed(context, AppRoutes.notifications);
            },
          ),
        ],
      ),
      body: tabs[_currentIndex],
      bottomNavigationBar: CustomBottomNavBar(
        selectedIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }

  String _getTabTitle(int index) {
    switch (index) {
      case 0:
        return 'Misiones y Logros';
      case 1:
        return 'Mi Jardín';
      case 2:
        return 'ECO2 Dashboard';
      case 3:
        return 'Escáner IA';
      case 4:
        return 'Mi Perfil';
      default:
        return 'ECO2';
    }
  }

  // --- TAB 1: HOME/DASHBOARD ---
  Widget _buildHomeTab(BuildContext context) {
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
                      color: Colors.white.withOpacity(0.85),
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
                onPressed: () {
                  setState(() {
                    _currentIndex = 1; // Switch to Garden tab
                  });
                },
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
                      color: needsWater ? AppColors.orange.withOpacity(0.5) : AppColors.textMuted.withOpacity(0.15),
                      width: needsWater ? 1.5 : 1,
                    ),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(12),
                    leading: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.06),
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
            color: isDark ? Colors.white.withOpacity(0.7) : AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  // --- TAB 2: MY GARDEN ---
  Widget _buildGardenTab(BuildContext context) {
    final plantsProvider = Provider.of<PlantsProvider>(context);

    return Scaffold(
      body: plantsProvider.userPlants.isEmpty
          ? const Center(child: Text('Aún no tienes plantas en tu jardín.'))
          : GridView.builder(
              padding: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 100),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.8,
              ),
              itemCount: plantsProvider.userPlants.length,
              itemBuilder: (context, index) {
                final plant = plantsProvider.userPlants[index];
                return PlantCard(
                  plant: plant,
                  onTap: () {
                    Navigator.pushNamed(context, AppRoutes.plantDetail);
                  },
                );
              },
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Open scan or add plant
          Navigator.pushNamed(context, AppRoutes.addPlant);
        },
        icon: const Icon(Icons.add),
        label: const Text('Añadir Planta'),
      ),
    );
  }

  // --- TAB 3: MISSIONS ---
  Widget _buildMissionsTab(BuildContext context) {
    final theme = Theme.of(context);
    final missionsProvider = Provider.of<MissionsProvider>(context);

    return ListView(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 100),
      children: [
        // Seeds header
        Card(
          color: theme.colorScheme.secondaryContainer.withOpacity(0.4),
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
                          ? theme.colorScheme.primary.withOpacity(0.1)
                          : Colors.grey.withOpacity(0.1),
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
                            color: theme.colorScheme.onBackground.withOpacity(0.6),
                          ),
                        ),
                        const SizedBox(height: 8),
                        // Progress bar mock
                        LinearProgressIndicator(
                          value: isCompleted ? 1.0 : 0.4,
                          backgroundColor: Colors.grey.withOpacity(0.2),
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

  // --- TAB 4: PROFILE ---
  Widget _buildProfileTab(BuildContext context) {
    final theme = Theme.of(context);
    final userProvider = Provider.of<UserProvider>(context);
    final user = userProvider.currentUser;

    return ListView(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 100),
      children: [
        // Profile Card
        Center(
          child: Column(
            children: [
              CircleAvatar(
                radius: 50,
                backgroundColor: theme.colorScheme.primary.withOpacity(0.2),
                child: Text(
                  (user?.username ?? 'U')[0].toUpperCase(),
                  style: theme.textTheme.headlineLarge?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                user?.username ?? 'Usuario ECO2',
                style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              Text(
                user?.email ?? '',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onBackground.withOpacity(0.6),
                ),
              ),
              const SizedBox(height: 8),
              // Plan Type Badge (Figma: O2+ Upgrade / Free)
              Chip(
                label: Text(
                  user?.planType == 'free' ? 'Plan Gratuito' : 'Miembro O2+',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: user?.planType == 'free' ? AppColors.textSecondary : AppColors.primary,
                  ),
                ),
                backgroundColor: user?.planType == 'free'
                    ? AppColors.textMuted.withOpacity(0.15)
                    : AppColors.accentLight.withOpacity(0.35),
              ),
            ],
          ),
        ),
        const SizedBox(height: 32),

        // Options
        ListTile(
          leading: const Icon(Icons.edit_outlined),
          title: const Text('Editar Perfil'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => Navigator.pushNamed(context, AppRoutes.editProfile),
        ),
        const Divider(),
        ListTile(
          leading: const Icon(Icons.co2_outlined),
          title: const Text('Mi Huella Verde'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => Navigator.pushNamed(context, AppRoutes.greenFootprint),
        ),
        const Divider(),
        ListTile(
          leading: const Icon(Icons.star_outline),
          title: const Text('Mejorar a O2+ Premium'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => Navigator.pushNamed(context, AppRoutes.premiumUpgrade),
        ),
        const Divider(),
        ListTile(
          leading: const Icon(Icons.settings_outlined),
          title: const Text('Ajustes'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => Navigator.pushNamed(context, AppRoutes.settings),
        ),
        const Divider(),
        const SizedBox(height: 24),
        // Logout Button
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: OutlinedButton.icon(
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.red,
              side: const BorderSide(color: Colors.red),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            icon: const Icon(Icons.logout),
            label: const Text('Cerrar Sesión'),
            onPressed: () {
              userProvider.logout();
            },
          ),
        ),
      ],
    );
  }

  // --- TAB 5: SCANNER ---
  Widget _buildScannerTab(BuildContext context) {
    final theme = Theme.of(context);
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Identificación de Plantas',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Apunta con la cámara a la planta o sube una foto de tu galería para diagnosticarla.',
            style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
          ),
          const SizedBox(height: 20),

          // Viewfinder Card
          Card(
            elevation: 0,
            clipBehavior: Clip.antiAlias,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
              side: BorderSide(
                color: AppColors.primary.withOpacity(0.15),
                width: 1.5,
              ),
            ),
            child: AspectRatio(
              aspectRatio: 1.2,
              child: Stack(
                children: [
                  // Scan preview image
                  Positioned.fill(
                    child: Image.asset(
                      'assets/images/ai_scan_preview.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                  // Corner framing brackets (Overlay)
                  Positioned.fill(
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Stack(
                        children: [
                          // Top-Left corner
                          Align(
                            alignment: Alignment.topLeft,
                            child: Container(
                              width: 24,
                              height: 24,
                              decoration: const BoxDecoration(
                                border: Border(
                                  top: BorderSide(color: AppColors.accent, width: 3),
                                  left: BorderSide(color: AppColors.accent, width: 3),
                                ),
                              ),
                            ),
                          ),
                          // Top-Right corner
                          Align(
                            alignment: Alignment.topRight,
                            child: Container(
                              width: 24,
                              height: 24,
                              decoration: const BoxDecoration(
                                border: Border(
                                  top: BorderSide(color: AppColors.accent, width: 3),
                                  right: BorderSide(color: AppColors.accent, width: 3),
                                ),
                              ),
                            ),
                          ),
                          // Bottom-Left corner
                          Align(
                            alignment: Alignment.bottomLeft,
                            child: Container(
                              width: 24,
                              height: 24,
                              decoration: const BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(color: AppColors.accent, width: 3),
                                  left: BorderSide(color: AppColors.accent, width: 3),
                                ),
                              ),
                            ),
                          ),
                          // Bottom-Right corner
                          Align(
                            alignment: Alignment.bottomRight,
                            child: Container(
                              width: 24,
                              height: 24,
                              decoration: const BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(color: AppColors.accent, width: 3),
                                  right: BorderSide(color: AppColors.accent, width: 3),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Scanning Laser Line Animation
                  const Positioned.fill(
                    child: _ScanningLaserLine(),
                  ),
                  // Center Scanner Tag
                  Positioned(
                    bottom: 16,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.65),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.white.withOpacity(0.15)),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(
                                color: AppColors.accent,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Text(
                              'Listo para Escanear',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Scanning action buttons
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                  ),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Abriendo cámara para diagnóstico... 📸'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  },
                  icon: const Icon(Icons.camera_alt),
                  label: const Text(
                    'Hacer Foto',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.primary,
                    side: const BorderSide(color: AppColors.primary, width: 1.5),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Abriendo galería... 🖼️'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  },
                  icon: const Icon(Icons.photo_library),
                  label: const Text(
                    'Subir de Galería',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),

          // Recent analyses
          Text(
            'Análisis Recientes',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),

          _buildRecentAnalysisItem(
            context,
            'Monstera Deliciosa',
            '98% de coincidencia • Muy saludable',
            'Hace 2 horas',
            Icons.eco,
          ),
          const SizedBox(height: 10),
          _buildRecentAnalysisItem(
            context,
            'Poto (Epipremnum aureum)',
            '94% de coincidencia • Requiere riego',
            'Ayer',
            Icons.local_florist,
          ),

          const SizedBox(height: 100), // Padding for bottom navbar
        ],
      ),
    );
  }

  Widget _buildRecentAnalysisItem(
    BuildContext context,
    String title,
    String subtitle,
    String time,
    IconData icon,
  ) {
    return Card(
      elevation: 0,
      color: AppColors.cardBackground,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: AppColors.textMuted.withOpacity(0.15),
          width: 1,
        ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.06),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: AppColors.primary,
          ),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(
            color: AppColors.textSecondary,
            fontSize: 12,
          ),
        ),
        trailing: Text(
          time,
          style: const TextStyle(
            color: AppColors.textMuted,
            fontSize: 11,
          ),
        ),
        onTap: () {},
      ),
    );
  }
}

class _ScanningLaserLine extends StatefulWidget {
  const _ScanningLaserLine();

  @override
  State<_ScanningLaserLine> createState() => _ScanningLaserLineState();
}

class _ScanningLaserLineState extends State<_ScanningLaserLine>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Stack(
          children: [
            Align(
              alignment: Alignment(0, (_controller.value * 2) - 1),
              child: Container(
                height: 4,
                width: double.infinity,
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.accent.withOpacity(0.8),
                      blurRadius: 10,
                      spreadRadius: 2,
                    ),
                  ],
                  gradient: LinearGradient(
                    colors: [
                      AppColors.accent.withOpacity(0.0),
                      AppColors.accent,
                      AppColors.accent,
                      AppColors.accent.withOpacity(0.0),
                    ],
                    stops: const [0.0, 0.4, 0.6, 1.0],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

