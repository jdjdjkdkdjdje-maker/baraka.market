import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../shared/router/app_router.dart';

// ============================================================
// BARAKA MARKET — Home Categories Widget
// ============================================================

class HomeCategories extends StatelessWidget {
  const HomeCategories({super.key});

  static const List<_CategoryItem> _categories = [
    _CategoryItem(emoji: '🥩', name: 'Go\'sht', color: Color(0xFFFFEBEE)),
    _CategoryItem(emoji: '🥛', name: 'Sut', color: Color(0xFFE3F2FD)),
    _CategoryItem(emoji: '🥦', name: 'Sabzavot', color: Color(0xFFE8F5E9)),
    _CategoryItem(emoji: '🍎', name: 'Meva', color: Color(0xFFFFF3E0)),
    _CategoryItem(emoji: '🍞', name: 'Non', color: Color(0xFFFFF8E1)),
    _CategoryItem(emoji: '🧴', name: 'Gigiyena', color: Color(0xFFF3E5F5)),
    _CategoryItem(emoji: '🧹', name: 'Tozalik', color: Color(0xFFE0F7FA)),
    _CategoryItem(emoji: '🍫', name: 'Shirinlik', color: Color(0xFFFCE4EC)),
    _CategoryItem(emoji: '🥤', name: 'Ichimlik', color: Color(0xFFE8EAF6)),
    _CategoryItem(emoji: '🧂', name: 'Ziravorlar', color: Color(0xFFF1F8E9)),
    _CategoryItem(emoji: '🍱', name: 'Tayyor', color: Color(0xFFFFF9C4)),
    _CategoryItem(emoji: '📦', name: 'Barchasi', color: Color(0xFFF5F5F5)),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 14),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Kategoriyalar',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              TextButton(
                onPressed: () => context.push(AppRoutes.catalog),
                child: const Text('Barchasi →'),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 110,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: _categories.length,
            itemBuilder: (context, index) {
              final item = _categories[index];
              return _CategoryCard(
                item: item,
                isDark: isDark,
                onTap: () {},
              );
            },
          ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}

class _CategoryCard extends StatefulWidget {
  final _CategoryItem item;
  final bool isDark;
  final VoidCallback onTap;

  const _CategoryCard({
    required this.item,
    required this.isDark,
    required this.onTap,
  });

  @override
  State<_CategoryCard> createState() => _CategoryCardState();
}

class _CategoryCardState extends State<_CategoryCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.92).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) {
        _controller.reverse();
        widget.onTap();
      },
      onTapCancel: () => _controller.reverse(),
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) => Transform.scale(
          scale: _scaleAnimation.value,
          child: child,
        ),
        child: Container(
          width: 76,
          margin: const EdgeInsets.symmetric(horizontal: 5),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: widget.isDark
                      ? AppColors.darkSurfaceVariant
                      : widget.item.color,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: widget.isDark
                          ? Colors.black.withOpacity(0.2)
                          : widget.item.color.withOpacity(0.6),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    widget.item.emoji,
                    style: const TextStyle(fontSize: 30),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                widget.item.name,
                style: theme.textTheme.labelSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  fontSize: 11,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CategoryItem {
  final String emoji;
  final String name;
  final Color color;

  const _CategoryItem({
    required this.emoji,
    required this.name,
    required this.color,
  });
}
