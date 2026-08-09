import 'package:flutter/material.dart';
import 'package:frontend_eco_2/models/models.dart';
import 'package:frontend_eco_2/services/services.dart';

class PlantsProvider with ChangeNotifier {
  final PlantsService _plantsService;

  List<UserPlant> _userPlants = [];
  List<PlantSpecies> _speciesCatalog = [];
  bool _isLoading = false;
  bool _showCatalogTab = true;
  String? _errorMessage;

  PlantsProvider({required PlantsService plantsService})
      : _plantsService = plantsService;

  List<UserPlant> get userPlants => _userPlants;
  List<PlantSpecies> get speciesCatalog => _speciesCatalog;
  bool get isLoading => _isLoading;
  bool get showCatalogTab => _showCatalogTab;
  String? get errorMessage => _errorMessage;

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void setShowCatalogTab(bool value) {
    _showCatalogTab = value;
    notifyListeners();
  }

  // ---------------------------------------------------------------------------
  // Carga inicial
  // ---------------------------------------------------------------------------

  /// Carga en paralelo el catálogo de especies y la colección del usuario.
  Future<void> init() async {
    _setLoading(true);
    _errorMessage = null;
    try {
      final results = await Future.wait([
        _plantsService.getSpecies(),
        _plantsService.getUserPlants(),
      ]);
      _speciesCatalog = results[0] as List<PlantSpecies>;
      _userPlants = results[1] as List<UserPlant>;
    } on ApiException catch (e) {
      _errorMessage = e.message;
    } catch (_) {
      _errorMessage = 'Error al cargar tus plantas.';
    } finally {
      _setLoading(false);
    }
  }

  Future<void> loadSpecies() async {
    try {
      _speciesCatalog = await _plantsService.getSpecies();
      notifyListeners();
    } catch (_) {}
  }

  Future<void> loadUserPlants() async {
    try {
      _userPlants = await _plantsService.getUserPlants();
      notifyListeners();
    } catch (_) {}
  }

  // ---------------------------------------------------------------------------
  // Agregar planta
  // ---------------------------------------------------------------------------

  Future<bool> addPlantFromSpecies(PlantSpecies species, {String? nickname}) {
    return addPlant(nickname ?? species.commonName, species.id, species.commonName);
  }

  /// Devuelve true si la planta se agregó correctamente, false si falló
  /// (con [errorMessage] explicando por qué), para que la UI que llama
  /// pueda mostrar feedback real en vez de asumir éxito.
  Future<bool> addPlant(String nickname, String speciesId, String name) async {
    try {
      final newPlant = await _plantsService.addPlant(
        speciesId: speciesId,
        nickname: nickname,
        healthStatus: 'good',
      );
      _userPlants.add(newPlant);
      notifyListeners();
      return true;
    } on ApiException catch (e) {
      _errorMessage = e.message;
      notifyListeners();
      return false;
    } catch (_) {
      _errorMessage = 'Error al agregar la planta.';
      notifyListeners();
      return false;
    }
  }

  // ---------------------------------------------------------------------------
  // Regar planta
  // ---------------------------------------------------------------------------

  Future<void> waterPlant(String id, {DateTime? date}) async {
    final wateredAt = date ?? DateTime.now();
    // Actualización optimista local
    final index = _userPlants.indexWhere((p) => p.id == id);
    if (index != -1) {
      _userPlants[index] = _userPlants[index].copyWith(
        lastWateredAt: wateredAt,
        updatedAt: DateTime.now(),
      );
      notifyListeners();
    }
    // Persistir en API
    try {
      await _plantsService.updatePlant(id, lastWateredAt: wateredAt);
    } catch (_) {
      // Si falla, recargar desde la API para tener el estado correcto.
      await loadUserPlants();
    }
  }

  // ---------------------------------------------------------------------------
  // Eliminar planta
  // ---------------------------------------------------------------------------

  Future<void> deletePlant(String id) async {
    try {
      await _plantsService.deletePlant(id);
      _userPlants.removeWhere((p) => p.id == id);
      notifyListeners();
    } on ApiException catch (e) {
      _errorMessage = e.message;
      notifyListeners();
    }
  }

  void setLoading(bool value) => _setLoading(value);
}
