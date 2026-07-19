import 'package:flutter/material.dart';
import 'package:finance_track/theme/app_theme.dart';
import 'package:finance_track/screens/profile_setup_screen.dart';
import 'package:finance_track/screens/onboarding_loading_state_screen.dart';
import 'package:finance_track/services/profile_service.dart';
import 'package:finance_track/services/settings_service.dart';
import 'package:finance_track/l10n/app_translations.dart';
import 'package:finance_track/screens/settings_screen.dart';

class OnboardingSelectProfileScreen extends StatefulWidget {
  const OnboardingSelectProfileScreen({super.key});

  @override
  State<OnboardingSelectProfileScreen> createState() =>
      _OnboardingSelectProfileScreenState();
}

class _OnboardingSelectProfileScreenState
    extends State<OnboardingSelectProfileScreen> {
  late Future<List<String>> _profilesFuture;
  bool _isDeleteMode = false;

  @override
  void initState() {
    super.initState();
    _loadProfiles();
  }

  void _loadProfiles() {
    setState(() {
      _profilesFuture = ProfileService.getProfiles();
    });
  }

  Widget _buildSteamProfileCard(BuildContext context, String profileName) {
    return Container(
      margin: const EdgeInsets.all(16),
      child: Column(
        children: [
          Stack(
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: AppTheme.warmShadow,
                ),
                child: Material(
                  color: AppTheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(20),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(20),
                    onTap: _isDeleteMode
                        ? null
                        : () async {
                              await SettingsService.setUserName(profileName);
                              if (context.mounted) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        OnboardingLoadingStateScreen(profileName: profileName),
                                  ),
                                );
                              }
                            },
                    child: Center(
                      child: Icon(
                        Icons.pets,
                        size: 44,
                        color: AppTheme.primary,
                      ),
                    ),
                  ),
                ),
              ),
              if (_isDeleteMode)
                Positioned(
                  top: 2,
                  right: 2,
                  child: GestureDetector(
                    onTap: () async {
                      await ProfileService.removeProfile(profileName);
                      _loadProfiles();
                    },
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: AppTheme.error,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.close,
                        size: 16,
                        color: AppTheme.onError,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            profileName,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppTheme.onSurface,
                  fontWeight: FontWeight.bold,
                ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        leading: ValueListenableBuilder<ThemeMode>(
          valueListenable: SettingsService.themeNotifier,
          builder: (context, currentThemeMode, _) {
            final isDark = currentThemeMode == ThemeMode.dark;
            return IconButton(
              icon: Icon(
                isDark ? Icons.light_mode : Icons.dark_mode,
                color: AppTheme.onSurfaceVariant,
              ),
              onPressed: () {
                SettingsService.toggleTheme();
              },
            );
          },
        ),
        actions: [
          IconButton(
            icon: Icon(
              _isDeleteMode ? Icons.check_circle : Icons.delete,
              color: _isDeleteMode
                  ? AppTheme.primary
                  : AppTheme.onSurfaceVariant,
            ),
            onPressed: () {
              setState(() {
                _isDeleteMode = !_isDeleteMode;
              });
            },
          ),
          IconButton(
            icon: Icon(Icons.settings, color: AppTheme.onSurfaceVariant),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsScreen()),
              );
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Mascot Image
              Container(
                width: 128,
                height: 128,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: AppTheme.surfaceContainerHighest,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppTheme.surfaceContainerLowest,
                    width: 4,
                  ),
                  boxShadow: AppTheme.warmShadow,
                ),
                child: ClipOval(
                  child: Image.asset(
                    'lib/assets/Idle_animation_only_headloop_cycle_animat.gif',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Text(
                context.tr('welcome_back_exclamation'),
                style: Theme.of(
                  context,
                ).textTheme.headlineLarge?.copyWith(color: AppTheme.primary),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                context.tr('who_is_tracking_today'),
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppTheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),

              // Profiles List from SharedPreferences
              FutureBuilder<List<String>>(
                future: _profilesFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final profiles = snapshot.data ?? [];

                  if (profiles.isEmpty) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 32),
                      child: Text(
                        context.tr('no_profiles_found'),
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppTheme.onSurfaceVariant,
                        ),
                      ),
                    );
                  }

                  return Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    alignment: WrapAlignment.center,
                    children: profiles.map((profileName) {
                      return _buildSteamProfileCard(context, profileName);
                    }).toList(),
                  );
                },
              ),

              const SizedBox(height: 16),
              // Add New Profile Button
              OutlinedButton(
                onPressed: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ProfileSetupScreen(),
                    ),
                  );
                  // Refresh list after returning
                  _loadProfiles();
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppTheme.primary,
                  backgroundColor: AppTheme.surfaceContainerLow,
                  side: BorderSide(
                    color: AppTheme.outlineVariant,
                    width: 2,
                  ), // dashed not supported out of box easily
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.add),
                    const SizedBox(width: 8),
                    Text(context.tr('create_profile')),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
