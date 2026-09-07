import 'package:flutter/material.dart';
import 'package:frontend_eco_2/theme/app_colors.dart';
import 'package:frontend_eco_2/routing/app_routes.dart';
import 'package:frontend_eco_2/widgets/common/custom_bottom_nav_bar.dart';
import 'package:frontend_eco_2/widgets/common/custom_status_bar.dart';
import 'package:frontend_eco_2/widgets/common/custom_button.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:frontend_eco_2/l10n/app_localizations.dart';

class PremiumUpgradeScreen extends StatelessWidget {
  final bool isTab;

  const PremiumUpgradeScreen({super.key, this.isTab = false});

  @override
  Widget build(BuildContext context) {
    if (isTab) {
      return Scaffold(
        backgroundColor: AppColors.background,
        body: _buildBodyContent(context),
      );
    }

    return Scaffold(
      extendBody: true,
      backgroundColor: AppColors.background,
      body: _buildBodyContent(context),
      bottomNavigationBar: CustomBottomNavBar(
        selectedIndex: 0, // Highlight O2 + tab
        onTap: (index) {
          // Pop back to the previous screen (e.g. Settings or Profile)
          Navigator.of(context).pop();
        },
      ),
    );
  }

  Widget _buildBodyContent(BuildContext context) {
    return Column(
      children: [
        if (!isTab) const CustomStatusBar(),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                // Hero Section (Dark Teal)
                Container(
                  color: AppColors.primaryDark,
                  width: double.infinity,
                  padding: const EdgeInsets.only(
                    left: 24.0,
                    right: 24.0,
                    top: 16.0,
                    bottom: 36.0,
                  ),
                  child: Column(
                    children: [
                      // Badge: O2 PLUS
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.accent, // Lime green
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.star_rounded,
                              size: 14,
                              color: AppColors.primary,
                            ),
                            const SizedBox(width: 4),
                            Text(AppLocalizations.of(context)!.o2PlusLabel,
                              style: const TextStyle(
                                color: AppColors.primary,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                                fontFamily: 'Inter',
                              ),
                            ),
                          ],
                        ),
                      ).animate().fadeIn(duration: 500.ms).shimmer(delay: 500.ms, duration: 1800.ms, color: Colors.white.withValues(alpha: 0.4)),
                      const SizedBox(height: 20),

                      // Main Title
                      Text(
                        AppLocalizations.of(context)!.premiumTitle,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'DM Sans',
                          letterSpacing: -0.5,
                        ),
                        textAlign: TextAlign.center,
                      ).animate().fadeIn(delay: 150.ms, duration: 600.ms).slideY(begin: -0.15, end: 0),
                      const SizedBox(height: 12),

                      // Subtitle
                      Text(
                        AppLocalizations.of(context)!.premiumSubtitle,
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.75),
                          fontSize: 14,
                          height: 1.4,
                          fontFamily: 'Inter',
                        ),
                        textAlign: TextAlign.center,
                      ).animate().fadeIn(delay: 250.ms, duration: 600.ms),
                    ],
                  ),
                ),

                // White Content Card with Rounded Top Corners (Wrapped in AppColors.primaryDark to keep background dark behind rounded corners)
                Container(
                  color: AppColors.primaryDark,
                  child: Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(40),
                        topRight: Radius.circular(40),
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24.0,
                      vertical: 28.0,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppLocalizations.of(context)!.premiumIncludes,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                            fontFamily: 'Inter',
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Item 1: Macetas ilimitadas
                        _buildFeatureItem(
                          icon: Icons.all_inclusive_rounded,
                          iconBgColor: const Color(0xFFE5ECEB),
                          iconColor: AppColors.primary,
                          title: AppLocalizations.of(context)!.premiumUnlimitedPots,
                          subtitle: AppLocalizations.of(context)!.premiumUnlimitedPotsDesc,
                        ).animate().fadeIn(delay: 350.ms, duration: 400.ms).slideX(begin: 0.1, end: 0),
                        const Divider(height: 1, color: Color(0xFFF1F4F3)),

                        // Item 2: Búsqueda mejorada
                        _buildFeatureItem(
                          icon: Icons.search_rounded,
                          iconBgColor: const Color(0xFFF0F4E5),
                          iconColor: AppColors.primary,
                          title: AppLocalizations.of(context)!.premiumBetterSearch,
                          subtitle: AppLocalizations.of(context)!.premiumBetterSearchDesc,
                        ).animate().fadeIn(delay: 450.ms, duration: 400.ms).slideX(begin: 0.1, end: 0),
                        const Divider(height: 1, color: Color(0xFFF1F4F3)),

                        // Item 3: Escaneos ilimitados
                        _buildFeatureItem(
                          icon: Icons.photo_camera_outlined,
                          iconBgColor: const Color(0xFFEBECE8),
                          iconColor: AppColors.primary,
                          title: AppLocalizations.of(context)!.premiumUnlimitedScans,
                          subtitle: AppLocalizations.of(context)!.premiumUnlimitedScansDesc,
                        ).animate().fadeIn(delay: 550.ms, duration: 400.ms).slideX(begin: 0.1, end: 0),
                        const Divider(height: 1, color: Color(0xFFF1F4F3)),

                        // Item 4: AI assisted How to treat
                        _buildFeatureItem(
                          icon: Icons.smart_toy_outlined,
                          iconBgColor: const Color(0xFFEEF5D1),
                          iconColor: const Color(0xFF8BA526),
                          title: AppLocalizations.of(context)!.premiumAiTreatment,
                          subtitle: AppLocalizations.of(context)!.premiumAiTreatmentDesc,
                        ).animate().fadeIn(delay: 650.ms, duration: 400.ms).slideX(begin: 0.1, end: 0),
                        const Divider(height: 1, color: Color(0xFFF1F4F3)),

                        // Item 5: Partner discounts
                        _buildFeatureItem(
                          icon: Icons.local_offer_outlined,
                          iconBgColor: const Color(0xFFF6F5E5),
                          iconColor: const Color(0xFF908E74),
                          title: AppLocalizations.of(context)!.premiumNurseryDiscounts,
                          subtitle: AppLocalizations.of(context)!.premiumNurseryDiscountsDesc,
                        ).animate().fadeIn(delay: 750.ms, duration: 400.ms).slideX(begin: 0.1, end: 0),
                        const Divider(height: 1, color: Color(0xFFF1F4F3)),

                        const SizedBox(height: 28),

                        // Subscription Action Button
                        CustomButton(
                          text: AppLocalizations.of(context)!.subscribeToO2Plus,
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          onPressed: () {
                            Navigator.pushNamed(context, AppRoutes.checkout);
                          },
                        ).animate().fadeIn(delay: 850.ms, duration: 500.ms).scaleXY(begin: 0.95, end: 1, curve: Curves.easeOutBack),
                        const SizedBox(
                          height: 120,
                        ), // Spacing for bottom navbar
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFeatureItem({
    required IconData icon,
    required Color iconBgColor,
    required Color iconColor,
    required String title,
    required String subtitle,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: iconBgColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: iconColor, size: 22),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: AppColors.textPrimary,
                    fontFamily: 'Inter',
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                    height: 1.3,
                    fontFamily: 'Inter',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
