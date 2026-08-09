import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Gestiona el almacenamiento seguro de tokens JWT (accessToken y refreshToken).
class SecureStorage {
  static const _accessTokenKey = 'access_token';
  static const _refreshTokenKey = 'refresh_token';
  static const _appTourSeenKey = 'app_tour_seen';

  final FlutterSecureStorage _storage = const FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
  );

  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    await Future.wait([
      _storage.write(key: _accessTokenKey, value: accessToken),
      _storage.write(key: _refreshTokenKey, value: refreshToken),
    ]);
  }

  Future<String?> getAccessToken() => _storage.read(key: _accessTokenKey);
  Future<String?> getRefreshToken() => _storage.read(key: _refreshTokenKey);

  Future<void> clearTokens() async {
    await Future.wait([
      _storage.delete(key: _accessTokenKey),
      _storage.delete(key: _refreshTokenKey),
    ]);
  }

  Future<bool> hasTokens() async {
    final token = await getAccessToken();
    return token != null && token.isNotEmpty;
  }

  /// Recorrido guiado de la app — se muestra automáticamente una sola vez.
  Future<bool> hasSeenAppTour() async {
    return (await _storage.read(key: _appTourSeenKey)) == 'true';
  }

  Future<void> markAppTourSeen() => _storage.write(key: _appTourSeenKey, value: 'true');
}
