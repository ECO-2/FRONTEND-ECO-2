/// Estado del plan del usuario y cuánto lleva consumido.
///
/// Los topes llegan como `null` cuando son ilimitados (O2+ activo), no como un
/// número grande: así la app no tiene que conocer las cifras del plan gratuito
/// ni quedarse desfasada si cambian en el backend.
class PlanStatus {
  final String planType;
  final DateTime? expiresAt;
  final bool isPlusActive;

  final int plantsUsed;
  final int? plantsLimit;

  final int scansUsedToday;
  final int? scansLimit;

  const PlanStatus({
    required this.planType,
    this.expiresAt,
    required this.isPlusActive,
    required this.plantsUsed,
    this.plantsLimit,
    required this.scansUsedToday,
    this.scansLimit,
  });

  /// Estado por defecto mientras no ha cargado: se asume plan gratuito sin
  /// consumo, que es lo conservador — nunca muestra la insignia O2+ de más.
  factory PlanStatus.unknown() => const PlanStatus(
        planType: 'free',
        isPlusActive: false,
        plantsUsed: 0,
        scansUsedToday: 0,
      );

  factory PlanStatus.fromJson(Map<String, dynamic> json) {
    return PlanStatus(
      planType: json['plan_type'] as String? ?? 'free',
      expiresAt: json['plan_expires_at'] != null
          ? DateTime.tryParse(json['plan_expires_at'] as String)
          : null,
      isPlusActive: json['is_plus_active'] as bool? ?? false,
      plantsUsed: json['plants_used'] as int? ?? 0,
      plantsLimit: json['plants_limit'] as int?,
      scansUsedToday: json['scans_used_today'] as int? ?? 0,
      scansLimit: json['scans_limit'] as int?,
    );
  }

  /// Escaneos que le quedan hoy, o null si son ilimitados.
  int? get scansLeftToday {
    final limit = scansLimit;
    if (limit == null) return null;
    final left = limit - scansUsedToday;
    return left < 0 ? 0 : left;
  }

  /// Macetas libres, o null si son ilimitadas.
  int? get plantSlotsLeft {
    final limit = plantsLimit;
    if (limit == null) return null;
    final left = limit - plantsUsed;
    return left < 0 ? 0 : left;
  }

  bool get hasReachedPlantLimit => plantSlotsLeft == 0;
  bool get hasReachedScanLimit => scansLeftToday == 0;
}
