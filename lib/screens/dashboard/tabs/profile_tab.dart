import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:frontend_eco_2/providers/providers.dart';
import 'package:frontend_eco_2/routing/app_routes.dart';
import 'package:frontend_eco_2/widgets/common/custom_button.dart';
import 'package:frontend_eco_2/theme/app_colors.dart';

class ProfileTab extends StatelessWidget {
  const ProfileTab({super.key});

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final plantsProvider = Provider.of<PlantsProvider>(context);
    final missionsProvider = Provider.of<MissionsProvider>(context);
    final user = userProvider.currentUser;

    return SafeArea(
      top: false,
      bottom: false,
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        children: [
          // Header Row: "Perfil" title and gear (settings) icon
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Perfil',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                  fontFamily: 'DM Sans',
                ),
              ),
              IconButton(
                icon: const Icon(
                  Icons.settings_outlined,
                  color: AppColors.primary,
                  size: 28,
                ),
                onPressed: () => Navigator.pushNamed(context, AppRoutes.settings),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // User Avatar
          Center(
            child: Column(
              children: [
                Container(
                  width: 110,
                  height: 110,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFFE2E7E4), // Light greyish green avatar background
                    border: Border.all(color: AppColors.primary, width: 2),
                  ),
                  child: const Icon(
                    Icons.person,
                    size: 60,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  user?.username ?? 'Usuario',
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                    fontFamily: 'DM Sans',
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '@${user?.username ?? 'usuario'}',
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                    fontFamily: 'Inter',
                  ),
                ),
                const SizedBox(height: 16),
                // Level Badge: "⚡ Nivel 2 • Brote"
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.primary, width: 1.5),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Icon(Icons.bolt, color: AppColors.primary, size: 16),
                      SizedBox(width: 4),
                      Text(
                        'Nivel 2 · Brote',
                        style: TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                          fontFamily: 'Inter',
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),

          // Stats Cards Row: Plantas, Semillas, CO2
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  '${plantsProvider.userPlants.length}',
                  'Plantas',
                  AppColors.primary,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  '${missionsProvider.userSeeds}',
                  'Semillas',
                  AppColors.accentLight,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  '36g',
                  'CO₂/día',
                  AppColors.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // "Editar perfil" Button
          SizedBox(
            width: double.infinity,
            child: CustomButton(
              text: 'Editar perfil',
              isOutlined: true,
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.primary,
              onPressed: () => Navigator.pushNamed(context, AppRoutes.editProfile),
            ),
          ),
          const SizedBox(height: 24),

          // Premium Upgrade / Free Plan Banner
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFE5EAE7), // Soft greyish green
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Plan gratuito activo',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                          fontSize: 15,
                          fontFamily: 'Inter',
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Canjea tus semillas o suscríbete a O₂₊',
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 12,
                          fontFamily: 'Inter',
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: AppColors.primary,
                    elevation: 0,
                    side: const BorderSide(color: AppColors.primary, width: 1.5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  ),
                  onPressed: () => Navigator.pushNamed(context, AppRoutes.premiumUpgrade),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Text(
                        'Ver O₂₊',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                          fontFamily: 'Inter',
                        ),
                      ),
                      SizedBox(width: 4),
                      Icon(Icons.arrow_forward, size: 14),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Option Items list with Dividers
          _buildOptionRow(
            icon: Icons.emoji_events_outlined,
            title: 'Mis Trofeos',
            subtitle: 'Trofeos y Nivel (12)',
            onTap: () => Navigator.pushNamed(context, AppRoutes.missions), // or trophies route
          ),
          const Divider(height: 1, color: Color(0xFFE2E7E4)),
          _buildOptionRow(
            icon: Icons.eco_outlined,
            title: 'Tienda de Semillas',
            subtitle: 'Canjear semillas (10)',
            onTap: () => Navigator.pushNamed(context, AppRoutes.greenFootprint), // or seed store route
          ),
          const Divider(height: 1, color: Color(0xFFE2E7E4)),
          _buildOptionRow(
            icon: Icons.bolt,
            title: 'Próximas funciones',
            subtitle: 'Coming soon IoT (14)',
            onTap: () {},
          ),
          const Divider(height: 1, color: Color(0xFFE2E7E4)),
          const SizedBox(height: 32),

          // Logout Button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.red,
                side: const BorderSide(color: Colors.red),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              icon: const Icon(Icons.logout),
              label: const Text('Cerrar Sesión'),
              onPressed: () {
                userProvider.logout();
              },
            ),
          ),
          const SizedBox(height: 120), // Padding to prevent navbar overlap
        ],
      ),
    );
  }

  Widget _buildStatCard(String value, String label, Color valueColor) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE2E7E4), width: 1),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: valueColor,
              fontFamily: 'Inter',
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
              fontFamily: 'Inter',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOptionRow({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 4),
      leading: Icon(icon, color: AppColors.primary, size: 24),
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: AppColors.primary,
          fontFamily: 'Inter',
          fontSize: 16,
        ),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            subtitle,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 12,
              fontFamily: 'Inter',
            ),
          ),
          const SizedBox(width: 8),
          const Icon(Icons.arrow_forward, color: AppColors.textSecondary, size: 16),
        ],
      ),
      onTap: onTap,
    );
  }
}
