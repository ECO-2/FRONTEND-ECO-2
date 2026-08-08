import 'package:frontend_eco_2/utils/plant_visuals.dart';

class PlantSpecies {
  final String id;
  final String scientificName;
  final String commonName;
  final String? category;
  final String? lightRequirement;
  final int waterFrequencyDays;
  final String? humidityPreference;
  final int? airPurificationScore;
  final int? minTemperature;
  final int? maxTemperature;
  final DateTime createdAt;

  PlantSpecies({
    required this.id,
    required this.scientificName,
    required this.commonName,
    this.category,
    this.lightRequirement,
    required this.waterFrequencyDays,
    this.humidityPreference,
    this.airPurificationScore,
    this.minTemperature,
    this.maxTemperature,
    required this.createdAt,
  });

  factory PlantSpecies.fromJson(Map<String, dynamic> json) {
    return PlantSpecies(
      id: json['id'] as String,
      scientificName: json['scientific_name'] as String,
      commonName: json['common_name'] as String,
      category: json['category'] as String?,
      lightRequirement: json['light_requirement'] as String?,
      waterFrequencyDays: json['water_frequency_days'] as int,
      humidityPreference: json['humidity_preference'] as String?,
      airPurificationScore: json['air_purification_score'] as int?,
      minTemperature: json['min_temperature'] as int?,
      maxTemperature: json['max_temperature'] as int?,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'scientific_name': scientificName,
      'common_name': commonName,
      'category': category,
      'light_requirement': lightRequirement,
      'water_frequency_days': waterFrequencyDays,
      'humidity_preference': humidityPreference,
      'air_purification_score': airPurificationScore,
      'min_temperature': minTemperature,
      'max_temperature': maxTemperature,
      'created_at': createdAt.toIso8601String(),
    };
  }

  PlantSpecies copyWith({
    String? id,
    String? scientificName,
    String? commonName,
    String? category,
    String? lightRequirement,
    int? waterFrequencyDays,
    String? humidityPreference,
    int? airPurificationScore,
    int? minTemperature,
    int? maxTemperature,
    DateTime? createdAt,
  }) {
    return PlantSpecies(
      id: id ?? this.id,
      scientificName: scientificName ?? this.scientificName,
      commonName: commonName ?? this.commonName,
      category: category ?? this.category,
      lightRequirement: lightRequirement ?? this.lightRequirement,
      waterFrequencyDays: waterFrequencyDays ?? this.waterFrequencyDays,
      humidityPreference: humidityPreference ?? this.humidityPreference,
      airPurificationScore: airPurificationScore ?? this.airPurificationScore,
      minTemperature: minTemperature ?? this.minTemperature,
      maxTemperature: maxTemperature ?? this.maxTemperature,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  String get difficulty {
    if (waterFrequencyDays >= 20) return 'Muy fácil';
    if (waterFrequencyDays >= 10) return 'Fácil';
    return 'Media';
  }

  // ── Derivados de los campos reales del catálogo (categoría, luz, riego,
  // humedad, puntaje de purificación) — no hay foto ni descripción curada
  // por especie en la base de datos, así que en vez de inventarlas se
  // construyen a partir de los datos reales que sí existen.

  List<String> get tags {
    final list = <String>[categoryLabelEs(category)];
    list.add('Luz ${lightLabelEs(lightRequirement)}');
    list.add('Riego c/${waterFrequencyDays}d');
    return list;
  }

  String get description {
    final cat = categoryLabelEs(category).toLowerCase();
    final light = lightLabelEs(lightRequirement).toLowerCase();
    final humidity = humidityLabelEs(humidityPreference).toLowerCase();
    final score = airPurificationScore ?? 0;
    final purifierNote = score >= 7
        ? ' Es una excelente purificadora de aire.'
        : score >= 4
            ? ' Ayuda a mejorar la calidad del aire de tu hogar.'
            : '';
    return 'Especie $cat que prefiere luz $light y humedad $humidity. '
        'Riega aproximadamente cada $waterFrequencyDays días, dejando secar el sustrato entre riegos, '
        'y se adapta bien a temperaturas entre ${minTemperature ?? 15}°C y ${maxTemperature ?? 30}°C.$purifierNote';
  }

  String get humidityRange => humidityRangeEs(humidityPreference);

  String get humidityLevel => humidityLabelEs(humidityPreference);

  List<String> get detailTags => [
        categoryLabelEs(category),
        'Luz ${lightLabelEs(lightRequirement)}',
        'Humedad ${humidityLabelEs(humidityPreference)}',
        if ((airPurificationScore ?? 0) >= 7) 'Aire purificador',
      ];

  int get difficultySegments {
    if (waterFrequencyDays >= 20) return 1; // Muy fácil
    if (waterFrequencyDays >= 10) return 2; // Fácil
    return 3; // Media
  }
}
