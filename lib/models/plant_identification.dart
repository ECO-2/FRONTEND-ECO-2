class PlantIdentification {
  final String id;
  final String userId;
  final String imageUrl;
  final String? identifiedSpeciesId;
  final double? confidenceScore;
  final DateTime createdAt;

  PlantIdentification({
    required this.id,
    required this.userId,
    required this.imageUrl,
    this.identifiedSpeciesId,
    this.confidenceScore,
    required this.createdAt,
  });

  factory PlantIdentification.fromJson(Map<String, dynamic> json) {
    return PlantIdentification(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      imageUrl: json['image_url'] as String,
      identifiedSpeciesId: json['identified_species_id'] as String?,
      confidenceScore: json['confidence_score'] != null ? (json['confidence_score'] as num).toDouble() : null,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'image_url': imageUrl,
      'identified_species_id': identifiedSpeciesId,
      'confidence_score': confidenceScore,
      'created_at': createdAt.toIso8601String(),
    };
  }

  PlantIdentification copyWith({
    String? id,
    String? userId,
    String? imageUrl,
    String? identifiedSpeciesId,
    double? confidenceScore,
    DateTime? createdAt,
  }) {
    return PlantIdentification(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      imageUrl: imageUrl ?? this.imageUrl,
      identifiedSpeciesId: identifiedSpeciesId ?? this.identifiedSpeciesId,
      confidenceScore: confidenceScore ?? this.confidenceScore,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
