import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:finance_track/theme/app_theme.dart';

class AddTransactionScreen extends StatefulWidget {
  const AddTransactionScreen({super.key});

  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  bool isOutcome = true;
  bool isToday = true;

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
                  const SizedBox(height: 64),
                  // Mascot Peeking
                  Transform.translate(
                    offset: const Offset(0, 32),
                    child: Container(
                      width: 128,
                      height: 128,
                      decoration: BoxDecoration(shape: BoxShape.circle),
                      child: ClipOval(
                        child: Align(
                          alignment: Alignment.topCenter,
                          heightFactor: 0.5,
                          child: Image.network(
                            'https://lh3.googleusercontent.com/aida-public/AB6AXuCX1-mf-jzzTRu-uIEDeHHSovjiFtQrmWBQgfmh3GqDEeV6SnyZBRqy8dm_aEgJ7BnztLfiN4W-KtizR2TZA_ApKbFFbsYuftRrXfmSQcn8jCL9J8dyoXYT9-NyqEZ2ebVbmgLmLz9x_izhAXdNd9gxPbI4vgAte0IwQXqbjD-nVTDfzvOE8ACGIhii--e5ZbjEkE0NR66VvN9svKvrDR59Gl9wz3rD4RPwX67UsOzPXBN_ARQy2qQyiF1Taef4HAQ2le3y-Xij7tUP',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
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
                                  'New Transaction',
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
                                              'Outcome',
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
                                              'Income',
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
                                    'Item Name',
                                    style: Theme.of(
                                      context,
                                    ).textTheme.labelSmall,
                                  ),
                                ),
                                TextField(
                                  decoration: InputDecoration(
                                    hintText: 'What did you buy?',
                                    prefixIcon: const Icon(
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
                                      borderSide: const BorderSide(
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
                                    'Amount',
                                    style: Theme.of(
                                      context,
                                    ).textTheme.labelSmall,
                                  ),
                                ),
                                TextField(
                                  keyboardType: TextInputType.number,
                                  textAlign: TextAlign.right,
                                  style: Theme.of(
                                    context,
                                  ).textTheme.headlineLarge,
                                  decoration: InputDecoration(
                                    hintText: '0.00',
                                    prefixIcon: Padding(
                                      padding: const EdgeInsets.only(
                                        left: 16,
                                        top: 12,
                                      ),
                                      child: Text(
                                        '\$',
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
                                      borderSide: const BorderSide(
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
                                    'When did this happen?',
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
                                                'Today',
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
                                        onTap: () =>
                                            setState(() => isToday = false),
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
                                                'Custom',
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
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    Icon(Icons.add_circle, size: 24),
                                    SizedBox(width: 8),
                                    Text(
                                      'Save Transaction',
                                      style: TextStyle(
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
