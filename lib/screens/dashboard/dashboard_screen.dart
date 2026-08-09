import 'package:flutter/material.dart';
import 'package:frontend_eco_2/widgets/common/custom_status_bar.dart';
import 'package:provider/provider.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:frontend_eco_2/providers/providers.dart';
import 'package:frontend_eco_2/routing/app_routes.dart';
import 'package:frontend_eco_2/services/services.dart';
import 'package:frontend_eco_2/theme/app_colors.dart';
import 'package:frontend_eco_2/utils/app_tour.dart';
import 'package:frontend_eco_2/widgets/common/custom_bottom_nav_bar.dart';
import 'package:frontend_eco_2/screens/dashboard/tabs/home_tab.dart';
import 'package:frontend_eco_2/screens/dashboard/tabs/garden_tab.dart';
import 'package:frontend_eco_2/screens/dashboard/tabs/scanner_tab.dart';
import 'package:frontend_eco_2/screens/dashboard/tabs/profile_tab.dart';
import 'package:frontend_eco_2/screens/store/store_screen.dart';
import 'package:frontend_eco_2/widgets/dashboard/dashboard_header.dart';

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

    return ShowCaseWidget(
      onFinish: () {
        Provider.of<SecureStorage>(context, listen: false).markAppTourSeen();
      },
      builder: (context) => _DashboardBody(
        currentIndex: _currentIndex,
        onTabChange: (i) => setState(() => _currentIndex = i),
      ),
    );
  }
}

class _DashboardBody extends StatefulWidget {
  final int currentIndex;
  final ValueChanged<int> onTabChange;

  const _DashboardBody({required this.currentIndex, required this.onTabChange});

  @override
  State<_DashboardBody> createState() => _DashboardBodyState();
}

class _DashboardBodyState extends State<_DashboardBody> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _maybeStartTour());
  }

  Future<void> _maybeStartTour() async {
    if (!mounted) return;
    final storage = Provider.of<SecureStorage>(context, listen: false);
    final seen = await storage.hasSeenAppTour();
    if (seen || !mounted) return;
    ShowCaseWidget.of(context).startShowCase(AppTourKeys.orderedSteps);
  }

  /// Relanza el recorrido manualmente (botón en Perfil) — vuelve primero al
  /// tab de Dashboard, porque ahí es donde viven los widgets señalados
  /// (header con semillas/trofeos/campana, barra inferior).
  void _restartTour() {
    widget.onTabChange(2);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      ShowCaseWidget.of(context).startShowCase(AppTourKeys.orderedSteps);
    });
  }

  @override
  Widget build(BuildContext context) {
    final tabs = [
      const StoreScreen(isTab: true), // Tienda -> Index 0
      const GardenTab(), // Jardin -> Index 1
      HomeTab(
        onViewAll: () => widget.onTabChange(1),
      ), // Dashboard -> Index 2
      const ScannerTab(), // Escaner -> Index 3
      ProfileTab(
        onNavigateToGarden: () => widget.onTabChange(1),
        onStartTour: _restartTour,
      ), // Perfil -> Index 4
    ];

    PreferredSizeWidget? appBar;
    if (widget.currentIndex == 2) {
      appBar = DashboardHeader(
        seedsKey: AppTourKeys.seedsPill,
        trophyKey: AppTourKeys.trophyIcon,
        bellKey: AppTourKeys.notifBell,
      );
    }

    final showStatusBarInBody = appBar == null;

    return Scaffold(
      extendBody: true,
      backgroundColor: AppColors.background,
      appBar: appBar,
      body: Column(
        children: [
          if (showStatusBarInBody) const CustomStatusBar(),
          Expanded(child: tabs[widget.currentIndex]),
        ],
      ),
      bottomNavigationBar: CustomBottomNavBar(
        selectedIndex: widget.currentIndex,
        onTap: widget.onTabChange,
        jardinKey: AppTourKeys.navJardin,
        escanerKey: AppTourKeys.navEscaner,
        tiendaKey: AppTourKeys.navTienda,
        perfilKey: AppTourKeys.navPerfil,
      ),
    );
  }
}
