import 'package:flutter/material.dart';
import 'package:frontend_eco_2/models/models.dart';

class UserProvider with ChangeNotifier {
  User? _currentUser;
  bool _isLoading = false;

  User? get currentUser => _currentUser;
  bool get isLoading => _isLoading;

  bool get isAuthenticated => _currentUser != null;

  void setUser(User? user) {
    _currentUser = user;
    notifyListeners();
  }

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  // Ejemplo de login simulado
  Future<bool> loginMock(String email, String password) async {
    setLoading(true);
    
    // Simular retraso de red
    await Future.delayed(const Duration(seconds: 1));
    
    // Crear un usuario de prueba
    _currentUser = User(
      id: 'mock-id-123',
      email: email,
      username: email.split('@')[0],
      mfaEnabled: false,
      planType: 'free',
      role: 'user',
      createdAt: DateTime.now(),
    );
    
    setLoading(false);
    return true;
  }

  void logout() {
    _currentUser = null;
    notifyListeners();
  }
}
