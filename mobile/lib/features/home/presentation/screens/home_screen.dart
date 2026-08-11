import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../shared/router/app_router.dart';
import '../widgets/home_banner_slider.dart';
import '../widgets/home_categories.dart';
import '../widgets/home_product_section.dart';
import '../widgets/home_promo_strip.dart';

// ============================================================
// BARAKA MARKET — Home Screen
// Premium UI: Banners, Categories, Flash Sale, Recommendations
// ============================================================

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final _scrollController = ScrollController();
  bool _showElevation = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      final show = _scrollController.offset > 10;
      if (show != _showElevation) setState(() => _showElevation = show);
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.background,
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          // ─── SliverAppBar ─────────────────────────
          _buildSliverAppBar(theme, isDark),

          // ─── Search Bar ───────────────────────────
          SliverToBoxAdapter(
            child: _buildSearchBar(theme, isDark),
          ),

          // ─── Promo Strip ──────────────────────────
          SliverToBoxAdapter(
            child: const HomePromoStrip()
                .animate()
                .fadeIn(delay: 100.ms, duration: 400.ms),
          ),

          // ─── Banner Slider ────────────────────────
          SliverToBoxAdapter(
            child: const HomeBannerSlider()
                .animate()
                .fadeIn(delay: 200.ms, duration: 400.ms),
          ),

          // ─── Categories ───────────────────────────
          SliverToBoxAdapter(
            child: HomeCategories()
                .animate()
                .slideX(
                  begin: -0.1,
                  duration: 500.ms,
                  delay: 300.ms,
                  curve: Curves.easeOut,
                ),
          ),

          // ─── Flash Sale ───────────────────────────
          SliverToBoxAdapter(
            child: HomeProductSection(
              title: '⚡ Flash Sale',
              subtitle: 'Chegirmalar tugashiga oz qoldi!',
              showTimer: true,
              sectionType: ProductSectionType.flashSale,
            ).animate().fadeIn(delay: 400.ms, duration: 400.ms),
          ),

          // ─── New Arrivals ─────────────────────────
          SliverToBoxAdapter(
            child: HomeProductSection(
              title: '🆕 Yangi mahsulotlar',
              subtitle: 'Yangi kelgan mahsulotlar',
              sectionType: ProductSectionType.newArrivals,
            ).animate().fadeIn(delay: 500.ms, duration: 400.ms),
          ),

          // ─── Wide Banner ──────────────────────────
          SliverToBoxAdapter(
            child: _buildWideBanner(theme)
                .animate()
                .fadeIn(delay: 550.ms, duration: 400.ms),
          ),

          // ─── Popular Products ─────────────────────
          SliverToBoxAdapter(
            child: HomeProductSection(
              title: '🔥 Mashhur mahsulotlar',
              subtitle: 'Eng ko\'p sotib olinganlar',
              sectionType: ProductSectionType.popular,
            ).animate().fadeIn(delay: 600.ms, duration: 400.ms),
          ),

          // ─── AI Recommendations ───────────────────
          SliverToBoxAdapter(
            child: HomeProductSection(
              title: '🤖 Siz uchun tavsiyalar',
              subtitle: 'AI tahlili asosida',
              sectionType: ProductSectionType.recommended,
            ).animate().fadeIn(delay: 700.ms, duration: 400.ms),
          ),

          // ─── Bottom Padding ───────────────────────
          const SliverPadding(padding: EdgeInsets.only(bottom: 100)),
        ],
      ),
    );
  }

  Widget _buildSliverAppBar(ThemeData theme, bool isDark) {
    return SliverAppBar(
      floating: true,
      snap: true,
      elevation: _showElevation ? 2 : 0,
      backgroundColor: isDark ? AppColors.darkSurface : AppColors.surface,
      titleSpacing: 20,
      title: Row(
        children: [
          // Location
          Expanded(
            child: GestureDetector(
              onTap: () => context.push(AppRoutes.addresses),
              child: Row(
                children: [
                  Icon(
                    Icons.location_on_rounded,
                    color: AppColors.primary,
                    size: 20,
                  ),
                  const SizedBox(width: 6),
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Yetkazish manzili',
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: AppColors.textHint,
                          ),
                        ),
                        Text(
                          'Chilonzor, 10-mavze',
                          style: theme.textTheme.labelMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: AppColors.textSecondary,
                    size: 18,
                  ),
                ],
              ),
            ),
          ),

          // Actions
          _buildAppBarAction(
            icon: Icons.notifications_outlined,
            badge: '3',
            onTap: () => context.push(AppRoutes.notifications),
          ),
          const SizedBox(width: 8),
          _buildAppBarAction(
            icon: Icons.favorite_border_rounded,
            onTap: () => context.push(AppRoutes.wishlist),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBarAction({
    required IconData icon,
    String? badge,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Theme.of(context).brightness == Brightness.dark
                  ? AppColors.darkSurfaceVariant
                  : AppColors.surfaceVariant,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, size: 22),
          ),
          if (badge != null)
            Positioned(
              right: -4,
              top: -4,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  color: AppColors.secondary,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  badge,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 9,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSearchBar(ThemeData theme, bool isDark) {
    return GestureDetector(
      onTap: () => context.push(AppRoutes.search),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
        child: Container(
          height: 50,
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkSurfaceVariant : AppColors.surfaceVariant,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: isDark ? AppColors.darkOutline : AppColors.outline,
            ),
          ),
          child: Row(
            children: [
              const SizedBox(width: 14),
              Icon(
                Icons.search_rounded,
                color: AppColors.textHint,
                size: 22,
              ),
              const SizedBox(width: 10),
              Text(
                'Mahsulot qidirish...',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: AppColors.textHint,
                ),
              ),
              const Spacer(),
              // Voice search
              GestureDetector(
                onTap: () {}, // TODO: voice search
                child: Container(
                  width: 38,
                  height: 38,
                  margin: const EdgeInsets.only(right: 6),
                  decoration: BoxDecoration(
                    color: AppColors.primaryContainer,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.mic_rounded,
                    color: AppColors.primary,
                    size: 18,
                  ),
                ),
              ),
              // Scanner
              GestureDetector(
                onTap: () => context.push(AppRoutes.scanner),
                child: Container(
                  width: 38,
                  height: 38,
                  margin: const EdgeInsets.only(right: 6),
                  decoration: BoxDecoration(
                    color: AppColors.primaryContainer,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.qr_code_scanner_rounded,
                    color: AppColors.primary,
                    size: 18,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWideBanner(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Container(
        height: 120,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFFFF6B35), Color(0xFFFF9A72)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Stack(
          children: [
            Positioned(
              right: -20,
              top: -20,
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.1),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    '🎁 Bepul yetkazib berish!',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontFamily: 'NunitoSans',
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    '100 000 so\'mdan yuqori buyurtmalarda',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 13,
                      fontFamily: 'NunitoSans',
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      'Xarid qilish',
                      style: TextStyle(
                        color: Color(0xFFFF6B35),
                        fontSize: 12,
                        fontFamily: 'NunitoSans',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
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

enum ProductSectionType { flashSale, newArrivals, popular, recommended }
