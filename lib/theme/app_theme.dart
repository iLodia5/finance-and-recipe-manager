import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:finance_track/services/settings_service.dart';

class AppTheme {
  // Underlying Light Colors
  static const Color _primaryLight = Color(0xFF9F4122);
  static const Color _onPrimaryLight = Color(0xFFFFFFFF);
  static const Color _primaryContainerLight = Color(0xFFFF8A65);
  static const Color _onPrimaryContainerLight = Color(0xFF752305);

  static const Color _secondaryLight = Color(0xFF3C6842);
  static const Color _onSecondaryLight = Color(0xFFFFFFFF);
  static const Color _secondaryContainerLight = Color(0xFFBDEFBE);
  static const Color _onSecondaryContainerLight = Color(0xFF426E47);

  static const Color _surfaceLight = Color(0xFFFFF8F6);
  static const Color _onSurfaceLight = Color(0xFF2C160E);
  static const Color _onSurfaceVariantLight = Color(0xFF56423C);

  static const Color _surfaceContainerLowestLight = Color(0xFFFFFFFF);
  static const Color _surfaceContainerLowLight = Color(0xFFFFF1ED);
  static const Color _surfaceContainerLight = Color(0xFFFFE9E3);
  static const Color _surfaceContainerHighLight = Color(0xFFFFE2DA);
  static const Color _surfaceContainerHighestLight = Color(0xFFFFDBD0);

  static const Color _outlineLight = Color(0xFF89726B);
  static const Color _outlineVariantLight = Color(0xFFDDC0B8);

  static const Color _errorLight = Color(0xFFBA1A1A);
  static const Color _onErrorLight = Color(0xFFFFFFFF);
  static const Color _errorContainerLight = Color(0xFFFFDAD6);
  static const Color _onErrorContainerLight = Color(0xFF93000A);

  static const Color _backgroundLight = Color(0xFFFFF8F6);
  static const Color _onBackgroundLight = Color(0xFF2C160E);

  // Underlying Cozy Cozy Dark Colors (Chocolate & Glow Accent)
  static const Color _primaryDark = Color(0xFFFFB59B);
  static const Color _onPrimaryDark = Color(0xFF5B1A00);
  static const Color _primaryContainerDark = Color(0xFF9F4122);
  static const Color _onPrimaryContainerDark = Color(0xFFFFDBD0);

  static const Color _secondaryDark = Color(0xFF81C784);
  static const Color _onSecondaryDark = Color(0xFF00390B);
  static const Color _secondaryContainerDark = Color(0xFF254E2C);
  static const Color _onSecondaryContainerDark = Color(0xFFC8E6C9);

  static const Color _surfaceDark = Color(0xFF271812);
  static const Color _onSurfaceDark = Color(0xFFFBECE8);
  static const Color _onSurfaceVariantDark = Color(0xFFDDC0B8);

  static const Color _surfaceContainerLowestDark = Color(0xFF150804);
  static const Color _surfaceContainerLowDark = Color(0xFF23140E);
  static const Color _surfaceContainerDark = Color(0xFF2E1E18);
  static const Color _surfaceContainerHighDark = Color(0xFF3B2922);
  static const Color _surfaceContainerHighestDark = Color(0xFF48342D);

  static const Color _outlineDark = Color(0xFF9F857E);
  static const Color _outlineVariantDark = Color(0xFF56423C);

  static const Color _errorDark = Color(0xFFFFB4AB);
  static const Color _onErrorDark = Color(0xFF690005);
  static const Color _errorContainerDark = Color(0xFF93000A);
  static const Color _onErrorContainerDark = Color(0xFFFFDAD6);

  static const Color _backgroundDark = Color(0xFF1B0D08);
  static const Color _onBackgroundDark = Color(0xFFFBECE8);

  // Dynamic Theme Helpers
  static bool get isDark =>
      SettingsService.themeNotifier.value == ThemeMode.dark;

  // Dynamic Brand Colors
  static Color get primary => isDark ? _primaryDark : _primaryLight;
  static Color get onPrimary => isDark ? _onPrimaryDark : _onPrimaryLight;
  static Color get primaryContainer =>
      isDark ? _primaryContainerDark : _primaryContainerLight;
  static Color get onPrimaryContainer =>
      isDark ? _onPrimaryContainerDark : _onPrimaryContainerLight;

  static Color get secondary => isDark ? _secondaryDark : _secondaryLight;
  static Color get onSecondary => isDark ? _onSecondaryDark : _onSecondaryLight;
  static Color get secondaryContainer =>
      isDark ? _secondaryContainerDark : _secondaryContainerLight;
  static Color get onSecondaryContainer =>
      isDark ? _onSecondaryContainerDark : _onSecondaryContainerLight;

  static Color get surface => isDark ? _surfaceDark : _surfaceLight;
  static Color get onSurface => isDark ? _onSurfaceDark : _onSurfaceLight;
  static Color get onSurfaceVariant =>
      isDark ? _onSurfaceVariantDark : _onSurfaceVariantLight;

  static Color get surfaceContainerLowest =>
      isDark ? _surfaceContainerLowestDark : _surfaceContainerLowestLight;
  static Color get surfaceContainerLow =>
      isDark ? _surfaceContainerLowDark : _surfaceContainerLowLight;
  static Color get surfaceContainer =>
      isDark ? _surfaceContainerDark : _surfaceContainerLight;
  static Color get surfaceContainerHigh =>
      isDark ? _surfaceContainerHighDark : _surfaceContainerHighLight;
  static Color get surfaceContainerHighest =>
      isDark ? _surfaceContainerHighestDark : _surfaceContainerHighestLight;

  static Color get outline => isDark ? _outlineDark : _outlineLight;
  static Color get outlineVariant =>
      isDark ? _outlineVariantDark : _outlineVariantLight;

  static Color get error => isDark ? _errorDark : _errorLight;
  static Color get onError => isDark ? _onErrorDark : _onErrorLight;
  static Color get errorContainer =>
      isDark ? _errorContainerDark : _errorContainerLight;
  static Color get onErrorContainer =>
      isDark ? _onErrorContainerDark : _onErrorContainerLight;

  static Color get background => isDark ? _backgroundDark : _backgroundLight;
  static Color get onBackground =>
      isDark ? _onBackgroundDark : _onBackgroundLight;

  // Static Light Theme Setup
  static ThemeData get lightTheme {
    final baseTextTheme = GoogleFonts.plusJakartaSansTextTheme();

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: const ColorScheme(
        brightness: Brightness.light,
        primary: _primaryLight,
        onPrimary: _onPrimaryLight,
        primaryContainer: _primaryContainerLight,
        onPrimaryContainer: _onPrimaryContainerLight,
        secondary: _secondaryLight,
        onSecondary: _onSecondaryLight,
        secondaryContainer: _secondaryContainerLight,
        onSecondaryContainer: _onSecondaryContainerLight,
        surface: _surfaceLight,
        onSurface: _onSurfaceLight,
        error: _errorLight,
        onError: _onErrorLight,
        errorContainer: _errorContainerLight,
        onErrorContainer: _onErrorContainerLight,
        outline: _outlineLight,
        outlineVariant: _outlineVariantLight,
      ),
      scaffoldBackgroundColor: _backgroundLight,
      textTheme: baseTextTheme.copyWith(
        headlineLarge: baseTextTheme.headlineLarge?.copyWith(
          fontSize: 32,
          fontWeight: FontWeight.w700,
          color: _onSurfaceLight,
          height: 1.2,
        ),
        headlineMedium: baseTextTheme.headlineMedium?.copyWith(
          fontSize: 24,
          fontWeight: FontWeight.w700,
          color: _onSurfaceLight,
          height: 1.3,
        ),
        bodyLarge: baseTextTheme.bodyLarge?.copyWith(
          fontSize: 18,
          fontWeight: FontWeight.w500,
          color: _onSurfaceLight,
          height: 1.6,
        ),
        bodyMedium: baseTextTheme.bodyMedium?.copyWith(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: _onSurfaceLight,
          height: 1.6,
        ),
        labelSmall: baseTextTheme.labelSmall?.copyWith(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: _onSurfaceVariantLight,
          height: 1.4,
          letterSpacing: 0.02,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: _primaryContainerLight,
          foregroundColor: _onPrimaryContainerLight,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            fontFamily: 'Plus Jakarta Sans',
          ),
        ),
      ),
      cardTheme: CardThemeData(
        color: _surfaceContainerLowestLight,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: const BorderSide(color: _outlineVariantLight),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFFFEF2CC),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 20,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(9999),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(9999),
          borderSide: const BorderSide(color: _primaryLight, width: 2),
        ),
        hintStyle: TextStyle(
          color: _onSurfaceVariantLight.withValues(alpha: 0.7),
        ),
      ),
    );
  }

  // Cozy Dark Theme Setup
  static ThemeData get darkTheme {
    final baseTextTheme = GoogleFonts.plusJakartaSansTextTheme();

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: const ColorScheme(
        brightness: Brightness.dark,
        primary: _primaryDark,
        onPrimary: _onPrimaryDark,
        primaryContainer: _primaryContainerDark,
        onPrimaryContainer: _onPrimaryContainerDark,
        secondary: _secondaryDark,
        onSecondary: _onSecondaryDark,
        secondaryContainer: _secondaryContainerDark,
        onSecondaryContainer: _onSecondaryContainerDark,
        surface: _surfaceDark,
        onSurface: _onSurfaceDark,
        error: _errorDark,
        onError: _onErrorDark,
        errorContainer: _errorDark, // maps matching container correctly
        onErrorContainer: _onErrorContainerDark,
        outline: _outlineDark,
        outlineVariant: _outlineVariantDark,
      ),
      scaffoldBackgroundColor: _backgroundDark,
      textTheme: baseTextTheme.copyWith(
        headlineLarge: baseTextTheme.headlineLarge?.copyWith(
          fontSize: 32,
          fontWeight: FontWeight.w700,
          color: _onSurfaceDark,
          height: 1.2,
        ),
        headlineMedium: baseTextTheme.headlineMedium?.copyWith(
          fontSize: 24,
          fontWeight: FontWeight.w700,
          color: _onSurfaceDark,
          height: 1.3,
        ),
        bodyLarge: baseTextTheme.bodyLarge?.copyWith(
          fontSize: 18,
          fontWeight: FontWeight.w500,
          color: _onSurfaceDark,
          height: 1.6,
        ),
        bodyMedium: baseTextTheme.bodyMedium?.copyWith(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: _onSurfaceDark,
          height: 1.6,
        ),
        labelSmall: baseTextTheme.labelSmall?.copyWith(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: _onSurfaceVariantDark,
          height: 1.4,
          letterSpacing: 0.02,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: _primaryContainerDark,
          foregroundColor: _onPrimaryContainerDark,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            fontFamily: 'Plus Jakarta Sans',
          ),
        ),
      ),
      cardTheme: CardThemeData(
        color: _surfaceContainerLowestDark,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: const BorderSide(color: _outlineVariantDark),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFF33221B),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 20,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(9999),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(9999),
          borderSide: const BorderSide(color: _primaryDark, width: 2),
        ),
        hintStyle: TextStyle(
          color: _onSurfaceVariantDark.withValues(alpha: 0.7),
        ),
      ),
    );
  }

  // Warm shadow helpers
  static List<BoxShadow> get warmShadow => [
    BoxShadow(
      color: isDark
          ? Colors.black.withValues(alpha: 0.3)
          : const Color(0xFF5D4037).withValues(alpha: 0.08),
      blurRadius: 12,
      offset: const Offset(0, 4),
    ),
  ];

  static List<BoxShadow> get warmShadowLg => [
    BoxShadow(
      color: isDark
          ? Colors.black.withValues(alpha: 0.45)
          : const Color(0xFF5D4037).withValues(alpha: 0.12),
      blurRadius: 24,
      offset: const Offset(0, 12),
    ),
  ];
}
