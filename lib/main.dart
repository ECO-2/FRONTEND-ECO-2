import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:frontend_eco_2/providers/providers.dart';
import 'package:frontend_eco_2/services/services.dart';
import 'package:frontend_eco_2/routing/app_routes.dart';
import 'package:frontend_eco_2/theme/app_colors.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';


final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Inicializar servicios compartidos
  final storage = SecureStorage();
  final apiClient = ApiClient(storage);

  final authService = AuthService(apiClient, storage);
  final userService = UserService(apiClient);
  final plantsService = PlantsService(apiClient);
  final gamificationService = GamificationService(apiClient);
  final careService = CareService(apiClient);
  final identificationService = IdentificationService(apiClient);
  final notificationService = NotificationService(apiClient);

  runApp(MyApp(
    storage: storage,
    authService: authService,
    userService: userService,
    plantsService: plantsService,
    gamificationService: gamificationService,
    careService: careService,
    identificationService: identificationService,
    notificationService: notificationService,
  ));
}

class MyApp extends StatelessWidget {
  final SecureStorage storage;
  final AuthService authService;
  final UserService userService;
  final PlantsService plantsService;
  final GamificationService gamificationService;
  final CareService careService;
  final IdentificationService identificationService;
  final NotificationService notificationService;   

  const MyApp({
    super.key,
    required this.storage,
    required this.authService,
    required this.userService,
    required this.plantsService,
    required this.gamificationService,
    required this.careService,
    required this.identificationService,
    required this.notificationService,
  });

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<CareService>.value(value: careService),
        Provider<IdentificationService>.value(value: identificationService),
        Provider<SecureStorage>.value(value: storage),
        Provider<NotificationService>.value(value: notificationService),
        ChangeNotifierProvider(
          create: (_) => UserProvider(
            authService: authService,
            userService: userService,
            storage: storage,
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => PlantsProvider(plantsService: plantsService),
        ),
        ChangeNotifierProvider(
          create: (_) => MissionsProvider(
            gamificationService: gamificationService,
            careService: careService,
          ),
        ),
        ChangeNotifierProvider(create: (_) => NotificationsProvider()),
      ],
      // ECO2 no ofrece modo oscuro: la app siempre usa el tema claro,
      // sin importar el ajuste de tema del sistema del teléfono.
      child: _AppLoader(
        child: MaterialApp(
          navigatorKey: navigatorKey,
          title: 'ECO2',
          themeMode: ThemeMode.light,
          debugShowCheckedModeBanner: false,
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('es', ''),
            Locale('en', ''),
          ],
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
          initialRoute: AppRoutes.welcome,
          onGenerateRoute: AppRoutes.onGenerateRoute,
        ),
      ),
    );
  }
}

/// Widget que intenta restaurar la sesión existente al arrancar la app.
/// Si hay tokens guardados, carga el usuario y redirige al onboarding o dashboard.
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

    if (userProvider.isAuthenticated) {
      final user = userProvider.currentUser!;

      if (!user.onboardingCompleted) {
        // Onboarding pendiente — no cargar datos del dashboard todavía.
        navigatorKey.currentState?.pushNamedAndRemoveUntil(
          AppRoutes.onboarding,
          (route) => false,
        );
        return;
      }

      // Carga paralela de datos del dashboard.
      final plantsProvider = context.read<PlantsProvider>();
      final missionsProvider = context.read<MissionsProvider>();
      await Future.wait([
        plantsProvider.init(),
        missionsProvider.init(),
      ]);
      missionsProvider.syncUserPlantsCount(plantsProvider.userPlants.length);

      if (!mounted) return;
      navigatorKey.currentState?.pushNamedAndRemoveUntil(
        AppRoutes.dashboard,
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
