import 'package:flutter/material.dart';
import 'package:frontend_eco_2/models/models.dart';

class PlantsProvider with ChangeNotifier {
  final List<UserPlant> _userPlants = [
    UserPlant(
      id: '1',
      userId: 'mock-id-123',
      speciesId: 's1',
      nickname: 'Mi Monstera',
      healthStatus: 'Excelente',
      acquiredAt: DateTime.now().subtract(const Duration(days: 30)),
      lastWateredAt: DateTime.now().subtract(const Duration(days: 8)), // Needs watering in Figma description (Lleva 8 días sin riego)
      createdAt: DateTime.now().subtract(const Duration(days: 30)),
    ),
    UserPlant(
      id: '2',
      userId: 'mock-id-123',
      speciesId: 's2',
      nickname: 'Mi Potus',
      healthStatus: 'Bueno',
      acquiredAt: DateTime.now().subtract(const Duration(days: 15)),
      lastWateredAt: DateTime.now().subtract(const Duration(days: 2)),
      createdAt: DateTime.now().subtract(const Duration(days: 15)),
    ),
  ];

  bool _isLoading = false;

  List<UserPlant> get userPlants => _userPlants;
  bool get isLoading => _isLoading;

  void addPlant(String nickname, String speciesId) {
    final newPlant = UserPlant(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      userId: 'mock-id-123',
      speciesId: speciesId,
      nickname: nickname,
      healthStatus: 'Bueno',
      acquiredAt: DateTime.now(),
      lastWateredAt: DateTime.now(),
      createdAt: DateTime.now(),
    );
    _userPlants.add(newPlant);
    notifyListeners();
  }

  void waterPlant(String id) {
    final index = _userPlants.indexWhere((p) => p.id == id);
    if (index != -1) {
      _userPlants[index] = _userPlants[index].copyWith(
        lastWateredAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      notifyListeners();
    }
  }

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
