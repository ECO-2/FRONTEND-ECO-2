import 'package:flutter/material.dart';

/// Etiqueta, ícono y color en español para un `task_type` real del backend
/// (enum TaskType de Prisma: watering/fertilizing/pruning/repotting/...).
/// Centralizado acá porque tanto CareSheetContent (registrar) como
/// CareHistoryList (mostrar historial real) necesitan el mismo mapeo.
class CareTaskVisual {
  final String label;
  final IconData icon;
  final Color color;
  final Color background;

  const CareTaskVisual({
    required this.label,
    required this.icon,
    required this.color,
    required this.background,
  });
}

const Map<String, CareTaskVisual> _kCareTaskVisuals = {
  'watering': CareTaskVisual(
    label: 'Riego',
    icon: Icons.water_drop_rounded,
    color: Color(0xFF4A90D9),
    background: Color(0xFFEAF3FC),
  ),
  'fertilizing': CareTaskVisual(
    label: 'Fertilización',
    icon: Icons.grain_rounded,
    color: Color(0xFF8A9A65),
    background: Color(0xFFEFF5E4),
  ),
  'pruning': CareTaskVisual(
    label: 'Poda',
    icon: Icons.content_cut_rounded,
    color: Color(0xFFF56B1C),
    background: Color(0xFFFFF0EC),
  ),
  'repotting': CareTaskVisual(
    label: 'Trasplante',
    icon: Icons.upload_rounded,
    color: Color(0xFF808E89),
    background: Color(0xFFF0F2F1),
  ),
};

const CareTaskVisual _kDefaultCareTaskVisual = CareTaskVisual(
  label: 'Cuidado',
  icon: Icons.eco_rounded,
  color: Color(0xFF10454F),
  background: Color(0xFFEFF2F1),
);

CareTaskVisual careTaskVisual(String taskType) =>
    _kCareTaskVisuals[taskType] ?? _kDefaultCareTaskVisual;
