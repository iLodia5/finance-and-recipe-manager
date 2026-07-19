import 'package:flutter/material.dart';
import 'package:finance_track/theme/app_theme.dart';
import 'package:finance_track/screens/create_finance_book_screen.dart';
import 'package:finance_track/screens/dashboard_screen.dart';
import 'package:finance_track/services/finance_book_service.dart';
import 'package:finance_track/services/settings_service.dart';
import 'package:finance_track/screens/settings_screen.dart';
import 'package:finance_track/l10n/app_translations.dart';

class FinanceLibraryScreen extends StatefulWidget {
  final String profileName;
  const FinanceLibraryScreen({super.key, required this.profileName});

  @override
  State<FinanceLibraryScreen> createState() => _FinanceLibraryScreenState();
}

class _FinanceLibraryScreenState extends State<FinanceLibraryScreen> {
  late Future<List<String>> _booksFuture;
  bool _isDeleteMode = false;

  @override
  void initState() {
    super.initState();
    _loadBooks();
  }

  void _loadBooks() {
    setState(() {
      _booksFuture = FinanceBookService.getBooks(widget.profileName);
    });
  }

  Widget _buildBookCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required Color onColor,
  }) {
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
          onTap: _isDeleteMode
              ? null
              : () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          DashboardScreen(profileName: widget.profileName, bookName: title),
                    ),
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
                        style: Theme.of(
                          context,
                        ).textTheme.headlineMedium?.copyWith(fontSize: 20),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: Theme.of(context).textTheme.labelSmall,
                      ),
                    ],
                  ),
                ),
                _isDeleteMode
                    ? IconButton(
                        icon: Icon(
                          Icons.delete_forever,
                          color: AppTheme.error,
                          size: 24,
                        ),
                        onPressed: () async {
                          await FinanceBookService.removeBook(widget.profileName, title);
                          _loadBooks();
                        },
                      )
                    : Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: AppTheme.surfaceContainer,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.chevron_right,
                          color: AppTheme.onSurfaceVariant,
                          size: 20,
                        ),
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
          icon: Icon(Icons.arrow_back, color: AppTheme.onSurfaceVariant),
          onPressed: () => Navigator.pop(context),
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
                '${context.tr('welcome_back')}${widget.profileName}!',
                style: Theme.of(
                  context,
                ).textTheme.headlineLarge?.copyWith(color: AppTheme.primary),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                context.tr('select_finance_book'),
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppTheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),

              // Books List from SharedPreferences
              FutureBuilder<List<String>>(
                future: _booksFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final books = snapshot.data ?? [];

                  if (books.isEmpty) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 32),
                      child: Text(
                        context.tr('no_finance_books'),
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppTheme.onSurfaceVariant,
                        ),
                      ),
                    );
                  }

                  return Column(
                    children: books.map((bookName) {
                      return _buildBookCard(
                        context,
                        title: bookName,
                        subtitle: context.tr('last_updated_recently'),
                        icon: Icons.book, // Could also be dynamic
                        color: AppTheme.secondaryContainer,
                        onColor: AppTheme.onSecondaryContainer,
                      );
                    }).toList(),
                  );
                },
              ),

              const SizedBox(height: 16),
              // Add New Book Button
              OutlinedButton(
                onPressed: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CreateFinanceBookScreen(profileName: widget.profileName),
                    ),
                  );
                  // Refresh list after returning
                  _loadBooks();
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppTheme.primary,
                  backgroundColor: AppTheme.surfaceContainerLow,
                  side: BorderSide(
                    color: AppTheme.outlineVariant,
                    width: 2,
                  ),
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
                    Text(context.tr('create_finance_book')),
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
