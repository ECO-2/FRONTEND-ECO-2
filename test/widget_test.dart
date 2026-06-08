import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend_eco_2/main.dart';

void main() {
  testWidgets('App smoke test - Welcome flow to Login and Dashboard', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that our app starts on the WelcomeScreen
    expect(find.text('Cuidado de plantas con IA'), findsOneWidget);
    expect(find.text('Iniciar Sesión'), findsOneWidget);
    expect(find.text('Crear Cuenta'), findsOneWidget);

    // Tap the 'Iniciar Sesión' button on the WelcomeScreen to go to LoginScreen
    await tester.tap(find.text('Iniciar Sesión'));
    await tester.pumpAndSettle(); // Wait for navigation transition

    // Verify that we are on the LoginScreen
    expect(find.text('Bienvenido de vuelta'), findsOneWidget);
    
    // Tap the 'Iniciar sesión' button on the LoginScreen (which has predefined test credentials)
    // Find the button inside LoginScreen. We have a CustomButton.
    final loginButton = find.widgetWithText(ElevatedButton, 'Iniciar sesión');
    expect(loginButton, findsOneWidget);
    await tester.ensureVisible(loginButton);
    await tester.tap(loginButton);
    
    // The login has a 1 second mock network delay
    await tester.pump(const Duration(seconds: 1));
    await tester.pumpAndSettle(); // Process redirect animation to Dashboard

    // Verify that we are now in the Dashboard screen
    expect(find.text('ECO2 Dashboard'), findsOneWidget);
    expect(find.text('¡Hola, usuario_prueba! 🌿'), findsOneWidget);
  });
}
