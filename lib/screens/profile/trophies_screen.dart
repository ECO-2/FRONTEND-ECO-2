import 'package:flutter/material.dart';
import 'package:frontend_eco_2/theme/app_colors.dart';
import 'package:frontend_eco_2/widgets/common/custom_status_bar.dart';

class TrophiesScreen extends StatefulWidget {
  const TrophiesScreen({super.key});

  @override
  State<TrophiesScreen> createState() => _TrophiesScreenState();
}

class _TrophiesScreenState extends State<TrophiesScreen> {
  String _selectedFilter = 'Todos'; // 'Todos', 'Oro', 'Plata', 'Bronce'

  // Mock list of trophies matching the design
  final List<TrophyItem> _trophies = const [
    TrophyItem(
      title: 'Primera Planta',
      category: 'Bronce',
      isUnlocked: true,
    ),
    TrophyItem(
      title: 'Coleccionista',
      category: 'Plata',
      isUnlocked: true,
    ),
    TrophyItem(
      title: 'Cuidadora Fiel',
      category: 'Oro',
      isUnlocked: true,
    ),
    TrophyItem(
      title: 'Explorer x10',
      category: 'Plata',
      isUnlocked: true,
    ),
    TrophyItem(
      title: 'Riego Master',
      category: 'Bronce',
      isUnlocked: false,
    ),
    TrophyItem(
      title: 'Verde Total',
      category: 'Oro',
      isUnlocked: false,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    // Filter the trophies based on selection
    final filteredTrophies = _selectedFilter == 'Todos'
        ? _trophies
        : _trophies.where((t) => t.category == _selectedFilter).toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          // 1. Dark Teal Header with AppBar
          Container(
            color: AppColors.primary,
            child: Column(
              children: [
                const CustomStatusBar(backgroundColor: AppColors.primaryDark),
                Container(
                  height: 72,
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Back Button
                      Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () => Navigator.of(context).pop(),
                          customBorder: const CircleBorder(),
                          child: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white.withValues(alpha: 0.15),
                            ),
                            alignment: Alignment.center,
                            child: const Icon(
                              Icons.chevron_left_rounded,
                              color: Colors.white,
                              size: 28,
                            ),
                          ),
                        ),
                      ),
                      // Title
                      const Text(
                        'Trofeos',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          fontFamily: 'Inter',
                        ),
                      ),
                      // Dummy spacing to center the title
                      const SizedBox(width: 40),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // 2. Scrollable Body Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Level Progress Card
                  _buildLevelCard(),
                  const SizedBox(height: 20),

                  // Three Stat Cards Row
                  _buildStatsRow(),
                  const SizedBox(height: 28),

                  // Tab Filter Selector
                  _buildTabSelector(),
                  const SizedBox(height: 20),

                  // Trophies Grid
                  GridView.builder(
                    padding: EdgeInsets.zero,
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: filteredTrophies.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      mainAxisSpacing: 14,
                      crossAxisSpacing: 14,
                      childAspectRatio: 0.66,
                    ),
                    itemBuilder: (context, index) {
                      return _buildTrophyCard(filteredTrophies[index]);
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLevelCard() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.primaryDark,
        borderRadius: BorderRadius.circular(24),
      ),
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          Row(
            children: [
              // Level Badge Circle
              Container(
                width: 64,
                height: 64,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.accent,
                ),
                alignment: Alignment.center,
                child: const Text(
                  '5',
                  style: TextStyle(
                    color: AppColors.primaryDark,
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'DM Sans',
                  ),
                ),
              ),
              const SizedBox(width: 16),
              // User level text
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Jardinera Dedicada',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'DM Sans',
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Nivel 5 - 12 trofeos desbloqueados',
                      style: TextStyle(
                        color: AppColors.accent,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Inter',
                      ),
                    ),
                  ],
                ),
              ),
              // Decorative Trophy Icon Container
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: AppColors.primary.withValues(alpha: 0.4),
                  border: Border.all(
                    color: AppColors.primary.withValues(alpha: 0.2),
                    width: 1,
                  ),
                ),
                alignment: Alignment.center,
                child: const Icon(
                  Icons.emoji_events_rounded,
                  color: AppColors.accent,
                  size: 24,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          // XP Bar labels
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                'Próximo: Guardiana Verde',
                style: TextStyle(
                  color: AppColors.accent,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Inter',
                ),
              ),
              Text(
                '340 / 500 XP',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Inter',
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Progress Indicator
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: const LinearProgressIndicator(
              value: 340 / 500,
              minHeight: 6,
              backgroundColor: Color(0xFF163E46), // Muted dark teal progress background
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.accent),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsRow() {
    return Row(
      children: [
        Expanded(child: _buildStatItem('12', 'Obtenidos')),
        const SizedBox(width: 12),
        Expanded(child: _buildStatItem('28', 'Disponibles')),
        const SizedBox(width: 12),
        Expanded(child: _buildStatItem('43%', 'Completado')),
      ],
    );
  }

  Widget _buildStatItem(String number, String label) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE8ECE9), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.01),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Column(
        children: [
          Text(
            number,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryDark,
              fontFamily: 'DM Sans',
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
              fontFamily: 'Inter',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabSelector() {
    final tabs = ['Todos', 'Oro', 'Plata', 'Bronce'];
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: tabs.map((tab) {
        final isSelected = _selectedFilter == tab;
        return GestureDetector(
          onTap: () {
            setState(() {
              _selectedFilter = tab;
            });
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                tab,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                  color: isSelected ? AppColors.primaryDark : AppColors.textSecondary,
                  fontFamily: 'Inter',
                ),
              ),
              const SizedBox(height: 6),
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                height: 3,
                width: isSelected ? 24 : 0,
                decoration: BoxDecoration(
                  color: AppColors.primaryDark,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildTrophyCard(TrophyItem trophy) {
    // Custom colors depending on status and tier
    Color circleBg;
    Color iconColor;
    IconData iconData;
    String badgeText;
    Color badgeTextCol;
    Color badgeBg;

    if (!trophy.isUnlocked) {
      circleBg = const Color(0xFFECECEC);
      iconColor = const Color(0xFF909090);
      iconData = Icons.lock_rounded;
      badgeText = 'Bloqueado';
      badgeTextCol = const Color(0xFF707070);
      badgeBg = const Color(0xFFECECEC);
    } else {
      iconData = Icons.emoji_events_rounded;
      if (trophy.category == 'Oro') {
        circleBg = const Color(0xFFFEF8E7);
        iconColor = const Color(0xFFFABF2E);
        badgeText = 'Oro';
        badgeTextCol = const Color(0xFFC6920C);
        badgeBg = const Color(0xFFFEF8E7);
      } else if (trophy.category == 'Plata') {
        circleBg = const Color(0xFFF1F3F2);
        iconColor = const Color(0xFF818274);
        badgeText = 'Plata';
        badgeTextCol = const Color(0xFF5A5B52);
        badgeBg = const Color(0xFFF1F3F2);
      } else {
        // Bronce
        circleBg = const Color(0xFFFDF0E7);
        iconColor = const Color(0xFFE26B26);
        badgeText = 'Bronce';
        badgeTextCol = const Color(0xFFB94E13);
        badgeBg = const Color(0xFFFDF0E7);
      }
    }

    return Container(
      decoration: BoxDecoration(
        color: trophy.isUnlocked ? Colors.white : const Color(0xFFF4F5F4),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: trophy.isUnlocked ? const Color(0xFFECECEC) : const Color(0xFFE4E4E4),
          width: 1,
        ),
        boxShadow: trophy.isUnlocked
            ? [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.02),
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                ),
              ]
            : null,
      ),
      padding: const EdgeInsets.all(12.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Icon Circle badge
          Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: circleBg,
            ),
            alignment: Alignment.center,
            child: Icon(
              iconData,
              color: iconColor,
              size: 26,
            ),
          ),
          const SizedBox(height: 12),
          // Title
          Expanded(
            child: Text(
              trophy.title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: trophy.isUnlocked ? AppColors.primaryDark : const Color(0xFF808080),
                height: 1.2,
                fontFamily: 'Inter',
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(height: 8),
          // Badge Pill
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: badgeBg,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              badgeText,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: badgeTextCol,
                fontFamily: 'Inter',
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class TrophyItem {
  final String title;
  final String category;
  final bool isUnlocked;

  const TrophyItem({
    required this.title,
    required this.category,
    required this.isUnlocked,
  });
}
