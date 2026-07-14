import 'package:flutter/material.dart';
import 'package:frontend_eco_2/models/models.dart';
import 'package:frontend_eco_2/services/services.dart';

class UserProvider with ChangeNotifier {
  final AuthService _authService;
  final UserService _userService;
  final SecureStorage _storage;

  User? _currentUser;
  bool _isLoading = false;
  String? _errorMessage;

  UserProvider({
    required AuthService authService,
    required UserService userService,
    required SecureStorage storage,
  })  : _authService = authService,
        _userService = userService,
        _storage = storage;

  User? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _currentUser != null;

  void setUser(User? user) {
    _currentUser = user;
    notifyListeners();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  // ---------------------------------------------------------------------------
  // Inicialización — restaurar sesión al arrancar la app
  // ---------------------------------------------------------------------------

  /// Intenta cargar el usuario desde la API si hay un token guardado.
  Future<void> loadCurrentUser() async {
    final hasTokens = await _storage.hasTokens();
    if (!hasTokens) return;

    _setLoading(true);
    try {
      _currentUser = await _userService.getMe();
    } catch (_) {
      // Token expirado o error de red — limpiar tokens silenciosamente.
      await _storage.clearTokens();
      _currentUser = null;
    } finally {
      _setLoading(false);
    }
  }

  // ---------------------------------------------------------------------------
  // Login
  // ---------------------------------------------------------------------------

  /// Inicia sesión con email y contraseña. Retorna true si fue exitoso.
  Future<bool> login(String email, String password) async {
    _setLoading(true);
    _errorMessage = null;
    try {
      await _authService.login(email, password);
      _currentUser = await _userService.getMe();
      _setLoading(false);
      return true;
    } on ApiException catch (e) {
      _errorMessage = e.isUnauthorized
          ? 'Correo o contraseña incorrectos.'
          : e.message;
      _setLoading(false);
      return false;
    } catch (_) {
      _errorMessage = 'Error de conexión. Verifica tu internet.';
      _setLoading(false);
      return false;
    }
  }

  // ---------------------------------------------------------------------------
  // Register
  // ---------------------------------------------------------------------------

  /// Registra un nuevo usuario y luego inicia sesión automáticamente.
  Future<bool> register(String email, String password) async {
    _setLoading(true);
    _errorMessage = null;
    try {
      await _authService.register(email, password);
      // Después de registrar, hacer login para obtener los tokens.
      await _authService.login(email, password);
      _currentUser = await _userService.getMe();
      _setLoading(false);
      return true;
    } on ApiException catch (e) {
      _errorMessage = e.isConflict
          ? 'Este correo ya tiene una cuenta registrada.'
          : e.message;
      _setLoading(false);
      return false;
    } catch (_) {
      _errorMessage = 'Error de conexión. Verifica tu internet.';
      _setLoading(false);
      return false;
    }
  }

  // ---------------------------------------------------------------------------
  // Profile update
  // ---------------------------------------------------------------------------

  Future<bool> updateProfile({
    String? username,
    bool? notificationsEnabled,
    int? reminderStartHour,
    int? reminderEndHour,
  }) async {
    _setLoading(true);
    _errorMessage = null;
    try {
      _currentUser = await _userService.updateProfile(
        username: username,
        notificationsEnabled: notificationsEnabled,
        reminderStartHour: reminderStartHour,
        reminderEndHour: reminderEndHour,
      );
      _setLoading(false);
      return true;
    } on ApiException catch (e) {
      _errorMessage = e.isConflict
          ? 'Ese nombre de usuario ya está en uso.'
          : e.message;
      _setLoading(false);
      return false;
    } catch (_) {
      _errorMessage = 'Error de conexión. Verifica tu internet.';
      _setLoading(false);
      return false;
    }
  }

  // ---------------------------------------------------------------------------
  // Logout
  // ---------------------------------------------------------------------------

  Future<void> logout() async {
    await _authService.logout();
    _currentUser = null;
    _errorMessage = null;
    notifyListeners();
  }
}
