import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../shared/router/app_router.dart';

// ============================================================
// BARAKA MARKET — Splash Screen
// Premium animated splash with logo reveal
// ============================================================

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _particleController;

  @override
  void initState() {
    super.initState();
    _particleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();

    _navigate();
  }

  Future<void> _navigate() async {
    await Future.delayed(const Duration(milliseconds: 2800));
    if (!mounted) return;

    // TODO: Check auth state via Riverpod
    // final authState = ref.read(authProvider);
    // if (authState.isAuthenticated) {
    //   context.go(AppRoutes.home);
    // } else {
    context.go(AppRoutes.onboarding);
    // }
  }

  @override
  void dispose() {
    _particleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF0D5C32),
              Color(0xFF1A8C4E),
              Color(0xFF2DB56B),
            ],
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              // Background circles
              ..._buildBackgroundCircles(),

              // Center content
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Logo
                    _buildLogo(),
                    const SizedBox(height: 24),

                    // App name
                    _buildAppName(),
                    const SizedBox(height: 8),

                    // Tagline
                    _buildTagline(),
                  ],
                ),
              ),

              // Bottom loader
              Positioned(
                bottom: 60,
                left: 0,
                right: 0,
                child: _buildLoader(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildBackgroundCircles() {
    return [
      Positioned(
        top: -60,
        right: -60,
        child: Container(
          width: 220,
          height: 220,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white.withOpacity(0.05),
          ),
        ),
      ).animate().scale(
            duration: 1.2.seconds,
            curve: Curves.easeOut,
            begin: const Offset(0.5, 0.5),
          ),
      Positioned(
        bottom: -80,
        left: -80,
        child: Container(
          width: 300,
          height: 300,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white.withOpacity(0.05),
          ),
        ),
      ).animate().scale(
            duration: 1.4.seconds,
            curve: Curves.easeOut,
            begin: const Offset(0.3, 0.3),
          ),
    ];
  }

  Widget _buildLogo() {
    return Container(
      width: 110,
      height: 110,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 30,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Center(
        child: Text(
          '🛒',
          style: const TextStyle(fontSize: 54),
        ),
      ),
    )
        .animate()
        .scale(
          duration: 700.ms,
          curve: Curves.elasticOut,
          begin: const Offset(0, 0),
        )
        .fadeIn(duration: 400.ms);
  }

  Widget _buildAppName() {
    return const Text(
      'Baraka Market',
      style: TextStyle(
        fontFamily: 'NunitoSans',
        fontSize: 32,
        fontWeight: FontWeight.w800,
        color: Colors.white,
        letterSpacing: 0.5,
      ),
    )
        .animate()
        .slideY(
          begin: 0.3,
          end: 0,
          duration: 600.ms,
          delay: 400.ms,
          curve: Curves.easeOut,
        )
        .fadeIn(duration: 500.ms, delay: 400.ms);
  }

  Widget _buildTagline() {
    return const Text(
      'Yangi sifat, yangi narx',
      style: TextStyle(
        fontFamily: 'NunitoSans',
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: Colors.white70,
        letterSpacing: 1.2,
      ),
    )
        .animate()
        .fadeIn(duration: 600.ms, delay: 700.ms);
  }

  Widget _buildLoader() {
    return Center(
      child: SizedBox(
        width: 200,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            backgroundColor: Colors.white.withOpacity(0.2),
            valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
            minHeight: 3,
          ),
        ),
      ),
    ).animate().fadeIn(delay: 1.seconds, duration: 400.ms);
  }
}
