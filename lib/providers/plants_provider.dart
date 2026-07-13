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
      name: 'Monstera Deliciosa',
      acquiredAt: DateTime.now().subtract(const Duration(days: 30)),
      lastWateredAt: DateTime.now().subtract(
        const Duration(days: 8),
      ), // Needs watering in Figma description (Lleva 8 días sin riego)
      createdAt: DateTime.now().subtract(const Duration(days: 30)),
    ),
    UserPlant(
      id: '2',
      userId: 'mock-id-123',
      speciesId: 's2',
      nickname: 'Mi Potus',
      healthStatus: 'Bueno',
      name: 'Potus',
      acquiredAt: DateTime.now().subtract(const Duration(days: 15)),
      lastWateredAt: DateTime.now().subtract(const Duration(days: 2)),
      createdAt: DateTime.now().subtract(const Duration(days: 15)),
    ),
  ];

  final List<PlantSpecies> _speciesCatalog = [
    PlantSpecies(
      id: 's1',
      scientificName: 'Monstera deliciosa',
      commonName: 'Monstera deliciosa',
      category: 'Tropical',
      lightRequirement: 'Luz indirecta',
      waterFrequencyDays: 7,
      humidityPreference: 'Alta',
      airPurificationScore: 80,
      minTemperature: 15,
      maxTemperature: 30,
      createdAt: DateTime.now().subtract(const Duration(days: 100)),
    ),
    PlantSpecies(
      id: 's2',
      scientificName: 'Epipremnum aureum',
      commonName: 'Pothos dorado',
      category: 'Tropical',
      lightRequirement: 'Luz indirecta',
      waterFrequencyDays: 7,
      humidityPreference: 'Media',
      airPurificationScore: 85,
      minTemperature: 15,
      maxTemperature: 30,
      createdAt: DateTime.now().subtract(const Duration(days: 100)),
    ),
    PlantSpecies(
      id: 's3',
      scientificName: 'Sansevieria trifasciata',
      commonName: 'Sansevieria',
      category: 'Suculentas',
      lightRequirement: 'Luz adaptable',
      waterFrequencyDays: 20,
      humidityPreference: 'Baja',
      airPurificationScore: 75,
      minTemperature: 10,
      maxTemperature: 35,
      createdAt: DateTime.now().subtract(const Duration(days: 100)),
    ),
    PlantSpecies(
      id: 's4',
      scientificName: 'Ficus lyrata',
      commonName: 'Ficus Lira',
      category: 'Tropical',
      lightRequirement: 'Luz brillante',
      waterFrequencyDays: 7,
      humidityPreference: 'Alta',
      airPurificationScore: 78,
      minTemperature: 15,
      maxTemperature: 28,
      createdAt: DateTime.now().subtract(const Duration(days: 100)),
    ),
    PlantSpecies(
      id: 's5',
      scientificName: 'Cactaceae',
      commonName: 'Cactus Saguaro',
      category: 'Cactus',
      lightRequirement: 'Pleno sol',
      waterFrequencyDays: 30,
      humidityPreference: 'Baja',
      airPurificationScore: 30,
      minTemperature: 5,
      maxTemperature: 45,
      createdAt: DateTime.now().subtract(const Duration(days: 100)),
    ),
    PlantSpecies(
      id: 's6',
      scientificName: 'Spathiphyllum wallisii',
      commonName: 'Espatifilo',
      category: 'Tropical',
      lightRequirement: 'Luz indirecta',
      waterFrequencyDays: 5,
      humidityPreference: 'Alta',
      airPurificationScore: 90,
      minTemperature: 16,
      maxTemperature: 25,
      createdAt: DateTime.now().subtract(const Duration(days: 100)),
    ),
    PlantSpecies(
      id: 's7',
      scientificName: 'Aloe vera',
      commonName: 'Áloe Vera',
      category: 'Suculentas',
      lightRequirement: 'Pleno sol',
      waterFrequencyDays: 14,
      humidityPreference: 'Baja',
      airPurificationScore: 70,
      minTemperature: 10,
      maxTemperature: 40,
      createdAt: DateTime.now().subtract(const Duration(days: 100)),
    ),
    PlantSpecies(
      id: 's8',
      scientificName: 'Chlorophytum comosum',
      commonName: 'Cinta',
      category: 'Tropical',
      lightRequirement: 'Luz indirecta',
      waterFrequencyDays: 6,
      humidityPreference: 'Media',
      airPurificationScore: 82,
      minTemperature: 12,
      maxTemperature: 28,
      createdAt: DateTime.now().subtract(const Duration(days: 100)),
    ),
  ];

  bool _isLoading = false;
  bool _showCatalogTab = true;

  List<UserPlant> get userPlants => _userPlants;
  List<PlantSpecies> get speciesCatalog => _speciesCatalog;
  bool get isLoading => _isLoading;
  bool get showCatalogTab => _showCatalogTab;

  void setShowCatalogTab(bool value) {
    _showCatalogTab = value;
    notifyListeners();
  }

  void addPlantFromSpecies(PlantSpecies species, {String? nickname}) {
    addPlant(nickname ?? species.commonName, species.id, species.commonName);
  }

  void addPlant(String nickname, String speciesId, String name) {
    final newPlant = UserPlant(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      userId: 'mock-id-123',
      speciesId: speciesId,
      nickname: nickname,
      healthStatus: 'Bueno',
      name: name,
      acquiredAt: DateTime.now(),
      lastWateredAt: DateTime.now(),
      createdAt: DateTime.now(),
    );
    _userPlants.add(newPlant);
    notifyListeners();
  }

  void waterPlant(String id, {DateTime? date}) {
    final index = _userPlants.indexWhere((p) => p.id == id);
    if (index != -1) {
      _userPlants[index] = _userPlants[index].copyWith(
        lastWateredAt: date ?? DateTime.now(),
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
