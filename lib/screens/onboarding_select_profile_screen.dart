import 'package:flutter/material.dart';
import 'package:finance_track/theme/app_theme.dart';
import 'package:finance_track/screens/profile_setup_screen.dart';
import 'package:finance_track/screens/onboarding_loading_state_screen.dart';

class OnboardingSelectProfileScreen extends StatelessWidget {
  const OnboardingSelectProfileScreen({super.key});

  Widget _buildProfileCard(BuildContext context, {required String title, required String subtitle, required IconData icon, required Color color, required Color onColor}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        boxShadow: AppTheme.warmShadow,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Material(
        color: AppTheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const OnboardingLoadingStateScreen()),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: onColor, size: 32),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontSize: 20),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: Theme.of(context).textTheme.labelSmall,
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 32,
                  height: 32,
                  decoration: const BoxDecoration(
                    color: AppTheme.surfaceContainer,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.chevron_right, color: AppTheme.onSurfaceVariant, size: 20),
                ),
              ],
            ),
          ),
        ),
      ),
    );
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
                  border: Border.all(color: AppTheme.surfaceContainerLowest, width: 4),
                  boxShadow: AppTheme.warmShadow,
                ),
                child: ClipOval(
                  child: Image.network(
                    'https://lh3.googleusercontent.com/aida-public/AB6AXuCoQ4P-Dw2a2BSy14uc3h2NBiJz65G7rMmUH6jEXxMge8AZGgUkcGr7XfIiA4EdD567Ojg3dpt9Bl3DsknqB1Zk79i9R53QeKKzJbjR35JinMYqvwLyEpsLkX0jRdfcSFmCnis1ztT3wA2-qAykLCR8ot2ANwh9Re9BjddR88S0OxzHw70WgH1hMh3CioLFCv_IQZSzg6qvds3wKgH148n_OsofHn-TbkiY89CRXpcOAXqXQCLAMziapkJiDVKO2GAInenn_LiB8AIn',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Text(
                'Welcome back!',
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(color: AppTheme.primary),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Who\'s tracking today?',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: AppTheme.onSurfaceVariant),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              // Profiles List
              _buildProfileCard(
                context,
                title: 'Personal Journal',
                subtitle: 'Last updated today',
                icon: Icons.pets,
                color: AppTheme.secondaryContainer,
                onColor: AppTheme.onSecondaryContainer,
              ),
              _buildProfileCard(
                context,
                title: 'Family Budget',
                subtitle: 'Last updated yesterday',
                icon: Icons.favorite,
                color: AppTheme.primaryContainer,
                onColor: AppTheme.onPrimaryContainer,
              ),
              _buildProfileCard(
                context,
                title: 'Work Expenses',
                subtitle: 'Last updated 3 days ago',
                icon: Icons.work,
                color: const Color(0xFFB4AA88), // tertiaryContainer
                onColor: const Color(0xFF453F24), // onTertiaryContainer
              ),
              const SizedBox(height: 16),
              // Add New Profile Button
              OutlinedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ProfileSetupScreen()),
                  );
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppTheme.primary,
                  backgroundColor: AppTheme.surfaceContainerLow,
                  side: const BorderSide(color: AppTheme.outlineVariant, width: 2), // dashed not supported out of box easily
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.add),
                    SizedBox(width: 8),
                    Text('Add New Profile'),
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
