import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

// ============================================================
// BARAKA MARKET — Promo Info Strip
// ============================================================

class HomePromoStrip extends StatelessWidget {
  const HomePromoStrip({super.key});

  static const _items = [
    _PromoItem(icon: '🚀', text: '30 daqiqada yetkazamiz'),
    _PromoItem(icon: '🔒', text: 'Xavfsiz to\'lov'),
    _PromoItem(icon: '↩️', text: 'Oson qaytarish'),
    _PromoItem(icon: '🎁', text: 'Bonus balllar'),
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.fromLTRB(20, 8, 20, 4),
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isDark ? AppColors.darkOutline : AppColors.outline,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: _items.map((item) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(item.icon, style: const TextStyle(fontSize: 20)),
              const SizedBox(height: 4),
              Text(
                item.text,
                style: theme.textTheme.labelSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  fontSize: 9.5,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          );
        }).toList(),
      ),
    );
  }
}

class _PromoItem {
  final String icon;
  final String text;
  const _PromoItem({required this.icon, required this.text});
}
