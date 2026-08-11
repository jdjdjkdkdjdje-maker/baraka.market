import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../../../core/theme/app_theme.dart';

// ============================================================
// BARAKA MARKET — Home Banner Slider
// ============================================================

class HomeBannerSlider extends StatefulWidget {
  const HomeBannerSlider({super.key});

  @override
  State<HomeBannerSlider> createState() => _HomeBannerSliderState();
}

class _HomeBannerSliderState extends State<HomeBannerSlider> {
  int _currentIndex = 0;

  final List<_BannerData> _banners = [
    _BannerData(
      gradient: [Color(0xFF1A8C4E), Color(0xFF2DB56B)],
      emoji: '🥦',
      title: 'Yangi sabzavotlar',
      subtitle: '40% chegirma',
      tag: 'Bugun',
    ),
    _BannerData(
      gradient: [Color(0xFF1565C0), Color(0xFF1E88E5)],
      emoji: '🥛',
      title: 'Sut mahsulotlari',
      subtitle: '2 ta oling, 3-si bepul!',
      tag: 'Aksiya',
    ),
    _BannerData(
      gradient: [Color(0xFF6A1B9A), Color(0xFFAB47BC)],
      emoji: '🍇',
      title: 'Mevalar festivali',
      subtitle: '20% chegirma',
      tag: 'Yangi',
    ),
    _BannerData(
      gradient: [Color(0xFFE65100), Color(0xFFFF6B35)],
      emoji: '🍕',
      title: 'Tayyor ovqatlar',
      subtitle: '30 daqiqada yetkazamiz!',
      tag: 'Ekspress',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CarouselSlider.builder(
          itemCount: _banners.length,
          itemBuilder: (context, index, realIndex) {
            final banner = _banners[index];
            return _BannerCard(data: banner);
          },
          options: CarouselOptions(
            height: 180,
            viewportFraction: 0.92,
            enlargeCenterPage: true,
            enlargeFactor: 0.05,
            autoPlay: true,
            autoPlayInterval: const Duration(seconds: 4),
            autoPlayAnimationDuration: const Duration(milliseconds: 600),
            autoPlayCurve: Curves.easeInOutCubic,
            onPageChanged: (index, reason) =>
                setState(() => _currentIndex = index),
          ),
        ),
        const SizedBox(height: 12),
        AnimatedSmoothIndicator(
          activeIndex: _currentIndex,
          count: _banners.length,
          effect: ExpandingDotsEffect(
            dotHeight: 6,
            dotWidth: 6,
            expansionFactor: 4,
            spacing: 6,
            activeDotColor: AppColors.primary,
            dotColor: AppColors.outline,
          ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}

class _BannerCard extends StatelessWidget {
  final _BannerData data;
  const _BannerCard({required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: data.gradient,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: data.gradient.first.withOpacity(0.35),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Background decoration
          Positioned(
            right: -30,
            top: -30,
            child: Container(
              width: 160,
              height: 160,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.08),
              ),
            ),
          ),
          Positioned(
            right: 20,
            bottom: -20,
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.06),
              ),
            ),
          ),

          // Content
          Padding(
            padding: const EdgeInsets.all(22),
            child: Row(
              children: [
                Expanded(
                  flex: 6,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          data.tag,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontFamily: 'NunitoSans',
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        data.title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontFamily: 'NunitoSans',
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        data.subtitle,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.85),
                          fontSize: 13,
                          fontFamily: 'NunitoSans',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 14),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          'Ko\'rish →',
                          style: TextStyle(
                            color: data.gradient.first,
                            fontSize: 12,
                            fontFamily: 'NunitoSans',
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 4,
                  child: Text(
                    data.emoji,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 70),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _BannerData {
  final List<Color> gradient;
  final String emoji;
  final String title;
  final String subtitle;
  final String tag;

  _BannerData({
    required this.gradient,
    required this.emoji,
    required this.title,
    required this.subtitle,
    required this.tag,
  });
}
