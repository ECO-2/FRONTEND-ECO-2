class Achievement {
  final String id;
  final String name;
  final String conditionType;
  final int conditionValue;
  final int xpReward;
  final String? description;

  Achievement({
    required this.id,
    required this.name,
    required this.conditionType,
    required this.conditionValue,
    required this.xpReward,
    this.description,
  });

  factory Achievement.fromJson(Map<String, dynamic> json) {
    return Achievement(
      id: json['id'] as String,
      name: json['name'] as String,
      conditionType: json['condition_type'] as String,
      conditionValue: json['condition_value'] as int,
      xpReward: json['xp_reward'] as int,
      description: json['description'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'condition_type': conditionType,
      'condition_value': conditionValue,
      'xp_reward': xpReward,
      'description': description,
    };
  }

  Achievement copyWith({
    String? id,
    String? name,
    String? conditionType,
    int? conditionValue,
    int? xpReward,
    String? description,
  }) {
    return Achievement(
      id: id ?? this.id,
      name: name ?? this.name,
      conditionType: conditionType ?? this.conditionType,
      conditionValue: conditionValue ?? this.conditionValue,
      xpReward: xpReward ?? this.xpReward,
      description: description ?? this.description,
    );
  }
}
