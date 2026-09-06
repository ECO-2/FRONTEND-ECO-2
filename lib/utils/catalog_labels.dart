import 'package:flutter/widgets.dart';
import 'package:frontend_eco_2/l10n/app_localizations.dart';

/// Etiquetas traducibles del catálogo (categoría, luz, dificultad, humedad).
///
/// Los valores que llegan del backend son claves estables en inglés
/// (`tropical`, `indirect`, `low`...), pero la app los mostraba con literales
/// en español escritos en `plant_visuals.dart` y en el modelo `PlantSpecies`,
/// que son código sin acceso a `BuildContext`. Por eso al cambiar la app a
/// inglés seguían apareciendo "Tropical", "Luz Baja" o "Muy fácil".
///
/// Aquí la traducción se resuelve en la capa de UI, donde sí hay contexto,
/// dejando el dato crudo intacto en el modelo.

String categoryLabel(BuildContext context, String? category) {
  final l = AppLocalizations.of(context)!;
  switch (category) {
    case 'tropical': return l.catTropical;
    case 'succulent': return l.catSucculent;
    case 'cactus': return l.catCactus;
    case 'fern': return l.catFern;
    case 'flowering': return l.catFlowering;
    case 'herb': return l.catHerb;
    case 'tree': return l.catTree;
    default: return l.catOther;
  }
}

String lightLabel(BuildContext context, String? light) {
  final l = AppLocalizations.of(context)!;
  switch (light) {
    case 'low': return l.lightLow;
    case 'medium': return l.lightMedium;
    case 'high': return l.lightHigh;
    case 'indirect': return l.lightIndirect;
    default: return l.lightIndirect;
  }
}

/// "Luz Baja" en español, "Low light" en inglés — el orden de las palabras
/// cambia entre idiomas, así que se resuelve con un placeholder y no
/// concatenando cadenas.
String lightWithPrefix(BuildContext context, String? light) =>
    AppLocalizations.of(context)!.lightPrefix(lightLabel(context, light));

/// Dificultad derivada de la frecuencia de riego: cuanto menos exige, más
/// fácil de mantener.
String difficultyLabel(BuildContext context, int waterFrequencyDays) {
  final l = AppLocalizations.of(context)!;
  if (waterFrequencyDays >= 20) return l.difficultyVeryEasy;
  if (waterFrequencyDays >= 10) return l.difficultyEasy;
  return l.difficultyMedium;
}

String humidityLabel(BuildContext context, String? humidity) {
  final l = AppLocalizations.of(context)!;
  switch (humidity) {
    case 'low': return l.humidityLow;
    case 'high': return l.humidityHigh;
    default: return l.humidityMedium;
  }
}

String wateringFrequencyLabel(BuildContext context, int days) =>
    AppLocalizations.of(context)!.wateringEveryDays(days);

/// Chips de una especie, ya traducidos. Reemplaza a `PlantSpecies.tags`, que
/// devolvía las etiquetas en español desde el modelo.
List<String> speciesTags(
  BuildContext context, {
  required String? category,
  required String? lightRequirement,
  required int waterFrequencyDays,
}) =>
    [
      categoryLabel(context, category),
      lightWithPrefix(context, lightRequirement),
      wateringFrequencyLabel(context, waterFrequencyDays),
    ];
