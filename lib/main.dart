import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:frontend_eco_2/providers/providers.dart';
import 'package:frontend_eco_2/routing/app_routes.dart';
import 'package:frontend_eco_2/theme/app_colors.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => PlantsProvider()),
        ChangeNotifierProvider(create: (_) => MissionsProvider()),
        ChangeNotifierProvider(create: (_) => NotificationsProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, _) {
          return MaterialApp(
            title: 'Material App',
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
    );
  }
}

