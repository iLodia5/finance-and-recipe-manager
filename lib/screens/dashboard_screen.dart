import 'package:flutter/material.dart';
import 'package:finance_track/theme/app_theme.dart';
import 'package:finance_track/screens/add_transaction_screen.dart';
import 'package:finance_track/models/transaction.dart';
import 'package:intl/intl.dart';

import 'package:finance_track/services/finance_book_service.dart';
import 'package:finance_track/l10n/app_translations.dart';
import 'package:finance_track/services/settings_service.dart';

class DashboardScreen extends StatefulWidget {
  final String profileName;
  final String bookName;

  const DashboardScreen({super.key, required this.profileName, required this.bookName});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  List<Transaction> transactions = [];
  bool _isLoading = true;
  bool _isDeleteMode = false;
  bool _isIncomeListVisible = true;
  bool _isOutcomeListVisible = true;
  String _currency = 'USD';

  void _deleteTransaction(Transaction transaction) async {
    setState(() {
      transactions.remove(transaction);
    });
    await FinanceBookService.saveTransactions(widget.profileName, widget.bookName, transactions);
  }

  @override
  void initState() {
    super.initState();
    _loadTransactions();
  }

  void _loadTransactions() async {
    final loadedTransactions = await FinanceBookService.getTransactions(
      widget.profileName, widget.bookName
    );
    final currency = await FinanceBookService.getBookCurrency(
      widget.profileName, widget.bookName
    );
    setState(() {
      transactions = loadedTransactions;
      _currency = currency;
      _isLoading = false;
    });
  }

  double get totalIncome {
    return transactions
        .where((t) => t.isIncome)
        .fold(0.0, (sum, t) => sum + t.amount);
  }

  double get totalOutcome {
    return transactions
        .where((t) => !t.isIncome)
        .fold(0.0, (sum, t) => sum + t.amount);
  }

  double get savedAmount {
    return totalIncome - totalOutcome;
  }

  String get _currencySymbol {
    if (_currency == 'IQD') {
      return SettingsService.isArabic ? 'د.ع' : 'IQD';
    }
    return '\$';
  }

  NumberFormat get _currencyFormat => NumberFormat.currency(
    locale: Localizations.localeOf(context).languageCode,
    symbol: _currencySymbol,
    decimalDigits: _currency == 'IQD' ? 0 : 2,
  );
  DateFormat get _dateFormat =>
      DateFormat('MMM dd, yyyy', Localizations.localeOf(context).languageCode);

  Widget _buildIncomeCard(BuildContext context) {
    final incomeList = transactions.where((t) => t.isIncome).toList();

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
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            decoration: BoxDecoration(
              color: const Color(0x33EEE2BD), // tertiary-fixed with opacity
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(24),
              ),
              border: Border(
                bottom: BorderSide(color: AppTheme.outlineVariant),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: AppTheme.secondaryContainer,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.trending_up,
                          color: AppTheme.onSecondaryContainer,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Flexible(
                              child: Text(
                                context.tr('income_list'),
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineMedium
                                    ?.copyWith(fontSize: 20),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '${context.formatNumber(incomeList.length.toString())} ${context.tr('items')}',
                              style: Theme.of(context).textTheme.labelSmall
                                  ?.copyWith(
                                    color: AppTheme.onSurfaceVariant.withValues(
                                      alpha: 0.6,
                                    ),
                                    fontSize: 12,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: AppTheme.secondaryContainer,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    '+${context.formatNumber(_currencyFormat.format(totalIncome))}',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontSize: 16,
                      color: AppTheme.onSecondaryContainer,
                    ),
                  ),
                ),
                const SizedBox(width: 4),
                IconButton(
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  icon: Icon(
                    _isIncomeListVisible
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: AppTheme.onSurfaceVariant,
                  ),
                  onPressed: () {
                    setState(() {
                      _isIncomeListVisible = !_isIncomeListVisible;
                    });
                  },
                ),
              ],
            ),
          ),
          // Content
          if (_isIncomeListVisible)
            Padding(
              padding: const EdgeInsets.all(16),
              child: incomeList.isEmpty
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: Text(
                          context.tr('no_income_yet'),
                          style: TextStyle(color: AppTheme.onSurfaceVariant),
                        ),
                      ),
                    )
                  : Column(
                      children: incomeList.map((t) {
                        return Column(
                          children: [
                            _buildTransactionRow(
                              context,
                              t,
                              AppTheme.secondary,
                            ),
                            if (t != incomeList.last)
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                                child: Divider(
                                  color: AppTheme.outlineVariant,
                                  height: 1,
                                ),
                              ),
                          ],
                        );
                      }).toList(),
                    ),
            ),
        ],
      ),
    );
  }

  Widget _buildTransactionRow(
    BuildContext context,
    Transaction t,
    Color amountColor,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(t.title, style: Theme.of(context).textTheme.bodyLarge),
              Text(
                context.formatNumber(_dateFormat.format(t.date)),
                style: Theme.of(context).textTheme.labelSmall,
              ),
            ],
          ),
        ),
        Text(
          (t.isIncome ? '+' : '-') +
              context.formatNumber(_currencyFormat.format(t.amount)),
          style: Theme.of(
            context,
          ).textTheme.bodyLarge?.copyWith(color: amountColor),
        ),
        if (_isDeleteMode)
          IconButton(
            icon: Icon(Icons.remove_circle, color: AppTheme.error),
            onPressed: () => _deleteTransaction(t),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
      ],
    );
  }

  Widget _buildOutcomeCard(BuildContext context) {
    final outcomeList = transactions.where((t) => !t.isIncome).toList();

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
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            decoration: BoxDecoration(
              color: outcomeList.isNotEmpty
                  ? AppTheme.surfaceContainerLowest
                  : AppTheme.surfaceContainerLowest,
              borderRadius: BorderRadius.circular(24),
              border: outcomeList.isNotEmpty
                  ? Border(bottom: BorderSide(color: AppTheme.outlineVariant))
                  : null,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: AppTheme.errorContainer,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.trending_down,
                          color: AppTheme.onErrorContainer,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Flexible(
                              child: Text(
                                context.tr('outcome_list'),
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineMedium
                                    ?.copyWith(fontSize: 20),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '${context.formatNumber(outcomeList.length.toString())} ${context.tr('items')}',
                              style: Theme.of(context).textTheme.labelSmall
                                  ?.copyWith(
                                    color: AppTheme.onSurfaceVariant.withValues(
                                      alpha: 0.6,
                                    ),
                                    fontSize: 12,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: AppTheme.errorContainer,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    '-${context.formatNumber(_currencyFormat.format(totalOutcome))}',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontSize: 16,
                      color: AppTheme.onErrorContainer,
                    ),
                  ),
                ),
                const SizedBox(width: 4),
                IconButton(
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  icon: Icon(
                    _isOutcomeListVisible
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: AppTheme.onSurfaceVariant,
                  ),
                  onPressed: () {
                    setState(() {
                      _isOutcomeListVisible = !_isOutcomeListVisible;
                    });
                  },
                ),
              ],
            ),
          ),
          if (_isOutcomeListVisible && outcomeList.isNotEmpty)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Column(
                children: outcomeList.map((t) {
                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: Divider(
                          color: AppTheme.outlineVariant,
                          height: 1,
                        ),
                      ),
                      _buildTransactionRow(context, t, AppTheme.error),
                    ],
                  );
                }).toList(),
              ),
            ),
        ],
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
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppTheme.onSurfaceVariant),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
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
              widget.bookName,
              style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                color: AppTheme.primary,
                fontSize: 24,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(
              _isDeleteMode ? Icons.done : Icons.edit,
              color: _isDeleteMode
                  ? AppTheme.primary
                  : AppTheme.onSurfaceVariant,
              size: 28,
            ),
            onPressed: () {
              setState(() {
                _isDeleteMode = !_isDeleteMode;
              });
            },
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${context.tr('welcome_back')}${widget.profileName}!',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppTheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        context.tr('monthly_overview'),
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
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: savedAmount >= 0
                            ? AppTheme.secondaryContainer
                            : AppTheme.errorContainer,
                        borderRadius: BorderRadius.circular(999),
                        border: Border.all(
                          color: savedAmount >= 0
                              ? const Color(0xFFA2D3A4)
                              : AppTheme.error,
                        ),
                        boxShadow: AppTheme.warmShadowLg,
                      ),
                      child: Text(
                        '${context.tr('saved')} ${context.formatNumber(_currencyFormat.format(savedAmount))}',
                        style: Theme.of(context).textTheme.headlineMedium
                            ?.copyWith(
                              fontSize: 20,
                              color: savedAmount >= 0
                                  ? AppTheme.onSecondaryContainer
                                  : AppTheme.onErrorContainer,
                            ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final newTransaction = await Navigator.push<Transaction>(
            context,
            MaterialPageRoute(
              builder: (context) => AddTransactionScreen(currency: _currency),
            ),
          );

          if (newTransaction != null) {
            setState(() {
              transactions.add(newTransaction);
            });
            await FinanceBookService.saveTransactions(
              widget.profileName,
              widget.bookName,
              transactions,
            );
          }
        },
        backgroundColor: AppTheme.primary,
        foregroundColor: AppTheme.onPrimary,
        elevation:
            0, // handeled by container below if needed, but FAB has its own
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
        child: Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: AppTheme.warmShadowLg,
            border: const Border(
              bottom: BorderSide(color: Color(0xFF7F2A0D), width: 3),
            ),
          ),
          child: const Icon(Icons.add, size: 32),
        ),
      ),
    );
  }
}
