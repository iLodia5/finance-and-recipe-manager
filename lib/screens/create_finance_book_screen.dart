import 'package:flutter/material.dart';
import 'package:finance_track/theme/app_theme.dart';
import 'package:finance_track/screens/dashboard_screen.dart';
import 'package:finance_track/services/finance_book_service.dart';
import 'package:finance_track/l10n/app_translations.dart';

class CreateFinanceBookScreen extends StatefulWidget {
  final String profileName;
  const CreateFinanceBookScreen({super.key, required this.profileName});

  @override
  State<CreateFinanceBookScreen> createState() => _CreateFinanceBookScreenState();
}

class _CreateFinanceBookScreenState extends State<CreateFinanceBookScreen> {
  final TextEditingController _nameController = TextEditingController();
  String _selectedCurrency = 'USD';
  DateTime _selectedDate = DateTime.now();

  void _submitBook() async {
    final name = _nameController.text.trim();
    if (name.isNotEmpty) {
      await FinanceBookService.addBook(
        widget.profileName,
        name,
        currency: _selectedCurrency,
        date: _selectedDate.toIso8601String(),
      );

      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) =>
                DashboardScreen(profileName: widget.profileName, bookName: name),
          ),
        );
      }
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppTheme.primary,
              onPrimary: AppTheme.onPrimary,
              onSurface: AppTheme.onSurface,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: AppTheme.primary,
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
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
          icon: Icon(Icons.arrow_back, color: AppTheme.onSurface),
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
                offset: const Offset(0, 32),
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
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: AppTheme.surfaceContainerHigh),
                  boxShadow: AppTheme.warmShadowLg,
                ),
                child: Column(
                  children: [
                    Text(
                      context.tr('create_finance_book'),
                      style: Theme.of(context).textTheme.headlineLarge
                          ?.copyWith(color: AppTheme.primary),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      context.tr('what_should_we_call_this_journal'),
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppTheme.onSurfaceVariant,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 32),
                    // Input Field
                    TextField(
                      controller: _nameController,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headlineMedium
                          ?.copyWith(color: AppTheme.onSurface),
                      decoration: InputDecoration(
                        hintText: context.tr('e_g_2025_budget'),
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
                      onSubmitted: (_) => _submitBook(),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      context.tr('select_currency'),
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: AppTheme.onSurfaceVariant,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: AppTheme.surfaceContainerLow,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: AppTheme.outlineVariant,
                          width: 1.5,
                        ),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () =>
                                  setState(() => _selectedCurrency = 'USD'),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 14,
                                ),
                                decoration: BoxDecoration(
                                  color: _selectedCurrency == 'USD'
                                      ? AppTheme.primary
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: _selectedCurrency == 'USD'
                                      ? AppTheme.warmShadow
                                      : null,
                                ),
                                child: Text(
                                  context.tr('us_dollar'),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: _selectedCurrency == 'USD'
                                        ? AppTheme.onPrimary
                                        : AppTheme.onSurfaceVariant,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: GestureDetector(
                              onTap: () =>
                                  setState(() => _selectedCurrency = 'IQD'),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 14,
                                ),
                                decoration: BoxDecoration(
                                  color: _selectedCurrency == 'IQD'
                                      ? AppTheme.primary
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: _selectedCurrency == 'IQD'
                                      ? AppTheme.warmShadow
                                      : null,
                                ),
                                child: Text(
                                  context.tr('iraqi_dinar'),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: _selectedCurrency == 'IQD'
                                        ? AppTheme.onPrimary
                                        : AppTheme.onSurfaceVariant,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      context.tr('start_date'),
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: AppTheme.onSurfaceVariant,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    InkWell(
                      onTap: () => _selectDate(context),
                      borderRadius: BorderRadius.circular(16),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                        decoration: BoxDecoration(
                          color: AppTheme.surfaceContainerLowest,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: AppTheme.outlineVariant,
                            width: 2,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "${_selectedDate.toLocal()}".split(' ')[0],
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                color: AppTheme.onSurface,
                              ),
                            ),
                            Icon(Icons.calendar_today, color: AppTheme.primary),
                          ],
                        ),
                      ),
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
                        onPressed: _submitBook,
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
            ],
          ),
        ),
      ),
    );
  }
}
