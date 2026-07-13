class UserPlant {
  final String id;
  final String userId;
  final String speciesId;
  final String nickname;
  final String name;
  final String? healthStatus;
  final DateTime? acquiredAt;
  final DateTime? lastWateredAt;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final DateTime? deletedAt;

  UserPlant({
    required this.name,
    required this.id,
    required this.userId,
    required this.speciesId,
    required this.nickname,
    this.healthStatus,
    this.acquiredAt,
    this.lastWateredAt,
    required this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  factory UserPlant.fromJson(Map<String, dynamic> json) {
    return UserPlant(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      speciesId: json['species_id'] as String,
      nickname: json['nickname'] as String,
      healthStatus: json['health_status'] as String?,
      acquiredAt: json['acquired_at'] != null
          ? DateTime.parse(json['acquired_at'] as String)
          : null,
      lastWateredAt: json['last_watered_at'] != null
          ? DateTime.parse(json['last_watered_at'] as String)
          : null,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : null,
      deletedAt: json['deleted_at'] != null
          ? DateTime.parse(json['deleted_at'] as String)
          : null,
      name: (json['name'] ?? json['nickname'] ?? '') as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'species_id': speciesId,
      'nickname': nickname,
      'health_status': healthStatus,
      'acquired_at': acquiredAt?.toIso8601String(),
      'last_watered_at': lastWateredAt?.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'deleted_at': deletedAt?.toIso8601String(),
    };
  }

  UserPlant copyWith({
    String? id,
    String? userId,
    String? speciesId,
    String? nickname,
    String? healthStatus,
    DateTime? acquiredAt,
    DateTime? lastWateredAt,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? deletedAt,
  }) {
    return UserPlant(
      name: name ?? name,
      id: id ?? this.id,
      userId: userId ?? this.userId,
      speciesId: speciesId ?? this.speciesId,
      nickname: nickname ?? this.nickname,
      healthStatus: healthStatus ?? this.healthStatus,
      acquiredAt: acquiredAt ?? this.acquiredAt,
      lastWateredAt: lastWateredAt ?? this.lastWateredAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
    );
  }
}
