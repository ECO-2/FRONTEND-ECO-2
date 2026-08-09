import 'package:flutter/material.dart';
import 'package:frontend_eco_2/models/models.dart';
import 'package:frontend_eco_2/utils/plant_visuals.dart';

class SpeciesData {
  final String scientific;
  final Color bg;
  final List<String> tags;
  final String? assetImage;
  final String waterFreq;
  final int waterFreqDays;
  final String light;
  final String temp;
  final String co2;
  final String humidity;
  final String personalNote;
  final IconData placeholderIcon;
  final Color placeholderIconColor;
  // Guía de cuidado en lenguaje llano: dónde ubicarla y cómo regarla,
  // pensada para orientar a alguien que recién la agrega a su jardín.
  final String placementHint;
  final String careGuide;

  const SpeciesData({
    required this.scientific,
    required this.bg,
    required this.tags,
    this.assetImage,
    required this.waterFreq,
    required this.waterFreqDays,
    required this.light,
    required this.temp,
    required this.co2,
    this.humidity = '40-60%',
    required this.personalNote,
    this.placeholderIcon = Icons.local_florist_rounded,
    this.placeholderIconColor = const Color(0xFFB0B0B0),
    this.placementHint = 'Luz filtrada, lejos de corrientes de aire.',
    required this.careGuide,
  });

  // Real catalog species (real UUID from the backend) don't have a legacy
  // illustration or a curated care write-up, so this builds a care summary
  // from the real fields the API does return (category, light, water
  // frequency, humidity, air_purification_score) instead of showing the
  // same generic placeholder text for all 50+ species.
  factory SpeciesData.fromReal(PlantSpecies species) {
    final visual = visualForCategory(species.category);
    final score = species.airPurificationScore ?? 0;
    final co2Grams = 1.0 + score * 0.4;
    return SpeciesData(
      scientific: species.scientificName,
      bg: visual.background,
      tags: species.tags,
      waterFreq: 'c/${species.waterFrequencyDays}d',
      waterFreqDays: species.waterFrequencyDays,
      light: lightLabelEs(species.lightRequirement),
      temp: '${species.minTemperature ?? 15}-${species.maxTemperature ?? 30}°C',
      co2: '${co2Grams.toStringAsFixed(1)} g/día',
      humidity: species.humidityRange,
      personalNote: 'Aún no has agregado notas para esta planta.',
      placeholderIcon: visual.icon,
      placeholderIconColor: visual.color,
      placementHint: lightHintEs(species.lightRequirement),
      careGuide: species.description,
    );
  }
}

const speciesDataMap = {
  's1': SpeciesData(
    scientific: 'Monstera deliciosa',
    bg: Color(0xFFF2F7F2),
    tags: ['Araceas', 'Interior'],
    assetImage: 'assets/images/monstera.png',
    waterFreq: 'c/7d',
    waterFreqDays: 7,
    light: 'Indirecta',
    temp: '18-27°C',
    co2: '3.2 g/día',
    humidity: '50-70%',
    personalNote: 'Le encanta el salón. La riego los domingos. Última vez noté hoja nueva emergiendo...',
    placementHint: 'Cerca de una ventana, sin sol directo sobre las hojas.',
    careGuide: 'Prefiere luz indirecta abundante y sustrato que drene bien. '
        'Riega cada 7 días dejando secar los primeros centímetros de tierra entre riegos, '
        'y agradece un ambiente húmedo (rocíala o acércala a otras plantas).',
  ),
  's2': SpeciesData(
    scientific: 'Epipremnum aureum',
    bg: Color(0xFFEAF5EA),
    tags: ['Araceas', 'Interior', 'Colgante'],
    waterFreq: 'c/7d',
    waterFreqDays: 7,
    light: 'Indirecta',
    temp: '15-30°C',
    co2: '2.5 g/día',
    humidity: '40-60%',
    personalNote: 'Crece muy rápido en la repisa. Es súper resistente y perdona algún olvido de riego.',
    placementHint: 'Luz indirecta o media; tolera rincones con menos luz.',
    careGuide: 'Muy tolerante y fácil de cuidar: riega cada 7 días dejando secar el sustrato entre '
        'riegos, y sitúala donde reciba luz indirecta. Poda las ramas largas para que crezca más tupida.',
  ),
  's3': SpeciesData(
    scientific: 'Sansevieria trifasciata',
    bg: Color(0xFFF0F4EC),
    tags: ['Liliáceas', 'Interior', 'Resistente'],
    waterFreq: 'c/20d',
    waterFreqDays: 20,
    light: 'Adaptable',
    temp: '10-35°C',
    co2: '1.8 g/día',
    humidity: '20-40%',
    personalNote: 'Ideal para el dormitorio. Prácticamente no necesita atención, dejar secar del todo el sustrato.',
    placementHint: 'Se adapta a casi cualquier luz, incluso rincones oscuros.',
    careGuide: 'Una de las plantas más resistentes que existen. Riega solo cada 20 días, dejando secar '
        'el sustrato por completo — el exceso de agua es su principal riesgo, no la falta de ella.',
  ),
};

