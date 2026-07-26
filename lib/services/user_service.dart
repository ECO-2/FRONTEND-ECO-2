import '../models/models.dart';
import 'api_client.dart';

/// Gestiona el perfil del usuario autenticado.
class UserService {
  final ApiClient _client;

  UserService(this._client);

  /// GET /user/me — retorna el usuario autenticado.
  Future<User> getMe() async {
    final data = await _client.get('/user/me') as Map<String, dynamic>;
    return User.fromJson(data);
  }

  /// PATCH /user/profile — actualiza nombre, notificaciones y horarios de recordatorio.
  Future<User> updateProfile({
    String? username,
    bool? notificationsEnabled,
    int? reminderStartHour,
    int? reminderEndHour,
  }) async {
    final body = <String, dynamic>{};
    if (username != null) body['username'] = username;
    if (notificationsEnabled != null) {
      body['notifications_enabled'] = notificationsEnabled;
    }
    if (reminderStartHour != null) body['reminder_start_hour'] = reminderStartHour;
    if (reminderEndHour != null) body['reminder_end_hour'] = reminderEndHour;

    final data = await _client.patch('/user/profile', body: body) as Map<String, dynamic>;
    return User.fromJson(data);
  }

  /// PATCH /user/onboarding — completa el perfil inicial del usuario tras el registro.
  /// Todos los campos son opcionales y pueden enviarse de forma progresiva.
  Future<User> completeOnboarding({
    String? username,
    String? gender,
    DateTime? birthDay,
  }) async {
    final body = <String, dynamic>{};
    if (username != null && username.isNotEmpty) body['username'] = username;
    if (gender != null) body['gender'] = gender;
    if (birthDay != null) {
      // La API espera formato date (YYYY-MM-DD)
      body['birth_day'] =
          '${birthDay.year.toString().padLeft(4, '0')}-${birthDay.month.toString().padLeft(2, '0')}-${birthDay.day.toString().padLeft(2, '0')}';
    }
    final data =
        await _client.patch('/user/onboarding', body: body) as Map<String, dynamic>;
    return User.fromJson(data);
  }
}
