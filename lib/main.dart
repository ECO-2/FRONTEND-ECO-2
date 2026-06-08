import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:frontend_eco_2/providers/providers.dart';

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
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, _) {
          return MaterialApp(
            title: 'Material App',
            themeMode: themeProvider.themeMode,
            theme: ThemeData(
              useMaterial3: true,
              brightness: Brightness.light,
              colorSchemeSeed: Colors.green,
            ),
            darkTheme: ThemeData(
              useMaterial3: true,
              brightness: Brightness.dark,
              colorSchemeSeed: Colors.green,
            ),
            home: Scaffold(
              appBar: AppBar(
                title: const Text('Material App Bar'),
              ),
              body: Center(
                child: Consumer<UserProvider>(
                  builder: (context, userProvider, _) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (userProvider.isLoading)
                          const CircularProgressIndicator()
                        else ...[
                          Text(
                            userProvider.isAuthenticated
                                ? 'Bienvenido, ${userProvider.currentUser?.username}!'
                                : 'No autenticado',
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: () {
                              if (userProvider.isAuthenticated) {
                                userProvider.logout();
                              } else {
                                userProvider.loginMock('usuario_prueba@eco2.com', 'password123');
                              }
                            },
                            child: Text(userProvider.isAuthenticated ? 'Cerrar sesión' : 'Simular Login'),
                          ),
                        ],
                        const SizedBox(height: 40),
                        ElevatedButton.icon(
                          onPressed: () {
                            themeProvider.toggleTheme(!themeProvider.isDarkMode);
                          },
                          icon: Icon(themeProvider.isDarkMode ? Icons.light_mode : Icons.dark_mode),
                          label: Text(themeProvider.isDarkMode ? 'Modo Claro' : 'Modo Oscuro'),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
