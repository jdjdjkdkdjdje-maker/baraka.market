import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';

// ============================================================
// BARAKA MARKET — Product Detail Screen
// Full premium product page with images, info, reviews, etc.
// ============================================================

class ProductDetailScreen extends ConsumerStatefulWidget {
  final String productId;
  const ProductDetailScreen({super.key, required this.productId});

  @override
  ConsumerState<ProductDetailScreen> createState() =>
      _ProductDetailScreenState();
}

class _ProductDetailScreenState extends ConsumerState<ProductDetailScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final _scrollController = ScrollController();
  bool _showAppBarTitle = false;
  int _selectedImageIndex = 0;
  int _quantity = 1;
  bool _isWishlisted = false;

  // Mock data
  final List<String> _emojis = ['🍗', '🍗', '🍗'];
  final _tabs = ['Tavsif', 'Tarkib', 'Sharhlar (24)', 'Savol & Javob'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
    _scrollController.addListener(() {
      final show = _scrollController.offset > 280;
      if (show != _showAppBarTitle) setState(() => _showAppBarTitle = show);
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  String _formatPrice(int price) {
    final s = price.toString();
    final buffer = StringBuffer();
    for (int i = 0; i < s.length; i++) {
      if (i > 0 && (s.length - i) % 3 == 0) buffer.write(' ');
      buffer.write(s[i]);
    }
    return buffer.toString();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      extendBodyBehindAppBar: true,
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          // ─── SliverAppBar with image ──────────────
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            backgroundColor: isDark ? AppColors.darkSurface : AppColors.surface,
            leading: _buildCircleButton(
              icon: Icons.arrow_back_ios_rounded,
              onTap: () => context.pop(),
            ),
            actions: [
              _buildCircleButton(
                icon: _isWishlisted
                    ? Icons.favorite_rounded
                    : Icons.favorite_border_rounded,
                color: _isWishlisted ? AppColors.saleBadge : null,
                onTap: () {
                  HapticFeedback.lightImpact();
                  setState(() => _isWishlisted = !_isWishlisted);
                },
              ),
              const SizedBox(width: 4),
              _buildCircleButton(
                icon: Icons.share_rounded,
                onTap: () {},
              ),
              const SizedBox(width: 12),
            ],
            title: AnimatedOpacity(
              opacity: _showAppBarTitle ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 200),
              child: Text(
                "Tovuq go'shti (1kg)",
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: _buildImageSection(isDark),
            ),
          ),

          // ─── Product Info ─────────────────────────
          SliverToBoxAdapter(
            child: _buildProductInfo(theme, isDark),
          ),

          // ─── Tabs ─────────────────────────────────
          SliverPersistentHeader(
            pinned: true,
            delegate: _SliverTabBarDelegate(
              TabBar(
                controller: _tabController,
                tabs: _tabs.map((t) => Tab(text: t)).toList(),
                isScrollable: true,
                tabAlignment: TabAlignment.start,
                labelStyle: const TextStyle(
                  fontFamily: 'NunitoSans',
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                ),
                unselectedLabelStyle: const TextStyle(
                  fontFamily: 'NunitoSans',
                  fontWeight: FontWeight.w500,
                  fontSize: 13,
                ),
                labelColor: AppColors.primary,
                unselectedLabelColor: AppColors.textSecondary,
                indicatorColor: AppColors.primary,
                indicatorWeight: 2.5,
                dividerColor: isDark ? AppColors.darkOutline : AppColors.outline,
              ),
              isDark ? AppColors.darkSurface : AppColors.surface,
            ),
          ),

          // ─── Tab Content ──────────────────────────
          SliverToBoxAdapter(
            child: _buildTabContent(theme, isDark),
          ),

          // ─── Similar Products ─────────────────────
          SliverToBoxAdapter(
            child: _buildSimilarProducts(theme, isDark),
          ),

          // ─── Bottom space for cart bar ─────────────
          const SliverPadding(padding: EdgeInsets.only(bottom: 100)),
        ],
      ),

      // ─── Bottom Cart Bar ─────────────────────────
      bottomNavigationBar: _buildBottomBar(theme, isDark),
    );
  }

  Widget _buildImageSection(bool isDark) {
    return Container(
      color: isDark ? AppColors.darkSurfaceVariant : AppColors.surfaceVariant,
      child: Stack(
        children: [
          // Main image
          Center(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: Text(
                _emojis[_selectedImageIndex],
                key: ValueKey(_selectedImageIndex),
                style: const TextStyle(fontSize: 160),
              ),
            ),
          ),

          // Thumbnail strip
          Positioned(
            bottom: 16,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(_emojis.length, (index) {
                final isSelected = index == _selectedImageIndex;
                return GestureDetector(
                  onTap: () => setState(() => _selectedImageIndex = index),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: isSelected ? 50 : 42,
                    height: isSelected ? 50 : 42,
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.darkSurface : Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected
                            ? AppColors.primary
                            : (isDark ? AppColors.darkOutline : AppColors.outline),
                        width: isSelected ? 2 : 1,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        _emojis[index],
                        style: TextStyle(fontSize: isSelected ? 26 : 22),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductInfo(ThemeData theme, bool isDark) {
    return Container(
      color: isDark ? AppColors.darkSurface : AppColors.surface,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Brand + badges
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.primaryContainer,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  '🏷 Milliy Foods',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: AppColors.primaryDark,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.successContainer,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  '✅ Mavjud',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: AppColors.success,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const Spacer(),
              // Discount
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.saleBadge,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Text(
                  '-18%',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontFamily: 'NunitoSans',
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ).animate().fadeIn(delay: 100.ms),

          const SizedBox(height: 12),

          // Name
          Text(
            "Tovuq go'shti (1kg) — Toza, Yangi",
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w800,
              height: 1.3,
            ),
          ).animate().slideX(begin: -0.1, duration: 400.ms, delay: 150.ms),

          const SizedBox(height: 10),

          // Rating row
          Row(
            children: [
              ...List.generate(
                5,
                (i) => Icon(
                  i < 4 ? Icons.star_rounded : Icons.star_half_rounded,
                  color: AppColors.starFilled,
                  size: 18,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '4.7',
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              Text(
                ' (284 sharh)',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const Spacer(),
              // Sold count
              Text(
                '1.2k+ sotilgan',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ).animate().fadeIn(delay: 200.ms),

          const SizedBox(height: 16),

          // Price
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${_formatPrice(45000)} so\'m',
                style: theme.textTheme.headlineSmall?.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(width: 10),
              Padding(
                padding: const EdgeInsets.only(bottom: 2),
                child: Text(
                  '${_formatPrice(55000)} so\'m',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: AppColors.textHint,
                    decoration: TextDecoration.lineThrough,
                  ),
                ),
              ),
              const Spacer(),
              // Quantity selector
              _buildQtySelector(theme, isDark),
            ],
          ).animate().slideY(begin: 0.2, duration: 400.ms, delay: 250.ms),

          const SizedBox(height: 16),

          // Quick info chips
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _InfoChip(label: '⚖️ 1 kg', isDark: isDark),
              _InfoChip(label: '🗓 Muddati: 5 kun', isDark: isDark),
              _InfoChip(label: '📦 O\'zbekiston', isDark: isDark),
              _InfoChip(label: '🌡 0-4°C', isDark: isDark),
            ],
          ).animate().fadeIn(delay: 300.ms),

          const SizedBox(height: 16),

          // Delivery info
          _buildDeliveryInfo(theme, isDark),
        ],
      ),
    );
  }

  Widget _buildQtySelector(ThemeData theme, bool isDark) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.outline),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: () {
              if (_quantity > 1) setState(() => _quantity--);
            },
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkSurfaceVariant : AppColors.surfaceVariant,
                borderRadius: const BorderRadius.horizontal(left: Radius.circular(11)),
              ),
              child: const Icon(Icons.remove_rounded, size: 16),
            ),
          ),
          Container(
            width: 40,
            alignment: Alignment.center,
            child: Text(
              '$_quantity',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          GestureDetector(
            onTap: () => setState(() => _quantity++),
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: const BorderRadius.horizontal(right: Radius.circular(11)),
              ),
              child: const Icon(Icons.add_rounded, color: Colors.white, size: 16),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDeliveryInfo(ThemeData theme, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurfaceVariant : AppColors.background,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isDark ? AppColors.darkOutline : AppColors.outline,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: AppColors.primaryContainer,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Center(
              child: Text('🚀', style: TextStyle(fontSize: 22)),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Tezkor yetkazib berish',
                  style: theme.textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  '30-45 daqiqa • 15 000 so\'m',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Text(
            'Bugun',
            style: theme.textTheme.labelMedium?.copyWith(
              color: AppColors.success,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabContent(ThemeData theme, bool isDark) {
    return SizedBox(
      height: 300,
      child: TabBarView(
        controller: _tabController,
        children: [
          _buildDescriptionTab(theme),
          _buildIngredientsTab(theme),
          _buildReviewsTab(theme, isDark),
          _buildQnaTab(theme),
        ],
      ),
    );
  }

  Widget _buildDescriptionTab(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Text(
        "Baraka Market taqdim etayotgan yangi, sog'lom va mazali tovuq go'shti. "
        "O'zbekistondagi eng yaxshi fermerlardan yetkazib beriladi. "
        "Mahsulot har kuni yangilanadi va sifat nazoratidan o'tkaziladi.\n\n"
        "• 100% tabiiy\n"
        "• Antibiotik va gormonlarsiz\n"
        "• HACCP sertifikati bor\n"
        "• Sovuq zanjirda saqlangan",
        style: theme.textTheme.bodyMedium?.copyWith(
          height: 1.7,
          color: AppColors.textSecondary,
        ),
      ),
    );
  }

  Widget _buildIngredientsTab(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _NutritionRow(label: 'Kaloriya', value: '165 kkal / 100g', theme: theme),
          _NutritionRow(label: 'Oqsil', value: '31g', theme: theme),
          _NutritionRow(label: 'Yog\'', value: '3.6g', theme: theme),
          _NutritionRow(label: 'Uglevod', value: '0g', theme: theme),
          _NutritionRow(label: 'Natrium', value: '74mg', theme: theme),
        ],
      ),
    );
  }

  Widget _buildReviewsTab(ThemeData theme, bool isDark) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 3,
      itemBuilder: (context, index) {
        return _ReviewTile(
          name: ['Anvar T.', 'Malika R.', 'Bobur K.'][index],
          rating: [5, 4, 5][index].toDouble(),
          text: [
            "Juda yaxshi mahsulot! Toza va yangi keldi.",
            "Sifat yaxshi, lekin narx biroz yuqori.",
            "Har doim shu yerdan olamiz. Tavsiya qilamiz!",
          ][index],
          date: ['2 kun oldin', '1 hafta oldin', '2 hafta oldin'][index],
          isDark: isDark,
          theme: theme,
        );
      },
    );
  }

  Widget _buildQnaTab(ThemeData theme) {
    return Center(
      child: Text(
        'Savollar bo\'limi tez orada',
        style: theme.textTheme.bodyMedium?.copyWith(color: AppColors.textHint),
      ),
    );
  }

  Widget _buildSimilarProducts(ThemeData theme, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 14),
          child: Text(
            'O\'xshash mahsulotlar',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        SizedBox(
          height: 200,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: 4,
            itemBuilder: (context, index) {
              final items = ['🍗', '🥩', '🐟', '🥚'];
              final names = ['Mol go\'shti', 'Baliq', 'Tuxum', 'Qo\'y go\'shti'];
              final prices = [68000, 55000, 22000, 75000];
              return Container(
                width: 140,
                margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 4),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkSurface : AppColors.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isDark ? AppColors.darkOutline : AppColors.outline,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(items[index], style: const TextStyle(fontSize: 50)),
                    const SizedBox(height: 8),
                    Text(
                      names[index],
                      style: theme.textTheme.labelMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${prices[index]} so\'m',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 12),
      ],
    );
  }

  Widget _buildBottomBar(ThemeData theme, bool isDark) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.surface,
        border: Border(
          top: BorderSide(
            color: isDark ? AppColors.darkOutline : AppColors.outline,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Total
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Jami:',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              Text(
                '${_formatPrice(45000 * _quantity)} so\'m',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const SizedBox(width: 20),

          // Add to cart
          Expanded(
            child: ElevatedButton.icon(
              onPressed: () {
                HapticFeedback.mediumImpact();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('Savatga qo\'shildi! ✅'),
                    backgroundColor: AppColors.success,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    margin: const EdgeInsets.all(16),
                  ),
                );
              },
              icon: const Icon(Icons.shopping_cart_outlined, size: 20),
              label: const Text('Savatga qo\'shish'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCircleButton({
    required IconData icon,
    Color? color,
    required VoidCallback onTap,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 38,
        height: 38,
        margin: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: isDark
              ? AppColors.darkSurfaceVariant.withOpacity(0.9)
              : Colors.white.withOpacity(0.9),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
            ),
          ],
        ),
        child: Icon(
          icon,
          size: 18,
          color: color ??
              (isDark ? AppColors.darkTextPrimary : AppColors.textPrimary),
        ),
      ),
    );
  }
}

// ─── Helper Widgets ────────────────────────────────────────

class _InfoChip extends StatelessWidget {
  final String label;
  final bool isDark;
  const _InfoChip({required this.label, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurfaceVariant : AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isDark ? AppColors.darkOutline : AppColors.outline,
        ),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              fontWeight: FontWeight.w600,
              fontSize: 11,
            ),
      ),
    );
  }
}

class _NutritionRow extends StatelessWidget {
  final String label;
  final String value;
  final ThemeData theme;
  const _NutritionRow({required this.label, required this.value, required this.theme});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Text(label, style: theme.textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary)),
          const Spacer(),
          Text(value, style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

class _ReviewTile extends StatelessWidget {
  final String name;
  final double rating;
  final String text;
  final String date;
  final bool isDark;
  final ThemeData theme;

  const _ReviewTile({
    required this.name,
    required this.rating,
    required this.text,
    required this.date,
    required this.isDark,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurfaceVariant : AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 16,
                backgroundColor: AppColors.primaryContainer,
                child: Text(
                  name[0],
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'NunitoSans',
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Text(name, style: theme.textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w700)),
              const Spacer(),
              ...List.generate(
                rating.toInt(),
                (_) => const Icon(Icons.star_rounded, color: AppColors.starFilled, size: 14),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(text, style: theme.textTheme.bodySmall?.copyWith(height: 1.5)),
          const SizedBox(height: 6),
          Text(date, style: theme.textTheme.labelSmall?.copyWith(color: AppColors.textHint)),
        ],
      ),
    );
  }
}

class _SliverTabBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar tabBar;
  final Color bgColor;

  _SliverTabBarDelegate(this.tabBar, this.bgColor);

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: bgColor,
      child: tabBar,
    );
  }

  @override
  double get maxExtent => tabBar.preferredSize.height;
  @override
  double get minExtent => tabBar.preferredSize.height;
  @override
  bool shouldRebuild(covariant _SliverTabBarDelegate oldDelegate) =>
      oldDelegate.tabBar != tabBar;
}
