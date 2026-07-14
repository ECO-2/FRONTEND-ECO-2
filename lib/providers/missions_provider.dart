import 'package:flutter/material.dart';
import 'package:frontend_eco_2/models/models.dart';
import 'package:frontend_eco_2/services/services.dart';

class MissionsProvider with ChangeNotifier {
  final GamificationService _gamificationService;

  List<Achievement> _achievements = [];
  List<UserAchievement> _unlockedAchievements = [];
  UserProgress? _progress;
  bool _isLoading = false;
  String? _errorMessage;

  MissionsProvider({required GamificationService gamificationService})
      : _gamificationService = gamificationService;

  List<Achievement> get achievements => _achievements;
  List<UserAchievement> get unlockedAchievements => _unlockedAchievements;
  UserProgress? get progress => _progress;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  /// IDs de logros ya desbloqueados por el usuario.
  List<String> get completedAchievementIds =>
      _unlockedAchievements.map((ua) => ua.achievementId).toList();

  /// Semillas actuales del usuario (0 si no ha cargado aún).
  int get userSeeds => _progress?.seeds ?? 0;

  bool isAchievementCompleted(String id) =>
      completedAchievementIds.contains(id);

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  // ---------------------------------------------------------------------------
  // Carga inicial
  // ---------------------------------------------------------------------------

  /// Carga progreso y logros del usuario desde la API.
  Future<void> init() async {
    _setLoading(true);
    _errorMessage = null;
    try {
      final results = await Future.wait([
        _gamificationService.getProgress(),
        _gamificationService.getAchievements(),
        _gamificationService.getMyAchievements(),
      ]);
      _progress = results[0] as UserProgress;
      _achievements = results[1] as List<Achievement>;
      _unlockedAchievements = results[2] as List<UserAchievement>;
    } on ApiException catch (e) {
      _errorMessage = e.message;
    } catch (_) {
      _errorMessage = 'Error al cargar misiones.';
    } finally {
      _setLoading(false);
    }
  }

  // ---------------------------------------------------------------------------
  // XP y semillas
  // ---------------------------------------------------------------------------

  Future<void> addSeeds(int amount, {String reason = 'reward'}) async {
    try {
      _progress = await _gamificationService.updateSeeds(amount, reason);
      notifyListeners();
    } catch (_) {
      // Actualización local como fallback
      if (_progress != null) {
        _progress = _progress!.copyWith(seeds: _progress!.seeds + amount);
        notifyListeners();
      }
    }
  }

  Future<bool> spendSeeds(int amount) async {
    if (userSeeds < amount) return false;
    try {
      _progress = await _gamificationService.updateSeeds(-amount, 'purchase');
      notifyListeners();
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<void> addXp(int amount, {String actionType = 'action'}) async {
    try {
      _progress = await _gamificationService.addXp(amount, actionType);
      notifyListeners();
    } catch (_) {}
  }

  // ---------------------------------------------------------------------------
  // Desbloquear logro manualmente (si es necesario)
  // ---------------------------------------------------------------------------

  void completeAchievement(String id) {
    if (!completedAchievementIds.contains(id)) {
      // Agregar localmente hasta que se recargue desde API
      _unlockedAchievements.add(UserAchievement(
        id: 'local_${DateTime.now().millisecondsSinceEpoch}',
        userId: '',
        achievementId: id,
        unlockedAt: DateTime.now(),
      ));
      notifyListeners();
    }
  }

  // Mantenido por compatibilidad con código existente
  void incrementRegisteredPlants() {}
}
