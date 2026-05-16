import 'package:flutter/material.dart';
import 'package:finance_track/theme/app_theme.dart';
import 'package:finance_track/screens/dashboard_screen.dart';

class OnboardingLoadingStateScreen extends StatefulWidget {
  const OnboardingLoadingStateScreen({super.key});

  @override
  State<OnboardingLoadingStateScreen> createState() => _OnboardingLoadingStateScreenState();
}

class _OnboardingLoadingStateScreenState extends State<OnboardingLoadingStateScreen> with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 0.6, end: 1.0).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    // Simulate loading delay then navigate to dashboard
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const DashboardScreen()),
        );
      }
    });
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  Widget _buildSkeletonLine(double width, double height, {double? radius}) {
    return FadeTransition(
      opacity: _pulseAnimation,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: AppTheme.surfaceContainerHigh,
          borderRadius: BorderRadius.circular(radius ?? 999),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Header Skeleton
              FadeTransition(
                opacity: _pulseAnimation,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      decoration: const BoxDecoration(
                        color: AppTheme.surfaceContainerHigh,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      width: 128,
                      height: 24,
                      decoration: BoxDecoration(
                        color: AppTheme.surfaceContainerHigh,
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              
              // Loading Image Box
              Container(
                width: double.infinity,
                height: 250,
                decoration: BoxDecoration(
                  color: AppTheme.surfaceContainer,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: AppTheme.warmShadow,
                ),
                child: Center(
                  child: FadeTransition(
                    opacity: _pulseAnimation,
                    child: Container(
                      width: 96,
                      height: 96,
                      decoration: BoxDecoration(
                        color: AppTheme.primaryContainer,
                        shape: BoxShape.circle,
                        boxShadow: AppTheme.warmShadowLg,
                      ),
                      child: const Center(
                        child: Icon(Icons.pets, size: 48, color: AppTheme.onPrimaryContainer),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32),
              
              // Text Skeletons
              _buildSkeletonLine(200, 32),
              const SizedBox(height: 16),
              _buildSkeletonLine(double.infinity, 16),
              const SizedBox(height: 8),
              _buildSkeletonLine(double.infinity * 0.8, 16),
              const SizedBox(height: 8),
              _buildSkeletonLine(double.infinity * 0.6, 16),
              
              const Spacer(),
              
              // Dots Skeleton
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildSkeletonLine(8, 8),
                  const SizedBox(width: 8),
                  FadeTransition(
                    opacity: _pulseAnimation,
                    child: Container(
                      width: 24,
                      height: 8,
                      decoration: BoxDecoration(
                        color: AppTheme.primaryContainer,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  _buildSkeletonLine(8, 8),
                ],
              ),
              const SizedBox(height: 16),
              
              // Button Skeleton
              _buildSkeletonLine(double.infinity, 56, radius: 16),
            ],
          ),
        ),
      ),
    );
  }
}
