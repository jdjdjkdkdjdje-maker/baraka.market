import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/theme/app_theme.dart';

// ============================================================
// BARAKA MARKET — Product Card Widget
// Premium design with discount badge, rating, add to cart
// ============================================================

class ProductCard extends StatefulWidget {
  final String id;
  final String name;
  final int price;
  final int? oldPrice;
  final int? discount;
  final String emoji;
  final double rating;
  final VoidCallback? onTap;
  final VoidCallback? onWishlistTap;

  const ProductCard({
    super.key,
    required this.id,
    required this.name,
    required this.price,
    this.oldPrice,
    this.discount,
    required this.emoji,
    required this.rating,
    this.onTap,
    this.onWishlistTap,
  });

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _addController;
  late Animation<double> _addAnimation;

  bool _isWishlisted = false;
  int _quantity = 0;

  @override
  void initState() {
    super.initState();
    _addController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _addAnimation = Tween<double>(begin: 1.0, end: 0.9).animate(
      CurvedAnimation(parent: _addController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _addController.dispose();
    super.dispose();
  }

  void _addToCart() {
    HapticFeedback.lightImpact();
    _addController.forward().then((_) => _addController.reverse());
    setState(() => _quantity++);
  }

  void _decreaseQty() {
    HapticFeedback.lightImpact();
    if (_quantity > 0) setState(() => _quantity--);
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

    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        width: 160,
        margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 4),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkSurface : AppColors.surface,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isDark ? AppColors.darkOutline : AppColors.outline,
          ),
          boxShadow: [
            BoxShadow(
              color: isDark
                  ? Colors.black.withOpacity(0.2)
                  : Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image area
                _buildImageArea(isDark),

                // Info
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 8, 10, 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Name
                      Text(
                        widget.name,
                        style: theme.textTheme.labelMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),

                      // Rating
                      Row(
                        children: [
                          Icon(
                            Icons.star_rounded,
                            color: AppColors.starFilled,
                            size: 13,
                          ),
                          const SizedBox(width: 3),
                          Text(
                            widget.rating.toStringAsFixed(1),
                            style: theme.textTheme.labelSmall?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: AppColors.textSecondary,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),

                      // Price row
                      _buildPriceRow(theme),
                      const SizedBox(height: 10),

                      // Add to cart
                      _buildCartButton(theme),
                    ],
                  ),
                ),
              ],
            ),

            // Discount badge
            if (widget.discount != null)
              Positioned(
                top: 8,
                left: 8,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppColors.saleBadge,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    '-${widget.discount}%',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontFamily: 'NunitoSans',
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),

            // Wishlist button
            Positioned(
              top: 6,
              right: 6,
              child: GestureDetector(
                onTap: () {
                  HapticFeedback.lightImpact();
                  setState(() => _isWishlisted = !_isWishlisted);
                  widget.onWishlistTap?.call();
                },
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  child: Container(
                    key: ValueKey(_isWishlisted),
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: isDark
                          ? AppColors.darkSurfaceVariant
                          : Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Icon(
                      _isWishlisted
                          ? Icons.favorite_rounded
                          : Icons.favorite_border_rounded,
                      size: 16,
                      color: _isWishlisted
                          ? AppColors.saleBadge
                          : AppColors.textHint,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageArea(bool isDark) {
    return Container(
      height: 120,
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.darkSurfaceVariant
            : AppColors.surfaceVariant,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
      ),
      child: Center(
        child: Text(
          widget.emoji,
          style: const TextStyle(fontSize: 60),
        ),
      ),
    );
  }

  Widget _buildPriceRow(ThemeData theme) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Flexible(
          child: Text(
            '${_formatPrice(widget.price)} so\'m',
            style: theme.textTheme.labelMedium?.copyWith(
              fontWeight: FontWeight.w800,
              color: AppColors.primary,
              fontSize: 13,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        if (widget.oldPrice != null) ...[
          const SizedBox(width: 4),
          Text(
            '${_formatPrice(widget.oldPrice!)}',
            style: theme.textTheme.labelSmall?.copyWith(
              color: AppColors.textHint,
              decoration: TextDecoration.lineThrough,
              fontSize: 10,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildCartButton(ThemeData theme) {
    if (_quantity == 0) {
      return ScaleTransition(
        scale: _addAnimation,
        child: GestureDetector(
          onTap: _addToCart,
          child: Container(
            height: 36,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.add_rounded, color: Colors.white, size: 16),
                  SizedBox(width: 4),
                  Text(
                    'Qo\'shish',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontFamily: 'NunitoSans',
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    return Container(
      height: 36,
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.primary, width: 1.5),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          GestureDetector(
            onTap: _decreaseQty,
            child: const Padding(
              padding: EdgeInsets.all(8),
              child: Icon(Icons.remove_rounded, color: AppColors.primary, size: 16),
            ),
          ),
          Text(
            '$_quantity',
            style: const TextStyle(
              fontFamily: 'NunitoSans',
              fontWeight: FontWeight.w800,
              fontSize: 15,
              color: AppColors.primary,
            ),
          ),
          GestureDetector(
            onTap: _addToCart,
            child: const Padding(
              padding: EdgeInsets.all(8),
              child: Icon(Icons.add_rounded, color: AppColors.primary, size: 16),
            ),
          ),
        ],
      ),
    );
  }
}
