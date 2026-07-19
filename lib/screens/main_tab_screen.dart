import 'package:flutter/material.dart';
import 'package:finance_track/theme/app_theme.dart';
import 'package:finance_track/screens/finance_library_screen.dart';
import 'package:finance_track/screens/recipe_hub_screen.dart';
import 'package:finance_track/services/settings_service.dart';
import 'package:finance_track/l10n/app_translations.dart';

class MainTabScreen extends StatefulWidget {
  final String profileName;
  final int initialIndex;

  const MainTabScreen({super.key, required this.profileName, this.initialIndex = 0});

  @override
  State<MainTabScreen> createState() => _MainTabScreenState();
}

class _MainTabScreenState extends State<MainTabScreen> {
  late int _currentIndex;

  late List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _screens = [
      RecipeHubScreen(profileName: widget.profileName),
      FinanceLibraryScreen(profileName: widget.profileName),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: SettingsService.themeNotifier,
      builder: (context, themeMode, child) {
        return Scaffold(
          body: IndexedStack(
            index: _currentIndex,
            children: _screens,
          ),
          bottomNavigationBar: Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 20,
                  offset: const Offset(0, -4),
                ),
              ],
            ),
            child: BottomNavigationBar(
              currentIndex: _currentIndex,
              onTap: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              backgroundColor: AppTheme.surfaceContainerLow,
              selectedItemColor: AppTheme.primary,
              unselectedItemColor: AppTheme.onSurfaceVariant,
              selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
              unselectedLabelStyle: const TextStyle(fontSize: 12),
              type: BottomNavigationBarType.fixed,
              items: [
                BottomNavigationBarItem(
                  icon: const Icon(Icons.menu_book_outlined),
                  activeIcon: const Icon(Icons.menu_book),
                  label: context.tr('recipe_hub') == 'recipe_hub' ? 'Recipes' : context.tr('recipe_hub'),
                ),
                BottomNavigationBarItem(
                  icon: const Icon(Icons.account_balance_wallet_outlined),
                  activeIcon: const Icon(Icons.account_balance_wallet),
                  label: context.tr('pawsitive_finance') == 'pawsitive_finance' ? 'Finance' : context.tr('pawsitive_finance'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
