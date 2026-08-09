import 'package:flutter/material.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:frontend_eco_2/theme/app_colors.dart';

/// Claves compartidas entre [CustomBottomNavBar] y [DashboardHeader] para
/// que [DashboardScreen] pueda armar el recorrido guiado señalando los
/// widgets reales de la app (no una maqueta aparte).
class AppTourKeys {
  static final navJardin = GlobalKey();
  static final navEscaner = GlobalKey();
  static final navTienda = GlobalKey();
  static final navPerfil = GlobalKey();
  static final seedsPill = GlobalKey();
  static final trophyIcon = GlobalKey();
  static final notifBell = GlobalKey();

  /// Orden en el que se muestran los pasos del recorrido.
  static List<GlobalKey> get orderedSteps => [
        navJardin,
        navEscaner,
        navTienda,
        seedsPill,
        trophyIcon,
        notifBell,
        navPerfil,
      ];
}

/// Envuelve [child] en un [Showcase] con el estilo visual consistente del
/// resto de la app, solo si se provee una key (para que los widgets que
/// usan esto —CustomBottomNavBar, DashboardHeader— sigan funcionando sin
/// recorrido en las pantallas donde no aplica).
Widget wrapWithTourStep({
  required GlobalKey? key,
  required String title,
  required String description,
  required Widget child,
}) {
  if (key == null) return child;
  return Showcase(
    key: key,
    title: title,
    description: description,
    titleTextStyle: const TextStyle(
      fontFamily: 'DM Sans',
      fontWeight: FontWeight.bold,
      fontSize: 15,
      color: AppColors.textPrimary,
    ),
    descTextStyle: const TextStyle(
      fontFamily: 'Inter',
      fontSize: 13,
      color: AppColors.textSecondary,
    ),
    tooltipBackgroundColor: Colors.white,
    targetBorderRadius: const BorderRadius.all(Radius.circular(16)),
    tooltipPadding: const EdgeInsets.all(16),
    child: child,
  );
}
