import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/database/database_providers.dart';
import '../../../../core/logic/wishlist_service.dart';
import '../../../../core/logic/budget_service.dart';
import '../../../../core/providers/price_tracker_provider.dart';
import '../../../../core/services/meli_price_service.dart';

import '../../../../core/utils/format_utils.dart';
import '../../../../core/providers/shell_providers.dart';
import '../../../budget/domain/models/budget.dart' as dom_b;
import '../../domain/models/wishlist_item.dart';
import '../providers/wishlist_provider.dart';
import '../widgets/add_wishlist_bottom_sheet.dart';
import '../widgets/purchase_bottom_sheet.dart';
import '../widgets/wishlist_budget_sheet.dart';

class WishlistPage extends ConsumerWidget {
  /// [standalone] = true when pushed on top of the shell (from Más, router).
  /// In standalone mode the page shows its own FAB.
  final bool standalone;
  const WishlistPage({super.key, this.standalone = false});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final itemsAsync = ref.watch(activeWishlistProvider);
    final hourlyRate = ref.watch(hourlyRateProvider);
    final globalReminderDays = ref.watch(globalReminderDaysProvider);
    final budgets = ref.watch(budgetsStreamProvider).valueOrNull ?? [];
    final shoppingBudget =
        budgets.where((b) => b.categoryId == 'shopping').firstOrNull;
    final priceDrops = ref.watch(priceDropAlertsProvider);

    // Trigger auto-check when page loads with items
    final items = itemsAsync.valueOrNull ?? [];
    if (items.isNotEmpty) {
      // Use Future.microtask to avoid calling during build
      Future.microtask(() => _autoCheckPrices(ref, items));
    }

    return Scaffold(
      floatingActionButton: standalone
          ? FloatingActionButton(
              onPressed: () => AddWishlistBottomSheet.show(context),
              backgroundColor: AppTheme.colorWarning,
              child: const Icon(Icons.add_rounded, color: Colors.white),
            )
          : null,
      appBar: AppBar(
        title: Text(
          'Compras Inteligentes',
          style: GoogleFonts.inter(fontWeight: FontWeight.w700, fontSize: 20),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          if (items.any((i) => i.url != null && MeliPriceService.extractItemId(i.url ?? '') != null))
            IconButton(
              icon: const Icon(Icons.refresh_rounded, size: 20),
              tooltip: 'Actualizar precios MeLi',
              onPressed: () => _forceCheckPrices(context, ref, items),
            ),
        ],
      ),
      body: itemsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, s) => Center(child: Text('Error: $e')),
        data: (items) {
          if (items.isEmpty) {
            return _EmptyState(shoppingBudget: shoppingBudget);
          }

          return ListView.separated(
            padding: const EdgeInsets.fromLTRB(20, 4, 20, 120),
            physics: const BouncingScrollPhysics(),
            itemCount: items.length + 1 + (priceDrops.isNotEmpty ? 1 : 0),
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              // Price drop alert banner
              if (priceDrops.isNotEmpty && index == 0) {
                return _PriceDropBanner(drops: priceDrops, onDismiss: () {
                  ref.read(priceDropAlertsProvider.notifier).state = [];
                });
              }

              final adjustedIndex = priceDrops.isNotEmpty ? index - 1 : index;

              if (adjustedIndex == 0) {
                return _ShoppingBudgetCard(budget: shoppingBudget);
              }
              final item = items[adjustedIndex - 1];

              // Find linked budget progress
              double? budgetSpent;
              double? budgetLimit;
              if (item.linkedBudgetId != null) {
                final budget = budgets
                    .where((b) => b.id == item.linkedBudgetId)
                    .firstOrNull;
                if (budget != null) {
                  budgetSpent = budget.spentAmount;
                  budgetLimit = budget.limitAmount;
                }
              }

              return _WishlistCard(
                item: item,
                hourlyRate: hourlyRate,
                globalReminderDays: globalReminderDays,
                budgetSpent: budgetSpent,
                budgetLimit: budgetLimit,
              );
            },
          );
        },
      ),
    );
  }

  static bool _autoCheckTriggered = false;

  Future<void> _autoCheckPrices(WidgetRef ref, List<WishlistItem> items) async {
    if (_autoCheckTriggered) return;
    _autoCheckTriggered = true;
    try {
      final drops = await ref.read(priceTrackerProvider.notifier).autoCheckPrices(items);
      if (drops.isNotEmpty) {
        ref.read(priceDropAlertsProvider.notifier).state = drops;
      }
    } catch (_) {}
  }

  Future<void> _forceCheckPrices(BuildContext context, WidgetRef ref, List<WishlistItem> items) async {
    _autoCheckTriggered = false;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('price_tracker_last_auto_check');

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Actualizando precios de MercadoLibre...'),
          backgroundColor: AppTheme.colorWarning.withValues(alpha: 0.8),
          duration: const Duration(seconds: 2),
        ),
      );
    }

    final drops = await ref.read(priceTrackerProvider.notifier).autoCheckPrices(items);
    if (drops.isNotEmpty) {
      ref.read(priceDropAlertsProvider.notifier).state = drops;
    }
    if (context.mounted) {
      final meliCount = items.where((i) => i.url != null && MeliPriceService.extractItemId(i.url ?? '') != null).length;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(drops.isNotEmpty
              ? '${drops.length} producto${drops.length > 1 ? 's' : ''} bajó de precio!'
              : '$meliCount precios actualizados'),
          backgroundColor: drops.isNotEmpty
              ? const Color(0xFF4CAF50).withValues(alpha: 0.8)
              : AppTheme.colorWarning.withValues(alpha: 0.8),
        ),
      );
    }
  }
}

// ─── Price Drop Banner ──────────────────────────────────────

class _PriceDropBanner extends StatelessWidget {
  final List<PriceDropAlert> drops;
  final VoidCallback onDismiss;
  const _PriceDropBanner({required this.drops, required this.onDismiss});

  @override
  Widget build(BuildContext context) {
    final fmt = NumberFormat.compactCurrency(symbol: '\$', decimalDigits: 0, locale: 'es_AR');
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF4CAF50).withValues(alpha: 0.15),
            const Color(0xFF4CAF50).withValues(alpha: 0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF4CAF50).withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.trending_down_rounded, color: Color(0xFF4CAF50), size: 18),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  '${drops.length} producto${drops.length > 1 ? 's bajaron' : ' bajó'} de precio!',
                  style: GoogleFonts.inter(
                    fontSize: 13, fontWeight: FontWeight.w700, color: const Color(0xFF4CAF50),
                  ),
                ),
              ),
              GestureDetector(
                onTap: onDismiss,
                child: Icon(Icons.close_rounded, color: Colors.white30, size: 16),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ...drops.take(3).map((d) => Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Row(
              children: [
                const SizedBox(width: 26),
                Expanded(
                  child: Text(d.itemTitle,
                    style: GoogleFonts.inter(fontSize: 12, color: Colors.white70),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Text(
                  '${fmt.format(d.oldPrice)} → ${fmt.format(d.newPrice)}',
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF4CAF50),
                  ),
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }
}

// ─── Empty State ────────────────────────────────────────────

class _EmptyState extends StatelessWidget {
  final dom_b.Budget? shoppingBudget;

  const _EmptyState({this.shoppingBudget});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 120),
      physics: const BouncingScrollPhysics(),
      children: [
        _ShoppingBudgetCard(budget: shoppingBudget),
        const SizedBox(height: 48),
        Center(
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppTheme.colorWarning.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.shopping_cart_outlined,
                    size: 48,
                    color: AppTheme.colorWarning.withValues(alpha: 0.7)),
              ),
              const SizedBox(height: 20),
              Text(
                'Tu lista está vacía',
                style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Agregá algo que quieras comprar\npara tomar decisiones más inteligentes.',
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontSize: 13,
                  color: Colors.white38,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ─── Shopping Budget Card ────────────────────────────────────

class _ShoppingBudgetCard extends ConsumerWidget {
  final dom_b.Budget? budget;
  const _ShoppingBudgetCard({this.budget});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (budget != null) {
      final spent = budget!.spentAmount;
      final limit = budget!.limitAmount;
      final progress = limit > 0 ? (spent / limit).clamp(0.0, 1.0) : 0.0;
      final remaining = (limit - spent).clamp(0.0, double.infinity);
      final fmt = NumberFormat.currency(
          symbol: '\$', decimalDigits: 0, locale: 'es_AR');

      return GestureDetector(
        onTap: () =>
            ref.read(navigateToTabProvider.notifier).state = 'budget',
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: AppTheme.colorWarning.withValues(alpha: 0.06),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
                color: AppTheme.colorWarning.withValues(alpha: 0.12)),
          ),
          child: Row(
            children: [
              // Mini progress circle
              SizedBox(
                width: 36,
                height: 36,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    CircularProgressIndicator(
                      value: progress,
                      strokeWidth: 3,
                      backgroundColor: Colors.white.withValues(alpha: 0.06),
                      color: progress >= 1.0
                          ? AppTheme.colorExpense
                          : AppTheme.colorWarning,
                    ),
                    Icon(Icons.shopping_bag_rounded,
                        color: AppTheme.colorWarning, size: 14),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Presupuesto de Compras',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w600)),
                    Text(
                      '${fmt.format(spent)} / ${fmt.format(limit)}',
                      style: TextStyle(
                        color: Colors.white38,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                fmt.format(remaining),
                style: TextStyle(
                  color: remaining > 0
                      ? AppTheme.colorIncome
                      : AppTheme.colorExpense,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(width: 4),
              Icon(Icons.chevron_right_rounded,
                  color: Colors.white24, size: 16),
            ],
          ),
        ),
      );
    }

    // No shopping budget — compact create row
    return GestureDetector(
      onTap: () => _createShoppingBudget(context, ref),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.03),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
              color: AppTheme.colorWarning.withValues(alpha: 0.1)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppTheme.colorWarning.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(Icons.add_rounded,
                  color: AppTheme.colorWarning, size: 16),
            ),
            const SizedBox(width: 10),
            Text('Crear Presupuesto de Compras',
                style: TextStyle(
                    color: Colors.white54,
                    fontSize: 12,
                    fontWeight: FontWeight.w600)),
            const Spacer(),
            Icon(Icons.chevron_right_rounded,
                color: Colors.white24, size: 16),
          ],
        ),
      ),
    );
  }

  Future<void> _createShoppingBudget(
      BuildContext context, WidgetRef ref) async {
    final amountController = TextEditingController();

    final amount = await showDialog<double>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1E1E2A),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Icon(Icons.shopping_bag_rounded,
                color: AppTheme.colorWarning, size: 22),
            const SizedBox(width: 8),
            const Expanded(
              child: Text('Presupuesto de Compras',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 16)),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              '¿Cuánto querés destinar por mes a compras?',
              style: TextStyle(color: Colors.white54, fontSize: 13),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: amountController,
              keyboardType: TextInputType.number,
              inputFormatters: [ThousandsSeparatorFormatter()],
              autofocus: true,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w700),
              decoration: InputDecoration(
                prefixText: '\$ ',
                prefixStyle: TextStyle(
                    color: AppTheme.colorWarning,
                    fontSize: 20,
                    fontWeight: FontWeight.w700),
                hintText: '50.000',
                hintStyle: const TextStyle(color: Colors.white24),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14)),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide:
                      const BorderSide(color: AppTheme.colorWarning),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancelar',
                style: TextStyle(color: Colors.white54)),
          ),
          FilledButton(
            onPressed: () {
              final val = parseFormattedAmount(amountController.text);
              if (val > 0) Navigator.pop(ctx, val);
            },
            style: FilledButton.styleFrom(
                backgroundColor: AppTheme.colorWarning),
            child: const Text('Crear'),
          ),
        ],
      ),
    );

    if (amount != null && amount > 0) {
      try {
        await ref.read(budgetServiceProvider).addBudgetForCategory(
              categoryId: 'shopping',
              categoryName: 'Compras',
              limitAmount: amount,
              isFixed: false,
              colorValue: AppTheme.colorWarning.toARGB32(),
              iconKey: 'shopping_bag',
            );
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Presupuesto de compras creado'),
              backgroundColor:
                  AppTheme.colorWarning.withValues(alpha: 0.8),
            ),
          );
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: $e')),
          );
        }
      }
    }
  }
}

// ─── Wishlist Card ────────────────────────────────────────────

class _WishlistCard extends ConsumerWidget {
  final WishlistItem item;
  final double? hourlyRate;
  final int globalReminderDays;
  final double? budgetSpent;
  final double? budgetLimit;

  const _WishlistCard({
    required this.item,
    required this.hourlyRate,
    required this.globalReminderDays,
    this.budgetSpent,
    this.budgetLimit,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final fmt = NumberFormat.compactCurrency(
        symbol: '\$', decimalDigits: 1, locale: 'es_AR');
    final now = DateTime.now();
    final daysPassed = now.difference(item.createdAt).inDays;
    final effectiveReminderDays = item.reminderDays ?? globalReminderDays;
    final isSnoozed = item.reminderSnoozedUntil != null &&
        now.isBefore(item.reminderSnoozedUntil!);
    final showReminder = daysPassed >= effectiveReminderDays &&
        !item.reminderDismissed &&
        !isSnoozed;
    final workHours =
        hourlyRate != null ? (item.estimatedCost / hourlyRate!).ceil() : null;
    final hasBudget = budgetSpent != null && budgetLimit != null;
    final savingsProgress =
        hasBudget && budgetLimit! > 0
            ? (budgetSpent! / budgetLimit!).clamp(0.0, 1.0)
            : 0.0;

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E2C).withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: showReminder
              ? AppTheme.colorWarning.withValues(alpha: 0.3)
              : Colors.white.withValues(alpha: 0.05),
          width: showReminder ? 1.5 : 1.0,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Reminder banner
          if (showReminder)
            Container(
              width: double.infinity,
              padding:
                  const EdgeInsets.symmetric(vertical: 7, horizontal: 14),
              decoration: BoxDecoration(
                color: AppTheme.colorWarning.withValues(alpha: 0.12),
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(18)),
              ),
              child: Row(
                children: [
                  Icon(Icons.psychology_alt_rounded,
                      color: AppTheme.colorWarning, size: 14),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      'Hace $daysPassed días. ¿Realmente lo necesitás?',
                      style: GoogleFonts.inter(
                        color: AppTheme.colorWarning,
                        fontWeight: FontWeight.w600,
                        fontSize: 11,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => ref
                        .read(wishlistServiceProvider)
                        .snoozeReminder(
                            item.id, Duration(days: effectiveReminderDays)),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: AppTheme.colorWarning.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text('Posponer',
                          style: TextStyle(
                              color: AppTheme.colorWarning,
                              fontSize: 10,
                              fontWeight: FontWeight.w600)),
                    ),
                  ),
                  const SizedBox(width: 6),
                  GestureDetector(
                    onTap: () => ref
                        .read(wishlistServiceProvider)
                        .dismissReminder(item.id),
                    child: Icon(Icons.close_rounded,
                        color: AppTheme.colorWarning.withValues(alpha: 0.5),
                        size: 14),
                  ),
                ],
              ),
            ),

          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title row with X discard + edit
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.title,
                            style: GoogleFonts.inter(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Row(
                            children: [
                              Text(
                                fmt.format(item.estimatedCost),
                                style: GoogleFonts.inter(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w800,
                                  color: AppTheme.colorExpense,
                                ),
                              ),
                              if (workHours != null) ...[
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withValues(alpha: 0.05),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    '${workHours}h de trabajo',
                                    style: const TextStyle(
                                      color: Colors.white30,
                                      fontSize: 10,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ],
                      ),
                    ),
                    // Edit icon
                    GestureDetector(
                      onTap: () => AddWishlistBottomSheet.show(context,
                          itemToEdit: item),
                      child: Padding(
                        padding: const EdgeInsets.all(4),
                        child: Icon(Icons.edit_rounded,
                            color: Colors.white24, size: 16),
                      ),
                    ),
                    const SizedBox(width: 2),
                    // X discard icon
                    GestureDetector(
                      onTap: () => ref
                          .read(wishlistServiceProvider)
                          .deleteItem(item.id),
                      child: Padding(
                        padding: const EdgeInsets.all(4),
                        child: Icon(Icons.close_rounded,
                            color: Colors.white24, size: 16),
                      ),
                    ),
                  ],
                ),

                // Info chips
                if (item.installments > 1 ||
                    item.hasPromo ||
                    (item.url != null && item.url!.isNotEmpty)) ...[
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 6,
                    runSpacing: 4,
                    children: [
                      if (item.installments > 1)
                        _InfoChip(
                          icon: Icons.credit_card_rounded,
                          label:
                              '${item.installments}x ${NumberFormat.compactCurrency(symbol: '\$', decimalDigits: 0, locale: 'es_AR').format(item.estimatedCost / item.installments)}',
                          color: AppTheme.colorTransfer,
                        ),
                      if (item.hasPromo)
                        _InfoChip(
                          icon: Icons.local_offer_rounded,
                          label: 'Promo',
                          color: const Color(0xFF4CAF50),
                        ),
                      if (item.url != null && item.url!.isNotEmpty)
                        _UrlChip(url: item.url!),
                      if (item.url != null && MeliPriceService.extractItemId(item.url!) != null)
                        _MeliCheckChip(item: item),
                    ],
                  ),
                ],

                if (item.note != null && item.note!.isNotEmpty) ...[
                  const SizedBox(height: 6),
                  Text(item.note!,
                      style: TextStyle(color: Colors.white30, fontSize: 11)),
                ],

                // ── Price tracker ──
                Builder(builder: (context) {
                  final tracker = ref.watch(priceTrackerProvider);
                  final history = tracker[item.id];
                  final trend = history?.trend;
                  final hasDrop = history?.hasDrop ?? false;

                  return Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () => _showPriceLogDialog(context, ref, item),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: hasDrop
                                  ? const Color(0xFF4CAF50).withValues(alpha: 0.12)
                                  : Colors.white.withValues(alpha: 0.05),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: hasDrop
                                    ? const Color(0xFF4CAF50).withValues(alpha: 0.3)
                                    : Colors.white.withValues(alpha: 0.08),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  trend == null
                                      ? Icons.trending_flat_rounded
                                      : (trend < 0 ? Icons.trending_down_rounded : Icons.trending_up_rounded),
                                  size: 14,
                                  color: trend == null
                                      ? Colors.white30
                                      : (trend < 0 ? const Color(0xFF4CAF50) : AppTheme.colorExpense),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  history != null && history.entries.isNotEmpty
                                      ? '${history.entries.length} precios'
                                      : 'Seguir precio',
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600,
                                    color: hasDrop ? const Color(0xFF4CAF50) : Colors.white38,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        if (hasDrop) ...[
                          const SizedBox(width: 6),
                          Text(
                            '¡Bajó de precio!',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF4CAF50),
                            ),
                          ),
                        ],
                      ],
                    ),
                  );
                }),

                if (hourlyRate == null) ...[
                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: () => context.push('/settings'),
                    child: Text(
                      'Configurá tu sueldo para ver horas de trabajo →',
                      style: TextStyle(color: Colors.white24, fontSize: 10),
                    ),
                  ),
                ],

                const SizedBox(height: 12),

                // Action row: Savings indicator + Buy button
                Row(
                  children: [
                    // Savings piggy bank (tap to create/view)
                    GestureDetector(
                      onTap: hasBudget
                          ? () => ref
                              .read(navigateToTabProvider.notifier)
                              .state = 'budget'
                          : () => WishlistBudgetSheet.show(context, item),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 8),
                        decoration: BoxDecoration(
                          color: hasBudget
                              ? AppTheme.colorTransfer
                                  .withValues(alpha: 0.08)
                              : Colors.white.withValues(alpha: 0.03),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: hasBudget
                                ? AppTheme.colorTransfer
                                    .withValues(alpha: 0.15)
                                : Colors.white.withValues(alpha: 0.06),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Mini piggy bank with fill
                            SizedBox(
                              width: 24,
                              height: 24,
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  if (hasBudget)
                                    CircularProgressIndicator(
                                      value: savingsProgress,
                                      strokeWidth: 2.5,
                                      backgroundColor: Colors.white
                                          .withValues(alpha: 0.06),
                                      color: AppTheme.colorTransfer,
                                    ),
                                  Icon(
                                    Icons.savings_rounded,
                                    size: hasBudget ? 12 : 16,
                                    color: hasBudget
                                        ? AppTheme.colorTransfer
                                        : Colors.white24,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              hasBudget
                                  ? '${(savingsProgress * 100).toInt()}%'
                                  : 'Ahorrar',
                              style: TextStyle(
                                color: hasBudget
                                    ? AppTheme.colorTransfer
                                    : Colors.white30,
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const Spacer(),

                    // Buy button
                    FilledButton.icon(
                      icon: const Icon(
                          Icons.shopping_cart_checkout_rounded,
                          size: 15),
                      label: const Text('Comprar'),
                      style: FilledButton.styleFrom(
                        backgroundColor: AppTheme.colorWarning,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 10),
                        textStyle: const TextStyle(
                            fontSize: 13, fontWeight: FontWeight.w700),
                      ),
                      onPressed: () =>
                          PurchaseBottomSheet.show(context, item),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Price Log Dialog ────────────────────────────────
void _showPriceLogDialog(BuildContext context, WidgetRef ref, WishlistItem item) {
  final ctrl = TextEditingController(text: item.estimatedCost.toStringAsFixed(0));
  final tracker = ref.read(priceTrackerProvider);
  final history = tracker[item.id];
  final fmt = NumberFormat.compactCurrency(symbol: '\$', decimalDigits: 0, locale: 'es_AR');

  showModalBottomSheet(
    context: context,
    backgroundColor: const Color(0xFF18181F),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    isScrollControlled: true,
    builder: (ctx) => Padding(
      padding: EdgeInsets.fromLTRB(20, 16, 20, MediaQuery.of(ctx).viewInsets.bottom + 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40, height: 4,
            decoration: BoxDecoration(color: Colors.white12, borderRadius: BorderRadius.circular(2)),
          ),
          const SizedBox(height: 16),
          Text('Seguimiento de precio',
            style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.white),
          ),
          const SizedBox(height: 4),
          Text(item.title,
            style: GoogleFonts.inter(fontSize: 13, color: Colors.white54),
          ),
          const SizedBox(height: 16),

          // Price history
          if (history != null && history.entries.isNotEmpty) ...[
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.04),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _PriceStat('Mínimo', fmt.format(history.lowestPrice!), const Color(0xFF4CAF50)),
                      _PriceStat('Último', fmt.format(history.latestPrice!), Colors.white70),
                      _PriceStat('Máximo', fmt.format(history.highestPrice!), AppTheme.colorExpense),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text('${history.entries.length} registros',
                    style: GoogleFonts.inter(fontSize: 10, color: Colors.white24),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
          ],

          // New price input
          TextField(
            controller: ctrl,
            keyboardType: TextInputType.number,
            autofocus: true,
            style: GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.w700, color: Colors.white),
            decoration: InputDecoration(
              prefixText: '\$ ',
              prefixStyle: TextStyle(
                color: AppTheme.colorWarning, fontSize: 20, fontWeight: FontWeight.w700,
              ),
              hintText: 'Precio actual',
              hintStyle: const TextStyle(color: Colors.white24),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(color: AppTheme.colorWarning),
              ),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              icon: const Icon(Icons.add_chart_rounded, size: 18),
              label: const Text('Registrar precio'),
              style: FilledButton.styleFrom(
                backgroundColor: AppTheme.colorWarning,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
              onPressed: () {
                final val = double.tryParse(ctrl.text.replaceAll('.', '').replaceAll(',', '.'));
                if (val != null && val > 0) {
                  ref.read(priceTrackerProvider.notifier).logPrice(item.id, val);
                  // Also update estimated cost if changed
                  if (val != item.estimatedCost) {
                    ref.read(wishlistServiceProvider).updateItem(item.id, estimatedCost: val);
                  }
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Precio registrado: ${fmt.format(val)}'),
                      backgroundColor: AppTheme.colorWarning.withValues(alpha: 0.8),
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
    ),
  );
}

class _PriceStat extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  const _PriceStat(this.label, this.value, this.color);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(label, style: GoogleFonts.inter(fontSize: 10, color: Colors.white38)),
        const SizedBox(height: 2),
        Text(value, style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w700, color: color)),
      ],
    );
  }
}

// ─── Chips ────────────────────────────────────────────

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  const _InfoChip(
      {required this.icon, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 12),
          const SizedBox(width: 4),
          Text(label,
              style: TextStyle(
                  color: color, fontSize: 11, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

class _UrlChip extends StatelessWidget {
  final String url;
  const _UrlChip({required this.url});

  bool get _isMercadoLibre =>
      url.contains('mercadolibre') ||
      url.contains('meli') ||
      url.contains('mercadopago');

  @override
  Widget build(BuildContext context) {
    final color =
        _isMercadoLibre ? const Color(0xFFFFE600) : AppTheme.colorWarning;
    final textColor = _isMercadoLibre ? Colors.black87 : Colors.white;
    final label = _isMercadoLibre ? 'MeLi' : 'Ver';
    final icon =
        _isMercadoLibre ? Icons.store_rounded : Icons.open_in_new_rounded;

    return GestureDetector(
      onTap: () async {
        final uri = Uri.tryParse(url);
        if (uri != null && await canLaunchUrl(uri)) {
          await launchUrl(uri, mode: LaunchMode.externalApplication);
        } else {
          if (!context.mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('No se pudo abrir el link')),
          );
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color.withValues(alpha: 0.5)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: textColor, size: 12),
            const SizedBox(width: 4),
            Text(label,
                style: TextStyle(
                    color: textColor,
                    fontSize: 11,
                    fontWeight: FontWeight.w700)),
          ],
        ),
      ),
    );
  }
}

class _MeliCheckChip extends ConsumerStatefulWidget {
  final WishlistItem item;
  const _MeliCheckChip({required this.item});

  @override
  ConsumerState<_MeliCheckChip> createState() => _MeliCheckChipState();
}

class _MeliCheckChipState extends ConsumerState<_MeliCheckChip> {
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    const color = Color(0xFF00B1EA); // MeLi blue
    final fmt = NumberFormat.compactCurrency(symbol: '\$', decimalDigits: 0, locale: 'es_AR');
    final tracker = ref.watch(priceTrackerProvider);
    final history = tracker[widget.item.id];
    final lastMeliEntry = history?.entries
        .where((e) => e.source == 'meli')
        .lastOrNull;

    return GestureDetector(
      onTap: _loading ? null : () async {
        setState(() => _loading = true);
        final result = await ref
            .read(priceTrackerProvider.notifier)
            .checkSinglePrice(widget.item);
        if (!mounted) return;
        setState(() => _loading = false);
        if (result != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('${widget.item.title}: ${fmt.format(result.price)} en MeLi'),
              backgroundColor: color.withValues(alpha: 0.8),
            ),
          );
        } else {
          final hasUrl = widget.item.url != null && widget.item.url!.isNotEmpty;
          final hasValidId = hasUrl && MeliPriceService.isValidProductUrl(widget.item.url);
          final apiError = MeliPriceService.lastError;
          final msg = !hasUrl
              ? 'Agregá un link de MercadoLibre al item'
              : !hasValidId
                  ? 'El link no contiene un ID de producto MeLi válido (MLA-...)'
                  : apiError != null
                      ? 'Error MeLi: $apiError'
                      : 'No se pudo conectar con MercadoLibre';
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(msg)),
          );
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (_loading)
              SizedBox(
                width: 12, height: 12,
                child: CircularProgressIndicator(strokeWidth: 1.5, color: color),
              )
            else
              Icon(Icons.price_check_rounded, color: color, size: 12),
            const SizedBox(width: 4),
            Text(
              lastMeliEntry != null
                  ? fmt.format(lastMeliEntry.price)
                  : 'Precio MeLi',
              style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}
