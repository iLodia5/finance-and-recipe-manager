import 'package:flutter/material.dart';
import 'package:finance_track/theme/app_theme.dart';
import 'package:finance_track/services/settings_service.dart';
import 'package:finance_track/l10n/app_translations.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.surface,
      appBar: AppBar(
        backgroundColor: AppTheme.surface,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppTheme.onSurfaceVariant),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          context.tr('settings'),
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            color: AppTheme.primary,
            fontSize: 24,
          ),
        ),
      ),
      body: ValueListenableBuilder<Locale>(
        valueListenable: SettingsService.localeNotifier,
        builder: (context, locale, _) {
          return ValueListenableBuilder<ThemeMode>(
            valueListenable: SettingsService.themeNotifier,
            builder: (context, themeMode, _) {
              return ListView(
                padding: const EdgeInsets.all(24),
                children: [
                  Text(
                    context.tr('appearance'),
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: AppTheme.onSurface,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildThemeToggle(context),
                  const SizedBox(height: 32),
                  Text(
                    context.tr('language'),
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: AppTheme.onSurface,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildLanguageTile(context, 'en', context.tr('english')),
                  const SizedBox(height: 12),
                  _buildLanguageTile(context, 'ar', context.tr('arabic')),
                  const SizedBox(height: 32),
                  Center(
                    child: Text(
                      'Version: 1.1v',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppTheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildThemeToggle(BuildContext context) {
    final bool isDark = SettingsService.isDarkMode;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: AppTheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.outlineVariant, width: 1),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            context.tr('dark_mode'),
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: AppTheme.onSurface,
              fontWeight: FontWeight.w500,
            ),
          ),
          Switch(
            value: isDark,
            onChanged: (value) {
              SettingsService.toggleTheme();
            },
            activeColor: AppTheme.primary,
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageTile(BuildContext context, String code, String title) {
    final bool isSelected =
        SettingsService.localeNotifier.value.languageCode == code;

    return InkWell(
      onTap: () {
        SettingsService.setLocale(code);
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: isSelected
              ? AppTheme.primaryContainer
              : AppTheme.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppTheme.primary : AppTheme.outlineVariant,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: isSelected
                    ? AppTheme.onPrimaryContainer
                    : AppTheme.onSurface,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w400,
              ),
            ),
            if (isSelected)
              Icon(Icons.check_circle, color: AppTheme.primary)
            else
              Icon(Icons.circle_outlined, color: AppTheme.outlineVariant),
          ],
        ),
      ),
    );
  }
}
