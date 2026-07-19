import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:finance_track/theme/app_theme.dart';
import 'package:finance_track/screens/profile_setup_screen.dart';
import 'package:finance_track/screens/onboarding_select_profile_screen.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Decorative Background Elements
          Positioned(
            top: 40,
            left: 40,
            child: Container(
              width: 128,
              height: 128,
              decoration: BoxDecoration(
                color: AppTheme.primaryContainer.withValues(alpha: 0.5),
                shape: BoxShape.circle,
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
                child: Container(color: Colors.transparent),
              ),
            ),
          ),
          Positioned(
            bottom: 80,
            right: 40,
            child: Container(
              width: 192,
              height: 192,
              decoration: BoxDecoration(
                color: AppTheme.secondaryContainer.withValues(alpha: 0.3),
                shape: BoxShape.circle,
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
                child: Container(color: Colors.transparent),
              ),
            ),
          ),
          // Content Container
          SafeArea(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24.0,
                  vertical: 32.0,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Mascot Illustration
                    Container(
                      width: 256,
                      height: 256,
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: AppTheme.surfaceContainerHigh,
                        shape: BoxShape.circle,
                        boxShadow: AppTheme.warmShadowLg,
                      ),
                      child: ClipOval(
                        child: Image.network(
                          'https://lh3.googleusercontent.com/aida-public/AB6AXuDTeRdhrOy2W3zDPEnujONB2Az6hta09ZYnTqiSntYK1a0f74BmAw0KcNVIRl7IVhvp6TOKk2OSvLhPH7U7_Jsdl2ZUQecqZJQJfp937GEU6qIvahZh-NhQEWkvZ6stC5C8lQJNvOG8HvvJbNaXZjIFNAg0HcZjA-Knfys-iD92_yIDW49g2d9YzgR6uAann8pzHSEFCfhK6zTy4oGXHfqxvyZggILAhyWAskPA7m_ZrKBaaWVwQn8_eOezIppoKCkCV-lNUvpfIvmB',
                          fit: BoxFit.cover,
                          colorBlendMode: BlendMode.multiply,
                        ),
                      ),
                    ),
                    // Onboarding Copy
                    Text(
                      'Welcome to FinanceTrack!',
                      style: Theme.of(context).textTheme.headlineLarge
                          ?.copyWith(color: AppTheme.primary),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        'Your cozy corner for mindful money tracking. Let\'s make managing finances feel less like a chore and more like writing in your favorite journal.',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppTheme.onSurfaceVariant,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const Spacer(),
                    // Actions
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        boxShadow: AppTheme.warmShadowLg,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: ElevatedButton(
                        style:
                            ElevatedButton.styleFrom(
                              side: const BorderSide(
                                color: Color(0xFFE67C5B),
                                width: 4,
                                strokeAlign: BorderSide.strokeAlignOutside,
                              ),
                            ).copyWith(
                              side: WidgetStateProperty.resolveWith(
                                (states) => const BorderSide(
                                  color: Color(0xFFE67C5B),
                                  width: 4,
                                ),
                              ),
                            ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ProfileSetupScreen(),
                            ),
                          );
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Text('Create Profile'),
                            SizedBox(width: 8),
                            Icon(Icons.arrow_forward),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                const OnboardingSelectProfileScreen(),
                          ),
                        );
                      },
                      child: Text(
                        'I already have an account',
                        style: Theme.of(context).textTheme.labelSmall,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
