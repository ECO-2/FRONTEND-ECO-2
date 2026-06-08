import 'package:flutter/material.dart';
import 'package:frontend_eco_2/widgets/common/custom_status_bar.dart';
import 'package:provider/provider.dart';
import 'package:frontend_eco_2/providers/providers.dart';
import 'package:frontend_eco_2/routing/app_routes.dart';
import 'package:frontend_eco_2/theme/app_colors.dart';
import 'package:frontend_eco_2/widgets/common/custom_bottom_nav_bar.dart';
import 'package:frontend_eco_2/screens/dashboard/tabs/home_tab.dart';
import 'package:frontend_eco_2/screens/dashboard/tabs/garden_tab.dart';
import 'package:frontend_eco_2/screens/dashboard/tabs/missions_tab.dart';
import 'package:frontend_eco_2/screens/dashboard/tabs/scanner_tab.dart';
import 'package:frontend_eco_2/screens/dashboard/tabs/profile_tab.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _currentIndex = 2; // Default to Dashboard (center tab)

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    // If user is not authenticated, redirect to WelcomeScreen
    if (!userProvider.isAuthenticated) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacementNamed(context, AppRoutes.welcome);
      });
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final tabs = [
      const MissionsTab(), // O2+ -> Index 0
      const GardenTab(),   // Jardin -> Index 1
      HomeTab(
        onViewAll: () {
          setState(() {
            _currentIndex = 1; // Switch to Garden tab
          });
        },
      ),                   // Dashboard -> Index 2
      const ScannerTab(),  // Escaner -> Index 3
      const ProfileTab(),  // Perfil -> Index 4
    ];

    return Scaffold(
      extendBody: true,
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          const CustomStatusBar(),
          Expanded(
            child: tabs[_currentIndex],
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomNavBar(
        selectedIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }

  String _getTabTitle(int index) {
    switch (index) {
      case 0:
        return 'Misiones y Logros';
      case 1:
        return 'Mi Jardín';
      case 2:
        return 'ECO2 Dashboard';
      case 3:
        return 'Escáner IA';
      case 4:
        return 'Mi Perfil';
      default:
        return 'ECO2';
    }
  }
}
