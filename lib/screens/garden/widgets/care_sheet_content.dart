import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:frontend_eco_2/models/models.dart';
import 'package:frontend_eco_2/providers/providers.dart';
import 'species_data.dart';

class CareSheetContent extends StatefulWidget {
  final UserPlant plant;
  final SpeciesData sp;

  const CareSheetContent({
    super.key,
    required this.plant,
    required this.sp,
  });

  @override
  State<CareSheetContent> createState() => _CareSheetContentState();
}

class _CareSheetContentState extends State<CareSheetContent> {
  String _selectedType = 'Riego';
  String _selectedDateOption = 'Hoy';
  DateTime _customDate = DateTime.now();
  final TextEditingController _noteController = TextEditingController();

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  String _formatSuggestionDate(DateTime dt) {
    final months = [
      'Ene', 'Feb', 'Mar', 'Abr', 'May', 'Jun',
      'Jul', 'Ago', 'Sep', 'Oct', 'Nov', 'Dic'
    ];
    return '${dt.day} ${months[dt.month - 1]} ${dt.year}';
  }

  @override
  Widget build(BuildContext context) {
    final plantsProvider = Provider.of<PlantsProvider>(context, listen: false);
    
    // Calculate suggestion date based on base date
    DateTime baseDate = DateTime.now();
    if (_selectedDateOption == 'Ayer') {
      baseDate = DateTime.now().subtract(const Duration(days: 1));
    } else if (_selectedDateOption == 'Otra fecha') {
      baseDate = _customDate;
    }
    
    final nextDate = baseDate.add(Duration(days: widget.sp.waterFreqDays));
    final daysDiff = nextDate.difference(DateTime.now()).inDays;
    
    String daysText;
    if (daysDiff == 0) {
      daysText = 'hoy';
    } else if (daysDiff == 1) {
      daysText = 'en 1 día';
    } else if (daysDiff < 0) {
      daysText = 'hace ${-daysDiff} días';
    } else {
      daysText = 'en $daysDiff días';
    }
    
    final nextDateStr = _formatSuggestionDate(nextDate);
    final nextSuggestedCareText = "$nextDateStr · $daysText";

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Handle top bar
              Center(
                child: Container(
                  width: 36,
                  height: 4,
                  decoration: BoxDecoration(
                    color: const Color(0xFFDDDDDD),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              
              // Header
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Registrar cuidado',
                          style: TextStyle(
                            fontFamily: 'DM Sans',
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                            color: Color(0xFF0D2B31),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${widget.plant.nickname} · ${widget.sp.scientific}',
                          style: const TextStyle(
                            fontFamily: 'DM Sans',
                            fontSize: 13,
                            color: Color(0xFF807F7F),
                          ),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: const BoxDecoration(
                        color: Color(0xFFF3F5F4),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.close,
                        size: 16,
                        color: Color(0xFF0D2B31),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              
              // Tipo de cuidado label
              const Text(
                'Tipo de cuidado',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: Color(0xFF0D2B31),
                ),
              ),
              const SizedBox(height: 12),
              
              // Care options grid
              Row(
                children: [
                  Expanded(
                    child: _buildTypeCard(
                      type: 'Riego',
                      icon: Icons.water_drop_rounded,
                      activeBgColor: const Color(0xFF164650),
                      inactiveIconBgColor: const Color(0xFFEAF3FC),
                      inactiveIconColor: const Color(0xFF4A90D9),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildTypeCard(
                      type: 'Fertilización',
                      icon: Icons.grain_rounded,
                      activeBgColor: const Color(0xFF164650),
                      inactiveIconBgColor: const Color(0xFFEFF5E4),
                      inactiveIconColor: const Color(0xFF8A9A65),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _buildTypeCard(
                      type: 'Poda',
                      icon: Icons.content_cut_rounded,
                      activeBgColor: const Color(0xFF164650),
                      inactiveIconBgColor: const Color(0xFFFFF0EC),
                      inactiveIconColor: const Color(0xFFF56B1C),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildTypeCard(
                      type: 'Trasplante',
                      icon: Icons.upload_rounded,
                      activeBgColor: const Color(0xFF164650),
                      inactiveIconBgColor: const Color(0xFFF0F2F1),
                      inactiveIconColor: const Color(0xFF808E89),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              
              // Fecha label
              const Text(
                'Fecha',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: Color(0xFF0D2B31),
                ),
              ),
              const SizedBox(height: 12),
              
              // Date options row
              Row(
                children: [
                  _buildDateButton('Hoy'),
                  const SizedBox(width: 8),
                  _buildDateButton('Ayer'),
                  const SizedBox(width: 8),
                  _buildDateButton('Otra fecha'),
                ],
              ),
              const SizedBox(height: 24),
              
              // Nota label
              const Text(
                'Nota (opcional)',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: Color(0xFF0D2B31),
                ),
              ),
              const SizedBox(height: 12),
              
              // Note TextField
              TextField(
                controller: _noteController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: const Color(0xFFEFF1F0),
                  hintText: 'Agua tibia · ~200ml · tierra ya estaba seca',
                  hintStyle: const TextStyle(color: Color(0xFF9CA59E), fontSize: 13),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                ),
                style: const TextStyle(color: Color(0xFF0D2B31), fontSize: 14),
              ),
              const SizedBox(height: 24),
              
              // Suggested care card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFEFF5D9),
                  border: Border.all(color: const Color(0xFFD3E0B5), width: 1.0),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.calendar_month_rounded,
                      color: Color(0xFF3A534E),
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Próximo riego sugerido',
                            style: TextStyle(
                              fontSize: 11,
                              color: Color(0xFF7E8A83),
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            nextSuggestedCareText,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: Color(0xFF0D2B31),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              
              // Guardar / Registrar Button
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0D2B31),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  minimumSize: const Size.fromHeight(50),
                ),
                onPressed: () {
                  // Submit logic
                  DateTime finalDate = DateTime.now();
                  if (_selectedDateOption == 'Ayer') {
                    finalDate = DateTime.now().subtract(const Duration(days: 1));
                  } else if (_selectedDateOption == 'Otra fecha') {
                    finalDate = _customDate;
                  }
                  
                  if (_selectedType == 'Riego') {
                    plantsProvider.waterPlant(widget.plant.id, date: finalDate);
                  }
                  
                  Navigator.pop(context);
                  
                  // Show success feedback
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Cuidado registrado: $_selectedType 🌿'),
                      backgroundColor: const Color(0xFF0D2B31),
                      duration: const Duration(seconds: 2),
                    ),
                  );
                },
                child: const Text(
                  'Registrar cuidado',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTypeCard({
    required String type,
    required IconData icon,
    required Color activeBgColor,
    required Color inactiveIconBgColor,
    required Color inactiveIconColor,
  }) {
    final isSelected = _selectedType == type;
    
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedType = type;
        });
      },
      child: Container(
        height: 60,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: isSelected ? activeBgColor : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: isSelected ? null : Border.all(color: const Color(0xFFE2E7E4), width: 1.2),
        ),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFF265E6B) : inactiveIconBgColor,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: isSelected ? Colors.white : inactiveIconColor,
                size: 18,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                type,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: isSelected ? Colors.white : const Color(0xFF0D2B31),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateButton(String option) {
    final isSelected = _selectedDateOption == option;
    
    return GestureDetector(
      onTap: () async {
        if (option == 'Otra fecha') {
          final picked = await showDatePicker(
            context: context,
            initialDate: _customDate,
            firstDate: DateTime(2020),
            lastDate: DateTime.now().add(const Duration(days: 365)),
            builder: (context, child) {
              return Theme(
                data: Theme.of(context).copyWith(
                  colorScheme: const ColorScheme.light(
                    primary: Color(0xFF0D2B31),
                    onPrimary: Colors.white,
                    onSurface: Color(0xFF0D2B31),
                  ),
                ),
                child: child!,
              );
            },
          );
          if (picked != null) {
            setState(() {
              _customDate = picked;
              _selectedDateOption = option;
            });
          }
        } else {
          setState(() {
            _selectedDateOption = option;
          });
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF0D2B31) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: isSelected ? null : Border.all(color: const Color(0xFFE2E7E4), width: 1.2),
        ),
        child: Text(
          option,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 13,
            color: isSelected ? Colors.white : const Color(0xFF5A6F6C),
          ),
        ),
      ),
    );
  }
}
