// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:frontend_eco_2/main.dart';

void main() {
  testWidgets('App smoke test - Login simulation', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that our app starts in an unauthenticated state.
    expect(find.text('No autenticado'), findsOneWidget);
    expect(find.text('Cerrar sesión'), findsNothing);

    // Tap the 'Simular Login' button.
    await tester.tap(find.text('Simular Login'));
    
    // The login has a 1 second delay, pump the duration and pump again to process states.
    await tester.pump(const Duration(seconds: 1));
    await tester.pump();

    // Verify that our app is now logged in.
    expect(find.text('Bienvenido, usuario_prueba!'), findsOneWidget);
    expect(find.text('Cerrar sesión'), findsOneWidget);
  });
}

