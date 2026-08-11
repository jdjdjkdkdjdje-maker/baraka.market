import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// ============================================================
// BARAKA MARKET — Premium App Theme
// Material 3, Custom Colors, Professional Design
// ============================================================

class AppColors {
  AppColors._();

  // Primary — Fresh Green
  static const Color primary = Color(0xFF1A8C4E);
  static const Color primaryLight = Color(0xFF4CAF7D);
  static const Color primaryDark = Color(0xFF0D5C32);
  static const Color primaryContainer = Color(0xFFD4EDDA);

  // Secondary — Warm Orange
  static const Color secondary = Color(0xFFFF6B35);
  static const Color secondaryLight = Color(0xFFFF9A72);
  static const Color secondaryDark = Color(0xFFCC4A1A);
  static const Color secondaryContainer = Color(0xFFFFE0D4);

  // Accent — Golden Yellow
  static const Color accent = Color(0xFFFFC300);
  static const Color accentLight = Color(0xFFFFD75C);
  static const Color accentDark = Color(0xFFCC9C00);

  // Semantic
  static const Color error = Color(0xFFE53935);
  static const Color errorLight = Color(0xFFEF9A9A);
  static const Color errorContainer = Color(0xFFFFEBEE);
  static const Color success = Color(0xFF43A047);
  static const Color successLight = Color(0xFFA5D6A7);
  static const Color successContainer = Color(0xFFE8F5E9);
  static const Color warning = Color(0xFFFB8C00);
  static const Color warningContainer = Color(0xFFFFF3E0);
  static const Color info = Color(0xFF1E88E5);
  static const Color infoContainer = Color(0xFFE3F2FD);

  // Neutrals — Light
  static const Color white = Color(0xFFFFFFFF);
  static const Color background = Color(0xFFF5F7F5);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceVariant = Color(0xFFF0F4F1);
  static const Color outline = Color(0xFFE0E8E2);
  static const Color divider = Color(0xFFEEF2EF);

  // Text — Light
  static const Color textPrimary = Color(0xFF1A2B1F);
  static const Color textSecondary = Color(0xFF5A7063);
  static const Color textHint = Color(0xFF9EB8A6);
  static const Color textDisabled = Color(0xFFBDD3C4);

  // Neutrals — Dark
  static const Color darkBackground = Color(0xFF0E1512);
  static const Color darkSurface = Color(0xFF1A231D);
  static const Color darkSurfaceVariant = Color(0xFF243029);
  static const Color darkOutline = Color(0xFF3A4D40);

  // Text — Dark
  static const Color darkTextPrimary = Color(0xFFE8F0EA);
  static const Color darkTextSecondary = Color(0xFF9EB8A6);

  // Special
  static const Color shimmerBase = Color(0xFFE8EFE9);
  static const Color shimmerHighlight = Color(0xFFF5F9F5);
  static const Color darkShimmerBase = Color(0xFF243029);
  static const Color darkShimmerHighlight = Color(0xFF2E3C33);

  // Rating
  static const Color starFilled = Color(0xFFFFC300);
  static const Color starEmpty = Color(0xFFDDE8DE);

  // Sale badge
  static const Color saleBadge = Color(0xFFE53935);
  static const Color newBadge = Color(0xFF1E88E5);
  static const Color hotBadge = Color(0xFFFF6B35);
}

class AppTheme {
  AppTheme._();

  static const String fontFamily = 'NunitoSans';

  // ─── LIGHT THEME ───────────────────────────────────────────
  static ThemeData get light {
    final base = ThemeData(
      useMaterial3: true,
      fontFamily: fontFamily,
      brightness: Brightness.light,
      colorScheme: ColorScheme.light(
        primary: AppColors.primary,
        onPrimary: Colors.white,
        primaryContainer: AppColors.primaryContainer,
        onPrimaryContainer: AppColors.primaryDark,
        secondary: AppColors.secondary,
        onSecondary: Colors.white,
        secondaryContainer: AppColors.secondaryContainer,
        onSecondaryContainer: AppColors.secondaryDark,
        tertiary: AppColors.accent,
        onTertiary: Colors.white,
        error: AppColors.error,
        errorContainer: AppColors.errorContainer,
        surface: AppColors.surface,
        onSurface: AppColors.textPrimary,
        surfaceContainerHighest: AppColors.surfaceVariant,
        outline: AppColors.outline,
        outlineVariant: AppColors.divider,
        background: AppColors.background,
        onBackground: AppColors.textPrimary,
      ),
    );

    return base.copyWith(
      scaffoldBackgroundColor: AppColors.background,
      appBarTheme: _appBarTheme(false),
      elevatedButtonTheme: _elevatedButtonTheme(),
      outlinedButtonTheme: _outlinedButtonTheme(),
      textButtonTheme: _textButtonTheme(),
      inputDecorationTheme: _inputDecorationTheme(false),
      cardTheme: _cardTheme(false),
      chipTheme: _chipTheme(false),
      bottomNavigationBarTheme: _bottomNavTheme(false),
      snackBarTheme: _snackBarTheme(),
      dialogTheme: _dialogTheme(false),
      drawerTheme: DrawerThemeData(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(0),
        ),
      ),
      dividerTheme: DividerThemeData(
        color: AppColors.divider,
        thickness: 1,
        space: 0,
      ),
      textTheme: _textTheme(false),
    );
  }

  // ─── DARK THEME ────────────────────────────────────────────
  static ThemeData get dark {
    final base = ThemeData(
      useMaterial3: true,
      fontFamily: fontFamily,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.dark(
        primary: AppColors.primaryLight,
        onPrimary: AppColors.darkBackground,
        primaryContainer: AppColors.primaryDark,
        onPrimaryContainer: AppColors.primaryLight,
        secondary: AppColors.secondaryLight,
        onSecondary: AppColors.darkBackground,
        secondaryContainer: AppColors.secondaryDark,
        tertiary: AppColors.accentLight,
        error: AppColors.errorLight,
        errorContainer: Color(0xFF5C1A1A),
        surface: AppColors.darkSurface,
        onSurface: AppColors.darkTextPrimary,
        surfaceContainerHighest: AppColors.darkSurfaceVariant,
        outline: AppColors.darkOutline,
        background: AppColors.darkBackground,
        onBackground: AppColors.darkTextPrimary,
      ),
    );

    return base.copyWith(
      scaffoldBackgroundColor: AppColors.darkBackground,
      appBarTheme: _appBarTheme(true),
      elevatedButtonTheme: _elevatedButtonTheme(),
      outlinedButtonTheme: _outlinedButtonTheme(),
      textButtonTheme: _textButtonTheme(),
      inputDecorationTheme: _inputDecorationTheme(true),
      cardTheme: _cardTheme(true),
      chipTheme: _chipTheme(true),
      bottomNavigationBarTheme: _bottomNavTheme(true),
      snackBarTheme: _snackBarTheme(),
      dialogTheme: _dialogTheme(true),
      dividerTheme: DividerThemeData(
        color: AppColors.darkOutline,
        thickness: 1,
        space: 0,
      ),
      textTheme: _textTheme(true),
    );
  }

  // ─── Component Themes ─────────────────────────────────────

  static AppBarTheme _appBarTheme(bool dark) => AppBarTheme(
        elevation: 0,
        scrolledUnderElevation: 1,
        centerTitle: false,
        backgroundColor: dark ? AppColors.darkSurface : AppColors.surface,
        foregroundColor: dark ? AppColors.darkTextPrimary : AppColors.textPrimary,
        systemOverlayStyle: dark
            ? SystemUiOverlayStyle.light.copyWith(
                statusBarColor: Colors.transparent,
                systemNavigationBarColor: AppColors.darkBackground,
              )
            : SystemUiOverlayStyle.dark.copyWith(
                statusBarColor: Colors.transparent,
                systemNavigationBarColor: AppColors.background,
              ),
        titleTextStyle: TextStyle(
          fontFamily: fontFamily,
          fontWeight: FontWeight.w700,
          fontSize: 18,
          color: dark ? AppColors.darkTextPrimary : AppColors.textPrimary,
        ),
      );

  static ElevatedButtonThemeData _elevatedButtonTheme() =>
      ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 0,
          shadowColor: Colors.transparent,
          minimumSize: const Size(double.infinity, 54),
          maximumSize: const Size(double.infinity, 54),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: const TextStyle(
            fontFamily: fontFamily,
            fontWeight: FontWeight.w700,
            fontSize: 16,
            letterSpacing: 0.3,
          ),
        ),
      );

  static OutlinedButtonThemeData _outlinedButtonTheme() =>
      OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          minimumSize: const Size(double.infinity, 54),
          side: const BorderSide(color: AppColors.primary, width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: const TextStyle(
            fontFamily: fontFamily,
            fontWeight: FontWeight.w700,
            fontSize: 16,
          ),
        ),
      );

  static TextButtonThemeData _textButtonTheme() => TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primary,
          textStyle: const TextStyle(
            fontFamily: fontFamily,
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
      );

  static InputDecorationTheme _inputDecorationTheme(bool dark) =>
      InputDecorationTheme(
        filled: true,
        fillColor: dark ? AppColors.darkSurfaceVariant : AppColors.surfaceVariant,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: dark ? AppColors.darkOutline : AppColors.outline,
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.error, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.error, width: 1.5),
        ),
        hintStyle: TextStyle(
          fontFamily: fontFamily,
          color: dark ? AppColors.darkTextSecondary : AppColors.textHint,
          fontSize: 14,
        ),
        labelStyle: TextStyle(
          fontFamily: fontFamily,
          color: dark ? AppColors.darkTextSecondary : AppColors.textSecondary,
          fontSize: 14,
        ),
      );

  static CardTheme _cardTheme(bool dark) => CardTheme(
        elevation: 0,
        color: dark ? AppColors.darkSurface : AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: dark ? AppColors.darkOutline : AppColors.outline,
            width: 1,
          ),
        ),
        margin: EdgeInsets.zero,
      );

  static ChipThemeData _chipTheme(bool dark) => ChipThemeData(
        backgroundColor: dark ? AppColors.darkSurfaceVariant : AppColors.surfaceVariant,
        selectedColor: AppColors.primaryContainer,
        labelStyle: TextStyle(
          fontFamily: fontFamily,
          fontSize: 13,
          fontWeight: FontWeight.w500,
          color: dark ? AppColors.darkTextPrimary : AppColors.textPrimary,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(
            color: dark ? AppColors.darkOutline : AppColors.outline,
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      );

  static BottomNavigationBarThemeData _bottomNavTheme(bool dark) =>
      BottomNavigationBarThemeData(
        backgroundColor: dark ? AppColors.darkSurface : AppColors.surface,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: dark ? AppColors.darkTextSecondary : AppColors.textHint,
        selectedLabelStyle: const TextStyle(
          fontFamily: fontFamily,
          fontWeight: FontWeight.w600,
          fontSize: 11,
        ),
        unselectedLabelStyle: const TextStyle(
          fontFamily: fontFamily,
          fontWeight: FontWeight.w500,
          fontSize: 11,
        ),
        elevation: 8,
        type: BottomNavigationBarType.fixed,
      );

  static SnackBarThemeData _snackBarTheme() => SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        contentTextStyle: const TextStyle(
          fontFamily: fontFamily,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      );

  static DialogTheme _dialogTheme(bool dark) => DialogTheme(
        backgroundColor: dark ? AppColors.darkSurface : AppColors.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        titleTextStyle: TextStyle(
          fontFamily: fontFamily,
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: dark ? AppColors.darkTextPrimary : AppColors.textPrimary,
        ),
        contentTextStyle: TextStyle(
          fontFamily: fontFamily,
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: dark ? AppColors.darkTextSecondary : AppColors.textSecondary,
        ),
      );

  static TextTheme _textTheme(bool dark) {
    final color = dark ? AppColors.darkTextPrimary : AppColors.textPrimary;
    final secondaryColor = dark ? AppColors.darkTextSecondary : AppColors.textSecondary;

    return TextTheme(
      displayLarge: TextStyle(fontFamily: fontFamily, fontSize: 57, fontWeight: FontWeight.w700, color: color),
      displayMedium: TextStyle(fontFamily: fontFamily, fontSize: 45, fontWeight: FontWeight.w700, color: color),
      displaySmall: TextStyle(fontFamily: fontFamily, fontSize: 36, fontWeight: FontWeight.w700, color: color),
      headlineLarge: TextStyle(fontFamily: fontFamily, fontSize: 32, fontWeight: FontWeight.w700, color: color),
      headlineMedium: TextStyle(fontFamily: fontFamily, fontSize: 28, fontWeight: FontWeight.w700, color: color),
      headlineSmall: TextStyle(fontFamily: fontFamily, fontSize: 24, fontWeight: FontWeight.w700, color: color),
      titleLarge: TextStyle(fontFamily: fontFamily, fontSize: 22, fontWeight: FontWeight.w600, color: color),
      titleMedium: TextStyle(fontFamily: fontFamily, fontSize: 16, fontWeight: FontWeight.w600, color: color),
      titleSmall: TextStyle(fontFamily: fontFamily, fontSize: 14, fontWeight: FontWeight.w600, color: color),
      bodyLarge: TextStyle(fontFamily: fontFamily, fontSize: 16, fontWeight: FontWeight.w400, color: color),
      bodyMedium: TextStyle(fontFamily: fontFamily, fontSize: 14, fontWeight: FontWeight.w400, color: color),
      bodySmall: TextStyle(fontFamily: fontFamily, fontSize: 12, fontWeight: FontWeight.w400, color: secondaryColor),
      labelLarge: TextStyle(fontFamily: fontFamily, fontSize: 14, fontWeight: FontWeight.w600, color: color),
      labelMedium: TextStyle(fontFamily: fontFamily, fontSize: 12, fontWeight: FontWeight.w500, color: color),
      labelSmall: TextStyle(fontFamily: fontFamily, fontSize: 11, fontWeight: FontWeight.w500, color: secondaryColor),
    );
  }
}
