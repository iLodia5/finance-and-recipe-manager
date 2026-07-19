import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:ui';

class SettingsService {
  static const String _localeKey = 'locale_language_code';
  static const String _themeKey = 'theme_mode_dark';
  static const String _userNameKey = 'global_user_name';
  static const String _hasCompletedOnboardingKey = 'has_completed_onboarding';

  static final ValueNotifier<Locale> localeNotifier = ValueNotifier(
    const Locale('en'),
  );
  static final ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(
    ThemeMode.light,
  );
  static final ValueNotifier<String?> userNameNotifier = ValueNotifier(null);
  static final ValueNotifier<bool> hasCompletedOnboardingNotifier = ValueNotifier(false);

  static Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();

    // Locale initialization
    final savedCode = prefs.getString(_localeKey);
    if (savedCode != null) {
      localeNotifier.value = Locale(savedCode);
    } else {
      // First install: detect system language
      final systemLocale = PlatformDispatcher.instance.locale.languageCode;
      final defaultLang = (systemLocale.toLowerCase() == 'ar') ? 'ar' : 'en';
      await prefs.setString(_localeKey, defaultLang);
      localeNotifier.value = Locale(defaultLang);
    }

    // Theme initialization
    final savedTheme = prefs.getBool(_themeKey);
    if (savedTheme != null) {
      themeNotifier.value = savedTheme ? ThemeMode.dark : ThemeMode.light;
    } else {
      themeNotifier.value = ThemeMode.light;
    }

    // User name initialization
    final savedName = prefs.getString(_userNameKey);
    userNameNotifier.value = savedName;

    // Onboarding status initialization
    final savedOnboarding = prefs.getBool(_hasCompletedOnboardingKey);
    hasCompletedOnboardingNotifier.value = savedOnboarding ?? false;
  }

  static Future<void> setLocale(String languageCode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_localeKey, languageCode);
    localeNotifier.value = Locale(languageCode);
  }

  static Future<void> toggleTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final isDark = themeNotifier.value == ThemeMode.dark;
    final nextMode = isDark ? ThemeMode.light : ThemeMode.dark;
    await prefs.setBool(_themeKey, !isDark);
    themeNotifier.value = nextMode;
  }

  static Future<void> setUserName(String name) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userNameKey, name);
    userNameNotifier.value = name;
  }

  static Future<void> completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_hasCompletedOnboardingKey, true);
    hasCompletedOnboardingNotifier.value = true;
  }

  static bool get isArabic => localeNotifier.value.languageCode == 'ar';
  static bool get isDarkMode => themeNotifier.value == ThemeMode.dark;
  static String? get userName => userNameNotifier.value;
  static bool get hasCompletedOnboarding => hasCompletedOnboardingNotifier.value;
}
