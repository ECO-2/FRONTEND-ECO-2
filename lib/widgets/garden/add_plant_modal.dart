import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:frontend_eco_2/providers/providers.dart';
import 'package:frontend_eco_2/theme/app_colors.dart';

// Mockup species list (replace with API data later)
const _availableSpecies = [
  _Species(id: 's1', name: 'Monstera', scientificName: 'Monstera deliciosa'),
  _Species(id: 's2', name: 'Potus', scientificName: 'Epipremnum aureum'),
  _Species(id: 's3', name: 'Sansevieria', scientificName: 'Sansevieria trifasciata'),
  _Species(id: 's4', name: 'Ficus Lira', scientificName: 'Ficus lyrata'),
  _Species(id: 's5', name: 'Cactus', scientificName: 'Cactaceae'),
];

class _Species {
  final String id;
  final String name;
  final String scientificName;

  const _Species({
    required this.id,
    required this.name,
    required this.scientificName,
  });
}

class AddPlantModal extends StatefulWidget {
  const AddPlantModal({super.key});

  @override
  State<AddPlantModal> createState() => _AddPlantModalState();
}

class _AddPlantModalState extends State<AddPlantModal> {
  final _nameController = TextEditingController();
  _Species? _selectedSpecies;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _submit() {
    final nickname = _nameController.text.trim();
    if (nickname.isEmpty || _selectedSpecies == null) return;

    Provider.of<PlantsProvider>(context, listen: false)
        .addPlant(nickname, _selectedSpecies!.id, _selectedSpecies!.name);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.fromLTRB(24, 20, 24, 24 + bottomPadding),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // ── Handle + header ───────────────────────
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
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Añadir nueva planta',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryDark,
                    fontFamily: 'DM Sans',
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(Icons.close_rounded,
                      color: AppColors.textSecondary),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // ── Name field ────────────────────────────
            const Text(
              'Nombre de tu planta',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 13,
                color: AppColors.textPrimary,
                fontFamily: 'Inter',
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _nameController,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(
                hintText: 'ej. Mi Monstera',
                hintStyle: const TextStyle(color: AppColors.textMuted),
                filled: true,
                fillColor: const Color(0xFFF5F7F5),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 14),
              ),
            ),
            const SizedBox(height: 20),

            // ── Species selector ──────────────────────
            const Text(
              'Especie',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 13,
                color: AppColors.textPrimary,
                fontFamily: 'Inter',
              ),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _availableSpecies.map((sp) {
                final selected = _selectedSpecies?.id == sp.id;
                return GestureDetector(
                  onTap: () => setState(() => _selectedSpecies = sp),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: selected
                          ? AppColors.primary
                          : AppColors.primary.withValues(alpha: 0.06),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: selected
                            ? AppColors.primary
                            : AppColors.primary.withValues(alpha: 0.2),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          sp.name,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                            color:
                                selected ? Colors.white : AppColors.textPrimary,
                            fontFamily: 'Inter',
                          ),
                        ),
                        Text(
                          sp.scientificName,
                          style: TextStyle(
                            fontSize: 10,
                            fontStyle: FontStyle.italic,
                            color: selected
                                ? Colors.white70
                                : AppColors.textSecondary,
                            fontFamily: 'Inter',
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 32),

            // ── Submit button ─────────────────────────
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  elevation: 0,
                ),
                onPressed: (_nameController.text.isNotEmpty &&
                        _selectedSpecies != null)
                    ? _submit
                    : null,
                child: const Text(
                  'Añadir planta',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    fontFamily: 'Inter',
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
