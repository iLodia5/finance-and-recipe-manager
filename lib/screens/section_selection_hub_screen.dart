import 'package:flutter/material.dart';
import 'package:finance_track/theme/app_theme.dart';
import 'package:finance_track/screens/main_tab_screen.dart';
import 'package:finance_track/screens/onboarding_select_profile_screen.dart';
import 'package:finance_track/services/settings_service.dart';
import 'package:finance_track/l10n/app_translations.dart';

class SectionSelectionHubScreen extends StatelessWidget {
  final String profileName;
  const SectionSelectionHubScreen({super.key, required this.profileName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.surface,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppTheme.onSurfaceVariant),
          onPressed: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const OnboardingSelectProfileScreen()),
              (route) => false,
            );
          },
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Header Section
              Container(
                width: 140,
                height: 140,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppTheme.surfaceContainerLowest,
                    width: 4,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.primary.withValues(alpha: 0.15),
                      blurRadius: 30,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: ClipOval(
                  child: Image.asset(
                    'lib/assets/Idle_animation_only_headloop_cycle_animat.gif',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 32),
              Text(
                context.tr('where_to_next'),
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      color: AppTheme.primary,
                      fontWeight: FontWeight.w800,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 48),

              // Selection Grid
              Column(
                children: [
                  // Financial Journal Card
                  _buildSelectionCard(
                    context,
                    title: context.tr('financial_journal'),
                    subtitle: context.tr('track_your_savings'),
                    icon: Icons.account_balance_wallet,
                    backgroundColor: AppTheme.secondaryContainer,
                    textColor: AppTheme.onSecondaryContainer,
                    iconBackgroundColor: AppTheme.secondary,
                    iconColor: AppTheme.onSecondary,
                      onTap: () async {
                        await SettingsService.completeOnboarding();
                        if (context.mounted) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => MainTabScreen(profileName: profileName, initialIndex: 1)),
                          );
                        }
                      },
                  ),
                  const SizedBox(height: 24),

                  // Recipe Book Card
                  _buildSelectionCard(
                    context,
                    title: context.tr('recipe_book'),
                    subtitle: context.tr('plan_your_meal'),
                    icon: Icons.menu_book,
                    backgroundColor: AppTheme.primaryContainer,
                    textColor: AppTheme.onPrimaryContainer,
                    iconBackgroundColor: AppTheme.primary,
                    iconColor: AppTheme.onPrimary,
                      onTap: () async {
                        await SettingsService.completeOnboarding();
                        if (context.mounted) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => MainTabScreen(profileName: profileName, initialIndex: 0)),
                          );
                        }
                      },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSelectionCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Color backgroundColor,
    required Color textColor,
    required Color iconBackgroundColor,
    required Color iconColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(24.0),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(40),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF4E342E).withValues(alpha: 0.05),
              blurRadius: 20,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: iconBackgroundColor,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(icon, size: 32, color: iconColor),
            ),
            const SizedBox(width: 24),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          color: textColor,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: textColor.withValues(alpha: 0.9),
                        ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
