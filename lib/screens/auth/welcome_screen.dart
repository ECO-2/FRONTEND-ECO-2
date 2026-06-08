import 'package:flutter/material.dart';
import 'package:frontend_eco_2/routing/app_routes.dart';
import 'package:frontend_eco_2/theme/app_colors.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: AppColors.welcomeGradient,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
            child: Column(
              children: [
                const Spacer(),
                // Centered brand logo (EC + circle O2 logo)
                // Logo con altura controlada para reducir margen transparente
                Image.asset(
                  'assets/images/Variante Tipografica 2.png',
                  height: size.height * 0.25, // Ajusta el tamaño del logo según el tamaño de la pantalla
                  fit: BoxFit.contain,
                ),
                
                // Desplazamiento del texto hacia arriba
                Transform.translate(
                  offset: const Offset(0, -10),
                  child: const Text(
                    'Cuidado de plantas con IA',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.accent,
                      fontFamily: 'DM Sans',
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
                
                const Spacer(),
                
                // Action Buttons at the bottom
                Column(
                  children: [
                    // Crear Cuenta Button (Dark, top position)
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryDark,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          elevation: 0,
                          side: BorderSide(
                            color: Colors.white.withValues(alpha: 0.15),
                            width: 1,
                          ),
                        ),
                        onPressed: () {
                          Navigator.pushNamed(context, AppRoutes.register);
                        },
                        child: const Text(
                          'Crear Cuenta',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Inter',
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    // Iniciar Sesión Button (Accent/Lime, bottom position)
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.accent,
                          foregroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          elevation: 0,
                        ),
                        onPressed: () {
                          Navigator.pushNamed(context, AppRoutes.login);
                        },
                        child: const Text(
                          'Iniciar Sesión',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Inter',
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
