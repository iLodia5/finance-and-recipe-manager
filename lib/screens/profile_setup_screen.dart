import 'package:flutter/material.dart';
import 'package:finance_track/theme/app_theme.dart';
import 'package:finance_track/screens/section_selection_hub_screen.dart';
import 'package:finance_track/services/settings_service.dart';
import 'package:finance_track/services/profile_service.dart';
import 'package:finance_track/l10n/app_translations.dart';

class ProfileSetupScreen extends StatefulWidget {
  const ProfileSetupScreen({super.key});

  @override
  State<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends State<ProfileSetupScreen> {
  final TextEditingController _nameController = TextEditingController();

  void _submitProfile() async {
    final name = _nameController.text.trim();
    if (name.isNotEmpty) {
      await SettingsService.setUserName(name);
      await ProfileService.addProfile(name);

      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => SectionSelectionHubScreen(profileName: name),
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            children: [
              const SizedBox(height: 32),
              // Mascot Peeking Element
              Transform.translate(
                offset: const Offset(0, 32), // Pull it down to overlap card
                child: Image.asset(
                  'lib/assets/welcome_bear_pose(nobackground).png',
                  width: 160,
                  height: 160,
                  fit: BoxFit.contain,
                  alignment: Alignment.bottomCenter,
                ),
              ),
              // Main Card Canvas
              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(24, 48, 24, 32),
                decoration: BoxDecoration(
                  color: AppTheme.surface,
                  borderRadius: BorderRadius.circular(24), // 1.5rem
                  border: Border.all(color: AppTheme.surfaceContainerHigh),
                  boxShadow: AppTheme.warmShadowLg,
                ),
                child: Column(
                  children: [
                    Text(
                      context.tr('create_profile'),
                      style: Theme.of(context).textTheme.headlineLarge
                          ?.copyWith(color: AppTheme.primary),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppTheme.onSurfaceVariant,
                        ),
                        children: [
                          TextSpan(
                            text: '${context.tr('what_should_we_call_you')}\n',
                          ),
                          TextSpan(
                            text: '(${context.tr('your_name_or_nickname')})',
                            style: TextStyle(
                              fontSize: 14,
                              color: AppTheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),
                    // Input Field
                    TextField(
                      controller: _nameController,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headlineMedium
                          ?.copyWith(color: AppTheme.onSurface),
                      decoration: InputDecoration(
                        hintText: 'My Journal',
                        filled: true,
                        fillColor: AppTheme.surfaceContainerLowest,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 16,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(
                            color: AppTheme.outlineVariant,
                            width: 2,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(
                            color: AppTheme.primary,
                            width: 2,
                          ),
                        ),
                      ),
                      onSubmitted: (_) => _submitProfile(),
                    ),
                    const SizedBox(height: 32),
                    // Submit Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style:
                            ElevatedButton.styleFrom(
                              backgroundColor: AppTheme.primary,
                              foregroundColor: AppTheme.onPrimary,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(999),
                              ),
                              side: const BorderSide(
                                color: Color(0xFF7F2A0D),
                                width: 4,
                                strokeAlign: BorderSide.strokeAlignOutside,
                              ),
                            ).copyWith(
                              side: WidgetStateProperty.resolveWith(
                                (states) => const BorderSide(
                                  color: Color(0xFF7F2A0D),
                                  width: 4,
                                ),
                              ),
                            ),
                        onPressed: _submitProfile,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              context.tr('continue'),
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Icon(Icons.arrow_forward, size: 18),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              // Security Note
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.lock, size: 16, color: AppTheme.onSurfaceVariant),
                  const SizedBox(width: 8),
                  Text(
                    'Your data is stored securely',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: AppTheme.onSurfaceVariant.withValues(alpha: 0.8),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
