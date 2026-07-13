import 'package:flutter/material.dart';
import 'package:frontend_eco_2/models/models.dart';
import 'package:frontend_eco_2/widgets/common/custom_app_bar.dart';

class _CareEvent {
  final String type; // Riego, Fertilización, Poda
  final String dateStr; // 20 Abr, 12 Abr, etc.
  final String description;
  final IconData icon;
  final Color iconColor;
  final Color iconBgColor;
  final Color dotColor;

  const _CareEvent({
    required this.type,
    required this.dateStr,
    required this.description,
    required this.icon,
    required this.iconColor,
    required this.iconBgColor,
    required this.dotColor,
  });
}

class CareHistoryScreen extends StatefulWidget {
  const CareHistoryScreen({super.key});

  @override
  State<CareHistoryScreen> createState() => _CareHistoryScreenState();
}

class _CareHistoryScreenState extends State<CareHistoryScreen> {
  String _selectedFilter = 'Todos';

  final List<_CareEvent> _events = const [
    _CareEvent(
      type: 'Riego',
      dateStr: '20 Abr',
      description: '~200ml · agua tibia',
      icon: Icons.water_drop_rounded,
      iconColor: Color(0xFF4A90D9),
      iconBgColor: Color(0xFFEAF3FC),
      dotColor: Color(0xFF164650),
    ),
    _CareEvent(
      type: 'Fertilización',
      dateStr: '12 Abr',
      description: 'Nutri-líquido · dilución 1:10',
      icon: Icons.grain_rounded,
      iconColor: Color(0xFF8A9A65),
      iconBgColor: Color(0xFFEFF5E4),
      dotColor: Color(0xFF8A9A65),
    ),
    _CareEvent(
      type: 'Riego',
      dateStr: '5 Abr',
      description: 'Tierra seca · ~180ml',
      icon: Icons.water_drop_rounded,
      iconColor: Color(0xFF4A90D9),
      iconBgColor: Color(0xFFEAF3FC),
      dotColor: Color(0xFF164650),
    ),
    _CareEvent(
      type: 'Poda',
      dateStr: '2 Abr',
      description: 'Hoja amarilla inferior',
      icon: Icons.content_cut_rounded,
      iconColor: Color(0xFFF56B1C),
      iconBgColor: Color(0xFFFFF0EC),
      dotColor: Color(0xFFF56B1C),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final plant = ModalRoute.of(context)?.settings.arguments as UserPlant?;
    final nickname = plant?.nickname ?? 'Mi Monstera';

    // Filter events
    final filteredEvents = _events.where((e) {
      if (_selectedFilter == 'Todos') return true;
      if (_selectedFilter == 'Riegos') return e.type == 'Riego';
      if (_selectedFilter == 'Podas') return e.type == 'Poda';
      if (_selectedFilter == 'Abonos') return e.type == 'Fertilización';
      return true;
    }).toList();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        automaticallyImplyLeading: true,
        titleWidget: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Historial',
              style: TextStyle(
                fontFamily: 'DM Sans',
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              nickname,
              style: const TextStyle(
                fontFamily: 'DM Sans',
                fontSize: 12,
                color: Color(0xFFBEE664),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        actions: [
          GestureDetector(
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Descargando historial de cuidados... 💾'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.download_rounded,
                size: 18,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Upper counts card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: const Color(0xFFE2E7E4),
                        width: 1.2,
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: _buildMetricCol(
                            icon: Icons.water_drop_rounded,
                            iconColor: const Color(0xFF4A90D9),
                            iconBgColor: const Color(0xFFEAF3FC),
                            value: '24',
                            label: 'Riegos',
                          ),
                        ),
                        Container(
                          width: 1,
                          height: 40,
                          color: const Color(0xFFE2E7E4),
                        ),
                        Expanded(
                          child: _buildMetricCol(
                            icon: Icons.grain_rounded,
                            iconColor: const Color(0xFF8A9A65),
                            iconBgColor: const Color(0xFFEFF5E4),
                            value: '5',
                            label: 'Fertilización',
                          ),
                        ),
                        Container(
                          width: 1,
                          height: 40,
                          color: const Color(0xFFE2E7E4),
                        ),
                        Expanded(
                          child: _buildMetricCol(
                            icon: Icons.content_cut_rounded,
                            iconColor: const Color(0xFFF56B1C),
                            iconBgColor: const Color(0xFFFFF0EC),
                            value: '2',
                            label: 'Podas',
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Filter Row
                  Row(
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              _buildFilterChip('Todos'),
                              const SizedBox(width: 8),
                              _buildFilterChip('Riegos'),
                              const SizedBox(width: 8),
                              _buildFilterChip('Podas'),
                              const SizedBox(width: 8),
                              _buildFilterChip('Abonos'),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: const Color(0xFFE2E7E4),
                            width: 1.2,
                          ),
                        ),
                        child: const Icon(
                          Icons.filter_list_rounded,
                          color: Color(0xFF0D2B31),
                          size: 18,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // List Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Abril 2026',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Color(0xFF0D2B31),
                        ),
                      ),
                      Text(
                        '${filteredEvents.length} eventos',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF807F7F),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Timeline List
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: filteredEvents.length,
                    itemBuilder: (context, index) {
                      final event = filteredEvents[index];
                      final isFirst = index == 0;
                      final isLast = index == filteredEvents.length - 1;

                      return IntrinsicHeight(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // Timeline visual
                            SizedBox(
                              width: 40,
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  // Line
                                  Positioned(
                                    top: isFirst ? 28 : 0,
                                    bottom: isLast ? 28 : 0,
                                    left: 19,
                                    child: Container(
                                      width: 2,
                                      color: const Color(0xFFE2E7E4),
                                    ),
                                  ),
                                  // Dot
                                  Positioned(
                                    top: 20,
                                    child: Container(
                                      width: 14,
                                      height: 14,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: event.dotColor,
                                          width: 3.5,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // Event Card
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 12.0),
                                child: Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(
                                      color: const Color(0xFFE2E7E4),
                                      width: 1.2,
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 36,
                                        height: 36,
                                        decoration: BoxDecoration(
                                          color: event.iconBgColor,
                                          shape: BoxShape.circle,
                                        ),
                                        alignment: Alignment.center,
                                        child: Icon(
                                          event.icon,
                                          color: event.iconColor,
                                          size: 18,
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Text(
                                                  event.type,
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 14,
                                                    color: Color(0xFF0D2B31),
                                                  ),
                                                ),
                                                const SizedBox(width: 8),
                                                Text(
                                                  event.dateStr,
                                                  style: const TextStyle(
                                                    fontSize: 11,
                                                    color: Color(0xFF807F7F),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 2),
                                            Text(
                                              event.description,
                                              style: const TextStyle(
                                                fontSize: 12,
                                                color: Color(0xFF807F7F),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          // Bottom Export Button
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
            child: OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFF0D2B31),
                side: const BorderSide(color: Color(0xFF0D2B31), width: 1.5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.symmetric(vertical: 14),
                minimumSize: const Size.fromHeight(50),
              ),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Historial exportado al calendario con éxito 📅',
                    ),
                    duration: Duration(seconds: 2),
                  ),
                );
              },
              icon: const Icon(Icons.calendar_today_rounded, size: 16),
              label: const Text(
                'Exportar a calendario',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricCol({
    required IconData icon,
    required Color iconColor,
    required Color iconBgColor,
    required String value,
    required String label,
  }) {
    return Column(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(color: iconBgColor, shape: BoxShape.circle),
          child: Icon(icon, color: iconColor, size: 16),
        ),
        const SizedBox(height: 8),
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Color(0xFF0D2B31),
            ),
          ),
        ),
        const SizedBox(height: 2),
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            label,
            style: const TextStyle(fontSize: 11, color: Color(0xFF807F7F)),
          ),
        ),
      ],
    );
  }

  Widget _buildFilterChip(String label) {
    final isSelected = _selectedFilter == label;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedFilter = label;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF0D2B31) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: isSelected
              ? null
              : Border.all(color: const Color(0xFFE2E7E4), width: 1.2),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 12,
            color: isSelected ? Colors.white : const Color(0xFF5A6F6C),
          ),
        ),
      ),
    );
  }
}
