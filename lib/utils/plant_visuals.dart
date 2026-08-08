import 'package:flutter/material.dart';

/// Visual theme (icon + colors) for a plant category. There are no real
/// per-species photos in the database, so instead of a single generic
/// placeholder for every species we give each botanical category its own
/// deliberate icon/color — an honest illustration, not a fake photo.
class PlantCategoryVisual {
  final IconData icon;
  final Color color;
  final Color background;
  final String label;

  const PlantCategoryVisual({
    required this.icon,
    required this.color,
    required this.background,
    required this.label,
  });
}

const Map<String, PlantCategoryVisual> _kCategoryVisuals = {
  'tropical': PlantCategoryVisual(
    icon: Icons.park_rounded,
    color: Color(0xFF2E7D32),
    background: Color(0xFFEAF5EA),
    label: 'Tropical',
  ),
  'succulent': PlantCategoryVisual(
    icon: Icons.spa_rounded,
    color: Color(0xFF8D8741),
    background: Color(0xFFF5F2E0),
    label: 'Suculenta',
  ),
  'cactus': PlantCategoryVisual(
    icon: Icons.grass_rounded,
    color: Color(0xFFC08A3E),
    background: Color(0xFFF7EFDE),
    label: 'Cactus',
  ),
  'fern': PlantCategoryVisual(
    icon: Icons.eco_rounded,
    color: Color(0xFF1B5E20),
    background: Color(0xFFE6F0E6),
    label: 'Helecho',
  ),
  'flowering': PlantCategoryVisual(
    icon: Icons.local_florist_rounded,
    color: Color(0xFFC2185B),
    background: Color(0xFFFBEAF1),
    label: 'Con flores',
  ),
  'herb': PlantCategoryVisual(
    icon: Icons.yard_rounded,
    color: Color(0xFF558B2F),
    background: Color(0xFFEEF3E2),
    label: 'Aromática',
  ),
  'tree': PlantCategoryVisual(
    icon: Icons.forest_rounded,
    color: Color(0xFF33691E),
    background: Color(0xFFE8F0DE),
    label: 'Árbol',
  ),
  'other': PlantCategoryVisual(
    icon: Icons.local_florist_outlined,
    color: Color(0xFF10454F),
    background: Color(0xFFF0F4F2),
    label: 'Planta',
  ),
};

const PlantCategoryVisual _kDefaultVisual = PlantCategoryVisual(
  icon: Icons.local_florist_outlined,
  color: Color(0xFF10454F),
  background: Color(0xFFF0F4F2),
  label: 'Planta',
);

PlantCategoryVisual visualForCategory(String? category) {
  if (category == null) return _kDefaultVisual;
  return _kCategoryVisuals[category.toLowerCase()] ?? _kDefaultVisual;
}

/// Spanish label for the raw category enum value returned by the API.
String categoryLabelEs(String? category) => visualForCategory(category).label;

/// Spanish label for the light_requirement enum value.
String lightLabelEs(String? light) {
  switch (light?.toLowerCase()) {
    case 'low':
      return 'Baja';
    case 'medium':
      return 'Media';
    case 'high':
      return 'Alta';
    case 'indirect':
      return 'Indirecta';
    default:
      return 'Indirecta';
  }
}

/// Short hint about where to place the plant, derived from the real
/// light_requirement enum value.
String lightHintEs(String? light) {
  switch (light?.toLowerCase()) {
    case 'low':
      return 'Rincones con poca luz';
    case 'high':
      return 'Cerca de la ventana';
    case 'indirect':
      return 'Sin sol directo';
    default:
      return 'Luz filtrada';
  }
}

/// Spanish label for the humidity_preference enum value.
String humidityLabelEs(String? humidity) {
  switch (humidity?.toLowerCase()) {
    case 'low':
      return 'Baja';
    case 'medium':
      return 'Media';
    case 'high':
      return 'Alta';
    default:
      return 'Media';
  }
}

/// Approximate relative-humidity range implied by the humidity_preference
/// enum. This is a display convenience derived from the real categorical
/// field, not a separately measured value.
String humidityRangeEs(String? humidity) {
  switch (humidity?.toLowerCase()) {
    case 'low':
      return '20-40%';
    case 'high':
      return '60-80%';
    default:
      return '40-60%';
  }
}

/// Kind of tag chip, used to color-code the pill by what it represents.
enum TagKind { category, light, water, humidity, temperature, generic }

class TagStyle {
  final IconData icon;
  final Color color;
  final Color background;

  const TagStyle({required this.icon, required this.color, required this.background});
}

const Map<TagKind, TagStyle> _kTagStyles = {
  TagKind.category: TagStyle(
    icon: Icons.spa_rounded,
    color: Color(0xFF2E7D32),
    background: Color(0xFFEAF5EA),
  ),
  TagKind.light: TagStyle(
    icon: Icons.wb_sunny_rounded,
    color: Color(0xFFB8860B),
    background: Color(0xFFFBF3DE),
  ),
  TagKind.water: TagStyle(
    icon: Icons.water_drop_rounded,
    color: Color(0xFF1565C0),
    background: Color(0xFFE3F0FB),
  ),
  TagKind.humidity: TagStyle(
    icon: Icons.opacity_rounded,
    color: Color(0xFF00796B),
    background: Color(0xFFE0F2F0),
  ),
  TagKind.temperature: TagStyle(
    icon: Icons.thermostat_rounded,
    color: Color(0xFFD84315),
    background: Color(0xFFFCE9E3),
  ),
  TagKind.generic: TagStyle(
    icon: Icons.eco_rounded,
    color: Color(0xFF10454F),
    background: Color(0xFFEFF2F1),
  ),
};

TagStyle styleForTagKind(TagKind kind) => _kTagStyles[kind] ?? _kTagStyles[TagKind.generic]!;

/// Infers a [TagKind] from a tag's text so free-form tag strings (built
/// elsewhere from real species fields) still get consistent coloring.
TagKind tagKindFor(String tag) {
  final t = tag.toLowerCase();
  if (t.contains('riego') || t.contains('agua')) return TagKind.water;
  if (t.contains('luz') || t.contains('sol')) return TagKind.light;
  if (t.contains('humedad')) return TagKind.humidity;
  if (t.contains('°c') || t.contains('temperatura')) return TagKind.temperature;
  if (t.contains('tropical') ||
      t.contains('suculenta') ||
      t.contains('cactus') ||
      t.contains('helecho') ||
      t.contains('flores') ||
      t.contains('aromática') ||
      t.contains('árbol')) {
    return TagKind.category;
  }
  return TagKind.generic;
}
