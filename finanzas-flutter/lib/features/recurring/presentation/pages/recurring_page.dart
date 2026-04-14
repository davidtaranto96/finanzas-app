import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../../../core/database/app_database.dart';
import '../../../../core/database/database_providers.dart';
import '../../../../core/logic/recurring_service.dart';
import '../../../../core/providers/feedback_provider.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/format_utils.dart';
import '../../../transactions/presentation/widgets/add_transaction_bottom_sheet.dart'
    show kCategoryEmojis;
import '../../../../core/widgets/page_coach.dart';

const _frequencyLabels = {
  'daily': 'Diario',
  'weekly': 'Semanal',
  'biweekly': 'Quincenal',
  'monthly': 'Mensual',
  'yearly': 'Anual',
};

class RecurringPage extends ConsumerWidget {
  const RecurringPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (context.mounted) showPageCoachIfNeeded(context, ref, 'recurring');
    });
    final itemsAsync = ref.watch(recurringTransactionsStreamProvider);
    final accounts = ref.watch(accountsStreamProvider).valueOrNull ?? [];

    String accountName(String id) =>
        accounts.where((a) => a.id == id).firstOrNull?.name ?? id;

    return Scaffold(
      appBar: AppBar(
        title: Text('Recurrentes',
            style: GoogleFonts.inter(fontWeight: FontWeight.w700, fontSize: 18)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      floatingActionButton: FloatingActionButton.small(
        backgroundColor: AppTheme.colorTransfer.withValues(alpha: 0.8),
        onPressed: () => _showAddSheet(context, ref),
        child: const Icon(Icons.add_rounded, color: Colors.white),
      ),
      body: itemsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (items) {
          if (items.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.repeat_rounded, size: 48,
                      color: Colors.white.withValues(alpha: 0.15)),
                  const SizedBox(height: 12),
                  Text('Sin gastos recurrentes',
                      style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.3),
                          fontSize: 14)),
                  const SizedBox(height: 4),
                  Text('Agregá suscripciones, alquileres, etc.',
                      style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.2),
                          fontSize: 12)),
                ],
              ),
            );
          }

          final active = items.where((i) => i.isActive).toList();
          final inactive = items.where((i) => !i.isActive).toList();

          return ListView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 120),
            children: [
              if (active.isNotEmpty) ...[
                _SectionLabel('Activos (${active.length})'),
                const SizedBox(height: 8),
                ...active.map((item) => _RecurringCard(
                  item: item,
                  accountName: accountName(item.accountId),
                  onDelete: () => _confirmDelete(context, ref, item),
                  onToggle: () => ref.read(recurringServiceProvider)
                      .toggleActive(item.id, false),
                )),
              ],
              if (inactive.isNotEmpty) ...[
                const SizedBox(height: 16),
                _SectionLabel('Pausados (${inactive.length})'),
                const SizedBox(height: 8),
                ...inactive.map((item) => _RecurringCard(
                  item: item,
                  accountName: accountName(item.accountId),
                  onDelete: () => _confirmDelete(context, ref, item),
                  onToggle: () => ref.read(recurringServiceProvider)
                      .toggleActive(item.id, true),
                  dimmed: true,
                )),
              ],
            ],
          );
        },
      ),
    );
  }

  void _confirmDelete(BuildContext context, WidgetRef ref,
      RecurringTransactionEntity item) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1E1E2C),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Eliminar recurrente',
            style: TextStyle(color: Colors.white, fontSize: 16)),
        content: Text('¿Eliminar "${item.title}"?',
            style: const TextStyle(color: Colors.white70, fontSize: 14)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              ref.read(recurringServiceProvider).deleteRecurring(item.id);
            },
            child: Text('Eliminar',
                style: TextStyle(color: AppTheme.colorExpense)),
          ),
        ],
      ),
    );
  }

  void _showAddSheet(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF18181F),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => _AddRecurringSheet(),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(text, style: GoogleFonts.inter(
      fontSize: 13, fontWeight: FontWeight.w600, color: Colors.white54,
    ));
  }
}

class _RecurringCard extends StatelessWidget {
  final RecurringTransactionEntity item;
  final String accountName;
  final VoidCallback onDelete;
  final VoidCallback onToggle;
  final bool dimmed;

  const _RecurringCard({
    required this.item,
    required this.accountName,
    required this.onDelete,
    required this.onToggle,
    this.dimmed = false,
  });

  @override
  Widget build(BuildContext context) {
    final emoji = kCategoryEmojis[item.categoryId] ?? '📌';
    final freq = _frequencyLabels[item.frequency] ?? item.frequency;
    final nextStr = DateFormat('dd/MM/yyyy').format(item.nextDate);
    final isExpense = item.type == 'expense';
    final color = isExpense ? AppTheme.colorExpense : AppTheme.colorIncome;

    return Opacity(
      opacity: dimmed ? 0.5 : 1.0,
      child: Dismissible(
        key: ValueKey(item.id),
        direction: DismissDirection.endToStart,
        background: Container(
          margin: const EdgeInsets.only(bottom: 8),
          decoration: BoxDecoration(
            color: AppTheme.colorExpense.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(16),
          ),
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.only(right: 20),
          child: Icon(Icons.delete_rounded,
              color: AppTheme.colorExpense, size: 22),
        ),
        confirmDismiss: (_) async {
          onDelete();
          return false;
        },
        child: Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: const Color(0xFF1E1E2C).withValues(alpha: 0.6),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
          ),
          child: Row(
            children: [
              Text(emoji, style: const TextStyle(fontSize: 24)),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(item.title, style: const TextStyle(
                      color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600,
                    )),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: color.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(freq, style: TextStyle(
                            color: color, fontSize: 10, fontWeight: FontWeight.w600,
                          )),
                        ),
                        const SizedBox(width: 6),
                        Text('$accountName · $nextStr',
                            style: const TextStyle(
                                color: Colors.white38, fontSize: 11)),
                      ],
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${isExpense ? '-' : '+'}\$${formatAmount(item.amount)}',
                    style: TextStyle(
                      color: color,
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  GestureDetector(
                    onTap: onToggle,
                    child: Icon(
                      item.isActive
                          ? Icons.pause_circle_rounded
                          : Icons.play_circle_rounded,
                      color: Colors.white38,
                      size: 20,
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
}

class _AddRecurringSheet extends ConsumerStatefulWidget {
  @override
  ConsumerState<_AddRecurringSheet> createState() => _AddRecurringSheetState();
}

class _AddRecurringSheetState extends ConsumerState<_AddRecurringSheet> {
  final _titleCtrl = TextEditingController();
  final _amountCtrl = TextEditingController();
  String _type = 'expense';
  String _categoryId = 'food';
  String? _accountId;
  String _frequency = 'monthly';
  DateTime _nextDate = DateTime.now();

  @override
  void dispose() {
    _titleCtrl.dispose();
    _amountCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final accounts = ref.watch(accountsStreamProvider).valueOrNull ?? [];
    _accountId ??= accounts.isNotEmpty
        ? accounts.firstWhere((a) => a.isDefault, orElse: () => accounts.first).id
        : null;

    return Padding(
      padding: EdgeInsets.fromLTRB(
          24, 16, 24, MediaQuery.of(context).viewInsets.bottom + 24),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(child: Container(
              width: 40, height: 4,
              decoration: BoxDecoration(
                color: Colors.white24,
                borderRadius: BorderRadius.circular(2),
              ),
            )),
            const SizedBox(height: 16),
            Text('Nuevo recurrente', style: GoogleFonts.inter(
              fontSize: 18, fontWeight: FontWeight.w800, color: Colors.white,
            )),
            const SizedBox(height: 16),

            // Title
            _InputField(
              controller: _titleCtrl,
              label: 'Título',
              hint: 'Ej: Netflix, Alquiler, Gimnasio',
            ),
            const SizedBox(height: 12),

            // Amount
            _InputField(
              controller: _amountCtrl,
              label: 'Monto',
              hint: '0',
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 12),

            // Type toggle
            Row(
              children: [
                _TypeChip(label: 'Gasto', value: 'expense',
                    selected: _type, onTap: () => setState(() => _type = 'expense')),
                const SizedBox(width: 8),
                _TypeChip(label: 'Ingreso', value: 'income',
                    selected: _type, onTap: () => setState(() => _type = 'income')),
              ],
            ),
            const SizedBox(height: 12),

            // Frequency
            Text('Frecuencia', style: TextStyle(
              color: Colors.white.withValues(alpha: 0.5), fontSize: 12,
            )),
            const SizedBox(height: 6),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: _frequencyLabels.entries.map((e) {
                final sel = _frequency == e.key;
                return GestureDetector(
                  onTap: () => setState(() => _frequency = e.key),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: sel
                          ? AppTheme.colorTransfer.withValues(alpha: 0.2)
                          : Colors.white.withValues(alpha: 0.04),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: sel
                          ? AppTheme.colorTransfer.withValues(alpha: 0.3)
                          : Colors.white.withValues(alpha: 0.06)),
                    ),
                    child: Text(e.value, style: TextStyle(
                      color: sel ? AppTheme.colorTransfer : Colors.white38,
                      fontSize: 12,
                      fontWeight: sel ? FontWeight.w700 : FontWeight.w500,
                    )),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 12),

            // Category chips
            Text('Categoría', style: TextStyle(
              color: Colors.white.withValues(alpha: 0.5), fontSize: 12,
            )),
            const SizedBox(height: 6),
            SizedBox(
              height: 40,
              child: ListView(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                children: kCategoryEmojis.entries.map((entry) {
                  final isSel = _categoryId == entry.key;
                  return Padding(
                    padding: const EdgeInsets.only(right: 6),
                    child: GestureDetector(
                      onTap: () => setState(() => _categoryId = entry.key),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: isSel
                              ? AppTheme.colorTransfer.withValues(alpha: 0.2)
                              : Colors.white.withValues(alpha: 0.04),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: isSel
                              ? AppTheme.colorTransfer.withValues(alpha: 0.3)
                              : Colors.transparent),
                        ),
                        child: Text(entry.value,
                            style: const TextStyle(fontSize: 16)),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 12),

            // Account picker
            if (accounts.isNotEmpty) ...[
              Text('Cuenta', style: TextStyle(
                color: Colors.white.withValues(alpha: 0.5), fontSize: 12,
              )),
              const SizedBox(height: 6),
              SizedBox(
                height: 36,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  children: accounts.map((acc) {
                    final isSel = _accountId == acc.id;
                    return Padding(
                      padding: const EdgeInsets.only(right: 6),
                      child: GestureDetector(
                        onTap: () => setState(() => _accountId = acc.id),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: isSel
                                ? AppTheme.colorTransfer.withValues(alpha: 0.2)
                                : Colors.white.withValues(alpha: 0.04),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: isSel
                                ? AppTheme.colorTransfer.withValues(alpha: 0.3)
                                : Colors.transparent),
                          ),
                          child: Text(acc.name, style: TextStyle(
                            color: isSel ? Colors.white : Colors.white54,
                            fontSize: 12,
                            fontWeight: isSel ? FontWeight.w600 : FontWeight.w400,
                          )),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 12),
            ],

            // Next date
            GestureDetector(
              onTap: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: _nextDate,
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(const Duration(days: 365)),
                  builder: (ctx, child) => Theme(
                    data: Theme.of(ctx).copyWith(
                      colorScheme: ColorScheme.dark(
                        primary: AppTheme.colorTransfer,
                        surface: const Color(0xFF1E1E2C),
                        onSurface: Colors.white,
                      ),
                    ),
                    child: child!,
                  ),
                );
                if (picked != null) setState(() => _nextDate = picked);
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.04),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                      color: Colors.white.withValues(alpha: 0.06)),
                ),
                child: Row(
                  children: [
                    Icon(Icons.calendar_today_rounded,
                        color: AppTheme.colorTransfer, size: 16),
                    const SizedBox(width: 8),
                    Text(
                      'Próxima fecha: ${DateFormat('dd/MM/yyyy').format(_nextDate)}',
                      style: const TextStyle(
                          color: Colors.white, fontSize: 13),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Save button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _save,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.colorTransfer,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: const Text('Guardar', style: TextStyle(
                  fontWeight: FontWeight.w700, fontSize: 15,
                )),
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  void _save() {
    if (_titleCtrl.text.isEmpty || _amountCtrl.text.isEmpty || _accountId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Completá título, monto y cuenta')),
      );
      return;
    }
    appHaptic(ref, type: HapticType.medium);
    final amount = double.tryParse(
        _amountCtrl.text.replaceAll(',', '.').replaceAll(' ', '')) ?? 0;
    if (amount <= 0) return;

    ref.read(recurringServiceProvider).addRecurring(
      title: _titleCtrl.text.trim(),
      amount: amount,
      type: _type,
      categoryId: _categoryId,
      accountId: _accountId!,
      frequency: _frequency,
      nextDate: _nextDate,
    );
    Navigator.pop(context);
  }
}

class _InputField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final TextInputType keyboardType;

  const _InputField({
    required this.controller,
    required this.label,
    this.hint = '',
    this.keyboardType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      style: const TextStyle(color: Colors.white, fontSize: 14),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        labelStyle: TextStyle(
            color: Colors.white.withValues(alpha: 0.5), fontSize: 12),
        hintStyle: TextStyle(
            color: Colors.white.withValues(alpha: 0.2)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
              color: Colors.white.withValues(alpha: 0.06)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
              color: AppTheme.colorTransfer.withValues(alpha: 0.4)),
        ),
        filled: true,
        fillColor: Colors.white.withValues(alpha: 0.04),
        contentPadding: const EdgeInsets.symmetric(
            horizontal: 14, vertical: 12),
      ),
    );
  }
}

class _TypeChip extends StatelessWidget {
  final String label;
  final String value;
  final String selected;
  final VoidCallback onTap;

  const _TypeChip({
    required this.label,
    required this.value,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isSel = selected == value;
    final color = value == 'expense' ? AppTheme.colorExpense : AppTheme.colorIncome;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSel ? color.withValues(alpha: 0.15) : Colors.white.withValues(alpha: 0.04),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSel ? color.withValues(alpha: 0.3) : Colors.white.withValues(alpha: 0.06),
          ),
        ),
        child: Text(label, style: TextStyle(
          color: isSel ? color : Colors.white38,
          fontSize: 13,
          fontWeight: isSel ? FontWeight.w700 : FontWeight.w500,
        )),
      ),
    );
  }
}
