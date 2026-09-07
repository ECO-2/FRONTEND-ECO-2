import 'package:flutter/material.dart';
import 'package:frontend_eco_2/l10n/app_localizations.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import 'package:frontend_eco_2/providers/providers.dart';
import 'package:frontend_eco_2/theme/app_colors.dart';
import 'package:frontend_eco_2/utils/store_labels.dart';
import 'package:frontend_eco_2/widgets/store/store_card_backdrop.dart';
import 'package:frontend_eco_2/widgets/common/custom_bottom_nav_bar.dart';
import 'package:frontend_eco_2/widgets/common/custom_status_bar.dart';
import 'package:frontend_eco_2/widgets/common/app_toast.dart';
import 'package:frontend_eco_2/routing/tab_navigation.dart';

// Claves estables, no etiquetas: comparar contra el texto visible rompia el
// filtro en cuanto la app cambiaba de idioma.
const _kStoreFilters = ['bestsellers', 'O2+', 'avatars', 'pots'];

class _StoreListing {
  final String id;
  final int cost;
  final String category;
  final IconData icon;
  final bool featured;
  final bool bestseller;
  final String? badge;

  const _StoreListing({
    required this.id,
    required this.cost,
    required this.category,
    required this.icon,
    this.featured = false,
    this.bestseller = false,
    this.badge,
  });
}

const List<_StoreListing> _kListings = [
  _StoreListing(
    id: 'o2_plus_2w',
    cost: 3500,
    category: 'O2+',
    icon: Icons.star_rounded,
    featured: true,
    bestseller: true,
  ),
  _StoreListing(
    id: 'maceta_rental_2w',
    cost: 150,
    category: 'pots',
    icon: Icons.timer_outlined,
    bestseller: true,
    badge: 'new',
  ),
  _StoreListing(
    id: 'avatar_explorador',
    cost: 250,
    category: 'avatars',
    icon: Icons.face_retouching_natural_rounded,
  ),
  _StoreListing(
    id: 'avatar_guardian',
    cost: 600,
    category: 'avatars',
    icon: Icons.forest_rounded,
  ),
  _StoreListing(
    id: 'maceta_pack3',
    cost: 1000,
    category: 'pots',
    icon: Icons.grid_view_rounded,
  ),
  _StoreListing(
    id: 'o2_plus_4w',
    cost: 6000,
    category: 'O2+',
    icon: Icons.workspace_premium_rounded,
  ),
];

class StoreScreen extends StatefulWidget {
  final bool isTab;

  const StoreScreen({super.key, this.isTab = false});

  @override
  State<StoreScreen> createState() => _StoreScreenState();
}

class _StoreScreenState extends State<StoreScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _selectedFilter = _kStoreFilters.first;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isTab) {
      return Scaffold(
        backgroundColor: AppColors.background,
        body: _buildBodyContent(context),
      );
    }

    return Scaffold(
      extendBody: true,
      backgroundColor: AppColors.background,
      body: _buildBodyContent(context),
      bottomNavigationBar: CustomBottomNavBar(
        selectedIndex: 0, // Highlight Tienda tab
        onTap: (index) => openDashboardTab(context, index),
      ),
    );
  }

  Widget _buildBodyContent(BuildContext context) {
    final missionsProvider = context.watch<MissionsProvider>();

    final filtered = _kListings.where((item) {
      final matchesSearch = _searchQuery.isEmpty ||
          storeItemTitle(context, item.id)
              .toLowerCase()
              .contains(_searchQuery.toLowerCase()) ||
          storeItemSubtitle(context, item.id)
              .toLowerCase()
              .contains(_searchQuery.toLowerCase());
      final matchesFilter = _selectedFilter == 'bestsellers'
          ? item.bestseller
          : item.category == _selectedFilter;
      return matchesSearch && matchesFilter;
    }).toList();

    return Column(
      children: [
        if (!widget.isTab) const CustomStatusBar(),
        _buildHeader(context, missionsProvider.userSeeds),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 120),
            children: [
              _buildSearchBar(),
              const SizedBox(height: 12),
              _buildFilterChips(),
              const SizedBox(height: 18),
              Row(
                children: [
                  Icon(Icons.spa_rounded, size: 16, color: AppColors.textMuted.withValues(alpha: 0.8)),
                  const SizedBox(width: 6),
                  Text(
                    _sectionSubtitle(_selectedFilter),
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textMuted,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              if (filtered.isEmpty)
                _buildEmptyState()
              else
                ...filtered.asMap().entries.map(
                  (entry) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _StoreItemCard(
                      item: entry.value,
                      userSeeds: missionsProvider.userSeeds,
                      onBuy: () => _handleBuy(context, entry.value, missionsProvider),
                    )
                        .animate()
                        .fadeIn(duration: 380.ms, delay: (entry.key * 70).ms)
                        .slideY(begin: 0.08, end: 0, curve: Curves.easeOutCubic),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  String _sectionSubtitle(String filter) {
    switch (filter) {
      case 'O2+':
        return AppLocalizations.of(context)!.boostGardenPremium;
      case 'avatars':
        return AppLocalizations.of(context)!.customizeYourProfile;
      case 'pots':
        return AppLocalizations.of(context)!.moreSpaceForPlants;
      default:
        return AppLocalizations.of(context)!.communityFavorites;
    }
  }

  Widget _buildHeader(BuildContext context, int seeds) {
    final canPop = !widget.isTab && Navigator.of(context).canPop();

    return Container(
      width: double.infinity,
      color: AppColors.primaryDark,
      padding: EdgeInsets.fromLTRB(20, widget.isTab ? 20 : 4, 20, 24),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            right: -24,
            top: -18,
            child: Icon(
              Icons.spa_rounded,
              size: 130,
              color: Colors.white.withValues(alpha: 0.05),
            ),
          ),
          _buildHeaderRow(context, seeds, canPop),
        ],
      ),
    );
  }

  Widget _buildHeaderRow(BuildContext context, int seeds, bool canPop) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (canPop) ...[
            GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.15),
                ),
                alignment: Alignment.center,
                child: const Icon(
                  Icons.chevron_left_rounded,
                  color: Colors.white,
                  size: 22,
                ),
              ),
            ),
            const SizedBox(width: 12),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppLocalizations.of(context)!.seedbed,
                  style: const TextStyle(
                    fontFamily: 'DM Sans',
                    fontWeight: FontWeight.bold,
                    fontSize: 26,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  AppLocalizations.of(context)!.redeemSeeds,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 12,
                    color: Colors.white.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.accent,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 22,
                  height: 22,
                  decoration: const BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: const Icon(
                    Icons.spa_rounded,
                    color: AppColors.accent,
                    size: 12,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '$seeds',
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ),
        ],
      );
  }

  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFEFF1EF),
        borderRadius: BorderRadius.circular(24),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: Row(
        children: [
          const Icon(Icons.search_rounded, color: AppColors.textSecondary, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: _searchController,
              onChanged: (val) => setState(() => _searchQuery = val),
              decoration: InputDecoration(
                hintText: AppLocalizations.of(context)!.search,
                hintStyle: const TextStyle(
                  color: AppColors.textSecondary,
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
                setState(() => _searchQuery = '');
              },
              child: const Icon(Icons.close_rounded, color: AppColors.textSecondary, size: 18),
            ),
        ],
      ),
    );
  }

  Widget _buildFilterChips() {
    // Chips and the filter button scroll together horizontally so nothing
    // ever gets clipped against a fixed sibling on narrower screens.
    return SizedBox(
      height: 40,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          ..._kStoreFilters.map((filter) {
            final selected = _selectedFilter == filter;
            final filterLabel = storeCategoryLabel(context, filter);
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: GestureDetector(
                onTap: () => setState(() => _selectedFilter = filter),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: selected ? AppColors.primaryDark : Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: selected ? AppColors.primaryDark : const Color(0xFFE5EAE7),
                      width: 1.2,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      filterLabel,
                      style: TextStyle(
                        fontFamily: 'DM Sans',
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                        color: selected ? Colors.white : AppColors.textPrimary,
                      ),
                    ),
                  ),
                ),
              ),
            );
          }),
          Container(
            height: 38,
            width: 38,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xFFE5EAE7), width: 1.2),
            ),
            child: const Icon(Icons.tune_rounded, color: AppColors.primaryDark, size: 18),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 48),
      child: Column(
        children: [
          Icon(Icons.search_off_rounded, size: 40, color: AppColors.textMuted.withValues(alpha: 0.6)),
          const SizedBox(height: 12),
          Text(
            AppLocalizations.of(context)!.noItemsFound,
            style: TextStyle(
              fontFamily: 'Inter',
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  void _handleBuy(BuildContext context, _StoreListing item, MissionsProvider missionsProvider) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          AppLocalizations.of(context)!.confirmPurchaseTitle,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.primaryDark,
            fontFamily: 'DM Sans',
          ),
        ),
        content: Text(
          AppLocalizations.of(context)!.confirmPurchaseBody(storeItemTitle(context, item.id), item.cost),
          style: const TextStyle(color: AppColors.textPrimary, fontFamily: 'Inter'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(
              AppLocalizations.of(context)!.cancel,
              style: TextStyle(color: AppColors.textSecondary, fontFamily: 'Inter'),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () async {
              Navigator.of(ctx).pop();
              final success = await missionsProvider.spendSeeds(item.cost);
              if (!context.mounted) return;
              showAppToast(
                context,
                success
                    ? '${AppLocalizations.of(context)!.purchaseSuccess(storeItemTitle(context, item.id))} 🎉'
                    : AppLocalizations.of(context)!.purchaseFailed,
                type: success ? ToastType.success : ToastType.error,
              );
            },
            child: Text(
              AppLocalizations.of(context)!.confirm,
              style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Inter'),
            ),
          ),
        ],
      ),
    );
  }
}

class _StoreItemCard extends StatelessWidget {
  final _StoreListing item;
  final int userSeeds;
  final VoidCallback onBuy;

  const _StoreItemCard({
    required this.item,
    required this.userSeeds,
    required this.onBuy,
  });

  @override
  Widget build(BuildContext context) {
    final canAfford = userSeeds >= item.cost;
    final titleColor = item.featured ? Colors.white : AppColors.primaryDark;
    final subtitleColor = item.featured ? AppColors.accent : AppColors.primary;

    // Fondo con degradado y patron vectorial por familia de producto, en vez
    // del blanco plano (o verde solido en la destacada) de antes.
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        border: item.featured
            ? null
            : Border.all(color: const Color(0xFFE2E7E4), width: 1.5),
        boxShadow: item.featured
            ? [
                BoxShadow(
                  color: AppColors.primaryDark.withValues(alpha: 0.22),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ]
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.03),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
      ),
      child: StoreCardBackdrop(
        category: item.category,
        featured: item.featured,
        child: Padding(
      padding: const EdgeInsets.all(18),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  StoreItemIcon(icon: item.icon, featured: item.featured),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          storeItemTitle(context, item.id),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: titleColor,
                            fontFamily: 'DM Sans',
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          storeItemSubtitle(context, item.id),
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                            color: subtitleColor,
                            fontFamily: 'Inter',
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              GestureDetector(
                onTap: canAfford ? onBuy : null,
                child: Container(
                  height: 44,
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    color: canAfford ? AppColors.accent : const Color(0xFFECECEC),
                    borderRadius: BorderRadius.circular(22),
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 16,
                        backgroundColor: canAfford ? AppColors.primaryDark : const Color(0xFFB7B7B7),
                        child: const Icon(Icons.spa_rounded, size: 16, color: Colors.white),
                      ),
                      Expanded(
                        child: Center(
                          child: Text(
                            AppLocalizations.of(context)!.seedsCost(item.cost),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                              color: canAfford ? AppColors.primaryDark : const Color(0xFF8A8A8A),
                              fontFamily: 'Inter',
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                      // Balances the circle's width so the text visually centers.
                      const SizedBox(width: 32),
                    ],
                  ),
                ),
              ),
            ],
          ),
          if (item.badge != null)
            Positioned(
              top: -6,
              right: -6,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.orange,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  item.badge == 'new' ? AppLocalizations.of(context)!.newBadgeLabel : item.badge!,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 10,
                    color: Colors.white,
                    fontFamily: 'Inter',
                  ),
                ),
              ),
            ),
        ],
      ),
        ),
      ),
    );
  }
}
