import 'package:flutter/material.dart';
import 'package:finance_track/theme/app_theme.dart';
import 'package:finance_track/screens/onboarding_loading_state_screen.dart';

class ProfileSetupScreen extends StatefulWidget {
  const ProfileSetupScreen({super.key});

  @override
  State<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends State<ProfileSetupScreen> {
  final TextEditingController _nameController = TextEditingController();

  void _submitProfile() {
    if (_nameController.text.trim().isNotEmpty) {
      // In a real app, save profile here
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const OnboardingLoadingStateScreen(),
        ),
      );
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
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppTheme.onSurface),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            children: [
              const SizedBox(height: 32),
              // Mascot Peeking Element
              Transform.translate(
                offset: const Offset(0, 32), // Pull it down to overlap card
                child: Container(
                  width: 112,
                  height: 112,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: AppTheme.surface, width: 4),
                    boxShadow: AppTheme.warmShadow,
                  ),
                  child: ClipOval(
                    child: Image.network(
                      'https://lh3.googleusercontent.com/aida-public/AB6AXuB2NRuNPf2-4ec1yrGcfUqjNe844SnoCFEzydbxQWfOYkLP6cBZTFiD9TWqd8Vyhb-iHWLPP8KvbzHRa4FBEXrTtr-7ArYYP-FXYUOazBJeK0-TmKkrcO89E2Uc3tzF5WmOzWfGjSiGruF-1YcVt5eOuQGOyQ9u4FjzZgdyggbGhdia8bufE_piENHQ2KDP2A1UmAG6f4RTzwJfug1JT-KwKGo0scIZhicbguzn9-bRTHd42wg7oERTnqchVnih_kRfHLGDJ4vvkmCD',
                      fit: BoxFit.cover,
                      alignment: Alignment.topCenter,
                    ),
                  ),
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
                      'Create Your Profile',
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
                        children: const [
                          TextSpan(text: 'Enter your profile name\n'),
                          TextSpan(
                            text: '(e.g., Personal, Job, or Company)',
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
                          borderSide: const BorderSide(
                            color: AppTheme.outlineVariant,
                            width: 2,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: const BorderSide(
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
                          children: const [
                            Text(
                              'Let\'s Start',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(width: 8),
                            Icon(Icons.arrow_forward, size: 18),
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
                  const Icon(
                    Icons.lock,
                    size: 16,
                    color: AppTheme.onSurfaceVariant,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Your data is stored securely',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: AppTheme.onSurfaceVariant.withOpacity(0.8),
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
