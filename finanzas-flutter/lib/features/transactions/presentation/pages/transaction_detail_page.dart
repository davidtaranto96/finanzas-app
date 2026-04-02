import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/database/database_providers.dart';
import '../../../../core/utils/format_utils.dart';
import '../../../../core/logic/transaction_service.dart';
import '../../domain/models/transaction.dart';
import '../widgets/add_transaction_bottom_sheet.dart' show kCategoryIcons, kCategoryEmojis;

class TransactionDetailPage extends ConsumerWidget {
  final String txId;
  const TransactionDetailPage({super.key, required this.txId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final txAsync = ref.watch(transactionsStreamProvider);
    final accountsAsync = ref.watch(accountsStreamProvider);

    return txAsync.when(
      loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (e, s) => Scaffold(body: Center(child: Text('Error: $e'))),
      data: (transactions) {
        final tx = transactions.cast<Transaction?>().firstWhere(
          (t) => t?.id == txId,
          orElse: () => null,
        );

        if (tx == null) {
          return Scaffold(
            appBar: AppBar(title: const Text('Movimiento')),
            body: const Center(child: Text('Movimiento no encontrado', style: TextStyle(color: Colors.white54))),
          );
        }

        final accounts = accountsAsync.value ?? [];
        final account = accounts.cast<dynamic>().firstWhere(
          (a) => a.id == tx.accountId,
          orElse: () => null,
        );

        final color = colorForType(tx.type);
        final icon = kCategoryIcons[tx.categoryId] ?? _iconForType(tx.type);
        final emoji = kCategoryEmojis[tx.categoryId];

        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: Text('Detalle', style: GoogleFonts.inter(fontWeight: FontWeight.w700)),
            actions: [
              IconButton(
                icon: const Icon(Icons.edit_outlined),
                onPressed: () => _showEditDialog(context, ref, tx, accounts),
              ),
              IconButton(
                icon: const Icon(Icons.delete_outline, color: AppTheme.colorExpense),
                onPressed: () => _confirmDelete(context, ref, tx),
              ),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Hero card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(28),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E1E2C),
                    borderRadius: BorderRadius.circular(28),
                    border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
                  ),
                  child: Column(
                    children: [
                      Container(
                        width: 72,
                        height: 72,
                        decoration: BoxDecoration(
                          color: color.withValues(alpha: 0.12),
                          shape: BoxShape.circle,
                        ),
                        child: emoji != null
                            ? Center(child: Text(emoji, style: const TextStyle(fontSize: 32)))
                            : Icon(icon, color: color, size: 32),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        tx.title,
                        style: GoogleFonts.inter(fontSize: 22, fontWeight: FontWeight.w700, color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${signForType(tx.type)}${formatAmount(tx.isShared ? tx.realExpense : tx.amount)}',
                        style: GoogleFonts.inter(fontSize: 36, fontWeight: FontWeight.w900, color: color),
                      ),
                      if (tx.isShared && tx.sharedTotalAmount != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          'Total: ${formatAmount(tx.sharedTotalAmount!)} · Tu parte: ${formatAmount(tx.sharedOwnAmount ?? 0)}',
                          style: const TextStyle(color: Colors.white38, fontSize: 12),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Detalles
                _DetailCard(children: [
                  _DetailRow(
                    icon: Icons.calendar_today_rounded,
                    label: 'Fecha',
                    value: formatFullDate(tx.date),
                  ),
                  if (account != null)
                    _DetailRow(
                      icon: Icons.account_balance_wallet_rounded,
                      label: 'Cuenta',
                      value: account.name,
                    ),
                  _DetailRow(
                    icon: kCategoryIcons[tx.categoryId] ?? Icons.label_rounded,
                    label: 'Categoría',
                    value: '${kCategoryEmojis[tx.categoryId] ?? ''} ${_categoryLabel(tx.categoryId)}',
                  ),
                  _DetailRow(
                    icon: Icons.swap_vert_rounded,
                    label: 'Tipo',
                    value: _typeLabel(tx.type),
                    valueColor: color,
                  ),
                  if (tx.note != null && tx.note!.isNotEmpty)
                    _DetailRow(
                      icon: Icons.notes_rounded,
                      label: 'Nota',
                      value: tx.note!,
                    ),
                ]),
                const SizedBox(height: 16),

                // Shared expense desglose
                if (tx.isShared) ...[
                  _DetailCard(children: [
                    Text('Gasto compartido', style: TextStyle(color: Colors.white.withValues(alpha: 0.5), fontSize: 11, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 12),
                    _DetailRow(icon: Icons.payments_rounded, label: 'Total pagado', value: formatAmount(tx.sharedTotalAmount ?? tx.amount)),
                    _DetailRow(icon: Icons.person_rounded, label: 'Mi parte', value: formatAmount(tx.sharedOwnAmount ?? 0), valueColor: AppTheme.colorExpense),
                    _DetailRow(icon: Icons.people_rounded, label: 'Parte ajena', value: formatAmount(tx.sharedOtherAmount ?? 0), valueColor: AppTheme.colorWarning),
                    if ((tx.sharedRecovered ?? 0) > 0)
                      _DetailRow(icon: Icons.check_circle_rounded, label: 'Recuperado', value: formatAmount(tx.sharedRecovered!), valueColor: AppTheme.colorIncome),
                    if (tx.pendingToRecover > 0)
                      _DetailRow(icon: Icons.pending_rounded, label: 'Pendiente a recuperar', value: formatAmount(tx.pendingToRecover), valueColor: AppTheme.colorWarning),
                  ]),
                  const SizedBox(height: 16),
                ],

                // Tags
                if (tx.isShared || tx.isExtraordinary)
                  Wrap(
                    spacing: 8,
                    children: [
                      if (tx.isShared)
                        _Tag(label: 'Compartido', color: AppTheme.colorTransfer),
                      if (tx.isExtraordinary)
                        _Tag(label: 'Extraordinario', color: AppTheme.colorWarning),
                    ],
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  IconData _iconForType(TransactionType type) {
    switch (type) {
      case TransactionType.income:
      case TransactionType.loanReceived:
        return Icons.arrow_downward_rounded;
      case TransactionType.expense:
      case TransactionType.loanGiven:
        return Icons.arrow_upward_rounded;
      case TransactionType.transfer:
        return Icons.swap_horiz_rounded;
    }
  }

  String _categoryLabel(String? id) {
    const labels = {
      'food': 'Comida',
      'transport': 'Transporte',
      'health': 'Salud',
      'entertainment': 'Entretenimiento',
      'shopping': 'Compras',
      'home': 'Hogar',
      'education': 'Educación',
      'services': 'Servicios',
      'salary': 'Sueldo',
      'freelance': 'Freelance',
      'transfer': 'Transferencia',
      'cat_alim': 'Supermercado',
      'cat_transp': 'Transporte',
      'cat_entret': 'Entretenimiento',
      'cat_salud': 'Salud',
      'cat_financial': 'Financiero',
      'cat_peer_to_peer': 'Entre personas',
      'other_expense': 'Otro gasto',
      'other_income': 'Otro ingreso',
    };
    return labels[id] ?? id ?? 'Sin categoría';
  }

  String _typeLabel(TransactionType type) {
    switch (type) {
      case TransactionType.income:
        return 'Ingreso';
      case TransactionType.expense:
        return 'Gasto';
      case TransactionType.transfer:
        return 'Transferencia';
      case TransactionType.loanGiven:
        return 'Préstamo dado';
      case TransactionType.loanReceived:
        return 'Préstamo recibido';
    }
  }

  void _confirmDelete(BuildContext context, WidgetRef ref, Transaction tx) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1E1E2C),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: AppTheme.colorExpense),
            SizedBox(width: 12),
            Expanded(child: Text('¿Eliminar movimiento?', style: TextStyle(color: Colors.white, fontSize: 17))),
          ],
        ),
        content: Text(
          '"${tx.title}" por ${formatAmount(tx.amount)} será eliminado permanentemente.',
          style: const TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancelar', style: TextStyle(color: Colors.white54)),
          ),
          TextButton(
            onPressed: () async {
              await ref.read(transactionServiceProvider).deleteTransaction(tx.id);
              if (context.mounted) {
                Navigator.pop(ctx);
                Navigator.pop(context);
              }
            },
            child: const Text('Eliminar', style: TextStyle(color: AppTheme.colorExpense, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  void _showEditDialog(BuildContext context, WidgetRef ref, Transaction tx, List accounts) {
    final titleCtrl = TextEditingController(text: tx.title);
    final amountCtrl = TextEditingController(text: tx.amount.toStringAsFixed(0));
    final noteCtrl = TextEditingController(text: tx.note ?? '');

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        padding: EdgeInsets.fromLTRB(24, 24, 24, MediaQuery.of(ctx).viewInsets.bottom + 100),
        decoration: const BoxDecoration(
          color: Color(0xFF18181F),
          borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.white12, borderRadius: BorderRadius.circular(2)))),
              const SizedBox(height: 24),
              Text('Editar Movimiento', style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w700, color: Colors.white)),
              const SizedBox(height: 24),
              TextField(
                controller: titleCtrl,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Descripción',
                  labelStyle: const TextStyle(color: AppTheme.colorTransfer),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: amountCtrl,
                keyboardType: TextInputType.number,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Monto',
                  prefixText: r'$ ',
                  labelStyle: const TextStyle(color: AppTheme.colorTransfer),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: noteCtrl,
                style: const TextStyle(color: Colors.white),
                maxLines: 2,
                decoration: InputDecoration(
                  labelText: 'Nota (opcional)',
                  labelStyle: const TextStyle(color: AppTheme.colorTransfer),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: FilledButton(
                  onPressed: () async {
                    await ref.read(transactionServiceProvider).updateTransaction(
                      id: tx.id,
                      title: titleCtrl.text,
                      amount: double.tryParse(amountCtrl.text) ?? tx.amount,
                      note: noteCtrl.text.isEmpty ? null : noteCtrl.text,
                    );
                    if (context.mounted) {
                      Navigator.pop(ctx);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Movimiento actualizado')),
                      );
                    }
                  },
                  style: FilledButton.styleFrom(
                    backgroundColor: AppTheme.colorTransfer,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  child: const Text('Guardar Cambios', style: TextStyle(fontWeight: FontWeight.w600)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DetailCard extends StatelessWidget {
  final List<Widget> children;
  const _DetailCard({required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E2C),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: Column(
        children: children.map((child) {
          final idx = children.indexOf(child);
          return Column(
            children: [
              child,
              if (idx < children.length - 1)
                Divider(height: 20, color: Colors.white.withValues(alpha: 0.06)),
            ],
          );
        }).toList(),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color? valueColor;
  const _DetailRow({required this.icon, required this.label, required this.value, this.valueColor});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.white38),
        const SizedBox(width: 10),
        Text(label, style: const TextStyle(color: Colors.white38, fontSize: 13)),
        const Spacer(),
        Flexible(
          child: Text(
            value,
            style: TextStyle(color: valueColor ?? Colors.white, fontSize: 13, fontWeight: FontWeight.w500),
            textAlign: TextAlign.end,
          ),
        ),
      ],
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
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Text(label, style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.w600)),
    );
  }
}
