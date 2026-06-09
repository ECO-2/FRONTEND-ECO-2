import 'package:flutter/material.dart';
import 'package:frontend_eco_2/screens/auth/welcome_screen.dart';
import 'package:frontend_eco_2/screens/auth/login_screen.dart';
import 'package:frontend_eco_2/screens/auth/register_screen.dart';
import 'package:frontend_eco_2/screens/dashboard/dashboard_screen.dart';
import 'package:frontend_eco_2/screens/notifications/notifications_screen.dart';
import 'package:frontend_eco_2/screens/profile/edit_profile_screen.dart';
import 'package:frontend_eco_2/screens/settings/settings_screen.dart';
import 'package:frontend_eco_2/screens/premium/premium_upgrade_screen.dart';
import 'package:frontend_eco_2/screens/premium/checkout_screen.dart';
import 'package:frontend_eco_2/screens/premium/success_screen.dart';
import 'package:frontend_eco_2/screens/profile/trophies_screen.dart';
import 'package:frontend_eco_2/widgets/common/custom_app_bar.dart';
import 'package:frontend_eco_2/screens/dashboard/tabs/missions_tab.dart';

class AppRoutes {
  static const String welcome = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String dashboard = '/dashboard';
  static const String myGarden = '/my-garden';
  static const String plantDetail = '/plant-detail';
  static const String addPlant = '/add-plant';
  static const String careHistory = '/care-history';
  static const String scan = '/scan';
  static const String recordCare = '/record-care';
  static const String profile = '/profile';
  static const String editProfile = '/edit-profile';
  static const String settings = '/settings';
  static const String greenFootprint = '/green-footprint';
  static const String missions = '/missions';
  static const String trophies = '/trophies';
  static const String premiumUpgrade = '/premium-upgrade';
  static const String checkout = '/checkout';
  static const String success = '/success';
  static const String notifications = '/notifications';

  static Route<dynamic> onGenerateRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case welcome:
        return MaterialPageRoute(builder: (_) => const WelcomeScreen());
      case login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case register:
        return MaterialPageRoute(builder: (_) => const RegisterScreen());
      case dashboard:
        return MaterialPageRoute(builder: (_) => const DashboardScreen());
      case notifications:
        return MaterialPageRoute(builder: (_) => const NotificationsScreen());
      
      // Rutas para pantallas secundarias (inicialmente placeholders sencillos)
      case myGarden:
        return MaterialPageRoute(builder: (_) => _placeholderScreen('Mi Jardín'));
      case plantDetail:
        return MaterialPageRoute(builder: (_) => _placeholderScreen('Detalle de Planta'));
      case addPlant:
        return MaterialPageRoute(builder: (_) => _placeholderScreen('Añadir Planta'));
      case careHistory:
        return MaterialPageRoute(builder: (_) => _placeholderScreen('Historial de Cuidados'));
      case scan:
        return MaterialPageRoute(builder: (_) => _placeholderScreen('Escáner IA'));
      case recordCare:
        return MaterialPageRoute(builder: (_) => _placeholderScreen('Registrar Cuidado'));
      case profile:
        return MaterialPageRoute(builder: (_) => _placeholderScreen('Perfil'));
      case editProfile:
        return MaterialPageRoute(builder: (_) => const EditProfileScreen());
      case settings:
        return MaterialPageRoute(builder: (_) => const SettingsScreen());
      case greenFootprint:
        return MaterialPageRoute(builder: (_) => _placeholderScreen('Mi Huella Verde'));
      case missions:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            appBar: CustomAppBar(title: 'Misiones'),
            body: MissionsTab(),
          ),
        );
      case trophies:
        return MaterialPageRoute(builder: (_) => const TrophiesScreen());
      case premiumUpgrade:
        return MaterialPageRoute(builder: (_) => const PremiumUpgradeScreen());
      case checkout:
        return MaterialPageRoute(builder: (_) => const CheckoutScreen());
      case success:
        return MaterialPageRoute(builder: (_) => const SuccessScreen());
      
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('Ruta no encontrada: ${routeSettings.name}'),
            ),
          ),
        );
    }
  }

  static Widget _placeholderScreen(String title) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Text(
          'Pantalla: $title\n(Próximamente en desarrollo)',
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 18, color: Colors.grey),
        ),
      ),
    );
  }
}
