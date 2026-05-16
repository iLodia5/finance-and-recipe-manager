import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Brand Colors
  static const Color primary = Color(0xFF9F4122);
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color primaryContainer = Color(0xFFFF8A65);
  static const Color onPrimaryContainer = Color(0xFF752305);

  static const Color secondary = Color(0xFF3C6842);
  static const Color onSecondary = Color(0xFFFFFFFF);
  static const Color secondaryContainer = Color(0xFFBDEFBE);
  static const Color onSecondaryContainer = Color(0xFF426E47);

  static const Color surface = Color(0xFFFFF8F6);
  static const Color onSurface = Color(0xFF2C160E);
  static const Color onSurfaceVariant = Color(0xFF56423C);

  static const Color surfaceContainerLowest = Color(0xFFFFFFFF);
  static const Color surfaceContainerLow = Color(0xFFFFF1ED);
  static const Color surfaceContainer = Color(0xFFFFE9E3);
  static const Color surfaceContainerHigh = Color(0xFFFFE2DA);
  static const Color surfaceContainerHighest = Color(0xFFFFDBD0);

  static const Color outline = Color(0xFF89726B);
  static const Color outlineVariant = Color(0xFFDDC0B8);

  static const Color error = Color(0xFFBA1A1A);
  static const Color onError = Color(0xFFFFFFFF);
  static const Color errorContainer = Color(0xFFFFDAD6);
  static const Color onErrorContainer = Color(0xFF93000A);

  static const Color background = Color(0xFFFFF8F6);
  static const Color onBackground = Color(0xFF2C160E);

  static ThemeData get lightTheme {
    final baseTextTheme = GoogleFonts.plusJakartaSansTextTheme();

    return ThemeData(
      useMaterial3: true,
      colorScheme: const ColorScheme(
        brightness: Brightness.light,
        primary: primary,
        onPrimary: onPrimary,
        primaryContainer: primaryContainer,
        onPrimaryContainer: onPrimaryContainer,
        secondary: secondary,
        onSecondary: onSecondary,
        secondaryContainer: secondaryContainer,
        onSecondaryContainer: onSecondaryContainer,
        surface: surface,
        onSurface: onSurface,
        error: error,
        onError: onError,
        errorContainer: errorContainer,
        onErrorContainer: onErrorContainer,
        outline: outline,
        outlineVariant: outlineVariant,
      ),
      scaffoldBackgroundColor: background,
      textTheme: baseTextTheme.copyWith(
        headlineLarge: baseTextTheme.headlineLarge?.copyWith(
          fontSize: 32,
          fontWeight: FontWeight.w700,
          color: onSurface,
          height: 1.2,
        ),
        headlineMedium: baseTextTheme.headlineMedium?.copyWith(
          fontSize: 24,
          fontWeight: FontWeight.w700,
          color: onSurface,
          height: 1.3,
        ),
        bodyLarge: baseTextTheme.bodyLarge?.copyWith(
          fontSize: 18,
          fontWeight: FontWeight.w500,
          color: onSurface,
          height: 1.6,
        ),
        bodyMedium: baseTextTheme.bodyMedium?.copyWith(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: onSurface,
          height: 1.6,
        ),
        labelSmall: baseTextTheme.labelSmall?.copyWith(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: onSurfaceVariant,
          height: 1.4,
          letterSpacing: 0.02,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryContainer,
          foregroundColor: onPrimaryContainer,
          elevation: 0, // Using custom shadows if needed
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16), // 1rem
          ),
          textStyle: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            fontFamily: 'Plus Jakarta Sans',
          ),
        ),
      ),
      cardTheme: CardThemeData(
        color: surfaceContainerLowest,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: const BorderSide(color: outlineVariant),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFFFEF2CC), // From DESIGN.md
        contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(9999), // Pill shape
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(9999),
          borderSide: const BorderSide(color: primary, width: 2),
        ),
        hintStyle: TextStyle(
          color: onSurfaceVariant.withOpacity(0.7),
        ),
      ),
    );
  }

  // Warm shadow helper
  static List<BoxShadow> get warmShadow => [
        BoxShadow(
          color: const Color(0xFF5D4037).withOpacity(0.08),
          blurRadius: 12,
          offset: const Offset(0, 4),
        ),
      ];

  static List<BoxShadow> get warmShadowLg => [
        BoxShadow(
          color: const Color(0xFF5D4037).withOpacity(0.12),
          blurRadius: 24,
          offset: const Offset(0, 12),
        ),
      ];
}
