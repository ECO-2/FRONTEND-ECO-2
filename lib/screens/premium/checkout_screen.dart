import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:frontend_eco_2/providers/providers.dart';
import 'package:frontend_eco_2/theme/app_colors.dart';
import 'package:frontend_eco_2/routing/app_routes.dart';
import 'package:frontend_eco_2/widgets/common/custom_app_bar.dart';
import 'package:frontend_eco_2/widgets/common/custom_button.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  String _selectedMethod = 'card'; // 'card', 'apple_pay', 'paypal'
  bool _isProcessing = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomAppBar(
        title: 'Confirmar pago',
        backgroundColor: AppColors.primaryDark,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Selected Plan Card (Dark Teal Box)
                  _buildPlanCard(),
                  const SizedBox(height: 24),
                  
                  // Payment Method Section Title
                  const Text(
                    'Método de pago',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                      fontFamily: 'Inter',
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Payment Methods
                  _buildPaymentOption(
                    id: 'card',
                    title: 'Tarjeta',
                    subtitle: '•••• 4242',
                    icon: Icons.credit_card_rounded,
                  ),
                  const SizedBox(height: 12),
                  
                  _buildPaymentOption(
                    id: 'apple_pay',
                    title: 'Apple Pay',
                    subtitle: 'Pago rápido',
                    icon: Icons.apple,
                  ),
                  const SizedBox(height: 12),
                  
                  _buildPaymentOption(
                    id: 'paypal',
                    title: 'PayPal',
                    subtitle: 'carlos@eco2.app',
                    icon: Icons.account_balance_wallet_rounded,
                  ),
                  const SizedBox(height: 20),
                  
                  // Security Banner
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF1F4F3),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: const [
                        Icon(Icons.shield_outlined, color: AppColors.primary, size: 20),
                        SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Pagos seguros con cifrado 256-bit SSL',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.primary,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Inter',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
          
          // Bottom Payment Bar
          _buildBottomPaymentBar(context),
        ],
      ),
    );
  }

  Widget _buildPlanCard() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFF0F3138), // Deep dark green/teal
        borderRadius: BorderRadius.circular(24),
      ),
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.accent,
              borderRadius: BorderRadius.circular(6),
            ),
            child: const Text(
              '★ PLAN SELECCIONADO',
              style: TextStyle(
                color: AppColors.primaryDark,
                fontWeight: FontWeight.bold,
                fontSize: 10,
                letterSpacing: 0.5,
                fontFamily: 'Inter',
              ),
            ),
          ),
          const SizedBox(height: 16),
          
          // Row with Plan Name and Price
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'ECO2 Plus Anual',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Inter',
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Cancela en cualquier momento',
                      style: TextStyle(
                        color: AppColors.accent,
                        fontSize: 12,
                        fontFamily: 'Inter',
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: const [
                  Text(
                    '\$39.99',
                    style: TextStyle(
                      color: AppColors.accent,
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Inter',
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    '\$3.33/mes',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 11,
                      fontFamily: 'Inter',
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Divider(color: Colors.white24, height: 1),
          const SizedBox(height: 16),
          
          // Benefits list
          _buildPlanBenefit('Macetas ilimitadas'),
          const SizedBox(height: 10),
          _buildPlanBenefit('Búsqueda con IA'),
          const SizedBox(height: 10),
          _buildPlanBenefit('How to treat con IA'),
          const SizedBox(height: 10),
          _buildPlanBenefit('Descuentos en viveros'),
        ],
      ),
    );
  }

  Widget _buildPlanBenefit(String text) {
    return Row(
      children: [
        const Icon(Icons.check_rounded, color: AppColors.accent, size: 18),
        const SizedBox(width: 8),
        Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontFamily: 'Inter',
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentOption({
    required String id,
    required String title,
    required String subtitle,
    required IconData icon,
  }) {
    final isSelected = _selectedMethod == id;
    
    return InkWell(
      onTap: () {
        setState(() {
          _selectedMethod = id;
        });
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppColors.primary : const Color(0xFFE2E7E4),
            width: isSelected ? 2.0 : 1.0,
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
        child: Row(
          children: [
            // Left icon container
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary.withValues(alpha: 0.08) : const Color(0xFFF1F4F3),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: AppColors.primary, size: 22),
            ),
            const SizedBox(width: 16),
            
            // Text details
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
                      fontFamily: 'Inter',
                    ),
                  ),
                ],
              ),
            ),
            
            // Selected radio indicator
            Icon(
              isSelected ? Icons.radio_button_checked_rounded : Icons.radio_button_off_rounded,
              color: isSelected ? AppColors.primary : const Color(0xFFE2E7E4),
              size: 24,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomPaymentBar(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(24.0),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Total Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Total a pagar',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                        fontFamily: 'Inter',
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      '1 año de ECO2 Plus',
                      style: TextStyle(
                        fontSize: 11,
                        color: AppColors.textMuted,
                        fontFamily: 'Inter',
                      ),
                    ),
                  ],
                ),
                const Text(
                  '\$39.99',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                    fontFamily: 'Inter',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            // Pay button
            CustomButton(
              text: 'Pagar \$39.99',
              backgroundColor: AppColors.accent,
              foregroundColor: AppColors.primary,
              isLoading: _isProcessing,
              onPressed: _processPayment,
            ),
          ],
        ),
      ),
    );
  }

  void _processPayment() async {
    setState(() {
      _isProcessing = true;
    });
    
    // Simulate payment processing
    await Future.delayed(const Duration(milliseconds: 1500));
    
    if (mounted) {
      // Update user subscription plan to premium in state
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final currentUser = userProvider.currentUser;
      if (currentUser != null) {
        userProvider.setUser(currentUser.copyWith(planType: 'premium'));
      }
      
      setState(() {
        _isProcessing = false;
      });
      
      Navigator.pushReplacementNamed(context, AppRoutes.success);
    }
  }
}
