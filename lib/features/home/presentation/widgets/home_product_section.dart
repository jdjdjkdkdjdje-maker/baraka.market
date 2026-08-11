import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../shared/router/app_router.dart';
import '../../../home/presentation/screens/home_screen.dart';
import '../../../products/presentation/widgets/product_card.dart';

// ============================================================
// BARAKA MARKET — Home Product Section
// Horizontal scrollable product cards with optional countdown
// ============================================================

class HomeProductSection extends StatefulWidget {
  final String title;
  final String? subtitle;
  final bool showTimer;
  final ProductSectionType sectionType;

  const HomeProductSection({
    super.key,
    required this.title,
    this.subtitle,
    this.showTimer = false,
    required this.sectionType,
  });

  @override
  State<HomeProductSection> createState() => _HomeProductSectionState();
}

class _HomeProductSectionState extends State<HomeProductSection> {
  // Flash sale countdown (2 hours from now)
  Duration _remaining = const Duration(hours: 2, minutes: 34, seconds: 15);
  Timer? _timer;

  // Mock products
  final List<_MockProduct> _products = [
    _MockProduct(id: '1', name: "Tuxum (10 dona)", price: 22000, oldPrice: 28000, discount: 21, emoji: '🥚', rating: 4.8),
    _MockProduct(id: '2', name: "Sut 3.5% (1L)", price: 12500, oldPrice: 15000, discount: 17, emoji: '🥛', rating: 4.6),
    _MockProduct(id: '3', name: "Pomidor (1kg)", price: 8000, oldPrice: 10000, discount: 20, emoji: '🍅', rating: 4.9),
    _MockProduct(id: '4', name: "Tovuq go'shti (1kg)", price: 45000, oldPrice: 55000, discount: 18, emoji: '🍗', rating: 4.7),
    _MockProduct(id: '5', name: "Non (Obi non)", price: 3500, emoji: '🍞', rating: 4.5),
    _MockProduct(id: '6', name: "Olma (1kg)", price: 12000, emoji: '🍎', rating: 4.8),
  ];

  @override
  void initState() {
    super.initState();
    if (widget.showTimer) {
      _timer = Timer.periodic(const Duration(seconds: 1), (_) {
        if (_remaining.inSeconds > 0) {
          setState(() => _remaining -= const Duration(seconds: 1));
        } else {
          _timer?.cancel();
        }
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String _pad(int n) => n.toString().padLeft(2, '0');

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.title,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    if (widget.subtitle != null)
                      Text(
                        widget.subtitle!,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                  ],
                ),
              ),
              if (widget.showTimer) _buildTimer(theme),
              if (!widget.showTimer)
                TextButton(
                  onPressed: () {},
                  child: const Text('Barchasi →'),
                ),
            ],
          ),
        ),

        // Products
        SizedBox(
          height: 240,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: _products.length,
            itemBuilder: (context, index) {
              final p = _products[index];
              return ProductCard(
                id: p.id,
                name: p.name,
                price: p.price,
                oldPrice: p.oldPrice,
                discount: p.discount,
                emoji: p.emoji,
                rating: p.rating,
                onTap: () => context.push('/products/${p.id}'),
              );
            },
          ),
        ),
        const SizedBox(height: 4),
      ],
    );
  }

  Widget _buildTimer(ThemeData theme) {
    final h = _pad(_remaining.inHours);
    final m = _pad(_remaining.inMinutes.remainder(60));
    final s = _pad(_remaining.inSeconds.remainder(60));

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.saleBadge.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.saleBadge.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.timer_outlined, color: AppColors.saleBadge, size: 14),
          const SizedBox(width: 4),
          _TimerBlock(value: h),
          Text(':', style: TextStyle(color: AppColors.saleBadge, fontWeight: FontWeight.w700)),
          _TimerBlock(value: m),
          Text(':', style: TextStyle(color: AppColors.saleBadge, fontWeight: FontWeight.w700)),
          _TimerBlock(value: s),
        ],
      ),
    );
  }
}

class _TimerBlock extends StatelessWidget {
  final String value;
  const _TimerBlock({required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
      margin: const EdgeInsets.symmetric(horizontal: 1),
      decoration: BoxDecoration(
        color: AppColors.saleBadge,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        value,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 11,
          fontFamily: 'NunitoSans',
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

class _MockProduct {
  final String id;
  final String name;
  final int price;
  final int? oldPrice;
  final int? discount;
  final String emoji;
  final double rating;

  _MockProduct({
    required this.id,
    required this.name,
    required this.price,
    this.oldPrice,
    this.discount,
    required this.emoji,
    required this.rating,
  });
}
