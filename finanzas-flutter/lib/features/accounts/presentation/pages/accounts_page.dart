import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/providers/shell_providers.dart';
import '../../../../core/providers/feedback_provider.dart';
import '../../../../core/database/database_providers.dart';
import '../../../../core/logic/account_service.dart';
import '../../../../core/utils/format_utils.dart';
import '../../../../core/providers/account_order_provider.dart';
import '../../../../core/widgets/app_fab.dart';
import '../../../../core/providers/mercado_pago_provider.dart';
import '../../../transactions/domain/models/transaction.dart' as dom_tx;
import '../../domain/models/account.dart' as dom;
import '../widgets/edit_account_sheet.dart';

class AccountsPage extends ConsumerWidget {
  final bool standalone;
  const AccountsPage({super.key, this.standalone = false});

  /// Sort accounts by custom order (saved in SharedPreferences), fallback to default sort
  List<dom.Account> _sortAccounts(List<dom.Account> accounts, List<String> customOrder) {
    if (customOrder.isNotEmpty) {
      final orderMap = <String, int>{};
      for (var i = 0; i < customOrder.length; i++) {
        orderMap[customOrder[i]] = i;
      }
      final sorted = List<dom.Account>.from(accounts);
      sorted.sort((a, b) {
        final ai = orderMap[a.id] ?? 999;
        final bi = orderMap[b.id] ?? 999;
        if (ai != bi) return ai.compareTo(bi);
        return a.name.compareTo(b.name);
      });
      return sorted;
    }
    // Default sort
    final sorted = List<dom.Account>.from(accounts);
    sorted.sort((a, b) {
      if (a.isDefault && !b.isDefault) return -1;
      if (!a.isDefault && b.isDefault) return 1;
      if (!a.isCreditCard && b.isCreditCard) return -1;
      if (a.isCreditCard && !b.isCreditCard) return 1;
      if (a.isCreditCard && b.isCreditCard) return b.totalDebt.compareTo(a.totalDebt);
      return b.balance.compareTo(a.balance);
    });
    return sorted;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Listen for shell FAB trigger to open add-account dialog
    if (!standalone) {
      ref.listen<int>(addAccountRequestProvider, (prev, next) {
        if (prev != null && next > prev) {
          _showAddAccountDialog(context, ref);
        }
      });
    }

    final accountsAsync = ref.watch(accountsStreamProvider);
    final customOrder = ref.watch(accountOrderProvider);
    final sortMode = ref.watch(accountSortModeProvider);
    final txsAsync = ref.watch(transactionsStreamProvider);
    final mpLinkedId = ref.watch(mpLinkedAccountIdProvider).valueOrNull;

    return accountsAsync.when(
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (err, stack) =>
          Scaffold(body: Center(child: Text('Error: $err'))),
      data: (accounts) {
        final sorted = _sortAccounts(accounts, customOrder);

        // Current month spending per account (expenses only)
        final now = DateTime.now();
        final txs = txsAsync.valueOrNull ?? [];
        final Map<String, double> monthSpendByAccount = {};
        // Period spending for credit cards (based on closing day)
        final Map<String, double> periodSpendByAccount = {};

        for (final t in txs) {
          if (t.type == dom_tx.TransactionType.expense) {
            if (t.date.month == now.month && t.date.year == now.year) {
              monthSpendByAccount[t.accountId] =
                  (monthSpendByAccount[t.accountId] ?? 0) + t.amount;
            }
          }
        }

        // Calculate billing period expenses for each credit card
        for (final acc in sorted) {
          if (acc.isCreditCard && acc.closingDay != null) {
            final closingDay = acc.closingDay!;
            DateTime periodStart;
            if (now.day > closingDay) {
              periodStart = DateTime(now.year, now.month, closingDay + 1);
            } else {
              periodStart = now.month == 1
                  ? DateTime(now.year - 1, 12, closingDay + 1)
                  : DateTime(now.year, now.month - 1, closingDay + 1);
            }
            double total = 0;
            for (final t in txs) {
              if (t.accountId == acc.id &&
                  t.type == dom_tx.TransactionType.expense &&
                  (t.date.isAfter(periodStart) || t.date.isAtSameMomentAs(periodStart))) {
                total += t.amount;
              }
            }
            periodSpendByAccount[acc.id] = total;
          }
        }
        // Group accounts by type
        final groups = <String, List<dom.Account>>{};
        for (final acc in sorted) {
          final key = (mpLinkedId != null && acc.id == mpLinkedId)
              ? 'mp'
              : acc.type.name;
          groups.putIfAbsent(key, () => []).add(acc);
        }
        // Display order for groups
        const groupOrder = ['cash', 'bank', 'mp', 'savings', 'investment', 'credit'];
        const groupLabels = {
          'cash': 'Efectivo',
          'bank': 'Debito',
          'mp': 'Mercado Pago',
          'savings': 'Ahorro',
          'investment': 'Inversion',
          'credit': 'Tarjetas de credito',
        };

        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: Text(
              'Tus Cuentas',
              style:
                  GoogleFonts.inter(fontWeight: FontWeight.w700, fontSize: 20),
            ),
            actions: [
              // Sort mode toggle
              PopupMenuButton<String>(
                icon: Icon(
                  sortMode == AccountSortMode.manual
                      ? Icons.swap_vert_rounded
                      : Icons.auto_awesome_rounded,
                  size: 22,
                ),
                color: const Color(0xFF1E1E2C),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                onSelected: (val) {
                  if (val == 'auto') {
                    ref.read(accountSortModeProvider.notifier).setMode(AccountSortMode.auto);
                    ref.read(accountOrderProvider.notifier).clear();
                  } else if (val == 'manual') {
                    ref.read(accountSortModeProvider.notifier).setMode(AccountSortMode.manual);
                    _showReorderSheet(context, ref, sorted);
                  } else if (val == 'reorder') {
                    _showReorderSheet(context, ref, sorted);
                  }
                },
                itemBuilder: (_) => [
                  PopupMenuItem(
                    value: 'auto',
                    child: Row(children: [
                      Icon(Icons.auto_awesome_rounded, size: 18,
                          color: sortMode == AccountSortMode.auto ? AppTheme.colorTransfer : Colors.white54),
                      const SizedBox(width: 10),
                      Text('Automatico',
                          style: TextStyle(
                            color: sortMode == AccountSortMode.auto ? AppTheme.colorTransfer : Colors.white,
                            fontWeight: sortMode == AccountSortMode.auto ? FontWeight.w600 : FontWeight.w400,
                          )),
                    ]),
                  ),
                  PopupMenuItem(
                    value: 'manual',
                    child: Row(children: [
                      Icon(Icons.swap_vert_rounded, size: 18,
                          color: sortMode == AccountSortMode.manual ? AppTheme.colorTransfer : Colors.white54),
                      const SizedBox(width: 10),
                      Text('Manual',
                          style: TextStyle(
                            color: sortMode == AccountSortMode.manual ? AppTheme.colorTransfer : Colors.white,
                            fontWeight: sortMode == AccountSortMode.manual ? FontWeight.w600 : FontWeight.w400,
                          )),
                    ]),
                  ),
                  if (sortMode == AccountSortMode.manual)
                    const PopupMenuItem(
                      value: 'reorder',
                      child: Row(children: [
                        Icon(Icons.drag_handle_rounded, size: 18, color: Colors.white54),
                        SizedBox(width: 10),
                        Text('Reordenar', style: TextStyle(color: Colors.white)),
                      ]),
                    ),
                ],
              ),
              const SizedBox(width: 4),
            ],
          ),
          body: Stack(
            children: [
              ListView(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 120),
                children: [
                  if (sortMode == AccountSortMode.auto) ...[
                    // Grouped by type
                    for (final groupKey in groupOrder)
                      if (groups.containsKey(groupKey)) ...[
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10, top: 6),
                          child: Text(
                            groupLabels[groupKey] ?? groupKey,
                            style: GoogleFonts.inter(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: Colors.white38,
                            ),
                          ),
                        ),
                        for (final acc in groups[groupKey]!)
                          _buildAccountCard(context, ref, acc, monthSpendByAccount, periodSpendByAccount, mpLinkedId),
                      ],
                  ] else ...[
                    // Manual order — flat list
                    for (final acc in sorted)
                      _buildAccountCard(context, ref, acc, monthSpendByAccount, periodSpendByAccount, mpLinkedId),
                  ],
                ],
              ),
              if (standalone)
                Positioned(
                  right: 16,
                  bottom: MediaQuery.of(context).padding.bottom + 16,
                  child: AppFab(
                    icon: Icons.add_rounded,
                    onPressed: () {
                      appHaptic(ref, type: HapticType.medium);
                      appSound(ref, type: SoundType.tap);
                      _showAddAccountDialog(context, ref);
                    },
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAccountCard(
    BuildContext context,
    WidgetRef ref,
    dom.Account acc,
    Map<String, double> monthSpendByAccount,
    Map<String, double> periodSpendByAccount,
    String? mpLinkedId,
  ) {
    return _AccountCard(
      account: acc,
      monthSpend: monthSpendByAccount[acc.id] ?? 0.0,
      periodSpend: periodSpendByAccount[acc.id],
      isMpLinked: mpLinkedId != null && acc.id == mpLinkedId,
      onTap: () => context.push('/accounts/${acc.id}'),
      onLongPress: () => _showAccountOptions(context, ref, acc),
      onPayStatement: acc.isCreditCard && acc.pendingStatementAmount > 0
          ? () => _showPayStatementDialog(context, ref, acc)
          : null,
    );
  }

  void _showReorderSheet(BuildContext context, WidgetRef ref, List<dom.Account> accounts) {
    final reorderable = List<dom.Account>.from(accounts);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setLocal) {
          return Container(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.7,
            ),
            padding: const EdgeInsets.fromLTRB(0, 24, 0, 24),
            decoration: const BoxDecoration(
              color: Color(0xFF18181F),
              borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(2)))),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Row(
                    children: [
                      Text('Ordenar cuentas', style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w700, color: Colors.white)),
                      const Spacer(),
                      FilledButton(
                        onPressed: () {
                          ref.read(accountOrderProvider.notifier).setOrder(
                            reorderable.map((a) => a.id).toList(),
                          );
                          Navigator.pop(ctx);
                        },
                        style: FilledButton.styleFrom(
                          backgroundColor: AppTheme.colorTransfer,
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          minimumSize: Size.zero,
                        ),
                        child: const Text('Guardar', style: TextStyle(fontSize: 13)),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 4),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Text('Mantené presionado y arrastrá para reordenar',
                      style: GoogleFonts.inter(fontSize: 12, color: Colors.white38)),
                ),
                const SizedBox(height: 12),
                Flexible(
                  child: ReorderableListView.builder(
                    shrinkWrap: true,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: reorderable.length,
                    onReorder: (oldIndex, newIndex) {
                      setLocal(() {
                        if (newIndex > oldIndex) newIndex--;
                        final item = reorderable.removeAt(oldIndex);
                        reorderable.insert(newIndex, item);
                      });
                    },
                    proxyDecorator: (child, index, animation) {
                      return Material(
                        color: Colors.transparent,
                        elevation: 4,
                        shadowColor: AppTheme.colorTransfer.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(14),
                        child: child,
                      );
                    },
                    itemBuilder: (ctx, index) {
                      final acc = reorderable[index];
                      final color = getAccountColor(acc);
                      return Container(
                        key: ValueKey(acc.id),
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1E1E2C),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: color.withValues(alpha: 0.2)),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.drag_handle_rounded, size: 20, color: Colors.white38),
                            const SizedBox(width: 12),
                            Container(
                              width: 32, height: 32,
                              decoration: BoxDecoration(
                                color: color.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(
                                acc.isCreditCard ? Icons.credit_card_rounded : Icons.account_balance_wallet_rounded,
                                size: 16, color: color,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(acc.name, style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.white)),
                            ),
                            Text(formatAmount(acc.balance),
                                style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.white70)),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // ──────────────────────────────────────────────────────────────
  // Long-press options bottom sheet
  // ──────────────────────────────────────────────────────────────
  void _showAccountOptions(
      BuildContext context, WidgetRef ref, dom.Account acc) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Color(0xFF18181F),
          borderRadius:
              BorderRadius.vertical(top: Radius.circular(32)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(2)),
              ),
            ),
            const SizedBox(height: 24),
            Text(acc.name,
                style: GoogleFonts.inter(
                    fontWeight: FontWeight.w700,
                    fontSize: 18,
                    color: Colors.white)),
            const SizedBox(height: 24),
            ListTile(
              leading:
                  Icon(Icons.edit_rounded, color: AppTheme.colorTransfer),
              title: const Text('Editar cuenta',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w500)),
              onTap: () {
                Navigator.pop(ctx);
                showEditAccountSheet(context, ref, acc);
              },
            ),
            if (!acc.isDefault)
              ListTile(
                leading: Icon(Icons.delete_forever_rounded,
                    color: AppTheme.colorExpense),
                title: Text('Eliminar cuenta',
                    style: TextStyle(
                        color: AppTheme.colorExpense,
                        fontWeight: FontWeight.w500)),
                onTap: () async {
                  Navigator.pop(ctx);
                  final confirm = await showDialog<bool>(
                    context: context,
                    builder: (dCtx) => AlertDialog(
                      backgroundColor: const Color(0xFF1E1E2C),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      title: const Text('¿Eliminar cuenta?',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700)),
                      content: Text(
                        'Se eliminará "${acc.name}" permanentemente.',
                        style: const TextStyle(
                            color: Colors.white70, fontSize: 14),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(dCtx, false),
                          child: const Text('Cancelar',
                              style: TextStyle(color: Colors.white54)),
                        ),
                        FilledButton(
                          onPressed: () => Navigator.pop(dCtx, true),
                          style: FilledButton.styleFrom(
                              backgroundColor: AppTheme.colorExpense),
                          child: const Text('Eliminar'),
                        ),
                      ],
                    ),
                  );
                  if (confirm == true) {
                    await ref
                        .read(accountServiceProvider)
                        .deleteAccount(acc.id);
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content:
                                Text('"${acc.name}" eliminada')),
                      );
                    }
                  }
                },
              ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  // ──────────────────────────────────────────────────────────────
  // Add account bottom sheet
  // ──────────────────────────────────────────────────────────────
  void _showAddAccountDialog(BuildContext context, WidgetRef ref) {
    final nameController = TextEditingController();
    final balanceController = TextEditingController(text: '0');
    final closingDayController = TextEditingController();
    final dueDayController = TextEditingController();
    final creditLimitController = TextEditingController();
    final debtController = TextEditingController();
    final aliasController = TextEditingController();
    final cvuController = TextEditingController();
    String selectedType = 'Débito';
    String selectedIcon = 'wallet';
    Color selectedColor = AppTheme.colorTransfer;
    bool showAlias = false;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setState) => ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(ctx).size.height * 0.92,
            ),
            child: SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.fromLTRB(
                    24, 24, 24, MediaQuery.of(ctx).viewInsets.bottom + 32),
                decoration: const BoxDecoration(
                  color: Color(0xFF18181F),
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(32),
                      topRight: Radius.circular(32)),
                ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Nueva Cuenta / Billetera',
                    style: GoogleFonts.inter(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Colors.white),
                  ),
                  const SizedBox(height: 24),
                  TextField(
                    controller: nameController,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: 'Nombre / Institución',
                      labelStyle:
                          const TextStyle(color: AppTheme.colorTransfer),
                      hintText: 'Ej. Mercado Pago, BBVA, Brubank',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16)),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: balanceController,
                          keyboardType: TextInputType.number,
                          inputFormatters: [ThousandsSeparatorFormatter()],
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            labelText: selectedType == 'Crédito'
                                ? 'Gastos actuales'
                                : 'Saldo Inicial',
                            prefixText: r'$ ',
                            labelStyle: const TextStyle(
                                color: AppTheme.colorTransfer),
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.circular(16)),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.white10),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: DropdownButton<String>(
                          value: selectedType,
                          dropdownColor: const Color(0xFF18181F),
                          underline: const SizedBox(),
                          style:
                              const TextStyle(color: Colors.white),
                          items: ['Débito', 'Crédito']
                              .map((t) => DropdownMenuItem(
                                  value: t, child: Text(t)))
                              .toList(),
                          onChanged: (val) {
                            if (val != null) {
                              setState(() {
                                selectedType = val;
                                if (val == 'Crédito') {
                                  selectedIcon = 'credit_card';
                                } else {
                                  selectedIcon = 'wallet';
                                }
                              });
                            }
                          },
                        ),
                      ),
                    ],
                  ),

                  // Ícono y color
                  const SizedBox(height: 20),
                  Text('Ícono',
                      style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.6),
                          fontSize: 13,
                          fontWeight: FontWeight.w500)),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: accountIcons.entries.map((entry) {
                      final isSelected =
                          entry.key == selectedIcon;
                      return GestureDetector(
                        onTap: () => setState(
                            () => selectedIcon = entry.key),
                        child: Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: isSelected
                                ? selectedColor
                                    .withValues(alpha: 0.2)
                                : Colors.white
                                    .withValues(alpha: 0.05),
                            borderRadius:
                                BorderRadius.circular(12),
                            border: isSelected
                                ? Border.all(
                                    color: selectedColor,
                                    width: 2)
                                : null,
                          ),
                          child: Icon(entry.value,
                              color: isSelected
                                  ? selectedColor
                                  : Colors.white38,
                              size: 20),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),
                  Text('Color',
                      style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.6),
                          fontSize: 13,
                          fontWeight: FontWeight.w500)),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: accountColors.map((color) {
                      final isSelected = color.toARGB32() ==
                          selectedColor.toARGB32();
                      return GestureDetector(
                        onTap: () => setState(
                            () => selectedColor = color),
                        child: Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: color,
                            shape: BoxShape.circle,
                            border: isSelected
                                ? Border.all(
                                    color: Colors.white,
                                    width: 3)
                                : null,
                          ),
                          child: isSelected
                              ? const Icon(Icons.check_rounded,
                                  color: Colors.white, size: 18)
                              : null,
                        ),
                      );
                    }).toList(),
                  ),

                  // Alias/CVU toggle
                  const SizedBox(height: 16),
                  GestureDetector(
                    onTap: () =>
                        setState(() => showAlias = !showAlias),
                    child: Row(
                      children: [
                        Icon(
                          showAlias
                              ? Icons.expand_less_rounded
                              : Icons.expand_more_rounded,
                          color: AppTheme.colorTransfer,
                          size: 20,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'Alias y CVU (opcional)',
                          style: TextStyle(
                              color: AppTheme.colorTransfer,
                              fontSize: 13,
                              fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                  if (showAlias) ...[
                    const SizedBox(height: 12),
                    TextField(
                      controller: aliasController,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: 'Alias',
                        labelStyle: const TextStyle(
                            color: AppTheme.colorTransfer),
                        hintText: 'Ej: mi.alias.mp',
                        hintStyle: TextStyle(
                            color:
                                Colors.white.withValues(alpha: 0.2)),
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(16)),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: cvuController,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: 'CVU / CBU',
                        labelStyle: const TextStyle(
                            color: AppTheme.colorTransfer),
                        hintText: 'Ej: 0000003100...',
                        hintStyle: TextStyle(
                            color:
                                Colors.white.withValues(alpha: 0.2)),
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(16)),
                      ),
                    ),
                  ],

                  // Credit card fields
                  if (selectedType == 'Crédito') ...[
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        const Icon(Icons.credit_card_rounded,
                            color: AppTheme.colorTransfer,
                            size: 16),
                        const SizedBox(width: 8),
                        Text('Fechas de la tarjeta',
                            style: TextStyle(
                                color: Colors.white
                                    .withValues(alpha: 0.6),
                                fontSize: 13,
                                fontWeight: FontWeight.w500)),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: closingDayController,
                            keyboardType: TextInputType.number,
                            style:
                                const TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              labelText: 'Día de cierre',
                              hintText: 'Ej: 15',
                              hintStyle: TextStyle(
                                  color: Colors.white
                                      .withValues(alpha: 0.2)),
                              labelStyle: const TextStyle(
                                  color: AppTheme.colorTransfer),
                              border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.circular(16)),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextField(
                            controller: dueDayController,
                            keyboardType: TextInputType.number,
                            style:
                                const TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              labelText: 'Día de vencimiento',
                              hintText: 'Ej: 5',
                              hintStyle: TextStyle(
                                  color: Colors.white
                                      .withValues(alpha: 0.2)),
                              labelStyle: const TextStyle(
                                  color: AppTheme.colorTransfer),
                              border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.circular(16)),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: creditLimitController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [ThousandsSeparatorFormatter()],
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: 'Límite de la tarjeta (opcional)',
                        prefixText: r'$ ',
                        hintText: 'Ej: 500.000',
                        hintStyle: TextStyle(
                            color:
                                Colors.white.withValues(alpha: 0.2)),
                        labelStyle: const TextStyle(
                            color: AppTheme.colorTransfer),
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(16)),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: debtController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [ThousandsSeparatorFormatter()],
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: 'Deuda actual (opcional)',
                        prefixText: r'$ ',
                        hintText: 'Ej: 120.000',
                        hintStyle: TextStyle(
                            color:
                                Colors.white.withValues(alpha: 0.2)),
                        labelStyle:
                            TextStyle(color: AppTheme.colorExpense),
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(16)),
                        helperText:
                            'Saldo pendiente de resúmenes anteriores',
                        helperStyle: TextStyle(
                            color:
                                Colors.white.withValues(alpha: 0.3),
                            fontSize: 11),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Estos días se repiten automáticamente cada mes.',
                      style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.35),
                          fontSize: 11),
                    ),
                  ],
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: FilledButton(
                      onPressed: () async {
                        if (nameController.text.isEmpty) return;

                        final type = selectedType == 'Crédito'
                            ? 'credit'
                            : 'bank';
                        final debt =
                            parseFormattedAmount(debtController.text);

                        await ref
                            .read(accountServiceProvider)
                            .addAccount(
                              name: nameController.text,
                              type: type,
                              currencyCode: 'ARS',
                              initialBalance:
                                  parseFormattedAmount(balanceController.text),
                              iconName: selectedIcon,
                              colorValue:
                                  selectedColor.toARGB32(),
                              closingDay: type == 'credit'
                                  ? int.tryParse(
                                      closingDayController.text)
                                  : null,
                              dueDay: type == 'credit'
                                  ? int.tryParse(
                                      dueDayController.text)
                                  : null,
                              creditLimit: type == 'credit' && creditLimitController.text.isNotEmpty
                                  ? parseFormattedAmount(creditLimitController.text)
                                  : null,
                              pendingStatementAmount:
                                  type == 'credit' ? debt : 0,
                              alias: aliasController
                                      .text.trim().isEmpty
                                  ? null
                                  : aliasController.text.trim(),
                              cvu: cvuController
                                      .text.trim().isEmpty
                                  ? null
                                  : cvuController.text.trim(),
                            );

                        if (context.mounted) {
                          Navigator.pop(ctx);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text(
                                    'Cuenta creada satisfactoriamente')),
                          );
                        }
                      },
                      style: FilledButton.styleFrom(
                        backgroundColor: AppTheme.colorTransfer,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16)),
                      ),
                      child: const Text('Crear Cuenta',
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
      },
    );
  }

  // ──────────────────────────────────────────────────────────────
  // Pay statement dialog
  // ──────────────────────────────────────────────────────────────
  void _showPayStatementDialog(
      BuildContext context, WidgetRef ref, dom.Account card) {
    final allAccounts =
        ref.read(accountsStreamProvider).value ?? [];
    final sources =
        allAccounts.where((a) => !a.isCreditCard).toList();
    dom.Account? selectedSource =
        sources.isNotEmpty ? sources.first : null;
    final amountController = TextEditingController(
        text: card.pendingStatementAmount.toStringAsFixed(0));

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        final bottomPadding =
            MediaQuery.of(ctx).viewInsets.bottom;
        return StatefulBuilder(builder: (context, setState) {
          return Container(
            padding: EdgeInsets.fromLTRB(
                24, 24, 24, bottomPadding + 32),
            decoration: const BoxDecoration(
              color: Color(0xFF18181F),
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(32),
                  topRight: Radius.circular(32)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Pagar Resumen: ${card.name}',
                  style: GoogleFonts.inter(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Colors.white),
                ),
                const SizedBox(height: 16),
                const Text('Seleccionar origen:',
                    style: TextStyle(
                        color: Colors.white54, fontSize: 13)),
                const SizedBox(height: 8),
                DropdownButton<dom.Account>(
                  value: selectedSource,
                  dropdownColor: const Color(0xFF1E1E2C),
                  isExpanded: true,
                  style: const TextStyle(color: Colors.white),
                  items: sources
                      .map((s) => DropdownMenuItem(
                            value: s,
                            child: Text(
                                '${s.name} (${formatAmount(s.balance)})'),
                          ))
                      .toList(),
                  onChanged: (val) =>
                      setState(() => selectedSource = val),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: amountController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [ThousandsSeparatorFormatter()],
                  style: const TextStyle(
                      color: Colors.white, fontSize: 24),
                  decoration: const InputDecoration(
                    prefixText: r'$ ',
                    labelText: 'Monto a pagar',
                    labelStyle:
                        TextStyle(color: AppTheme.colorTransfer),
                    enabledBorder: UnderlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.white24)),
                  ),
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: FilledButton(
                    onPressed: selectedSource == null
                        ? null
                        : () async {
                            final amount =
                                parseFormattedAmount(amountController.text);
                            final srcId = selectedSource!.id;
                            final txId = await ref
                                .read(accountServiceProvider)
                                .payCardStatement(
                                  sourceAccountId: srcId,
                                  cardAccountId: card.id,
                                  amount: amount,
                                );
                            if (context.mounted) {
                              Navigator.pop(ctx);
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(
                                SnackBar(
                                  content: Text(
                                      'Pago de \$${amount.toStringAsFixed(0)} registrado'),
                                  duration: const Duration(seconds: 6),
                                  action: SnackBarAction(
                                    label: 'DESHACER',
                                    textColor: AppTheme.colorWarning,
                                    onPressed: () async {
                                      await ref
                                          .read(accountServiceProvider)
                                          .undoPayCardStatement(
                                            sourceAccountId: srcId,
                                            cardAccountId: card.id,
                                            amount: amount,
                                            transactionId: txId,
                                          );
                                    },
                                  ),
                                ),
                              );
                            }
                          },
                    style: FilledButton.styleFrom(
                        backgroundColor: AppTheme.colorIncome),
                    child: const Text('Confirmar Pago',
                        style: TextStyle(
                            fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          );
        });
      },
    );
  }
}

// ──────────────────────────────────────────────────────────────
// Account Card widget
// ──────────────────────────────────────────────────────────────
class _AccountCard extends StatelessWidget {
  final dom.Account account;
  final double monthSpend;
  final double? periodSpend; // Billing-cycle spend for credit cards
  final bool isMpLinked;
  final VoidCallback onTap;
  final VoidCallback onLongPress;
  final VoidCallback? onPayStatement;

  const _AccountCard({
    required this.account,
    required this.monthSpend,
    this.periodSpend,
    this.isMpLinked = false,
    required this.onTap,
    required this.onLongPress,
    this.onPayStatement,
  });

  static const _mpBlue = Color(0xFF009EE3);

  // Colors by account type
  static Color _typeColor(dom.Account acc, bool isMp) {
    if (isMp) return _mpBlue;
    switch (acc.type) {
      case dom.AccountType.cash:
        return const Color(0xFF4CAF50); // green
      case dom.AccountType.bank:
        return const Color(0xFF42A5F5); // blue
      case dom.AccountType.credit:
        return const Color(0xFFFF7043); // orange-red
      case dom.AccountType.savings:
        return const Color(0xFF7C4DFF); // purple
      case dom.AccountType.investment:
        return const Color(0xFFFFB300); // gold
    }
  }

  static String _typeLabel(dom.Account acc, bool isMp) {
    if (isMp) return 'MP';
    switch (acc.type) {
      case dom.AccountType.cash:
        return 'Efectivo';
      case dom.AccountType.bank:
        return 'Debito';
      case dom.AccountType.credit:
        return 'Credito';
      case dom.AccountType.savings:
        return 'Ahorro';
      case dom.AccountType.investment:
        return 'Inversion';
    }
  }

  @override
  Widget build(BuildContext context) {
    final acc = account;
    final typeColor = _typeColor(acc, isMpLinked);
    final isDefault = acc.isDefault;

    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              typeColor.withValues(alpha: 0.12),
              typeColor.withValues(alpha: 0.04),
            ],
          ),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: typeColor.withValues(alpha: 0.25),
          ),
          boxShadow: [
            BoxShadow(
              color: typeColor.withValues(alpha: 0.12),
              blurRadius: 12,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: typeColor.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(
                      getAccountIcon(acc.icon ?? 'wallet'),
                      color: typeColor),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              acc.name,
                              style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (isMpLinked) ...[
                            const SizedBox(width: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: _mpBlue.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text('MP',
                                  style: GoogleFonts.inter(
                                      color: _mpBlue,
                                      fontSize: 9,
                                      fontWeight: FontWeight.w800)),
                            ),
                          ],
                          if (isDefault) ...[
                            const SizedBox(width: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: typeColor.withValues(alpha: 0.15),
                                borderRadius:
                                    BorderRadius.circular(6),
                              ),
                              child: Text('Por defecto',
                                  style: TextStyle(
                                      color: typeColor,
                                      fontSize: 9,
                                      fontWeight: FontWeight.w600)),
                            ),
                          ],
                          // Type badge
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: typeColor.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              _typeLabel(acc, isMpLinked),
                              style: TextStyle(
                                color: typeColor,
                                fontSize: 9,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),
                      if (acc.isCreditCard) ...[
                        // Credit card: show spending as negative
                        Text(
                          '-${formatAmount(periodSpend ?? monthSpend)}',
                          style: GoogleFonts.inter(
                            color: AppTheme.colorExpense,
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                          ),
                        ),
                        if (acc.pendingStatementAmount > 0)
                          Text(
                            'Resumen pendiente: -${formatAmount(acc.pendingStatementAmount)}',
                            style: TextStyle(
                                color: AppTheme.colorExpense.withValues(alpha: 0.7),
                                fontSize: 10),
                          ),
                        if (acc.creditLimit != null && acc.creditLimit! > 0)
                          Text(
                            'Disponible: ${formatAmount(acc.creditLimit! - (periodSpend ?? monthSpend))}',
                            style: TextStyle(
                                color: AppTheme.colorIncome.withValues(alpha: 0.7),
                                fontSize: 10),
                          ),
                      ] else ...[
                        // Non-credit: show positive balance
                        Text(
                          formatAmount(acc.balance),
                          style: GoogleFonts.inter(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                          ),
                        ),
                      ],
                      const SizedBox(height: 4),
                      // Alias / CVU copy row
                      if ((acc.alias != null && acc.alias!.isNotEmpty) ||
                          (acc.cvu != null && acc.cvu!.isNotEmpty)) ...[
                        const SizedBox(height: 4),
                        GestureDetector(
                          onTap: () {
                            final text = acc.alias ?? acc.cvu ?? '';
                            Clipboard.setData(ClipboardData(text: text));
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Copiado al portapapeles'),
                                duration: Duration(seconds: 1),
                              ),
                            );
                          },
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Flexible(
                                child: Text(
                                  acc.alias ?? acc.cvu ?? '',
                                  style: TextStyle(
                                      color: Colors.white.withValues(alpha: 0.3),
                                      fontSize: 10),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(width: 4),
                              Icon(Icons.copy_rounded,
                                  size: 10,
                                  color: Colors.white.withValues(alpha: 0.3)),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
            if (onPayStatement != null) ...[
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: onPayStatement,
                  icon: const Icon(Icons.payments_outlined,
                      size: 16),
                  label: const Text('Pagar Resumen'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppTheme.colorIncome,
                    side: BorderSide(
                        color: AppTheme.colorIncome
                            .withValues(alpha: 0.5)),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
