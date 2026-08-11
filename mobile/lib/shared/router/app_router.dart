import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// ============================================================
// BARAKA MARKET — App Router (GoRouter)
// ============================================================

// Route names
class AppRoutes {
  AppRoutes._();

  // Auth
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String otp = '/otp';
  static const String register = '/register';

  // Main Shell
  static const String home = '/home';
  static const String catalog = '/catalog';
  static const String cart = '/cart';
  static const String orders = '/orders';
  static const String profile = '/profile';

  // Products
  static const String productDetail = '/products/:id';
  static const String categoryProducts = '/category/:id/products';
  static const String brandProducts = '/brand/:id/products';
  static const String search = '/search';

  // Orders
  static const String orderDetail = '/orders/:id';
  static const String orderTracking = '/orders/:id/tracking';
  static const String checkout = '/checkout';
  static const String orderSuccess = '/order-success';

  // Profile
  static const String editProfile = '/profile/edit';
  static const String addresses = '/profile/addresses';
  static const String addAddress = '/profile/addresses/add';
  static const String wishlist = '/wishlist';
  static const String reviewHistory = '/profile/reviews';

  // Wallet & Loyalty
  static const String wallet = '/wallet';
  static const String walletTopup = '/wallet/topup';
  static const String loyalty = '/loyalty';

  // Notifications
  static const String notifications = '/notifications';

  // Support
  static const String support = '/support';
  static const String chat = '/chat/:sessionId';

  // Settings
  static const String settings = '/settings';
  static const String language = '/settings/language';
  static const String theme = '/settings/theme';

  // Payment
  static const String payment = '/payment';

  // Scanner
  static const String scanner = '/scanner';

  // Returns
  static const String orderReturn = '/orders/:id/return';

  // Gift Cards
  static const String giftCards = '/gift-cards';

  // Promo
  static const String promotions = '/promotions';
  static const String coupon = '/coupon';
}

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: AppRoutes.splash,
    debugLogDiagnostics: true,
    redirect: (context, state) {
      // TODO: Add auth redirect logic
      return null;
    },
    routes: [
      // ─── Splash ────────────────────────────
      GoRoute(
        path: AppRoutes.splash,
        builder: (context, state) => const SplashScreen(),
      ),

      // ─── Onboarding ────────────────────────
      GoRoute(
        path: AppRoutes.onboarding,
        pageBuilder: (context, state) => _buildSlideTransition(
          state: state,
          child: const OnboardingScreen(),
        ),
      ),

      // ─── Auth ──────────────────────────────
      GoRoute(
        path: AppRoutes.login,
        pageBuilder: (context, state) => _buildSlideTransition(
          state: state,
          child: const LoginScreen(),
        ),
      ),
      GoRoute(
        path: AppRoutes.otp,
        pageBuilder: (context, state) => _buildSlideTransition(
          state: state,
          child: OtpScreen(
            phone: state.extra as String? ?? '',
          ),
        ),
      ),

      // ─── Main Shell (Bottom Nav) ─────────────────────────
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) => MainShell(child: child),
        routes: [
          GoRoute(
            path: AppRoutes.home,
            builder: (context, state) => const HomeScreen(),
            routes: [
              GoRoute(
                path: 'promotions',
                builder: (context, state) => const PromotionsScreen(),
              ),
            ],
          ),
          GoRoute(
            path: AppRoutes.catalog,
            builder: (context, state) => const CatalogScreen(),
          ),
          GoRoute(
            path: AppRoutes.cart,
            builder: (context, state) => const CartScreen(),
          ),
          GoRoute(
            path: AppRoutes.orders,
            builder: (context, state) => const OrdersScreen(),
          ),
          GoRoute(
            path: AppRoutes.profile,
            builder: (context, state) => const ProfileScreen(),
          ),
        ],
      ),

      // ─── Products ──────────────────────────
      GoRoute(
        path: AppRoutes.productDetail,
        pageBuilder: (context, state) => _buildFadeTransition(
          state: state,
          child: ProductDetailScreen(
            productId: state.pathParameters['id']!,
          ),
        ),
      ),
      GoRoute(
        path: AppRoutes.search,
        pageBuilder: (context, state) => _buildSlideTransition(
          state: state,
          child: const SearchScreen(),
        ),
      ),
      GoRoute(
        path: AppRoutes.categoryProducts,
        pageBuilder: (context, state) => _buildSlideTransition(
          state: state,
          child: CategoryProductsScreen(
            categoryId: state.pathParameters['id']!,
          ),
        ),
      ),

      // ─── Checkout ──────────────────────────
      GoRoute(
        path: AppRoutes.checkout,
        pageBuilder: (context, state) => _buildSlideTransition(
          state: state,
          child: const CheckoutScreen(),
        ),
      ),
      GoRoute(
        path: AppRoutes.orderSuccess,
        pageBuilder: (context, state) => _buildFadeTransition(
          state: state,
          child: const OrderSuccessScreen(),
        ),
      ),

      // ─── Order Detail & Tracking ────────────
      GoRoute(
        path: AppRoutes.orderDetail,
        builder: (context, state) => OrderDetailScreen(
          orderId: state.pathParameters['id']!,
        ),
      ),
      GoRoute(
        path: AppRoutes.orderTracking,
        builder: (context, state) => OrderTrackingScreen(
          orderId: state.pathParameters['id']!,
        ),
      ),

      // ─── Profile Sub-routes ─────────────────
      GoRoute(
        path: AppRoutes.editProfile,
        builder: (context, state) => const EditProfileScreen(),
      ),
      GoRoute(
        path: AppRoutes.addresses,
        builder: (context, state) => const AddressesScreen(),
      ),
      GoRoute(
        path: AppRoutes.addAddress,
        builder: (context, state) => const AddAddressScreen(),
      ),
      GoRoute(
        path: AppRoutes.wishlist,
        builder: (context, state) => const WishlistScreen(),
      ),

      // ─── Wallet ─────────────────────────────
      GoRoute(
        path: AppRoutes.wallet,
        builder: (context, state) => const WalletScreen(),
      ),

      // ─── Notifications ──────────────────────
      GoRoute(
        path: AppRoutes.notifications,
        builder: (context, state) => const NotificationsScreen(),
      ),

      // ─── Scanner ────────────────────────────
      GoRoute(
        path: AppRoutes.scanner,
        builder: (context, state) => const ScannerScreen(),
      ),

      // ─── Settings ───────────────────────────
      GoRoute(
        path: AppRoutes.settings,
        builder: (context, state) => const SettingsScreen(),
      ),

      // ─── Support ────────────────────────────
      GoRoute(
        path: AppRoutes.support,
        builder: (context, state) => const SupportScreen(),
      ),
    ],
    errorBuilder: (context, state) => const NotFoundScreen(),
  );
});

// Transition Builders
CustomTransitionPage<void> _buildSlideTransition({
  required GoRouterState state,
  required Widget child,
}) {
  return CustomTransitionPage<void>(
    key: state.pageKey,
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final tween = Tween(begin: const Offset(1.0, 0.0), end: Offset.zero)
          .chain(CurveTween(curve: Curves.easeInOutCubic));
      return SlideTransition(position: animation.drive(tween), child: child);
    },
    transitionDuration: const Duration(milliseconds: 300),
  );
}

CustomTransitionPage<void> _buildFadeTransition({
  required GoRouterState state,
  required Widget child,
}) {
  return CustomTransitionPage<void>(
    key: state.pageKey,
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(opacity: animation, child: child);
    },
    transitionDuration: const Duration(milliseconds: 300),
  );
}

// Placeholder screen references (implemented in their respective feature folders)
class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});
  @override
  Widget build(BuildContext context) => const Scaffold();
}
class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});
  @override
  Widget build(BuildContext context) => const Scaffold();
}
class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});
  @override
  Widget build(BuildContext context) => const Scaffold();
}
class OtpScreen extends StatelessWidget {
  final String phone;
  const OtpScreen({super.key, required this.phone});
  @override
  Widget build(BuildContext context) => const Scaffold();
}
class MainShell extends StatelessWidget {
  final Widget child;
  const MainShell({super.key, required this.child});
  @override
  Widget build(BuildContext context) => child;
}
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  @override
  Widget build(BuildContext context) => const Scaffold();
}
class CatalogScreen extends StatelessWidget {
  const CatalogScreen({super.key});
  @override
  Widget build(BuildContext context) => const Scaffold();
}
class CartScreen extends StatelessWidget {
  const CartScreen({super.key});
  @override
  Widget build(BuildContext context) => const Scaffold();
}
class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});
  @override
  Widget build(BuildContext context) => const Scaffold();
}
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});
  @override
  Widget build(BuildContext context) => const Scaffold();
}
class ProductDetailScreen extends StatelessWidget {
  final String productId;
  const ProductDetailScreen({super.key, required this.productId});
  @override
  Widget build(BuildContext context) => const Scaffold();
}
class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});
  @override
  Widget build(BuildContext context) => const Scaffold();
}
class CategoryProductsScreen extends StatelessWidget {
  final String categoryId;
  const CategoryProductsScreen({super.key, required this.categoryId});
  @override
  Widget build(BuildContext context) => const Scaffold();
}
class CheckoutScreen extends StatelessWidget {
  const CheckoutScreen({super.key});
  @override
  Widget build(BuildContext context) => const Scaffold();
}
class OrderSuccessScreen extends StatelessWidget {
  const OrderSuccessScreen({super.key});
  @override
  Widget build(BuildContext context) => const Scaffold();
}
class OrderDetailScreen extends StatelessWidget {
  final String orderId;
  const OrderDetailScreen({super.key, required this.orderId});
  @override
  Widget build(BuildContext context) => const Scaffold();
}
class OrderTrackingScreen extends StatelessWidget {
  final String orderId;
  const OrderTrackingScreen({super.key, required this.orderId});
  @override
  Widget build(BuildContext context) => const Scaffold();
}
class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});
  @override
  Widget build(BuildContext context) => const Scaffold();
}
class AddressesScreen extends StatelessWidget {
  const AddressesScreen({super.key});
  @override
  Widget build(BuildContext context) => const Scaffold();
}
class AddAddressScreen extends StatelessWidget {
  const AddAddressScreen({super.key});
  @override
  Widget build(BuildContext context) => const Scaffold();
}
class WishlistScreen extends StatelessWidget {
  const WishlistScreen({super.key});
  @override
  Widget build(BuildContext context) => const Scaffold();
}
class WalletScreen extends StatelessWidget {
  const WalletScreen({super.key});
  @override
  Widget build(BuildContext context) => const Scaffold();
}
class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});
  @override
  Widget build(BuildContext context) => const Scaffold();
}
class ScannerScreen extends StatelessWidget {
  const ScannerScreen({super.key});
  @override
  Widget build(BuildContext context) => const Scaffold();
}
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});
  @override
  Widget build(BuildContext context) => const Scaffold();
}
class SupportScreen extends StatelessWidget {
  const SupportScreen({super.key});
  @override
  Widget build(BuildContext context) => const Scaffold();
}
class PromotionsScreen extends StatelessWidget {
  const PromotionsScreen({super.key});
  @override
  Widget build(BuildContext context) => const Scaffold();
}
class NotFoundScreen extends StatelessWidget {
  const NotFoundScreen({super.key});
  @override
  Widget build(BuildContext context) => const Scaffold();
}
