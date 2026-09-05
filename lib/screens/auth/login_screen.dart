import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:frontend_eco_2/providers/providers.dart';
import 'package:frontend_eco_2/routing/app_routes.dart';
import 'package:frontend_eco_2/theme/app_colors.dart';
import 'package:frontend_eco_2/widgets/common/custom_button.dart';
import 'package:frontend_eco_2/widgets/common/custom_text_field.dart';
import 'package:frontend_eco_2/widgets/common/custom_status_bar.dart';
import 'package:frontend_eco_2/widgets/common/app_toast.dart';
import 'package:frontend_eco_2/services/services.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final success = await userProvider.login(
        _emailController.text.trim(),
        _passwordController.text,
      );

      if (success && mounted) {
        // Registrar el device token para push notifications — se hace en
        // background (no bloquea la navegación) y falla silenciosamente
        // si el usuario no da permiso o algo sale mal.
        final notificationService =
            Provider.of<NotificationService>(context, listen: false);
        notificationService.registerDeviceToken();

        final user = userProvider.currentUser;

        if (user != null && user.onboardingCompleted) {
          // Cargar catálogo de plantas y progreso antes de entrar al
          // dashboard (mismo patrón que onboarding_screen.dart al terminar
          // o saltar el onboarding). Sin esto, PlantsProvider.speciesCatalog
          // se queda vacío tras un login normal y el catálogo no aparece.
          final plantsProvider = context.read<PlantsProvider>();
          final missionsProvider = context.read<MissionsProvider>();
          await Future.wait([plantsProvider.init(), missionsProvider.init()]);
          missionsProvider.syncUserPlantsCount(plantsProvider.userPlants.length);
          if (!mounted) return;

          Navigator.pushNamedAndRemoveUntil(
            context,
            AppRoutes.dashboard,
            (route) => false,
          );
        } else {
          Navigator.pushNamedAndRemoveUntil(
            context,
            AppRoutes.onboarding,
            (route) => false,
          );
        }
      } else if (mounted && userProvider.errorMessage != null) {
        showAppToast(context, userProvider.errorMessage!, type: ToastType.error);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          const CustomStatusBar(),
          Expanded(
            child: SafeArea(
              top: false,
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Image.asset(
                          'assets/images/Icono Principal.png',
                          height: 130,
                          fit: BoxFit.contain,
                        ),
                      ),
                      const SizedBox(height: 24),
                      
                      Center(
                        child: Text(
                          'Bienvenido de vuelta',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: AppColors.textSecondary.withValues(alpha: 0.8),
                            fontFamily: 'Inter',
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Center(
                        child: const Text(
                          'Iniciar Sesión',
                          style: TextStyle(
                            fontSize: 32,
                           
                            color: AppColors.primary,
                            fontFamily: 'DM Sans',
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),

                      // Email Field
                      CustomTextField(
                        controller: _emailController,
                        labelText: 'Correo electrónico',
                        hintText: 'correo@ejemplo.com',
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor ingresa tu correo';
                          }
                          if (!value.contains('@')) {
                            return 'Por favor ingresa un correo válido';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),

                      // Password Field
                      CustomTextField(
                        controller: _passwordController,
                        labelText: 'Contraseña',
                        hintText: '••••••',
                        obscureText: _obscurePassword,
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            color: AppColors.textSecondary,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor ingresa tu contraseña';
                          }
                          if (value.length < 6) {
                            return 'La contraseña debe tener al menos 6 caracteres';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 12),

                      // Forgot Password link
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {
                            showAppToast(
                              context,
                              'Simulación: Recuperación de contraseña enviada.',
                            );
                          },
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: const Text(
                            '¿Olvidaste tu contraseña?',
                            style: TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              fontFamily: 'Inter',
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),

                      // Login Button
                      SizedBox(
                        width: double.infinity,
                        child: CustomButton(
                          text: 'Iniciar sesión',
                          backgroundColor: AppColors.primaryDark,
                          foregroundColor: Colors.white,
                          isLoading: userProvider.isLoading,
                          onPressed: _submit,
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Bottom Register Link
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            '¿No tienes cuenta? ',
                            style: TextStyle(
                              color: AppColors.textSecondary,
                              fontFamily: 'Inter',
                              fontSize: 14,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushReplacementNamed(context, AppRoutes.register);
                            },
                            child: const Text(
                              'Crear cuenta',
                              style: TextStyle(
                                color: AppColors.primary,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Inter',
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
