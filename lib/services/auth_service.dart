import 'api_client.dart';
import 'secure_storage.dart';

/// Maneja registro, login y logout contra la ECO2 API.
class AuthService {
  final ApiClient _client;
  final SecureStorage _storage;

  AuthService(this._client, this._storage);

  /// POST /auth/login — guarda los tokens en SecureStorage.
  Future<void> login(String email, String password) async {
    final data = await _client.post(
      '/auth/login',
      body: {'email': email, 'password': password},
      requiresAuth: false,
    ) as Map<String, dynamic>;

    await _storage.saveTokens(
      accessToken: data['accessToken'] as String,
      refreshToken: data['refreshToken'] as String,
    );
  }

  /// POST /auth/register — crea el usuario en la API.
  Future<void> register(String email, String password) async {
    await _client.post(
      '/auth/register',
      body: {'email': email, 'password': password},
      requiresAuth: false,
    );
  }

  /// POST /auth/logout — revoca la sesión y limpia los tokens locales.
  Future<void> logout() async {
    try {
      final refreshToken = await _storage.getRefreshToken();
      if (refreshToken != null) {
        await _client.post(
          '/auth/logout',
          body: {'refreshToken': refreshToken},
        );
      }
    } catch (_) {
      // Ignorar errores en logout — limpiar tokens de todas formas.
    } finally {
      await _storage.clearTokens();
    }
  }
}
