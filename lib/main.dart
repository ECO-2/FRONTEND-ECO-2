import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:frontend_eco_2/providers/providers.dart';
import 'package:frontend_eco_2/services/services.dart';
import 'package:frontend_eco_2/routing/app_routes.dart';
import 'package:frontend_eco_2/theme/app_colors.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializar servicios compartidos
  final storage = SecureStorage();
  final apiClient = ApiClient(storage);

  final authService = AuthService(apiClient, storage);
  final userService = UserService(apiClient);
  final plantsService = PlantsService(apiClient);
  final gamificationService = GamificationService(apiClient);

  runApp(MyApp(
    storage: storage,
    authService: authService,
    userService: userService,
    plantsService: plantsService,
    gamificationService: gamificationService,
  ));
}

class MyApp extends StatelessWidget {
  final SecureStorage storage;
  final AuthService authService;
  final UserService userService;
  final PlantsService plantsService;
  final GamificationService gamificationService;

  const MyApp({
    super.key,
    required this.storage,
    required this.authService,
    required this.userService,
    required this.plantsService,
    required this.gamificationService,
  });

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => UserProvider(
            authService: authService,
            userService: userService,
            storage: storage,
          ),
        ),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(
          create: (_) => PlantsProvider(plantsService: plantsService),
        ),
        ChangeNotifierProvider(
          create: (_) =>
              MissionsProvider(gamificationService: gamificationService),
        ),
        ChangeNotifierProvider(create: (_) => NotificationsProvider()),
      ],
      child: _AppLoader(
        child: Consumer<ThemeProvider>(
          builder: (context, themeProvider, _) {
            return MaterialApp(
              title: 'ECO2',
              themeMode: themeProvider.themeMode,
              debugShowCheckedModeBanner: false,
              theme: ThemeData(
                useMaterial3: true,
                brightness: Brightness.light,
                colorSchemeSeed: AppColors.primary,
                scaffoldBackgroundColor: AppColors.background,
                appBarTheme: const AppBarTheme(
                  backgroundColor: AppColors.background,
                  elevation: 0,
                  foregroundColor: AppColors.textPrimary,
                ),
              ),
              darkTheme: ThemeData(
                useMaterial3: true,
                brightness: Brightness.dark,
                colorSchemeSeed: AppColors.accent,
              ),
              initialRoute: AppRoutes.welcome,
              onGenerateRoute: AppRoutes.onGenerateRoute,
            );
          },
        ),
      ),
    );
  }
}

/// Widget que intenta restaurar la sesión existente al arrancar la app.
/// Si hay tokens guardados, carga el usuario y redirige al dashboard.
class _AppLoader extends StatefulWidget {
  final Widget child;

  const _AppLoader({required this.child});

  @override
  State<_AppLoader> createState() => _AppLoaderState();
}

class _AppLoaderState extends State<_AppLoader> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _init());
  }

  Future<void> _init() async {
    final userProvider = context.read<UserProvider>();
    await userProvider.loadCurrentUser();

    if (!mounted) return;

    // Si el usuario ya tiene sesión activa, ir al dashboard.
    if (userProvider.isAuthenticated) {
      final plantsProvider = context.read<PlantsProvider>();
      final missionsProvider = context.read<MissionsProvider>();

      // Carga paralela de datos del dashboard.
      await Future.wait([
        plantsProvider.init(),
        missionsProvider.init(),
      ]);
    }
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
