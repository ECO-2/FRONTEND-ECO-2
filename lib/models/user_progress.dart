class UserProgress {
  final String userId;
  final int xp;
  final int level;
  final int streakDays;
  final int seeds;
  final DateTime? updatedAt;

  UserProgress({
    required this.userId,
    required this.xp,
    required this.level,
    required this.streakDays,
    required this.seeds,
    this.updatedAt,
  });

  factory UserProgress.fromJson(Map<String, dynamic> json) {
    return UserProgress(
      userId: json['user_id'] as String,
      xp: json['xp'] as int,
      level: json['level'] as int,
      streakDays: json['streak_days'] as int,
      seeds: json['seeds'] as int,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at'] as String) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'xp': xp,
      'level': level,
      'streak_days': streakDays,
      'seeds': seeds,
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  UserProgress copyWith({
    String? userId,
    int? xp,
    int? level,
    int? streakDays,
    int? seeds,
    DateTime? updatedAt,
  }) {
    return UserProgress(
      userId: userId ?? this.userId,
      xp: xp ?? this.xp,
      level: level ?? this.level,
      streakDays: streakDays ?? this.streakDays,
      seeds: seeds ?? this.seeds,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
