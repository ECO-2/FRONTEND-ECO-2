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

  List<String> get tags {
    final list = <String>[];
    if (category != null) list.add(category!);
    if (lightRequirement != null) list.add(lightRequirement!);
    list.add('Riego c/${waterFrequencyDays}d');
    return list;
  }

  String get description {
    switch (id) {
      case 's1':
        return 'Planta de interior popular por sus hojas grandes con perforaciones únicas. Fácil de cuidar, crece rápido y purifica el aire de tu hogar.';
      case 's2':
        return 'Una de las plantas colgantes más populares y resistentes. Sus hojas en forma de corazón y su capacidad de purificar el aire la hacen perfecta para cualquier espacio.';
      case 's3':
        return 'Una planta extremadamente resistente que purifica el aire, ideal para dormitorios ya que libera oxígeno por la noche. Tolera la falta de riego y luz.';
      case 's4':
        return 'Conocido por sus hojas grandes en forma de violín, es una planta de acento espectacular para interiores luminosos.';
      case 's5':
        return 'Perfecto para exteriores soleados, requiere muy poco riego y aporta una textura desértica única.';
      case 's6':
        return 'También conocida como Cuna de Moisés, destaca por sus flores blancas elegantes y su gran capacidad de filtrar toxinas del aire.';
      case 's7':
        return 'Famosa por sus propiedades medicinales y cosméticas. Es una suculenta resistente que prefiere pleno sol y riegos espaciados.';
      case 's8':
        return 'Planta colgante muy fácil de propagar. Sus hojas arqueadas verdes y blancas purifican el aire eficientemente.';
      default:
        return 'Planta de interior y exterior ideal para decorar tu hogar. Aporta frescura y mejora la calidad del aire.';
    }
  }

  double get rating {
    switch (id) {
      case 's1': return 4.8;
      case 's2': return 4.7;
      case 's3': return 4.9;
      case 's4': return 4.6;
      case 's5': return 4.5;
      case 's6': return 4.8;
      case 's7': return 4.9;
      case 's8': return 4.7;
      default: return 4.6;
    }
  }

  String get popularity {
    switch (id) {
      case 's1': return '1.2K en jardines';
      case 's2': return '850 en jardines';
      case 's3': return '2.3K en jardines';
      case 's4': return '510 en jardines';
      case 's5': return '320 en jardines';
      case 's6': return '740 en jardines';
      case 's7': return '1.9K en jardines';
      case 's8': return '680 en jardines';
      default: return '450 en jardines';
    }
  }

  bool get isToxic {
    switch (id) {
      case 's8': return false; // Spider plant is non-toxic
      default: return true;
    }
  }

  String get humidityRange {
    switch (id) {
      case 's1': return '60-80%';
      case 's2': return '50-70%';
      case 's3': return '30-50%';
      case 's4': return '60-80%';
      case 's5': return '20-40%';
      case 's6': return '60-80%';
      case 's7': return '30-50%';
      case 's8': return '50-70%';
      default: return '40-60%';
    }
  }

  String get humidityLevel {
    switch (id) {
      case 's1': case 's4': case 's6': return 'Alta';
      case 's2': case 's8': return 'Media';
      default: return 'Baja';
    }
  }

  List<String> get detailTags {
    switch (id) {
      case 's1': return ['Araceae', 'Tropical', 'Interior', 'Aire purificador'];
      case 's2': return ['Araceae', 'Tropical', 'Interior', 'Colgante'];
      case 's3': return ['Liliaceae', 'Interior', 'Resistente', 'Purificador'];
      case 's4': return ['Moraceae', 'Tropical', 'Interior', 'Llamativa'];
      case 's5': return ['Cactaceae', 'Exterior', 'Sol directo', 'Desértica'];
      case 's6': return ['Araceae', 'Interior', 'Floración', 'Filtro de toxinas'];
      case 's7': return ['Asphodelaceae', 'Exterior', 'Medicinal', 'Suculenta'];
      case 's8': return ['Anthericaceae', 'Interior', 'Colgante', 'Fácil propagación'];
      default: return ['Planta', 'Hogar'];
    }
  }

  int get difficultySegments {
    switch (id) {
      case 's3': case 's7': return 1; // Muy fácil (Sansevieria, Aloe)
      case 's1': case 's2': case 's8': return 2; // Fácil (Monstera, Potus, Cinta)
      case 's4': case 's6': return 3; // Media (Ficus, Espatifilo)
      default: return 2;
    }
  }
}
