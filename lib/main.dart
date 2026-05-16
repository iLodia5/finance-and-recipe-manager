import 'package:flutter/material.dart';
import 'package:finance_track/theme/app_theme.dart';
import 'package:finance_track/screens/onboarding_screen.dart';

void main() {
  runApp(const FinanceTrackApp());
}

class FinanceTrackApp extends StatelessWidget {
  const FinanceTrackApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FinanceTrack',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const OnboardingScreen(),
    );
  }
}
