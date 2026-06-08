import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:frontend_eco_2/providers/providers.dart';
import 'package:frontend_eco_2/theme/app_colors.dart';
import 'package:frontend_eco_2/routing/app_routes.dart';
import 'package:frontend_eco_2/widgets/common/custom_status_bar.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _biometricAuth = true;
  bool _pushNotifications = true;
  bool _wateringReminders = true;
  bool _achievementsMissions = false;
  late bool _darkMode;

  @override
  void initState() {
    super.initState();
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    _darkMode = themeProvider.isDarkMode;
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);
    final user = userProvider.currentUser;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          const CustomStatusBar(),
          _buildAppBar(context),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
              children: [
                // Profile summary card
                Container(
                  margin: const EdgeInsets.only(bottom: 24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: const Color(0xFFE2E7E4), width: 1),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    leading: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color(0xFFE2E7E4),
                        border: Border.all(color: AppColors.primary, width: 1.5),
                      ),
                      child: const Icon(
                        Icons.person,
                        size: 30,
                        color: AppColors.primary,
                      ),
                    ),
                    title: Text(
                      user != null && user.username.isNotEmpty && user.username != 'usuario'
                          ? user.username
                          : 'Carlos Eco',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: AppColors.textPrimary,
                        fontFamily: 'Inter',
                      ),
                    ),
                    subtitle: Text(
                      user != null && user.username.isNotEmpty && user.username != 'usuario'
                          ? '@${user.username} · Nivel 2 Brote'
                          : '@carlos_eco · Nivel 2 Brote',
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                        fontFamily: 'Inter',
                      ),
                    ),
                    trailing: const Icon(Icons.chevron_right_rounded, color: AppColors.textSecondary),
                    onTap: () => Navigator.pushNamed(context, AppRoutes.editProfile),
                  ),
                ),

                // CUENTA Section
                _buildSectionHeader('Cuenta'),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: const Color(0xFFE2E7E4), width: 1),
                  ),
                  child: Column(
                    children: [
                      _buildSettingsItem(
                        icon: Icons.person_outline_rounded,
                        title: 'Editar perfil',
                        subtitle: 'Nombre, bio, foto',
                        onTap: () => Navigator.pushNamed(context, AppRoutes.editProfile),
                      ),
                      const Divider(height: 1, indent: 68, endIndent: 16, color: Color(0xFFE2E7E4)),
                      _buildSettingsItem(
                        icon: Icons.lock_outline_rounded,
                        title: 'Cambiar contraseña',
                        subtitle: 'Última: hace 3 meses',
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Función para cambiar contraseña próximamente 🔒')),
                          );
                        },
                      ),
                      const Divider(height: 1, indent: 68, endIndent: 16, color: Color(0xFFE2E7E4)),
                      _buildSettingsItem(
                        icon: Icons.fingerprint_rounded,
                        title: 'Autenticación biométrica',
                        trailing: _buildSwitch(
                          value: _biometricAuth,
                          onChanged: (val) {
                            setState(() {
                              _biometricAuth = val;
                            });
                          },
                        ),
                      ),
                      const Divider(height: 1, indent: 68, endIndent: 16, color: Color(0xFFE2E7E4)),
                      _buildSettingsItem(
                        icon: Icons.star_outline_rounded,
                        title: 'Gestionar ECO2 Plus',
                        subtitle: 'Plan gratuito activo',
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Text(
                              'Ver',
                              style: TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 13,
                                fontFamily: 'Inter',
                              ),
                            ),
                            SizedBox(width: 4),
                            Icon(Icons.chevron_right_rounded, color: AppColors.textSecondary),
                          ],
                        ),
                        onTap: () => Navigator.pushNamed(context, AppRoutes.premiumUpgrade),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // NOTIFICACIONES Section
                _buildSectionHeader('Notificaciones'),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: const Color(0xFFE2E7E4), width: 1),
                  ),
                  child: Column(
                    children: [
                      _buildSettingsItem(
                        icon: Icons.notifications_none_rounded,
                        title: 'Notificaciones push',
                        trailing: _buildSwitch(
                          value: _pushNotifications,
                          onChanged: (val) {
                            setState(() {
                              _pushNotifications = val;
                            });
                          },
                        ),
                      ),
                      const Divider(height: 1, indent: 68, endIndent: 16, color: Color(0xFFE2E7E4)),
                      _buildSettingsItem(
                        icon: Icons.chat_bubble_outline_rounded,
                        title: 'Recordatorios de riego',
                        trailing: _buildSwitch(
                          value: _wateringReminders,
                          onChanged: (val) {
                            setState(() {
                              _wateringReminders = val;
                            });
                          },
                        ),
                      ),
                      const Divider(height: 1, indent: 68, endIndent: 16, color: Color(0xFFE2E7E4)),
                      _buildSettingsItem(
                        icon: Icons.star_outline_rounded,
                        title: 'Logros y misiones',
                        trailing: _buildSwitch(
                          value: _achievementsMissions,
                          onChanged: (val) {
                            setState(() {
                              _achievementsMissions = val;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // PREFERENCIAS Section
                _buildSectionHeader('Preferencias'),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: const Color(0xFFE2E7E4), width: 1),
                  ),
                  child: Column(
                    children: [
                      _buildSettingsItem(
                        icon: Icons.language_rounded,
                        title: 'Idioma',
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Text(
                              'Español',
                              style: TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 13,
                                fontFamily: 'Inter',
                              ),
                            ),
                            SizedBox(width: 4),
                            Icon(Icons.chevron_right_rounded, color: AppColors.textSecondary),
                          ],
                        ),
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Configuración de idioma próximamente 🌐')),
                          );
                        },
                      ),
                      const Divider(height: 1, indent: 68, endIndent: 16, color: Color(0xFFE2E7E4)),
                      _buildSettingsItem(
                        icon: Icons.dark_mode_outlined,
                        title: 'Modo oscuro',
                        trailing: _buildSwitch(
                          value: _darkMode,
                          onChanged: (val) {
                            setState(() {
                              _darkMode = val;
                            });
                            themeProvider.toggleTheme(val);
                          },
                        ),
                      ),
                      const Divider(height: 1, indent: 68, endIndent: 16, color: Color(0xFFE2E7E4)),
                      _buildSettingsItem(
                        icon: Icons.color_lens_outlined,
                        title: 'Tema y colores',
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Text(
                              'Natural',
                              style: TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 13,
                                fontFamily: 'Inter',
                              ),
                            ),
                            SizedBox(width: 4),
                            Icon(Icons.chevron_right_rounded, color: AppColors.textSecondary),
                          ],
                        ),
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Configuración de tema próximamente 🎨')),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 12.0, bottom: 8.0, top: 16.0),
      child: Text(
        title.toUpperCase(),
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: AppColors.textSecondary,
          letterSpacing: 1.2,
          fontFamily: 'Inter',
        ),
      ),
    );
  }

  Widget _buildSettingsItem({
    required IconData icon,
    required String title,
    String? subtitle,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: const Color(0xFFF1F4F3), // Light greyish green background
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: AppColors.primary, size: 20),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 15,
          color: AppColors.textPrimary,
          fontFamily: 'Inter',
        ),
      ),
      subtitle: subtitle != null
          ? Text(
              subtitle,
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
                fontFamily: 'Inter',
              ),
            )
          : null,
      trailing: trailing ?? const Icon(Icons.chevron_right_rounded, color: AppColors.textSecondary),
      onTap: onTap,
    );
  }

  Widget _buildSwitch({required bool value, required ValueChanged<bool> onChanged}) {
    return Switch(
      value: value,
      onChanged: onChanged,
      activeThumbColor: Colors.white,
      activeTrackColor: AppColors.primary,
      inactiveThumbColor: Colors.white,
      inactiveTrackColor: const Color(0xFFE2E7E4),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Container(
      height: 72,
      color: AppColors.primary,
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Back button
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => Navigator.of(context).pop(),
              customBorder: const CircleBorder(),
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.15),
                ),
                alignment: Alignment.center,
                child: const Icon(
                  Icons.chevron_left_rounded,
                  color: Colors.white,
                  size: 28,
                ),
              ),
            ),
          ),
          
          // Title
          const Text(
            'Ajustes',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 20,
              fontFamily: 'Inter',
            ),
          ),
          
          // Empty placeholder to balance the back button alignment
          const SizedBox(width: 40),
        ],
      ),
    );
  }
}
