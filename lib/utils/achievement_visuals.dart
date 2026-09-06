import 'package:flutter/material.dart';
import 'package:frontend_eco_2/models/achievement.dart';
import 'package:frontend_eco_2/providers/missions_provider.dart';

/// Identidad visual de un logro: su vector y su color.
class AchievementVisual {
  final IconData icon;
  final Color color;

  const AchievementVisual(this.icon, this.color);
}

// Paleta por familia de logro. Cada familia mantiene su tono para que se
// reconozca de un vistazo a qué progresión pertenece un trofeo.
const _cuidado = Color(0xFF3B82C4); // agua
const _coleccion = Color(0xFF4E9A51); // plantas
const _espacio = Color(0xFF8A6BC1); // habitaciones
const _descubrir = Color(0xFFE08A2E); // escáner / IA
const _inicio = Color(0xFF10454F); // primeros pasos

/// Vector propio de cada logro, en vez de uno compartido por tipo de
/// condición. Antes los cuatro logros de cuidados ("Manos a la Obra",
/// "Cuidador Constante", "Guardián Verde", "Maestro del Cuidado" y "Leyenda
/// Botánica") mostraban exactamente la misma gota, así que la pantalla de
/// trofeos parecía una lista repetida y no transmitía progresión.
///
/// Se mapea por nombre porque es lo que el usuario ve y lo que distingue un
/// hito de otro; si aparece un logro nuevo que aún no está aquí, se cae a un
/// icono por tipo de condición en vez de romperse.
const Map<String, AchievementVisual> _byName = {
  // Progresión de cuidados: de la mano que riega a la corona.
  'Manos a la Obra': AchievementVisual(Icons.pan_tool_rounded, _cuidado),
  'Cuidador Constante': AchievementVisual(Icons.opacity_rounded, _cuidado),
  'Guardián Verde': AchievementVisual(Icons.shield_moon_rounded, _cuidado),
  'Maestro del Cuidado': AchievementVisual(Icons.workspace_premium_rounded, _cuidado),
  'Leyenda Botánica': AchievementVisual(Icons.military_tech_rounded, _cuidado),

  // Progresión de colección: del brote al bosque.
  'Mi Pequeño Jardín': AchievementVisual(Icons.local_florist_rounded, _coleccion),
  'Coleccionista': AchievementVisual(Icons.forest_rounded, _coleccion),

  // Otras familias.
  'Mi Primer Espacio': AchievementVisual(Icons.meeting_room_rounded, _espacio),
  'Ojo Botánico': AchievementVisual(Icons.center_focus_strong_rounded, _descubrir),
  'Primeros Pasos': AchievementVisual(Icons.flag_rounded, _inicio),
};

const Map<String, AchievementVisual> _byCondition = {
  AchievementConditions.userPlants: AchievementVisual(Icons.park_rounded, _coleccion),
  AchievementConditions.careLogs: AchievementVisual(Icons.water_drop_rounded, _cuidado),
  AchievementConditions.onboardingCompleted: AchievementVisual(Icons.flag_rounded, _inicio),
  AchievementConditions.plantScans: AchievementVisual(Icons.search_rounded, _descubrir),
  AchievementConditions.roomsCreated: AchievementVisual(Icons.home_rounded, _espacio),
};

AchievementVisual visualForAchievement(Achievement achievement) {
  return _byName[achievement.name] ??
      _byCondition[achievement.conditionType] ??
      const AchievementVisual(Icons.emoji_events_rounded, Color(0xFFFABF2E));
}
