import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:frontend_eco_2/providers/providers.dart';
import 'package:frontend_eco_2/theme/app_colors.dart';
import 'package:frontend_eco_2/widgets/common/custom_text_field.dart';
import 'package:frontend_eco_2/widgets/common/custom_status_bar.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  
  late TextEditingController _fullNameController;
  late TextEditingController _usernameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _locationController;
  late TextEditingController _birthDateController;

  @override
  void initState() {
    super.initState();
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final user = userProvider.currentUser;

    // Pre-populate with user data or default mockup values from Figma
    _fullNameController = TextEditingController(
      text: user != null && user.username.isNotEmpty && user.username != 'usuario'
          ? user.username
          : 'Carlos Eco',
    );
    _usernameController = TextEditingController(
      text: user != null && user.username.isNotEmpty && user.username != 'usuario'
          ? '@${user.username}'
          : '@carlos_eco',
    );
    _emailController = TextEditingController(
      text: user?.email ?? 'carlos@eco2.app',
    );
    _phoneController = TextEditingController(text: '+1 809 555 0142');
    _locationController = TextEditingController(text: 'Santo Domingo, DO');
    _birthDateController = TextEditingController(text: '12 / 08 / 1995');
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _locationController.dispose();
    _birthDateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          const CustomStatusBar(),
          _buildAppBar(context),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // White Avatar Container
                  Container(
                    width: double.infinity,
                    color: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 24.0),
                    child: Column(
                      children: [
                        Stack(
                          children: [
                            Container(
                              width: 120,
                              height: 120,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: const Color(0xFFE2E7E4), // Light greyish green avatar background
                                border: Border.all(color: AppColors.primary, width: 2),
                              ),
                              child: const Icon(
                                Icons.person,
                                size: 70,
                                color: AppColors.primary,
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: InkWell(
                                onTap: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Función para cambiar foto próximamente 📸'),
                                    ),
                                  );
                                },
                                child: Container(
                                  width: 36,
                                  height: 36,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: AppColors.accent, // Lime green
                                    border: Border.all(color: Colors.white, width: 2),
                                  ),
                                  child: const Icon(
                                    Icons.camera_alt,
                                    size: 18,
                                    color: AppColors.primary,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        TextButton(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Función para cambiar foto próximamente 📸'),
                              ),
                            );
                          },
                          child: const Text(
                            'Cambiar foto de perfil',
                            style: TextStyle(
                              color: AppColors.primary,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Inter',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  // Horizontal spacer/divider strip
                  Container(
                    height: 8,
                    width: double.infinity,
                    color: const Color(0xFFF1F4F3),
                  ),
                  
                  // Form Section
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Información personal',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textSecondary,
                              fontFamily: 'Inter',
                            ),
                          ),
                          const SizedBox(height: 20),
                          
                          // Full name
                          CustomTextField(
                            controller: _fullNameController,
                            labelText: 'Nombre completo',
                            customLabel: _buildCustomLabel('Nombre completo'),
                            prefixIcon: Icons.person_outline_rounded,
                          ),
                          const SizedBox(height: 20),

                          // Username
                          CustomTextField(
                            controller: _usernameController,
                            labelText: 'Nombre de usuario',
                            customLabel: _buildCustomLabel('Nombre de usuario'),
                            // No prefix icon as in Figma mockup!
                          ),
                          const SizedBox(height: 20),

                          // Email
                          CustomTextField(
                            controller: _emailController,
                            labelText: 'Correo electrónico',
                            customLabel: _buildCustomLabel('Correo electrónico'),
                            prefixIcon: Icons.mail_outline_rounded,
                            keyboardType: TextInputType.emailAddress,
                          ),
                          const SizedBox(height: 20),

                          // Phone
                          CustomTextField(
                            controller: _phoneController,
                            labelText: 'Teléfono',
                            customLabel: _buildCustomLabel('Teléfono'),
                            prefixIcon: Icons.phone_outlined,
                            keyboardType: TextInputType.phone,
                          ),
                          const SizedBox(height: 20),

                          // Location
                          CustomTextField(
                            controller: _locationController,
                            labelText: 'Ubicación',
                            customLabel: _buildCustomLabel('Ubicación'),
                            prefixIcon: Icons.location_on_outlined,
                          ),
                          const SizedBox(height: 20),

                          // Birth Date
                          CustomTextField(
                            controller: _birthDateController,
                            labelText: 'Fecha de nacimiento',
                            customLabel: _buildCustomLabel('Fecha de nacimiento'),
                            prefixIcon: Icons.calendar_today_outlined,
                          ),
                          const SizedBox(height: 40),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: AppColors.textSecondary,
        fontFamily: 'Inter',
      ),
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
            'Editar perfil',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 20,
              fontFamily: 'Inter',
            ),
          ),
          
          // Guardar Button
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.accent, // Lime green
              foregroundColor: AppColors.primary, // Dark green text
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            ),
            onPressed: () {
              // Simulate saving changes
              final userProvider = Provider.of<UserProvider>(context, listen: false);
              final currentUser = userProvider.currentUser;
              if (currentUser != null) {
                // Update username and email in state
                String newUsername = _usernameController.text;
                if (newUsername.startsWith('@')) {
                  newUsername = newUsername.substring(1);
                }
                final updatedUser = currentUser.copyWith(
                  username: newUsername,
                  email: _emailController.text,
                );
                userProvider.setUser(updatedUser);
              }
              
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('¡Perfil guardado con éxito! 💾'),
                  backgroundColor: AppColors.primary,
                ),
              );
              Navigator.of(context).pop();
            },
            child: const Text(
              'Guardar',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                fontFamily: 'Inter',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
