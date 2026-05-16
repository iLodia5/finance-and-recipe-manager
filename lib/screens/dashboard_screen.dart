import 'package:flutter/material.dart';
import 'package:finance_track/theme/app_theme.dart';
import 'package:finance_track/screens/add_transaction_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  Widget _buildIncomeCard(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppTheme.outlineVariant),
        boxShadow: AppTheme.warmShadow,
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(24),
            decoration: const BoxDecoration(
              color: Color(0x33EEE2BD), // tertiary-fixed with opacity
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              border: Border(bottom: BorderSide(color: AppTheme.outlineVariant)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: const BoxDecoration(
                        color: AppTheme.secondaryContainer,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.trending_up, color: AppTheme.onSecondaryContainer),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Income List',
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontSize: 20),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppTheme.secondaryContainer,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    '+\$3,450.00',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontSize: 16,
                          color: AppTheme.onSecondaryContainer,
                        ),
                  ),
                ),
              ],
            ),
          ),
          // Content
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                _buildTransactionRow(context, 'Salary', 'Oct 01, 2023', '+\$3,000.00', AppTheme.secondary),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Divider(color: AppTheme.outlineVariant, height: 1),
                ),
                _buildTransactionRow(context, 'Freelance Project', 'Oct 15, 2023', '+\$450.00', AppTheme.secondary),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionRow(BuildContext context, String title, String date, String amount, Color amountColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.bodyLarge),
            Text(date, style: Theme.of(context).textTheme.labelSmall),
          ],
        ),
        Text(
          amount,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: amountColor),
        ),
      ],
    );
  }

  Widget _buildOutcomeCard(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppTheme.outlineVariant),
        boxShadow: AppTheme.warmShadow,
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: const BoxDecoration(
                    color: AppTheme.errorContainer,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.trending_down, color: AppTheme.onErrorContainer),
                ),
                const SizedBox(width: 12),
                Text(
                  'Outcome List',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontSize: 20),
                ),
              ],
            ),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppTheme.errorContainer,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    '-\$2,250.00',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontSize: 16,
                          color: AppTheme.onErrorContainer,
                        ),
                  ),
                ),
                const SizedBox(width: 16),
                const Icon(Icons.expand_more, color: AppTheme.onSurfaceVariant),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.surface,
        elevation: 0,
        toolbarHeight: 80,
        title: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppTheme.primaryContainer, width: 2),
              ),
              child: ClipOval(
                child: Image.network(
                  'https://lh3.googleusercontent.com/aida-public/AB6AXuABfY6svzqW_QgGO1Tn3_w3kxkFAAhOPJwDlq5L5n10DK0XzWiasq-eOmoRK9v7-oh_dQ3XDVvXqd3xVR0p2fYYEbOhpU0OdEJt5JljQFZnr9LssSr1g7kYTkbL9t24ldBO81PwpM2tYI6UNT20bMMbWMPAG_lzsDurRSNfn1b3uuNRj2Nn_eFJflpTd3nEdhCptS9ZSQ0i8pOIxTGHog_xnFcorI8I4FfYpyqjLlZajxfunegvGvRcDt3nyB1gvO0nmDeZyA5IH3gU',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Text(
              'FinanceTrack',
              style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                    color: AppTheme.primary,
                    fontSize: 24,
                  ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: AppTheme.onSurfaceVariant, size: 28),
            onPressed: () {},
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome back!',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppTheme.onSurfaceVariant),
                ),
                const SizedBox(height: 8),
                Text(
                  'Here\'s your monthly overview.',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 32),
                _buildIncomeCard(context),
                const SizedBox(height: 16),
                _buildOutcomeCard(context),
                const SizedBox(height: 100), // padding for fixed elements
              ],
            ),
          ),
          // Fixed Bottom Summary
          Positioned(
            bottom: 24,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                decoration: BoxDecoration(
                  color: AppTheme.secondaryContainer,
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(color: const Color(0xFFA2D3A4)),
                  boxShadow: AppTheme.warmShadowLg,
                ),
                child: Text(
                  'Saved \$1,200',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontSize: 20,
                        color: AppTheme.onSecondaryContainer,
                      ),
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddTransactionScreen()),
          );
        },
        backgroundColor: AppTheme.primary,
        foregroundColor: AppTheme.onPrimary,
        elevation: 0, // handeled by container below if needed, but FAB has its own
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(999),
        ),
        child: Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: AppTheme.warmShadowLg,
            border: const Border(bottom: BorderSide(color: Color(0xFF7F2A0D), width: 3)),
          ),
          child: const Icon(Icons.add, size: 32),
        ),
      ),
    );
  }
}
