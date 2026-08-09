import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:frontend_eco_2/models/models.dart';
import 'package:frontend_eco_2/providers/providers.dart';
import 'package:frontend_eco_2/routing/app_routes.dart';
import 'package:frontend_eco_2/theme/app_colors.dart';
import 'package:frontend_eco_2/utils/achievement_feedback.dart';
import 'package:frontend_eco_2/utils/plant_visuals.dart';
import 'package:frontend_eco_2/widgets/garden/add_plant_modal.dart';
import 'package:frontend_eco_2/screens/garden/widgets/needs_care_modal.dart';
import 'package:frontend_eco_2/widgets/common/tag_chips_row.dart';

// ── Figma color tokens ────────────────────────────────────────────────────
const _kDark = Color(0xFF10454F);
const _kTextMuted = Color(0xFF807F7F);
const _kTextDark = Color(0xFF0D2B31);

// Categorías rápidas para el filtro de "Mi Jardín" — mismas categorías
// reales del catálogo (reemplaza el filtro anterior "Interior/Exterior" que
// era una aproximación heurística sobre categorías que no encajan del todo).
const _kGardenQuickCategories = ['tropical', 'succulent', 'cactus'];

class GardenTab extends StatefulWidget {
  const GardenTab({super.key});

  @override
  State<GardenTab> createState() => _GardenTabState();
}

class _GardenTabState extends State<GardenTab> {
  String _searchQuery = '';
  bool _isGridView = false;
  bool _isGardenGridView = false;
  String _selectedGardenCategory = 'all';

  // Catalog filters. Category/light store the raw API enum value (or
  // 'all'); difficulty stores the exact label PlantSpecies.difficulty
  // returns (or 'Todas').
  String _selectedCategoryValue = 'all';
  String _selectedDifficulty = 'Todas';
  String _selectedLight = 'all';

  final TextEditingController _searchController = TextEditingController();

  // Quick-access chips show only the most common categories; the rest are
  // reachable from the full filter sheet (tune button).
  static const List<String> _quickCategoryKeys = ['succulent', 'tropical', 'cactus'];
  static const List<String> _allCategoryKeys = [
    'tropical',
    'succulent',
    'cactus',
    'fern',
    'flowering',
    'herb',
    'tree',
    'other',
  ];
  static const List<String> _difficultyOptions = ['Todas', 'Muy fácil', 'Fácil', 'Media'];
  static const List<String> _lightKeys = ['low', 'medium', 'high', 'indirect'];

  bool get _hasAdvancedFilters => _selectedDifficulty != 'Todas' || _selectedLight != 'all';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  /// Agrega [species] al jardín del usuario y, si tuvo éxito, otorga XP real
  /// y revisa logros de tipo `user_plants` — usado por los botones rápidos
  /// "Añadir" del catálogo (a diferencia de AddPlantModal, que hace lo mismo
  /// pero con selección de apodo).
  Future<void> _addSpeciesToGarden(
    BuildContext context,
    PlantSpecies species,
    PlantsProvider plantsProvider,
  ) async {
    final success = await plantsProvider.addPlantFromSpecies(species);
    if (!context.mounted) return;

    if (!success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(plantsProvider.errorMessage ?? 'No se pudo agregar la planta.'),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
      return;
    }

    final missionsProvider = Provider.of<MissionsProvider>(context, listen: false);
    final unlocked = await missionsProvider.onPlantAdded(plantsProvider.userPlants.length);
    if (!context.mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('¡${species.commonName} añadida a tu jardín! 🌿'),
        backgroundColor: AppColors.primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
    showAchievementUnlockedSnackbars(context, unlocked);
  }

  // Legacy mock species (s1-s5) keep their bespoke background/illustration;
  // every real catalog species (real UUID from the backend) gets a
  // category-based visual instead of a single generic placeholder.
  Color _getSpeciesBg(String id, {String? category}) {
    switch (id) {
      case 's1':
        return const Color(0xFFF2F7F2);
      case 's2':
        return const Color(0xFFEAF5EA);
      case 's3':
        return const Color(0xFFF0F4EC);
      case 's4':
        return const Color(0xFFEAF0E8);
      case 's5':
        return const Color(0xFFF5F2E8);
      default:
        return visualForCategory(category).background;
    }
  }

  @override
  Widget build(BuildContext context) {
    final plantsProvider = Provider.of<PlantsProvider>(context);
    final plants = plantsProvider.userPlants;
    final showCatalog = plantsProvider.showCatalogTab;

    return SafeArea(
      top: false,
      bottom: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header Row (Title & Toggle) ─────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  showCatalog ? 'Jardín' : 'Mi Jardín',
                  style: const TextStyle(
                    fontFamily: 'DM Sans',
                    fontWeight: FontWeight.w700,
                    fontSize: 32,
                    color: _kTextDark,
                  ),
                ),
                // Pill Toggle Selector
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEFF2F0),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () => plantsProvider.setShowCatalogTab(true),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 150),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 6),
                          decoration: BoxDecoration(
                            color: showCatalog ? _kDark : Colors.transparent,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            'Jardín',
                            style: TextStyle(
                              fontFamily: 'DM Sans',
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                              color: showCatalog ? Colors.white : _kTextMuted,
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () => plantsProvider.setShowCatalogTab(false),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 150),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 6),
                          decoration: BoxDecoration(
                            color: !showCatalog ? _kDark : Colors.transparent,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            'Mi Jardín',
                            style: TextStyle(
                              fontFamily: 'DM Sans',
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                              color: !showCatalog ? Colors.white : _kTextMuted,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Render view based on toggle
          Expanded(
            child: showCatalog
                ? _buildCatalogView(context, plantsProvider)
                : _buildMyGardenView(context, plantsProvider, plants),
          ),
        ],
      ),
    );
  }

  Widget _buildCatalogView(BuildContext context, PlantsProvider plantsProvider) {
    final catalog = plantsProvider.speciesCatalog;
    final filteredCatalog = catalog.where((species) {
      final matchesSearch = species.commonName.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          species.scientificName.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesCategory =
          _selectedCategoryValue == 'all' || species.category == _selectedCategoryValue;
      final matchesDifficulty =
          _selectedDifficulty == 'Todas' || species.difficulty == _selectedDifficulty;
      final matchesLight = _selectedLight == 'all' || species.lightRequirement == _selectedLight;
      return matchesSearch && matchesCategory && matchesDifficulty && matchesLight;
    }).toList();

    // "Tendencias": no hay datos de popularidad/analítica en el backend, así
    // que se usan las especies con mejor puntaje real de purificación de
    // aire (air_purification_score) como criterio honesto de destacadas.
    final trends = [...catalog]
      ..sort((a, b) => (b.airPurificationScore ?? 0).compareTo(a.airPurificationScore ?? 0));
    final topTrends = trends.take(5).toList();
    final showTrends = _searchQuery.isEmpty && _selectedCategoryValue == 'all' && !_hasAdvancedFilters;

    // A single real scrollable (CustomScrollView + SliverGrid/SliverList)
    // instead of a ListView.builder/GridView.builder nested with
    // shrinkWrap+NeverScrollableScrollPhysics inside an outer ListView.
    // shrinkWrap forces Flutter to lay out every item up front to measure
    // the shrink-wrapped extent, defeating lazy building — with 50+ catalog
    // cards that meant all of them were built (images, badges, buttons)
    // even though only ~4 are ever visible. Slivers keep this lazy no
    // matter how large the catalog grows, with no pagination/"load more"
    // UI needed.
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(child: _buildCatalogSearchBar()),
        SliverToBoxAdapter(child: _buildCatalogFilterChips()),
        if (showTrends) SliverToBoxAdapter(child: _buildTrendsSection(context, topTrends)),
        SliverToBoxAdapter(child: _buildExplorarHeader(filteredCatalog.length)),
        if (filteredCatalog.isEmpty)
          SliverToBoxAdapter(child: _buildEmptyCatalogState())
        else if (_isGridView)
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.62,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) =>
                    _buildGridCatalogCard(context, filteredCatalog[index], plantsProvider),
                childCount: filteredCatalog.length,
              ),
            ),
          )
        else
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) =>
                    _buildListCatalogCard(context, filteredCatalog[index], plantsProvider),
                childCount: filteredCatalog.length,
              ),
            ),
          ),
        const SliverToBoxAdapter(child: SizedBox(height: 120)),
      ],
    );
  }

  Widget _buildCatalogSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFFEFF1EF),
                borderRadius: BorderRadius.circular(24),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: Row(
                children: [
                  const Icon(Icons.search_rounded, color: _kTextMuted, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      onChanged: (val) {
                        setState(() {
                          _searchQuery = val;
                        });
                      },
                      decoration: const InputDecoration(
                        hintText: 'Buscar mi planta...',
                        hintStyle: TextStyle(
                          color: _kTextMuted,
                          fontSize: 13,
                          fontFamily: 'Inter',
                        ),
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                  if (_searchQuery.isNotEmpty)
                    GestureDetector(
                      onTap: () {
                        _searchController.clear();
                        setState(() {
                          _searchQuery = '';
                        });
                      },
                      child: const Icon(Icons.close_rounded, color: _kTextMuted, size: 18),
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 10),
          // Circular search icon button
          Container(
            height: 48,
            width: 48,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFFE5EAE7), width: 1.2),
            ),
            child: const Icon(Icons.search_rounded, color: _kDark, size: 20),
          ),
        ],
      ),
    );
  }

  Widget _buildCatalogFilterChips() {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: SizedBox(
        height: 42,
        child: Row(
          children: [
            Expanded(
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  _buildQuickCategoryChip('Todas', 'all'),
                  ..._quickCategoryKeys.map(
                    (key) => _buildQuickCategoryChip(categoryLabelEs(key), key),
                  ),
                ],
              ),
            ),
            // Filter icon button — opens the full filter sheet (category,
            // difficulty, light).
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: GestureDetector(
                onTap: () => _openFilterSheet(context),
                child: Container(
                  height: 38,
                  width: 38,
                  decoration: BoxDecoration(
                    color: _hasAdvancedFilters ? _kDark : Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: _hasAdvancedFilters ? _kDark : const Color(0xFFE5EAE7),
                      width: 1.2,
                    ),
                  ),
                  child: Icon(
                    Icons.tune_rounded,
                    color: _hasAdvancedFilters ? Colors.white : _kDark,
                    size: 18,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickCategoryChip(String label, String value) {
    final selected = _selectedCategoryValue == value;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: GestureDetector(
        onTap: () => setState(() => _selectedCategoryValue = value),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: selected ? _kDark : Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: selected ? _kDark : const Color(0xFFE5EAE7),
              width: 1.2,
            ),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                fontFamily: 'DM Sans',
                fontWeight: FontWeight.bold,
                fontSize: 12,
                color: selected ? Colors.white : _kTextDark,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTrendsSection(BuildContext context, List<PlantSpecies> topTrends) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(16, 24, 16, 12),
          child: Row(
            children: [
              Icon(Icons.trending_up_rounded, color: Colors.orange, size: 20),
              SizedBox(width: 6),
              Text(
                'Tendencias esta semana',
                style: TextStyle(
                  fontFamily: 'DM Sans',
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: _kTextDark,
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 255,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: topTrends.length,
            itemBuilder: (context, idx) {
              final species = topTrends[idx];
              final visual = visualForCategory(species.category);
              final purificationScore = species.airPurificationScore ?? 0;
              final commonNameText = species.commonName;
              final subtitleText = species.scientificName;

              return GestureDetector(
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    AppRoutes.speciesDetail,
                    arguments: species,
                  );
                },
                child: Container(
                  width: 165,
                  margin: const EdgeInsets.only(right: 12, bottom: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: const Color(0xFFE5EAE7), width: 1.2),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.02),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Image Container with purification badge
                      Expanded(
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            Container(
                              color: _getSpeciesBg(species.id, category: species.category),
                              alignment: Alignment.center,
                              padding: const EdgeInsets.all(12),
                              child: species.id == 's1'
                                  ? Image.asset('assets/images/monstera.png', fit: BoxFit.contain)
                                  : Icon(
                                      visual.icon,
                                      size: 48,
                                      color: visual.color.withValues(alpha: 0.4),
                                    ),
                            ),
                            // Floating purification badge (real air_purification_score)
                            Positioned(
                              top: 8,
                              right: 8,
                              child: Container(
                                padding: const EdgeInsets.all(6),
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.air_rounded,
                                  color: Colors.orange,
                                  size: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Details
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              commonNameText,
                              style: const TextStyle(
                                fontFamily: 'DM Sans',
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: _kTextDark,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 2),
                            Text(
                              subtitleText,
                              style: const TextStyle(
                                fontFamily: 'DM Sans',
                                fontSize: 11,
                                color: _kTextMuted,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF2F4EB),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    species.difficulty,
                                    style: const TextStyle(
                                      fontSize: 9,
                                      fontWeight: FontWeight.bold,
                                      color: _kDark,
                                    ),
                                  ),
                                ),
                                Row(
                                  children: [
                                    const Icon(Icons.air_rounded,
                                        color: Colors.orange, size: 10),
                                    const SizedBox(width: 2),
                                    Text(
                                      '$purificationScore/9',
                                      style: const TextStyle(
                                        fontSize: 9,
                                        fontWeight: FontWeight.bold,
                                        color: _kTextDark,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildExplorarHeader(int resultCount) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Explorar especies',
            style: TextStyle(
              fontFamily: 'DM Sans',
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: _kTextDark,
            ),
          ),
          Row(
            children: [
              Text(
                '$resultCount plantas',
                style: const TextStyle(
                  fontFamily: 'DM Sans',
                  fontSize: 12,
                  color: _kTextMuted,
                ),
              ),
              const SizedBox(width: 8),
              // Grid/List toggle button
              GestureDetector(
                onTap: () => setState(() => _isGridView = !_isGridView),
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: const Color(0xFFE5EAE7), width: 1.2),
                  ),
                  child: Icon(
                    _isGridView ? Icons.view_list_rounded : Icons.grid_view_rounded,
                    size: 16,
                    color: _kDark,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyCatalogState() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 16),
      child: Column(
        children: [
          Icon(Icons.search_off_rounded, size: 40, color: _kTextMuted.withValues(alpha: 0.6)),
          const SizedBox(height: 12),
          const Text(
            'No se encontraron especies con estos filtros',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Inter',
              fontWeight: FontWeight.w600,
              color: _kTextMuted,
            ),
          ),
        ],
      ),
    );
  }

  void _openFilterSheet(BuildContext context) {
    String tempCategory = _selectedCategoryValue;
    String tempDifficulty = _selectedDifficulty;
    String tempLight = _selectedLight;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        return StatefulBuilder(
          builder: (sheetContext, setSheetState) {
            Widget sectionTitle(String text) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text(
                    text,
                    style: const TextStyle(
                      fontFamily: 'DM Sans',
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                      color: _kTextDark,
                    ),
                  ),
                );

            Widget filterChip(String label, bool selected, VoidCallback onTap) {
              return GestureDetector(
                onTap: onTap,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: selected ? _kDark : Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: selected ? _kDark : const Color(0xFFE5EAE7),
                      width: 1.2,
                    ),
                  ),
                  child: Text(
                    label,
                    style: TextStyle(
                      fontFamily: 'DM Sans',
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                      color: selected ? Colors.white : _kTextDark,
                    ),
                  ),
                ),
              );
            }

            return Container(
              padding: EdgeInsets.fromLTRB(
                  20, 16, 20, MediaQuery.of(sheetContext).viewInsets.bottom + 24),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 38,
                      height: 5,
                      decoration: BoxDecoration(
                        color: const Color(0xFFE2E7E4),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Filtros',
                        style: TextStyle(
                          fontFamily: 'DM Sans',
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: _kTextDark,
                        ),
                      ),
                      TextButton(
                        onPressed: () => setSheetState(() {
                          tempCategory = 'all';
                          tempDifficulty = 'Todas';
                          tempLight = 'all';
                        }),
                        child: const Text(
                          'Limpiar',
                          style: TextStyle(color: _kTextMuted, fontFamily: 'Inter'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  sectionTitle('Categoría'),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      filterChip('Todas', tempCategory == 'all',
                          () => setSheetState(() => tempCategory = 'all')),
                      ..._allCategoryKeys.map(
                        (key) => filterChip(
                          categoryLabelEs(key),
                          tempCategory == key,
                          () => setSheetState(() => tempCategory = key),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  sectionTitle('Dificultad'),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _difficultyOptions
                        .map(
                          (option) => filterChip(
                            option,
                            tempDifficulty == option,
                            () => setSheetState(() => tempDifficulty = option),
                          ),
                        )
                        .toList(),
                  ),
                  const SizedBox(height: 20),
                  sectionTitle('Luz'),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      filterChip('Todas', tempLight == 'all',
                          () => setSheetState(() => tempLight = 'all')),
                      ..._lightKeys.map(
                        (key) => filterChip(
                          lightLabelEs(key),
                          tempLight == key,
                          () => setSheetState(() => tempLight = key),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _kDark,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      onPressed: () {
                        setState(() {
                          _selectedCategoryValue = tempCategory;
                          _selectedDifficulty = tempDifficulty;
                          _selectedLight = tempLight;
                        });
                        Navigator.pop(sheetContext);
                      },
                      child: const Text(
                        'Aplicar filtros',
                        style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Inter'),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildListCatalogCard(BuildContext context, PlantSpecies species, PlantsProvider plantsProvider) {
    final isMonstera = species.id == 's1';
    final visual = visualForCategory(species.category);
    final nameToDisplay = species.commonName;
    final subtitleToDisplay = species.scientificName;

    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          AppRoutes.speciesDetail,
          arguments: species,
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFFE5EAE7), width: 1.2),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.01),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Image container (left)
              Container(
                width: 110,
                color: _getSpeciesBg(species.id, category: species.category),
                padding: const EdgeInsets.all(12),
                child: isMonstera
                    ? Image.asset('assets/images/monstera.png', fit: BoxFit.contain)
                    : Icon(
                        visual.icon,
                        size: 40,
                        color: visual.color.withValues(alpha: 0.4),
                      ),
              ),
              // Details container (right)
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        nameToDisplay,
                        style: const TextStyle(
                          fontFamily: 'DM Sans',
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: _kTextDark,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        subtitleToDisplay,
                        style: const TextStyle(
                          fontFamily: 'DM Sans',
                          fontSize: 12,
                          color: _kTextMuted,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 6),
                      // Difficulty (fijo) + tags de la especie en una sola
                      // línea con scroll horizontal — nunca se apilan a una
                      // segunda línea ni empujan el resto de la tarjeta.
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF2F4EB),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              species.difficulty,
                              style: const TextStyle(
                                fontSize: 9,
                                fontWeight: FontWeight.bold,
                                color: _kDark,
                              ),
                            ),
                          ),
                          const SizedBox(width: 6),
                          Expanded(child: TagChipsRow(tags: species.tags)),
                        ],
                      ),
                      const SizedBox(height: 8),
                      // Add Button
                      GestureDetector(
                        onTap: () => _addSpeciesToGarden(context, species, plantsProvider),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                          decoration: BoxDecoration(
                            color: const Color(0xFFBDE038), // Lime Green
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.add, size: 14, color: _kTextDark),
                              SizedBox(width: 4),
                              Text(
                                'Añadir',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: _kTextDark,
                                  fontFamily: 'Inter',
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGridCatalogCard(BuildContext context, PlantSpecies species, PlantsProvider plantsProvider) {
    final isMonstera = species.id == 's1';
    final visual = visualForCategory(species.category);
    final nameToDisplay = species.commonName;

    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          AppRoutes.speciesDetail,
          arguments: species,
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFFE5EAE7), width: 1.2),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                color: _getSpeciesBg(species.id, category: species.category),
                alignment: Alignment.center,
                padding: const EdgeInsets.all(12),
                child: isMonstera
                    ? Image.asset('assets/images/monstera.png', fit: BoxFit.contain)
                    : Icon(
                        visual.icon,
                        size: 40,
                        color: visual.color.withValues(alpha: 0.4),
                      ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    nameToDisplay,
                    style: const TextStyle(
                      fontFamily: 'DM Sans',
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: _kTextDark,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    species.scientificName,
                    style: const TextStyle(
                      fontFamily: 'DM Sans',
                      fontSize: 11,
                      color: _kTextMuted,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  if (species.tags.isNotEmpty) ...[
                    TagChipsRow(tags: species.tags.take(2).toList(), fontSize: 8, iconSize: 9),
                    const SizedBox(height: 6),
                  ],
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF2F4EB),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          species.difficulty,
                          style: const TextStyle(
                            fontSize: 8,
                            fontWeight: FontWeight.bold,
                            color: _kDark,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () => _addSpeciesToGarden(context, species, plantsProvider),
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: Color(0xFFBDE038),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.add, size: 14, color: _kTextDark),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool _needsWater(UserPlant p, PlantsProvider plantsProvider) {
    final species = plantsProvider.speciesCatalog.firstWhere(
      (s) => s.id == p.speciesId,
      orElse: () => catalogFallback(p.speciesId),
    );
    if (p.lastWateredAt == null) return true;
    return DateTime.now().difference(p.lastWateredAt!).inDays >= species.waterFrequencyDays;
  }

  Widget _buildMyGardenView(BuildContext context, PlantsProvider plantsProvider, List<UserPlant> plants) {
    // Filtro por categoría real de especie (mismo criterio que el catálogo),
    // en vez de la aproximación Interior/Exterior anterior.
    final filteredPlants = plants.where((p) {
      if (_selectedGardenCategory == 'all') return true;
      final info = plantsProvider.speciesCatalog.firstWhere(
        (s) => s.id == p.speciesId,
        orElse: () => catalogFallback(p.speciesId),
      );
      return info.category == _selectedGardenCategory;
    }).toList();

    // Plants that need watering
    final plantsNeedingWater = plants.where((p) => _needsWater(p, plantsProvider)).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Filter chips ──
        _buildGardenFilterChips(),

        // ── Alert Banner ──
        if (plantsNeedingWater.isNotEmpty)
          _buildAttentionBanner(context, plantsNeedingWater.length),

        // ── Plants list/grid ──
        Expanded(
          child: filteredPlants.isEmpty
              ? _buildEmptyGardenState(context, plants.length)
              : _isGardenGridView
                  ? GridView.builder(
                      padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 0.72,
                      ),
                      itemCount: filteredPlants.length + 1,
                      itemBuilder: (context, i) {
                        if (i == filteredPlants.length) {
                          return _buildAddPlantButton(context, plants.length);
                        }
                        final plant = filteredPlants[i];
                        return _PlantGridCard(
                          plant: plant,
                          species: plantsProvider.speciesCatalog.firstWhere(
                            (s) => s.id == plant.speciesId,
                            orElse: () => catalogFallback(plant.speciesId),
                          ),
                          needsWater: _needsWater(plant, plantsProvider),
                          onTap: () => Navigator.pushNamed(
                            context,
                            AppRoutes.plantDetail,
                            arguments: plant,
                          ),
                        );
                      },
                    )
                  : ListView(
                      padding: const EdgeInsets.only(
                          left: 16, right: 16, top: 12, bottom: 100),
                      children: [
                        ...filteredPlants.map((plant) => Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: _PlantListCard(
                                plant: plant,
                                species: plantsProvider.speciesCatalog.firstWhere(
                                  (s) => s.id == plant.speciesId,
                                  orElse: () => catalogFallback(plant.speciesId),
                                ),
                                onTap: () => Navigator.pushNamed(
                                  context,
                                  AppRoutes.plantDetail,
                                  arguments: plant,
                                ),
                                onWater: () => plantsProvider.waterPlant(plant.id),
                              ),
                            )),
                        // Add plant button at the bottom
                        const SizedBox(height: 8),
                        _buildAddPlantButton(context, plants.length),
                      ],
                    ),
        ),
      ],
    );
  }

  Widget _buildEmptyGardenState(BuildContext context, int totalPlantCount) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 100),
      child: Column(
        children: [
          Icon(Icons.eco_outlined, size: 40, color: _kTextMuted.withValues(alpha: 0.6)),
          const SizedBox(height: 12),
          const Text(
            'No tienes plantas en esta categoría todavía',
            textAlign: TextAlign.center,
            style: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.w600, color: _kTextMuted),
          ),
          const SizedBox(height: 16),
          _buildAddPlantButton(context, totalPlantCount),
        ],
      ),
    );
  }

  PlantSpecies catalogFallback(String speciesId) {
    return PlantSpecies(
      id: speciesId,
      scientificName: 'Especie desconocida',
      commonName: 'Planta',
      waterFrequencyDays: 7,
      createdAt: DateTime.now(),
    );
  }

  Widget _buildGardenFilterChips() {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: SizedBox(
        height: 42,
        child: Row(
          children: [
            Expanded(
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  _buildGardenCategoryChip('Todas', 'all'),
                  ..._kGardenQuickCategories.map(
                    (key) => _buildGardenCategoryChip(categoryLabelEs(key), key),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: GestureDetector(
                onTap: () => _openGardenCategorySheet(context),
                child: Container(
                  height: 38,
                  width: 38,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: const Color(0xFFE5EAE7), width: 1.2),
                  ),
                  child: const Icon(Icons.tune_rounded, color: _kDark, size: 18),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: GestureDetector(
                onTap: () => setState(() => _isGardenGridView = !_isGardenGridView),
                child: Container(
                  height: 38,
                  width: 38,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: const Color(0xFFE5EAE7), width: 1.2),
                  ),
                  child: Icon(
                    _isGardenGridView ? Icons.view_list_rounded : Icons.grid_view_rounded,
                    color: _kDark,
                    size: 18,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGardenCategoryChip(String label, String value) {
    final selected = _selectedGardenCategory == value;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: GestureDetector(
        onTap: () => setState(() => _selectedGardenCategory = value),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: selected ? _kDark : Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: selected ? _kDark : const Color(0xFFE5EAE7),
              width: 1.2,
            ),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                fontFamily: 'DM Sans',
                fontWeight: FontWeight.bold,
                fontSize: 12,
                color: selected ? Colors.white : _kTextDark,
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _openGardenCategorySheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        return Container(
          padding: EdgeInsets.fromLTRB(20, 16, 20, MediaQuery.of(sheetContext).viewInsets.bottom + 24),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 38,
                  height: 5,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE2E7E4),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Filtrar por categoría',
                style: TextStyle(
                  fontFamily: 'DM Sans',
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: _kTextDark,
                ),
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _buildGardenCategoryChip('Todas', 'all'),
                  ..._allCategoryKeys.map(
                    (key) => _buildGardenCategoryChip(categoryLabelEs(key), key),
                  ),
                ],
              ),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    ).then((_) => setState(() {}));
  }

  Widget _buildAttentionBanner(BuildContext context, int count) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFEFF5D9),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFD3E0B5), width: 1),
      ),
      child: Row(
        children: [
          Container(
            width: 22,
            height: 22,
            decoration: const BoxDecoration(color: _kDark, shape: BoxShape.circle),
            alignment: Alignment.center,
            child: const Icon(Icons.info_outline_rounded, color: Colors.white, size: 13),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              count == 1
                  ? '1 planta necesita atención hoy'
                  : '$count plantas necesitan atención hoy',
              style: const TextStyle(
                fontFamily: 'DM Sans',
                fontWeight: FontWeight.w600,
                fontSize: 12,
                color: _kTextDark,
              ),
            ),
          ),
          GestureDetector(
            onTap: () => showNeedsCareModal(context),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: _kDark, width: 1.2),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Ver',
                    style: TextStyle(
                      fontFamily: 'DM Sans',
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                      color: _kTextDark,
                    ),
                  ),
                  SizedBox(width: 4),
                  Icon(Icons.arrow_forward_rounded, size: 13, color: _kTextDark),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddPlantButton(BuildContext context, int plantCount) {
    return GestureDetector(
      onTap: () => showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (_) => const AddPlantModal(),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFF8FAF9),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Stack(
          children: [
            const Positioned.fill(
              child: CustomPaint(
                painter: _DashedCornerPainter(color: Color(0xFF8FA89F)),
              ),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          '+',
                          style: TextStyle(
                            fontFamily: 'DM Sans',
                            fontWeight: FontWeight.w500,
                            fontSize: 20,
                            color: _kDark,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: const Color(0xFF8FA89F),
                              width: 1.2,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.spa_rounded,
                            color: _kDark,
                            size: 20,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Añadir Planta',
                      style: TextStyle(
                        fontFamily: 'DM Sans',
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                        color: _kTextDark,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '[$plantCount macetas de 10 gratis]',
                      style: const TextStyle(
                        fontFamily: 'DM Sans',
                        fontSize: 11,
                        color: Color(0xFF8FA89F),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DashedCornerPainter extends CustomPainter {
  final Color color;
  const _DashedCornerPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round;

    final double r = 16.0; // Corner radius
    final double l = 8.0;  // Extension length
    final double w = size.width;
    final double h = size.height;

    final path = Path();

    // Top-left
    path.moveTo(r + l, 0);
    path.lineTo(r, 0);
    path.arcToPoint(Offset(0, r), radius: Radius.circular(r), clockwise: false);
    path.lineTo(0, r + l);

    // Top-right
    path.moveTo(w - (r + l), 0);
    path.lineTo(w - r, 0);
    path.arcToPoint(Offset(w, r), radius: Radius.circular(r), clockwise: true);
    path.lineTo(w, r + l);

    // Bottom-left
    path.moveTo(0, h - (r + l));
    path.lineTo(0, h - r);
    path.arcToPoint(Offset(r, h), radius: Radius.circular(r), clockwise: false);
    path.lineTo(r + l, h);

    // Bottom-right
    path.moveTo(w, h - (r + l));
    path.lineTo(w, h - r);
    path.arcToPoint(Offset(w - r, h), radius: Radius.circular(r), clockwise: true);
    path.lineTo(w - (r + l), h);

    _drawDashedPath(canvas, path, paint, 3.0, 3.0);
  }

  void _drawDashedPath(Canvas canvas, Path path, Paint paint, double dashLength, double gapLength) {
    for (final pathMetric in path.computeMetrics()) {
      double distance = 0.0;
      while (distance < pathMetric.length) {
        final length = dashLength;
        final drawLength = (distance + length < pathMetric.length) ? length : pathMetric.length - distance;
        canvas.drawPath(pathMetric.extractPath(distance, distance + drawLength), paint);
        distance += length + gapLength;
      }
    }
  }

  @override
  bool shouldRepaint(covariant _DashedCornerPainter oldDelegate) => color != oldDelegate.color;
}

// ── Species data (mirrors plant_card.dart) ───────────────────────────────────
const _kSpeciesData = {
  's1': _GardenSpecies(
    scientificName: 'Monstera deliciosa',
    tags: ['Tropical', 'Luz indirecta', 'Riego semanal'],
    imageBg: Color(0xFFF2F7F2),
    assetImage: 'assets/images/monstera.png',
  ),
  's2': _GardenSpecies(
    scientificName: 'Epipremnum aureum',
    tags: ['Tropical', 'Luz indirecta', 'Riego semanal'],
    imageBg: Color(0xFFEAF5EA),
  ),
  's3': _GardenSpecies(
    scientificName: 'Sansevieria',
    tags: ['Desértica', 'Luz Adaptable', 'Riego 2-3 sem.'],
    imageBg: Color(0xFFF0F4EC),
  ),
  's4': _GardenSpecies(
    scientificName: 'Ficus lyrata',
    tags: ['Tropical', 'Luz brillante', 'Riego semanal'],
    imageBg: Color(0xFFEAF0E8),
  ),
  's5': _GardenSpecies(
    scientificName: 'Cactaceae',
    tags: ['Desértica', 'Pleno sol', 'Riego mensual'],
    imageBg: Color(0xFFF5F2E8),
  ),
};

class _GardenSpecies {
  final String scientificName;
  final List<String> tags;
  final Color imageBg;
  final String? assetImage;
  final IconData placeholderIcon;
  final Color placeholderIconColor;
  const _GardenSpecies({
    required this.scientificName,
    required this.tags,
    required this.imageBg,
    this.assetImage,
    this.placeholderIcon = Icons.local_florist_rounded,
    this.placeholderIconColor = AppColors.primary,
  });

  // Real catalog species (real UUID from the backend) don't have a legacy
  // illustration, so they get a category-based icon/color instead of the
  // single generic placeholder every species used to share.
  factory _GardenSpecies.fromReal(PlantSpecies species) {
    final visual = visualForCategory(species.category);
    return _GardenSpecies(
      scientificName: species.scientificName,
      tags: species.tags,
      imageBg: visual.background,
      placeholderIcon: visual.icon,
      placeholderIconColor: visual.color,
    );
  }
}

// ── Plant list card — Mi Jardín horizontal ────────────────────────────────────
class _PlantListCard extends StatelessWidget {
  final UserPlant plant;
  final PlantSpecies species;
  final VoidCallback onTap;
  final VoidCallback onWater;

  const _PlantListCard({
    required this.plant,
    required this.species,
    required this.onTap,
    required this.onWater,
  });

  @override
  Widget build(BuildContext context) {
    final neverWatered = plant.lastWateredAt == null;
    final daysSinceWater =
        neverWatered ? null : DateTime.now().difference(plant.lastWateredAt!).inDays;
    final needsWater = neverWatered || daysSinceWater! >= species.waterFrequencyDays;
    final sp = _kSpeciesData[plant.speciesId] ?? _GardenSpecies.fromReal(species);

    // Badge on image: "! Riego" in orange when needs water, "✓ Riego" in sage green when up-to-date
    final riegoBadgeBg = needsWater ? const Color(0xFFF56B1C) : const Color(0xFF789D8C);
    final riegoBadgeText = needsWater ? '! Riego' : '✓ Riego';
    final riegoBadgeColor = Colors.white;

    // Status pill — siempre con ícono de check (estilo Figma), el color y el
    // texto reflejan el estado real: días exactos sin riego cuando ya toca,
    // "Al día" cuando no.
    final statusBg = needsWater ? const Color(0xFFFFF4EC) : const Color(0xFFF2F4EB);
    final statusBorderColor = needsWater ? const Color(0xFFFFCCA0) : const Color(0xFF8A9A65);
    final statusTextColor = needsWater ? const Color(0xFFB94E13) : const Color(0xFF10454F);
    final overdueBy = daysSinceWater == null ? null : daysSinceWater - species.waterFrequencyDays;
    final statusText = !needsWater
        ? 'Al día'
        : neverWatered
            ? 'Nunca regada'
            : overdueBy! <= 0
                ? 'Riego hoy'
                : '$overdueBy día${overdueBy == 1 ? '' : 's'} de retraso';
    const statusIcon = Icons.check_rounded;

    final daysLabel = neverWatered
        ? 'Sin riego registrado · c/${species.waterFrequencyDays}d'
        : '${daysSinceWater}d sin riego · c/${species.waterFrequencyDays}d';

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: const Color(0xFFE5EAE7),
            width: 1.2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ── LEFT CONTAINER: Image box ─────────────────────────
              Container(
                width: 110,
                constraints: const BoxConstraints(minHeight: 130),
                decoration: BoxDecoration(
                  color: sp.imageBg,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: const Color(0xFF5E7A82),
                    width: 1.5,
                  ),
                ),
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    // Image
                    Positioned.fill(
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: sp.assetImage != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.asset(
                                  sp.assetImage!,
                                  fit: BoxFit.contain,
                                  errorBuilder: (_, _, _) => Icon(
                                    sp.placeholderIcon,
                                    size: 48,
                                    color: sp.placeholderIconColor.withValues(alpha: 0.5),
                                  ),
                                ),
                              )
                            : Icon(
                                sp.placeholderIcon,
                                size: 48,
                                color: sp.placeholderIconColor.withValues(alpha: 0.5),
                              ),
                      ),
                    ),
                    // "! Riego" Badge — top-right
                    Positioned(
                      top: 6,
                      right: 6,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: riegoBadgeBg,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          riegoBadgeText,
                          style: TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.w800,
                            color: riegoBadgeColor,
                            fontFamily: 'Inter',
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),

              // ── RIGHT CONTAINER: Info column ────────────────────────
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Title + Chevron
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            plant.nickname,
                            style: const TextStyle(
                              fontFamily: 'DM Sans',
                              fontWeight: FontWeight.w700,
                              fontSize: 18,
                              color: _kTextDark,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const Icon(
                          Icons.chevron_right_rounded,
                          size: 22,
                          color: _kTextDark,
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),

                    // Scientific name
                    Text(
                      sp.scientificName,
                      style: const TextStyle(
                        fontFamily: 'DM Sans',
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                        color: _kTextMuted,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 10),

                    // Status Row (Status Pill + Days Label)
                    Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      spacing: 8,
                      runSpacing: 4,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: statusBg,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: statusBorderColor,
                              width: 1.2,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                statusIcon,
                                size: 12,
                                color: statusTextColor,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                statusText,
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w700,
                                  fontSize: 11,
                                  color: statusTextColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          daysLabel,
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 12,
                            color: Color(0xFF807F7F),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    // Tags Row — una sola línea con scroll horizontal, no se
                    // apila ni deforma la tarjeta sin importar cuántos tags
                    // tenga la especie.
                    TagChipsRow(
                      tags: sp.tags,
                      fontSize: 10,
                      iconSize: 12,
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

}

// ── Plant grid card — Mi Jardín en cuadrícula ──────────────────────────────
class _PlantGridCard extends StatelessWidget {
  final UserPlant plant;
  final PlantSpecies species;
  final bool needsWater;
  final VoidCallback onTap;

  const _PlantGridCard({
    required this.plant,
    required this.species,
    required this.needsWater,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final visual = visualForCategory(species.category);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFFE5EAE7), width: 1.2),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Container(
                    color: visual.background,
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(12),
                    child: Icon(visual.icon, size: 40, color: visual.color.withValues(alpha: 0.5)),
                  ),
                  Positioned(
                    top: 6,
                    right: 6,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                      decoration: BoxDecoration(
                        color: needsWater ? const Color(0xFFF56B1C) : const Color(0xFF789D8C),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        needsWater ? '! Riego' : '✓ Riego',
                        style: const TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                          fontFamily: 'Inter',
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    plant.nickname,
                    style: const TextStyle(
                      fontFamily: 'DM Sans',
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: _kTextDark,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    species.scientificName,
                    style: const TextStyle(
                      fontFamily: 'DM Sans',
                      fontSize: 11,
                      color: _kTextMuted,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
