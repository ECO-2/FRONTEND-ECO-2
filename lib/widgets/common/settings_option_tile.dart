import 'package:flutter/material.dart';
import 'package:frontend_eco_2/theme/app_colors.dart';

class SettingsOptionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;
  final bool useIconContainer;
  final bool showArrow;

  const SettingsOptionTile({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
    this.useIconContainer = false,
    this.showArrow = true,
  });

  @override
  Widget build(BuildContext context) {
    Widget leadingWidget;
    if (useIconContainer) {
      leadingWidget = Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: const Color(0xFFF1F4F3),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: AppColors.primary, size: 20),
      );
    } else {
      leadingWidget = Icon(icon, color: AppColors.primary, size: 24);
    }

    Widget? trailingWidget = trailing;
    if (trailingWidget == null && showArrow) {
      trailingWidget = const Icon(
        Icons.chevron_right_rounded,
        color: AppColors.textSecondary,
        size: 24,
      );
    }

    return ListTile(
      contentPadding: useIconContainer
          ? const EdgeInsets.symmetric(horizontal: 16, vertical: 4)
          : const EdgeInsets.symmetric(vertical: 4),
      leading: leadingWidget,
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: useIconContainer ? 15 : 16,
          color: useIconContainer ? AppColors.textPrimary : AppColors.primary,
          fontFamily: 'Inter',
        ),
      ),
      subtitle: (useIconContainer && subtitle != null)
          ? Text(
              subtitle!,
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
                fontFamily: 'Inter',
              ),
            )
          : null,
      trailing: !useIconContainer && subtitle != null
          ? Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  subtitle!,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                    fontFamily: 'Inter',
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(Icons.arrow_forward, color: AppColors.textSecondary, size: 16),
              ],
            )
          : trailingWidget,
      onTap: onTap,
    );
  }
}
