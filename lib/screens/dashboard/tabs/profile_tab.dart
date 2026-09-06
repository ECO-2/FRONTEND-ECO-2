import 'package:flutter/material.dart';
import 'package:frontend_eco_2/l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:frontend_eco_2/providers/providers.dart';
import 'package:frontend_eco_2/routing/app_routes.dart';
import 'package:frontend_eco_2/widgets/common/custom_button.dart';
import 'package:frontend_eco_2/theme/app_colors.dart';
import 'package:frontend_eco_2/utils/co2_estimate.dart';
import 'package:frontend_eco_2/widgets/common/stat_card.dart';
import 'package:frontend_eco_2/widgets/common/settings_option_tile.dart';

class ProfileTab extends StatelessWidget {
  final VoidCallback? onNavigateToGarden;
  final VoidCallback? onStartTour;

  const ProfileTab({super.key, this.onNavigateToGarden, this.onStartTour});

  /// "Nivel 3 · Retoño" con los datos reales del backend. Si el progreso aún
  /// no ha cargado, se muestra el nivel base en vez de un texto inventado.
  String _levelLabel(MissionsProvider mp) {
    final progress = mp.progress;
    final level = progress?.level ?? 1;
    final name = progress?.levelName;
    return name == null ? 'Nivel $level' : 'Nivel $level · $name';
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final userProvider = Provider.of<UserProvider>(context);
    final plantsProvider = Provider.of<PlantsProvider>(context);
    final missionsProvider = Provider.of<MissionsProvider>(context);
    final user = userProvider.currentUser;
    // CO2 acumulado real del jardín. Antes era "36.5 kg" escrito a mano,
    // el mismo número para cualquier usuario.
    final co2 = Co2Estimate.forPlants(
      plantsProvider.userPlants,
      speciesById: {for (final s in plantsProvider.speciesCatalog) s.id: s},
    );

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
              Text(
                l.profile,
                style: const TextStyle(
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
                    children: [
                      const Icon(Icons.bolt, color: AppColors.primary, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        // Nivel real del usuario. Antes decía "Nivel 2 · Brote"
                        // escrito a mano, igual para todos y en contradicción
                        // con la pantalla de Trofeos, que sí leía el dato.
                        _levelLabel(missionsProvider),
                        style: const TextStyle(
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
                child: StatCard(
                  value: '${plantsProvider.userPlants.length}',
                  label: l.plants,
                  valueColor: AppColors.primary,
                  showBorder: true,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: GestureDetector(
                  onTap: () => Navigator.pushNamed(context, AppRoutes.greenFootprint),
                  child: StatCard(
                    value: '${missionsProvider.userSeeds}',
                    label: l.seeds,
                    valueColor: AppColors.accentLight,
                    showBorder: true,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: GestureDetector(
                  onTap: () => Navigator.pushNamed(context, AppRoutes.greenFootprint),
                  child: StatCard(
                    value: '${co2.totalKg.toStringAsFixed(2)} kg',
                    label: l.co2Total,
                    valueColor: AppColors.textSecondary,
                    showBorder: true,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // "Editar perfil" Button
          SizedBox(
            width: double.infinity,
            child: CustomButton(
              text: l.editProfile,
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
          SettingsOptionTile(
            icon: Icons.emoji_events_outlined,
            title: l.myTrophies,
            subtitle: '${l.trophies} · ${missionsProvider.unlockedCount}',
            onTap: () => Navigator.pushNamed(context, AppRoutes.trophies),
          ),
          const Divider(height: 1, color: Color(0xFFE2E7E4)),
          SettingsOptionTile(
            icon: Icons.assignment_outlined,
            title: 'Misiones Activas',
            subtitle: 'Ver mis logros y misiones',
            onTap: () => Navigator.pushNamed(context, AppRoutes.missions),
          ),
          const Divider(height: 1, color: Color(0xFFE2E7E4)),
          SettingsOptionTile(
            icon: Icons.menu_book_rounded,
            title: 'Catálogo de Plantas',
            subtitle: 'Explorar especies botánicas',
            onTap: () {
              plantsProvider.setShowCatalogTab(true);
              onNavigateToGarden?.call();
            },
          ),
          const Divider(height: 1, color: Color(0xFFE2E7E4)),
          SettingsOptionTile(
            icon: Icons.eco_outlined,
            title: 'Tienda de Semillas',
            subtitle: 'Canjear ${missionsProvider.userSeeds} semillas',
            onTap: () => Navigator.pushNamed(context, AppRoutes.store),
          ),
          const Divider(height: 1, color: Color(0xFFE2E7E4)),
          SettingsOptionTile(
            icon: Icons.bolt,
            title: 'Próximas funciones',
            subtitle: 'Coming soon IoT (14)',
            onTap: () {},
          ),
          const Divider(height: 1, color: Color(0xFFE2E7E4)),
          SettingsOptionTile(
            icon: Icons.explore_outlined,
            title: 'Recorrido de la app',
            subtitle: 'Vuelve a ver el tutorial guiado',
            onTap: () => onStartTour?.call(),
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

  }

