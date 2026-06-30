import 'package:flutter/material.dart';

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
  final String personalNote;

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
    required this.personalNote,
  });
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
    personalNote: 'Le encanta el salón. La riego los domingos. Última vez noté hoja nueva emergiendo...',
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
    personalNote: 'Crece muy rápido en la repisa. Es súper resistente y perdona algún olvido de riego.',
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
    personalNote: 'Ideal para el dormitorio. Prácticamente no necesita atención, dejar secar del todo el sustrato.',
  ),
};

const defaultSpecies = SpeciesData(
  scientific: 'Especie desconocida',
  bg: Color(0xFFF8FAF9),
  tags: ['Plantas'],
  waterFreq: 'c/7d',
  waterFreqDays: 7,
  light: 'Indirecta',
  temp: '18-25°C',
  co2: '2.0 g/día',
  personalNote: 'Colocada en semisombra, mantener el sustrato ligeramente húmedo sin encharcar.',
);
