import 'package:flutter/material.dart';
import 'package:frontend_eco_2/theme/app_colors.dart';
import 'package:frontend_eco_2/routing/app_routes.dart';
import 'package:frontend_eco_2/widgets/common/custom_status_bar.dart';

class SuccessScreen extends StatelessWidget {
  const SuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.accent, // Lime green background matching Figma mockup
      body: Column(
        children: [
          // CustomStatusBar with lime-green background (automatically configures dark icons)
          const CustomStatusBar(backgroundColor: AppColors.accent),
          
          // Close button at the top-right
          Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: const EdgeInsets.only(right: 24.0, top: 16.0),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      AppRoutes.dashboard,
                      (route) => false,
                    );
                  },
                  customBorder: const CircleBorder(),
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.primaryDark.withValues(alpha: 0.1),
                    ),
                    child: const Icon(
                      Icons.close_rounded,
                      color: AppColors.primaryDark,
                      size: 24,
                    ),
                  ),
                ),
              ),
            ),
          ),
          
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.zero, // Zero padding to let the confetti stack span full screen width
              child: Column(
                children: [
                  // Full-Width Stack for Welcome Header and Spread-Out Confetti
                  SizedBox(
                    height: 330,
                    width: double.infinity,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // 1. Central Checkmark Circle
                        Positioned(
                          top: 10,
                          left: 0,
                          right: 0,
                          child: Center(
                            child: Container(
                              width: 130,
                              height: 130,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColors.primaryDark,
                              ),
                              alignment: Alignment.center,
                              child: const Icon(
                                Icons.check_rounded,
                                color: AppColors.accent,
                                size: 70,
                              ),
                            ),
                          ),
                        ),
                        
                        // 2. Welcome Title
                        Positioned(
                          top: 160,
                          left: 24,
                          right: 24,
                          child: const Text(
                            '¡Bienvenido a ECO2\nPlus!',
                            style: TextStyle(
                              color: AppColors.primaryDark,
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              height: 1.15,
                              fontFamily: 'DM Sans',
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        
                        // 3. Welcome Subtitle
                        Positioned(
                          top: 248,
                          left: 40,
                          right: 40,
                          child: const Text(
                            'Tu suscripción anual está activa. Disfruta de todas las funciones Plus desde ahora.',
                            style: TextStyle(
                              color: AppColors.primaryDark,
                              fontSize: 14,
                              height: 1.4,
                              fontWeight: FontWeight.w500,
                              fontFamily: 'Inter',
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        
                        // 4. Spread-Out Confetti (Relative to full screen width)
                        
                        // Top-Right star
                        Positioned(
                          top: 15,
                          right: 35,
                          child: const Icon(
                            Icons.star_rounded,
                            color: AppColors.primaryDark,
                            size: 26,
                          ),
                        ),
                        
                        // Top-Left dot
                        Positioned(
                          top: 35,
                          left: 60,
                          child: _buildDot(8),
                        ),
                        
                        // Top-Left line
                        Positioned(
                          top: 55,
                          left: 70,
                          child: _buildDash(-20, 5, 16),
                        ),
                        
                        // Mid-Left dot
                        Positioned(
                          top: 85,
                          left: 90,
                          child: _buildDot(6),
                        ),
                        
                        // Far-Left dot (level with top of welcome title)
                        Positioned(
                          top: 175,
                          left: 30,
                          child: _buildDot(10),
                        ),
                        
                        // Far-Right dot (level with top of welcome title)
                        Positioned(
                          top: 195,
                          right: 30,
                          child: _buildDot(10),
                        ),
                        
                        // Mid-Right tilted dash
                        Positioned(
                          top: 65,
                          right: 80,
                          child: _buildDash(25, 5, 16),
                        ),
                        
                        // Mid-Right dot
                        Positioned(
                          top: 100,
                          right: 70,
                          child: _buildDot(8),
                        ),
                        
                        // Bottom-Left star
                        Positioned(
                          top: 255,
                          left: 20,
                          child: const Icon(
                            Icons.star_rounded,
                            color: AppColors.primaryDark,
                            size: 24,
                          ),
                        ),
                        
                        // Bottom-Left diagonal dash
                        Positioned(
                          top: 275,
                          left: 32,
                          child: _buildDash(45, 5, 18),
                        ),
                        
                        // Bottom-Right checkmark/tick sparkle
                        Positioned(
                          top: 255,
                          right: 24,
                          child: const Icon(
                            Icons.check_rounded,
                            color: AppColors.primaryDark,
                            size: 24,
                          ),
                        ),
                        
                        // Bottom-Right dot
                        Positioned(
                          top: 285,
                          right: 32,
                          child: _buildDot(6),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Next Steps White Card (with 24 horizontal margin)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.02),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Card Header
                          Row(
                            children: const [
                              Icon(Icons.star_outline_rounded, color: AppColors.primaryDark, size: 20),
                              SizedBox(width: 8),
                              Text(
                                'Qué hacer ahora',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primaryDark,
                                  fontFamily: 'Inter',
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          
                          // Step 1
                          _buildStepRow(
                            number: '1',
                            title: 'Escanea tu planta favorita',
                            subtitle: 'Identifica cualquier especie con IA',
                          ),
                          const SizedBox(height: 18),
                          
                          // Step 2
                          _buildStepRow(
                            number: '2',
                            title: 'Añade plantas sin límite',
                            subtitle: 'Tu jardín puede crecer todo lo que quieras',
                          ),
                          const SizedBox(height: 18),
                          
                          // Step 3
                          _buildStepRow(
                            number: '3',
                            title: 'Explora descuentos exclusivos',
                            subtitle: 'Hasta 20% off en viveros aliados',
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
          
          // Bottom Action Button
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: SafeArea(
              top: false,
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryDark, // Dark green background
                    foregroundColor: AppColors.accent, // Lime green text!
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                  onPressed: () {
                    // Navigate back and remove history to get fresh start in dashboard
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      AppRoutes.dashboard,
                      (route) => false,
                    );
                  },
                  child: const Text(
                    'Empezar a usar Plus',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Inter',
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepRow({
    required String number,
    required String title,
    required String subtitle,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Number badge
        Container(
          width: 28,
          height: 28,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.accent, // Lime green badge
          ),
          alignment: Alignment.center,
          child: Text(
            number,
            style: const TextStyle(
              color: AppColors.primaryDark,
              fontWeight: FontWeight.bold,
              fontSize: 14,
              fontFamily: 'Inter',
            ),
          ),
        ),
        const SizedBox(width: 16),
        
        // Text Column
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: AppColors.primaryDark,
                  fontFamily: 'Inter',
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                  fontFamily: 'Inter',
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDot(double size) {
    return Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.primaryDark,
      ),
    );
  }

  Widget _buildDash(double angleDegrees, double width, double height) {
    return RotationTransition(
      turns: AlwaysStoppedAnimation(angleDegrees / 360),
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: AppColors.primaryDark,
          borderRadius: BorderRadius.circular(width / 2),
        ),
      ),
    );
  }
}
