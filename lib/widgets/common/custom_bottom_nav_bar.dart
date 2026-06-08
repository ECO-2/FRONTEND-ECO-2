import 'package:flutter/material.dart';
import 'package:frontend_eco_2/theme/app_colors.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onTap;

  const CustomBottomNavBar({
    super.key,
    required this.selectedIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      margin: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E), // Dark charcoal background
        borderRadius: BorderRadius.circular(40),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.25),
            blurRadius: 15,
            spreadRadius: 1,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildItem(
            index: 0,
            label: 'O2 +',
            iconBuilder: (color, isSelected) => _buildO2Icon(color),
          ),
          _buildItem(
            index: 1,
            label: 'Jardín',
            iconBuilder: (color, isSelected) => _buildJardinIcon(color),
          ),
          _buildItem(
            index: 2,
            label: 'Dashboard',
            iconBuilder: (color, isSelected) => _buildDashboardIcon(color, isSelected),
          ),
          _buildItem(
            index: 3,
            label: 'Escáner',
            iconBuilder: (color, isSelected) => _buildEscanerIcon(color),
          ),
          _buildItem(
            index: 4,
            label: 'Perfil',
            iconBuilder: (color, isSelected) => _buildPerfilIcon(color, isSelected),
          ),
        ],
      ),
    );
  }

  Widget _buildItem({
    required int index,
    required String label,
    required Widget Function(Color color, bool isSelected) iconBuilder,
  }) {
    final isSelected = index == selectedIndex;
    final contentColor = isSelected ? AppColors.primary : const Color(0xFFA0A0A0);

    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => onTap(index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeInOut,
          margin: const EdgeInsets.all(2),
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
          decoration: BoxDecoration(
            color: isSelected ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              iconBuilder(contentColor, isSelected),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                  color: contentColor,
                  letterSpacing: -0.1,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Icon O2 + : Star inside a circle outline
  Widget _buildO2Icon(Color color) {
    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: color, width: 2),
      ),
      alignment: Alignment.center,
      child: Icon(
        Icons.star_rounded,
        size: 14,
        color: color,
      ),
    );
  }

  // Icon Jardin : Flower/Sprout inside a rounded square
  Widget _buildJardinIcon(Color color) {
    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color, width: 2),
      ),
      alignment: Alignment.center,
      child: Icon(
        Icons.local_florist_rounded,
        size: 14,
        color: color,
      ),
    );
  }

  // Icon Dashboard : Simple house
  Widget _buildDashboardIcon(Color color, bool isSelected) {
    return Icon(
      isSelected ? Icons.home_rounded : Icons.home_outlined,
      size: 24,
      color: color,
    );
  }

  // Icon Escaner : Target crosshair with a leaf/dot in center
  Widget _buildEscanerIcon(Color color) {
    return SizedBox(
      width: 24,
      height: 24,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: color, width: 2),
            ),
          ),
          // Crosshairs
          Positioned(
            top: 0,
            bottom: 0,
            child: Container(
              width: 2,
              height: 24,
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(width: 2, height: 3, color: color),
                  Container(width: 2, height: 3, color: color),
                ],
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            child: Container(
              height: 2,
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(width: 3, height: 2, color: color),
                  Container(width: 3, height: 2, color: color),
                ],
              ),
            ),
          ),
          Icon(
            Icons.eco,
            size: 10,
            color: color,
          ),
        ],
      ),
    );
  }

  // Icon Perfil : Person outline
  Widget _buildPerfilIcon(Color color, bool isSelected) {
    return Icon(
      isSelected ? Icons.person_rounded : Icons.person_outline_rounded,
      size: 24,
      color: color,
    );
  }
}
