import 'package:flutter/material.dart';
import 'package:frontend_eco_2/models/models.dart';

class MissionsProvider with ChangeNotifier {
  final List<Achievement> _achievements = [
    Achievement(
      id: 'a1',
      name: 'Jardín Saludable',
      conditionType: 'care_logs',
      conditionValue: 5,
      xpReward: 100,
      description: 'Completa 5 tareas de cuidado para tus plantas.',
    ),
    Achievement(
      id: 'a2',
      name: 'Jardín Urbano',
      conditionType: 'plant_count',
      conditionValue: 5,
      xpReward: 200,
      description: 'Registra 5 plantas en tu jardín personal.',
    ),
    Achievement(
      id: 'a3',
      name: 'Primeros Pasos',
      conditionType: 'plant_count',
      conditionValue: 1,
      xpReward: 50,
      description: 'Registra tu primera planta en la aplicación.',
    ),
  ];

  final List<String> _completedAchievementIds = ['a3']; // First steps is done
  int _userSeeds = 240; // From Figma description (240 semillas acumuladas)
  int _registeredPlantsCount = 2; // From Figma (2 de 5 plantas registradas)

  List<Achievement> get achievements => _achievements;
  List<String> get completedAchievementIds => _completedAchievementIds;
  int get userSeeds => _userSeeds;
  int get registeredPlantsCount => _registeredPlantsCount;

  bool isAchievementCompleted(String id) => _completedAchievementIds.contains(id);

  void addSeeds(int count) {
    _userSeeds += count;
    notifyListeners();
  }

  void completeAchievement(String id) {
    if (!_completedAchievementIds.contains(id)) {
      _completedAchievementIds.add(id);
      final ach = _achievements.firstWhere((a) => a.id == id);
      addSeeds(ach.xpReward ~/ 5); // Add some seeds as reward
      notifyListeners();
    }
  }

  void incrementRegisteredPlants() {
    _registeredPlantsCount++;
    if (_registeredPlantsCount >= 5) {
      completeAchievement('a2');
    }
    notifyListeners();
  }
}
