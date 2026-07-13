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
    if (waterFrequencyDays >= 7) return 'Fácil';
    return 'Media';
  }

  List<String> get tags {
    final list = <String>[];
    if (category != null) list.add(category!);
    if (lightRequirement != null) list.add(lightRequirement!);
    list.add('Riego c/${waterFrequencyDays}d');
    return list;
  }
}
