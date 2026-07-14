import '../models/models.dart';
import 'api_client.dart';

/// Gestiona el progreso de gamificación, logros y semillas del usuario.
class GamificationService {
  final ApiClient _client;

  GamificationService(this._client);

  /// GET /gamification/progress
  Future<UserProgress> getProgress() async {
    final data =
        await _client.get('/gamification/progress') as Map<String, dynamic>;
    return UserProgress.fromJson(data);
  }

  /// POST /gamification/progress/xp — suma XP al usuario.
  Future<UserProgress> addXp(int amount, String actionType) async {
    final data = await _client.post('/gamification/progress/xp', body: {
      'amount': amount,
      'action_type': actionType,
    }) as Map<String, dynamic>;
    return UserProgress.fromJson(data);
  }

  /// POST /gamification/progress/seeds — suma o resta semillas.
  /// Usa [amount] positivo para agregar y negativo para gastar.
  Future<UserProgress> updateSeeds(int amount, String reason) async {
    final data = await _client.post('/gamification/progress/seeds', body: {
      'amount': amount,
      'reason': reason,
    }) as Map<String, dynamic>;
    return UserProgress.fromJson(data);
  }

  /// GET /gamification/achievements — todos los logros disponibles.
  Future<List<Achievement>> getAchievements() async {
    final data =
        await _client.get('/gamification/achievements') as List<dynamic>;
    return data
        .map((e) => Achievement.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// GET /gamification/achievements/me — logros desbloqueados por el usuario.
  Future<List<UserAchievement>> getMyAchievements() async {
    final data =
        await _client.get('/gamification/achievements/me') as List<dynamic>;
    return data
        .map((e) => UserAchievement.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
