import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:finance_track/theme/app_theme.dart';
import 'package:finance_track/models/transaction.dart';
import 'package:intl/intl.dart';
import 'package:finance_track/l10n/app_translations.dart';
import 'package:finance_track/services/settings_service.dart';

class AddTransactionScreen extends StatefulWidget {
  final String currency;

  const AddTransactionScreen({super.key, required this.currency});

  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  bool isOutcome = true;
  bool isToday = true;
  DateTime selectedDate = DateTime.now();

  String get _currencySymbol {
    if (widget.currency == 'IQD') {
      return SettingsService.isArabic ? 'د.ع' : 'IQD';
    }
    return '\$';
  }

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppTheme.primary,
              onPrimary: AppTheme.onPrimary,
              surface: AppTheme.surfaceContainerLowest,
              onSurface: AppTheme.onSurface,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        selectedDate = picked;
        isToday = false;
      });
    }
  }

  void _saveTransaction() {
    final title = _titleController.text.trim();
    final amountText = _amountController.text.trim();

    if (title.isEmpty || amountText.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(context.tr('please_enter_title'))));
      return;
    }

    final amount = double.tryParse(amountText);
    if (amount == null || amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.tr('please_enter_positive'))),
      );
      return;
    }

    final transaction = Transaction(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      amount: amount,
      date: isToday ? DateTime.now() : selectedDate,
      isIncome: !isOutcome,
    );

    Navigator.pop(context, transaction);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.surface,
      body: Stack(
        children: [
          // Decorative Background
          Positioned(
            top: -80,
            left: -80,
            child: Container(
              width: 384,
              height: 384,
              decoration: BoxDecoration(
                color: AppTheme.primaryContainer.withValues(alpha: 0.5),
                shape: BoxShape.circle,
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 50, sigmaY: 50),
                child: Container(color: Colors.transparent),
              ),
            ),
          ),
          // Content
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Column(
                children: [
                  // Mascot Peeking
                  Transform.translate(
                    offset: const Offset(0, 9),
                    child: Image.asset(
                      'lib/assets/transaction_page_icon(noBackground).png',
                      width: 220,
                      height: 220,
                      fit: BoxFit.contain,
                      alignment: Alignment.bottomCenter,
                    ),
                  ),
                  // Card Body
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: AppTheme.surfaceContainerLowest,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: AppTheme.warmShadowLg,
                      ),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            // Header
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const SizedBox(width: 32),
                                Text(
                                  context.tr('new_transaction'),
                                  style: Theme.of(
                                    context,
                                  ).textTheme.headlineMedium,
                                ),
                                IconButton(
                                  icon: const Icon(Icons.close),
                                  style: IconButton.styleFrom(
                                    backgroundColor: AppTheme.surfaceContainer,
                                    foregroundColor: AppTheme.onSurfaceVariant,
                                  ),
                                  onPressed: () => Navigator.pop(context),
                                ),
                              ],
                            ),
                            const SizedBox(height: 32),
                            // Type Toggle
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: AppTheme.surfaceContainer,
                                borderRadius: BorderRadius.circular(999),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () =>
                                          setState(() => isOutcome = true),
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 12,
                                        ),
                                        decoration: BoxDecoration(
                                          color: isOutcome
                                              ? AppTheme.surfaceContainerLowest
                                              : Colors.transparent,
                                          borderRadius: BorderRadius.circular(
                                            999,
                                          ),
                                          boxShadow: isOutcome
                                              ? [
                                                  const BoxShadow(
                                                    color: Colors.black12,
                                                    blurRadius: 4,
                                                  ),
                                                ]
                                              : null,
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.arrow_outward,
                                              size: 18,
                                              color: isOutcome
                                                  ? AppTheme.primary
                                                  : AppTheme.onSurfaceVariant,
                                            ),
                                            const SizedBox(width: 8),
                                            Text(
                                              context.tr('outcome'),
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .labelSmall
                                                  ?.copyWith(
                                                    color: isOutcome
                                                        ? AppTheme.primary
                                                        : AppTheme
                                                              .onSurfaceVariant,
                                                  ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () =>
                                          setState(() => isOutcome = false),
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 12,
                                        ),
                                        decoration: BoxDecoration(
                                          color: !isOutcome
                                              ? AppTheme.surfaceContainerLowest
                                              : Colors.transparent,
                                          borderRadius: BorderRadius.circular(
                                            999,
                                          ),
                                          boxShadow: !isOutcome
                                              ? [
                                                  const BoxShadow(
                                                    color: Colors.black12,
                                                    blurRadius: 4,
                                                  ),
                                                ]
                                              : null,
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.south_west,
                                              size: 18,
                                              color: !isOutcome
                                                  ? AppTheme.primary
                                                  : AppTheme.onSurfaceVariant,
                                            ),
                                            const SizedBox(width: 8),
                                            Text(
                                              context.tr('income'),
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .labelSmall
                                                  ?.copyWith(
                                                    color: !isOutcome
                                                        ? AppTheme.primary
                                                        : AppTheme
                                                              .onSurfaceVariant,
                                                  ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 24),
                            // Item Name Input
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                    left: 8,
                                    bottom: 8,
                                  ),
                                  child: Text(
                                    context.tr('item_name'),
                                    style: Theme.of(
                                      context,
                                    ).textTheme.labelSmall,
                                  ),
                                ),
                                TextField(
                                  controller: _titleController,
                                  decoration: InputDecoration(
                                    hintText: context.tr('what_did_you_buy'),
                                    prefixIcon: Icon(
                                      Icons.shopping_bag,
                                      color: AppTheme.primary,
                                    ),
                                    fillColor: AppTheme.surfaceContainerLow,
                                    filled: true,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide.none,
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide(
                                        color: AppTheme.primary,
                                        width: 2,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 24),
                            // Amount Input
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                    left: 8,
                                    bottom: 8,
                                  ),
                                  child: Text(
                                    context.tr('amount'),
                                    style: Theme.of(
                                      context,
                                    ).textTheme.labelSmall,
                                  ),
                                ),
                                TextField(
                                  controller: _amountController,
                                  keyboardType:
                                      const TextInputType.numberWithOptions(
                                        decimal: true,
                                      ),
                                  textAlign: TextAlign.right,
                                  style: Theme.of(
                                    context,
                                  ).textTheme.headlineLarge,
                                  decoration: InputDecoration(
                                    hintText: widget.currency == 'IQD'
                                        ? '0'
                                        : '0.00',
                                    prefixIcon: Padding(
                                      padding: const EdgeInsets.only(
                                        left: 16,
                                        top: 12,
                                      ),
                                      child: Text(
                                        _currencySymbol,
                                        style: Theme.of(context)
                                            .textTheme
                                            .headlineMedium
                                            ?.copyWith(color: AppTheme.primary),
                                      ),
                                    ),
                                    fillColor: AppTheme.surfaceContainerLow,
                                    filled: true,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide.none,
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide(
                                        color: AppTheme.primary,
                                        width: 2,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 24),
                            // Date Toggle
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                    left: 8,
                                    bottom: 8,
                                  ),
                                  child: Text(
                                    context.tr('when_did_this_happen'),
                                    style: Theme.of(
                                      context,
                                    ).textTheme.labelSmall,
                                  ),
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: GestureDetector(
                                        onTap: () =>
                                            setState(() => isToday = true),
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 16,
                                          ),
                                          decoration: BoxDecoration(
                                            color: isToday
                                                ? AppTheme.primaryContainer
                                                : AppTheme.surfaceContainerLow,
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                            border: Border.all(
                                              color: isToday
                                                  ? AppTheme.primaryContainer
                                                  : Colors.transparent,
                                              width: 2,
                                            ),
                                          ),
                                          child: Column(
                                            children: [
                                              Icon(
                                                Icons.today,
                                                size: 28,
                                                color: isToday
                                                    ? AppTheme
                                                          .onPrimaryContainer
                                                    : AppTheme.onSurfaceVariant,
                                              ),
                                              const SizedBox(height: 8),
                                              Text(
                                                context.tr('today'),
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .labelSmall
                                                    ?.copyWith(
                                                      color: isToday
                                                          ? AppTheme
                                                                .onPrimaryContainer
                                                          : AppTheme
                                                                .onSurfaceVariant,
                                                    ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: GestureDetector(
                                        onTap: () => _selectDate(context),
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 16,
                                          ),
                                          decoration: BoxDecoration(
                                            color: !isToday
                                                ? AppTheme.primaryContainer
                                                : AppTheme.surfaceContainerLow,
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                            border: Border.all(
                                              color: !isToday
                                                  ? AppTheme.primaryContainer
                                                  : Colors.transparent,
                                              width: 2,
                                            ),
                                          ),
                                          child: Column(
                                            children: [
                                              Icon(
                                                Icons.calendar_month,
                                                size: 28,
                                                color: !isToday
                                                    ? AppTheme
                                                          .onPrimaryContainer
                                                    : AppTheme.onSurfaceVariant,
                                              ),
                                              const SizedBox(height: 8),
                                              Text(
                                                !isToday
                                                    ? context.formatNumber(
                                                        DateFormat(
                                                          'MMM dd, yyyy',
                                                          Localizations.localeOf(
                                                            context,
                                                          ).languageCode,
                                                        ).format(selectedDate),
                                                      )
                                                    : context.tr('custom'),
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .labelSmall
                                                    ?.copyWith(
                                                      color: !isToday
                                                          ? AppTheme
                                                                .onPrimaryContainer
                                                          : AppTheme
                                                                .onSurfaceVariant,
                                                    ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 32),
                            // Action Area
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                style:
                                    ElevatedButton.styleFrom(
                                      backgroundColor: AppTheme.primary,
                                      foregroundColor: AppTheme.onPrimary,
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 20,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      side: const BorderSide(
                                        color: Color(0xFF7F2A0D),
                                        width: 4,
                                        strokeAlign:
                                            BorderSide.strokeAlignOutside,
                                      ),
                                    ).copyWith(
                                      side: WidgetStateProperty.resolveWith(
                                        (states) => const BorderSide(
                                          color: Color(0xFF7F2A0D),
                                          width: 4,
                                        ),
                                      ),
                                    ),
                                onPressed: _saveTransaction,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(Icons.add_circle, size: 24),
                                    const SizedBox(width: 8),
                                    Text(
                                      context.tr('save_transaction'),
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
