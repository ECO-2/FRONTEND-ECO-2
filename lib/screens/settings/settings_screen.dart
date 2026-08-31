import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:frontend_eco_2/providers/providers.dart';
import 'package:frontend_eco_2/theme/app_colors.dart';
import 'package:frontend_eco_2/routing/app_routes.dart';
import 'package:frontend_eco_2/widgets/common/custom_app_bar.dart';
import 'package:frontend_eco_2/widgets/common/settings_option_tile.dart';
import 'package:frontend_eco_2/widgets/common/app_toast.dart';

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

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final user = userProvider.currentUser;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomAppBar(title: 'Ajustes'),
      body: ListView(
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
                      SettingsOptionTile(
                        icon: Icons.person_outline_rounded,
                        title: 'Editar perfil',
                        subtitle: 'Nombre, bio, foto',
                        useIconContainer: true,
                        onTap: () => Navigator.pushNamed(context, AppRoutes.editProfile),
                      ),
                      const Divider(height: 1, indent: 68, endIndent: 16, color: Color(0xFFE2E7E4)),
                      SettingsOptionTile(
                        icon: Icons.lock_outline_rounded,
                        title: 'Cambiar contraseña',
                        subtitle: 'Última: hace 3 meses',
                        useIconContainer: true,
                        onTap: () {
                          showAppToast(context, 'Función para cambiar contraseña próximamente 🔒');
                        },
                      ),
                      const Divider(height: 1, indent: 68, endIndent: 16, color: Color(0xFFE2E7E4)),
                      SettingsOptionTile(
                        icon: Icons.fingerprint_rounded,
                        title: 'Autenticación biométrica',
                        useIconContainer: true,
                        showArrow: false,
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
                      SettingsOptionTile(
                        icon: Icons.star_outline_rounded,
                        title: 'Gestionar ECO2 Plus',
                        subtitle: 'Plan gratuito activo',
                        useIconContainer: true,
                        showArrow: false,
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
                      SettingsOptionTile(
                        icon: Icons.notifications_none_rounded,
                        title: 'Notificaciones push',
                        useIconContainer: true,
                        showArrow: false,
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
                      SettingsOptionTile(
                        icon: Icons.chat_bubble_outline_rounded,
                        title: 'Recordatorios de riego',
                        useIconContainer: true,
                        showArrow: false,
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
                      SettingsOptionTile(
                        icon: Icons.star_outline_rounded,
                        title: 'Logros y misiones',
                        useIconContainer: true,
                        showArrow: false,
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
                      SettingsOptionTile(
                        icon: Icons.language_rounded,
                        title: 'Idioma',
                        useIconContainer: true,
                        showArrow: false,
                        iconColor: const Color(0xFF8FA89F),
                        iconBgColor: const Color(0xFFEFF3F1),
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
                          showAppToast(context, 'Configuración de idioma próximamente 🌐');
                        },
                      ),
                      const Divider(height: 1, indent: 68, endIndent: 16, color: Color(0xFFE2E7E4)),
                      SettingsOptionTile(
                        icon: Icons.palette_outlined,
                        title: 'Tema y colores',
                        useIconContainer: true,
                        showArrow: false,
                        iconColor: const Color(0xFF9CCC65),
                        iconBgColor: const Color(0xFFF3F9ED),
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
                          showAppToast(context, 'Configuración de tema próximamente 🎨');
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // PRIVACIDAD Y DATOS Section
                _buildSectionHeader('Privacidad y datos'),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: const Color(0xFFE2E7E4), width: 1),
                  ),
                  child: Column(
                    children: [
                      SettingsOptionTile(
                        icon: Icons.shield_outlined,
                        title: 'Privacidad',
                        subtitle: 'Control de datos personales',
                        useIconContainer: true,
                        iconColor: const Color(0xFF26A69A),
                        iconBgColor: const Color(0xFFE0F2F1),
                        onTap: () {
                          showAppToast(context, 'Ajustes de privacidad próximamente 🛡️');
                        },
                      ),
                      const Divider(height: 1, indent: 68, endIndent: 16, color: Color(0xFFE2E7E4)),
                      SettingsOptionTile(
                        icon: Icons.storage_rounded,
                        title: 'Exportar mis datos',
                        useIconContainer: true,
                        iconColor: const Color(0xFF8D6E63),
                        iconBgColor: const Color(0xFFF5F0ED),
                        onTap: () {
                          showAppToast(context, 'Exportando datos... 💾');
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // APLICACIÓN Section
                _buildSectionHeader('Aplicación'),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: const Color(0xFFE2E7E4), width: 1),
                  ),
                  child: Column(
                    children: [
                      SettingsOptionTile(
                        icon: Icons.help_outline_rounded,
                        title: 'Ayuda y soporte',
                        useIconContainer: true,
                        iconColor: const Color(0xFF78909C),
                        iconBgColor: const Color(0xFFECEFF1),
                        onTap: () {
                          showAppToast(context, 'Soporte técnico próximamente ✉️');
                        },
                      ),
                      const Divider(height: 1, indent: 68, endIndent: 16, color: Color(0xFFE2E7E4)),
                      SettingsOptionTile(
                        icon: Icons.info_outline_rounded,
                        title: 'Sobre ECO2',
                        subtitle: 'Versión 2.4.1',
                        useIconContainer: true,
                        iconColor: const Color(0xFF78909C),
                        iconBgColor: const Color(0xFFECEFF1),
                        onTap: () {},
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // ZONA DE RIESGO Section
                _buildSectionHeader('Zona de riesgo', isRisk: true),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: const Color(0xFFE2E7E4), width: 1),
                  ),
                  child: Column(
                    children: [
                      SettingsOptionTile(
                        icon: Icons.logout_rounded,
                        title: 'Cerrar sesión',
                        useIconContainer: true,
                        iconColor: const Color(0xFF757575),
                        iconBgColor: const Color(0xFFF5F5F5),
                        titleColor: const Color(0xFF212121),
                        onTap: () {
                          userProvider.logout();
                          Navigator.pushReplacementNamed(context, AppRoutes.welcome);
                        },
                      ),
                      const Divider(height: 1, indent: 68, endIndent: 16, color: Color(0xFFE2E7E4)),
                      SettingsOptionTile(
                        icon: Icons.delete_outline_rounded,
                        title: 'Eliminar cuenta',
                        subtitle: 'Esta acción es permanente',
                        useIconContainer: true,
                        iconColor: const Color(0xFFE53935),
                        iconBgColor: const Color(0xFFFFEBEE),
                        titleColor: const Color(0xFFE53935),
                        onTap: () {
                          showAppToast(context, 'Eliminar cuenta no disponible en esta demo 🛑', type: ToastType.error);
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
    );
  }

  Widget _buildSectionHeader(String title, {bool isRisk = false}) {
    return Padding(
      padding: const EdgeInsets.only(left: 12.0, bottom: 8.0, top: 16.0),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: isRisk ? const Color(0xFFE53935) : AppColors.textSecondary,
          letterSpacing: 1.2,
          fontFamily: 'Inter',
        ),
      ),
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
}
