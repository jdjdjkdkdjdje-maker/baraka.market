// ============================================================
// BARAKA MARKET — App Constants
// ============================================================

class AppConstants {
  AppConstants._();

  // App Info
  static const String appName = 'Baraka Market';
  static const String appVersion = '1.0.0';
  static const String packageName = 'uz.baraka.market';

  // API
  static const String baseUrl = 'https://api.barakamarket.uz/v1';
  static const String wsUrl = 'wss://api.barakamarket.uz/ws';
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);

  // Storage Keys
  static const String accessTokenKey = 'access_token';
  static const String refreshTokenKey = 'refresh_token';
  static const String userKey = 'user_data';
  static const String themeKey = 'app_theme';
  static const String languageKey = 'app_language';
  static const String onboardingKey = 'onboarding_shown';
  static const String cartKey = 'cart_data';

  // Pagination
  static const int defaultPageSize = 20;
  static const int searchPageSize = 10;

  // Cache Duration
  static const Duration cacheExpiry = Duration(hours: 1);
  static const Duration categoryCacheExpiry = Duration(hours: 6);
  static const Duration productCacheExpiry = Duration(minutes: 30);

  // OTP
  static const int otpLength = 6;
  static const int otpExpiry = 120; // seconds
  static const int otpMaxAttempts = 3;

  // Maps
  static const String googleMapsApiKey = 'YOUR_GOOGLE_MAPS_KEY';
  static const double defaultLat = 41.2995;
  static const double defaultLng = 69.2401;

  // Image
  static const int maxImageSize = 5 * 1024 * 1024; // 5MB
  static const List<String> allowedImageTypes = ['jpg', 'jpeg', 'png', 'webp'];

  // Loyalty
  static const int pointsPerThousandSom = 1;
  static const int pointValueInSom = 10;

  // Delivery
  static const int freeDeliveryThreshold = 100000; // 100k som
  static const int standardDeliveryFee = 15000;

  // Animation Duration
  static const Duration shortAnimation = Duration(milliseconds: 200);
  static const Duration normalAnimation = Duration(milliseconds: 350);
  static const Duration longAnimation = Duration(milliseconds: 500);

  // Brand Colors
  static const String primaryColorHex = '#1A8C4E';
  static const String secondaryColorHex = '#FF6B35';
  static const String accentColorHex = '#FFC300';
}
