import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/database/database_providers.dart';
import '../../../../core/logic/transaction_service.dart';
import '../../../../core/providers/shell_providers.dart';
import '../../../../core/utils/format_utils.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../features/transactions/domain/models/transaction.dart';
import '../widgets/add_transaction_bottom_sheet.dart' show kCategoryEmojis;

enum _FilterType { all, income, expense, shared }
enum _SortMode { byDate, byAmountDesc, byAmountAsc }

final _filterProvider = StateProvider<_FilterType>((ref) => _FilterType.all);

class TransactionsPage extends ConsumerStatefulWidget {
  const TransactionsPage({super.key});

  @override
  ConsumerState<TransactionsPage> createState() => _TransactionsPageState();
}

class _TransactionsPageState extends ConsumerState<TransactionsPage> with AutomaticKeepAliveClientMixin {
  _SortMode _sortMode = _SortMode.byDate;

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final txsAsync = ref.watch(transactionsStreamProvider);
    final filterValue = ref.watch(_filterProvider);
    final searchQuery = ref.watch(txSearchQueryProvider);
    final cs = Theme.of(context).colorScheme;

    return txsAsync.when(
      loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (err, stack) => Scaffold(body: Center(child: Text('Error DB: $err'))),
      data: (allTxs) {
        final filtered = allTxs.where((tx) {
          final matchesSearch = tx.title.toLowerCase().contains(searchQuery.toLowerCase()) ||
                               (tx.note?.toLowerCase().contains(searchQuery.toLowerCase()) ?? false);
          if (!matchesSearch) return false;

          switch (filterValue) {
            case _FilterType.all:
              return true;
            case _FilterType.income:
              return tx.type == TransactionType.income || tx.type == TransactionType.loanReceived;
            case _FilterType.expense:
              return tx.type == TransactionType.expense || tx.type == TransactionType.loanGiven;
            case _FilterType.shared:
              return tx.isShared;
          }
        }).toList();

        // Aplicar sort
        if (_sortMode == _SortMode.byAmountDesc) {
          filtered.sort((a, b) => b.amount.compareTo(a.amount));
        } else if (_sortMode == _SortMode.byAmountAsc) {
          filtered.sort((a, b) => a.amount.compareTo(b.amount));
        } else {
          filtered.sort((a, b) => b.date.compareTo(a.date));
        }

        // Agrupar por fecha (solo cuando se ordena por fecha)
        final grouped = <String, List<Transaction>>{};
        if (_sortMode == _SortMode.byDate) {
          for (final tx in filtered) {
            final key = formatDate(tx.date);
            grouped.putIfAbsent(key, () => []).add(tx);
          }
        } else {
          // Sin agrupación: usar el monto como key para mostrar lista plana con separadores
          grouped['all'] = filtered;
        }

        final listContent = grouped.isEmpty
            ? _EmptyState()
            : _sortMode == _SortMode.byDate
                ? ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    itemCount: grouped.length,
                    itemBuilder: (context, groupIndex) {
                      final dateKey = grouped.keys.elementAt(groupIndex);
                      final txList = grouped[dateKey]!;
                      final dayTotal = txList.fold<double>(0, (sum, tx) {
                        if (tx.type == TransactionType.income || tx.type == TransactionType.loanReceived) return sum + tx.amount;
                        return sum - tx.realExpense;
                      });

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 16, bottom: 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  dateKey,
                                  style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
                                ),
                                Text(
                                  '${dayTotal >= 0 ? '+' : ''}${formatAmount(dayTotal)}',
                                  style: GoogleFonts.inter(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: dayTotal >= 0 ? AppTheme.colorIncome : AppTheme.colorExpense,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          ...txList.map((tx) => Padding(
                                padding: const EdgeInsets.only(bottom: 8),
                                child: _TxRow(transaction: tx),
                              )),
                        ],
                      );
                    },
                  )
                : ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    itemCount: filtered.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 8),
                    itemBuilder: (context, i) => _TxRow(transaction: filtered[i]),
                  );

        return Scaffold(
          appBar: AppBar(
            title: Text('Movimientos',
                style: GoogleFonts.inter(fontSize: 24, fontWeight: FontWeight.w700)),
            actions: [
              PopupMenuButton<_SortMode>(
                icon: Icon(
                  _sortMode == _SortMode.byDate ? Icons.sort_by_alpha_rounded : Icons.sort_rounded,
                  color: _sortMode != _SortMode.byDate ? cs.primary : cs.onSurface,
                ),
                tooltip: 'Ordenar',
                color: const Color(0xFF1E1E2C),
                onSelected: (mode) => setState(() => _sortMode = mode),
                itemBuilder: (_) => [
                  PopupMenuItem(
                    value: _SortMode.byDate,
                    child: Row(children: [
                      Icon(Icons.calendar_today_rounded, size: 16, color: _sortMode == _SortMode.byDate ? cs.primary : Colors.white54),
                      const SizedBox(width: 10),
                      Text('Por fecha', style: TextStyle(color: _sortMode == _SortMode.byDate ? cs.primary : Colors.white)),
                    ]),
                  ),
                  PopupMenuItem(
                    value: _SortMode.byAmountDesc,
                    child: Row(children: [
                      Icon(Icons.arrow_downward_rounded, size: 16, color: _sortMode == _SortMode.byAmountDesc ? cs.primary : Colors.white54),
                      const SizedBox(width: 10),
                      Text('Mayor a menor', style: TextStyle(color: _sortMode == _SortMode.byAmountDesc ? cs.primary : Colors.white)),
                    ]),
                  ),
                  PopupMenuItem(
                    value: _SortMode.byAmountAsc,
                    child: Row(children: [
                      Icon(Icons.arrow_upward_rounded, size: 16, color: _sortMode == _SortMode.byAmountAsc ? cs.primary : Colors.white54),
                      const SizedBox(width: 10),
                      Text('Menor a mayor', style: TextStyle(color: _sortMode == _SortMode.byAmountAsc ? cs.primary : Colors.white)),
                    ]),
                  ),
                ],
              ),
            ],
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(56),
              child: _FilterChips(),
            ),
          ),
          body: listContent,
        );
      },
    );
  }
}

class _FilterChips extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final current = ref.watch(_filterProvider);
    final cs = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.only(left: 16, bottom: 10),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: _FilterType.values.map((f) {
            final selected = f == current;
            final label = switch (f) {
              _FilterType.all => 'Todos',
              _FilterType.income => 'Ingresos',
              _FilterType.expense => 'Gastos',
              _FilterType.shared => 'Compartidos',
            };
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: FilterChip(
                label: Text(label),
                selected: selected,
                onSelected: (_) =>
                    ref.read(_filterProvider.notifier).state = f,
                selectedColor: cs.primary.withValues(alpha: 0.2),
                checkmarkColor: cs.primary,
                labelStyle: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                  color: selected ? cs.primary : cs.onSurfaceVariant,
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

class _TxRow extends ConsumerWidget {
  final Transaction transaction;
  const _TxRow({required this.transaction});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = Theme.of(context).colorScheme;
    final isIncome = transaction.type == TransactionType.income || transaction.type == TransactionType.loanReceived;
    final color = colorForType(transaction.type);
    final emoji = kCategoryEmojis[transaction.categoryId] ?? _emojiForType(transaction.type);
    final displayAmount = transaction.isShared ? transaction.realExpense : transaction.amount;

    return Dismissible(
      key: Key(transaction.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: AppTheme.colorExpense.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(14),
        ),
        child: const Icon(Icons.delete_outline_rounded, color: AppTheme.colorExpense),
      ),
      confirmDismiss: (_) async {
        await ref.read(transactionServiceProvider).deleteTransaction(transaction.id);
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('${transaction.title} eliminado — saldo restaurado')),
          );
        }
        return false; // Stream will rebuild without this item
      },
      child: InkWell(
        onTap: () => context.push('/transactions/${transaction.id}'),
        onLongPress: () => _showTransactionOptions(context, ref, transaction),
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: cs.surfaceContainerHigh,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: cs.outlineVariant),
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                alignment: Alignment.center,
                child: Text(emoji, style: const TextStyle(fontSize: 22)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      transaction.title,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 3),
                    Wrap(
                      spacing: 4,
                      children: [
                        if (transaction.isShared)
                          _Tag(label: 'Compartido', color: AppTheme.colorWarning),
                        if (transaction.groupId != null)
                          _Tag(label: 'Grupo', color: AppTheme.colorTransfer),
                        if (transaction.isExtraordinary)
                          _Tag(label: 'Extraordinario', color: Colors.purpleAccent),
                      ],
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${isIncome ? '+' : '-'}${formatAmount(displayAmount)}',
                    style: GoogleFonts.inter(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: color,
                    ),
                  ),
                  if (transaction.isShared && transaction.pendingToRecover > 0)
                    Text(
                      '↩ ${formatAmount(transaction.pendingToRecover, compact: true)}',
                      style: GoogleFonts.inter(
                        fontSize: 10,
                        color: AppTheme.colorWarning,
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _emojiForType(TransactionType type) {
    switch (type) {
      case TransactionType.income:
        return '💰';
      case TransactionType.expense:
        return '💸';
      case TransactionType.transfer:
        return '🔄';
      case TransactionType.loanGiven:
        return '👆';
      case TransactionType.loanReceived:
        return '👇';
    }
  }

  void _showTransactionOptions(BuildContext context, WidgetRef ref, Transaction tx) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Color(0xFF18181F),
          borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(child: Container(width: 40, height: 4, margin: const EdgeInsets.only(bottom: 16), decoration: BoxDecoration(color: Colors.white12, borderRadius: BorderRadius.circular(2)))),
            Text(tx.title, style: const TextStyle(color: Colors.white70, fontSize: 14)),
            Text(formatAmount(tx.amount), style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.edit_rounded, color: AppTheme.colorTransfer),
              title: const Text('Editar Movimiento', style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pop(ctx);
                context.push('/transactions/${tx.id}');
              },
            ),
            ListTile(
              leading: const Icon(Icons.copy_rounded, color: Colors.white54),
              title: const Text('Duplicar', style: TextStyle(color: Colors.white)),
              onTap: () async {
                Navigator.pop(ctx);
                await ref.read(transactionServiceProvider).duplicateTransaction(tx.id);
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Movimiento duplicado: ${tx.title}')),
                  );
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete_forever_rounded, color: AppTheme.colorExpense),
              title: const Text('Eliminar permanentemente', style: TextStyle(color: AppTheme.colorExpense)),
              onTap: () {
                Navigator.pop(ctx);
                _confirmDeleteTransaction(context, ref, tx);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _confirmDeleteTransaction(BuildContext context, WidgetRef ref, Transaction tx) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1E1E2C),
        title: const Text('Eliminar movimiento', style: TextStyle(color: Colors.white)),
        content: Text(
          '${tx.title} — ${formatAmount(tx.amount)}\n\nEl saldo de la cuenta se restaurará. Esta acción no se puede deshacer.',
          style: const TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancelar', style: TextStyle(color: Colors.white54)),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(ctx);
              await ref.read(transactionServiceProvider).deleteTransaction(tx.id);
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('${tx.title} eliminado — saldo restaurado')),
                );
              }
            },
            child: const Text('Eliminar', style: TextStyle(color: AppTheme.colorExpense, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}

class _Tag extends StatelessWidget {
  final String label;
  final Color color;
  const _Tag({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: GoogleFonts.inter(
          fontSize: 9,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.receipt_long_outlined, size: 64, color: cs.outlineVariant),
          const SizedBox(height: 16),
          Text(
            'Sin movimientos',
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(color: cs.onSurfaceVariant),
          ),
        ],
      ),
    );
  }
}

