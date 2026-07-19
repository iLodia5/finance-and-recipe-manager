import 'package:flutter/material.dart';
import 'package:finance_track/theme/app_theme.dart';
import 'package:finance_track/screens/profile_setup_screen.dart';
import 'package:finance_track/screens/section_selection_hub_screen.dart';
import 'package:finance_track/screens/main_tab_screen.dart';
import 'package:finance_track/widgets/global_timer_overlay.dart';
import 'package:finance_track/services/recipe_timer_service.dart';

import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:finance_track/services/settings_service.dart';
import 'package:finance_track/services/profile_service.dart';
import 'package:finance_track/screens/onboarding_select_profile_screen.dart';
import 'package:intl/date_symbol_data_local.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting();

  await SettingsService.init();
  final profiles = await ProfileService.getProfiles();

  runApp(
    FinanceTrackApp(
      initialScreen: profiles.isEmpty
          ? const ProfileSetupScreen()
          : const OnboardingSelectProfileScreen(),
    ),
  );
}

class FinanceTrackApp extends StatelessWidget {
  final Widget initialScreen;

  const FinanceTrackApp({super.key, required this.initialScreen});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Locale>(
      valueListenable: SettingsService.localeNotifier,
      builder: (context, currentLocale, _) {
        return ValueListenableBuilder<ThemeMode>(
          valueListenable: SettingsService.themeNotifier,
          builder: (context, currentThemeMode, _) {
            return MaterialApp(
              navigatorKey: RecipeTimerService().navigatorKey,
              title: 'FinanceTrack',
              debugShowCheckedModeBanner: false,
              theme: AppTheme.lightTheme,
              darkTheme: AppTheme.darkTheme,
              themeMode: currentThemeMode,
              locale: currentLocale,
              localizationsDelegates: const [
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              supportedLocales: const [Locale('en'), Locale('ar')],
              builder: (context, child) {
                return MediaQuery(
                  data: MediaQuery.of(
                    context,
                  ).copyWith(textScaler: TextScaler.noScaling),
                  child: Stack(
                    children: [
                      child!,
                      const GlobalTimerOverlay(),
                    ],
                  ),
                );
              },
              home: initialScreen,
            );
          },
        );
      },
    );
  }
}
