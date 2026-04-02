import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/format_utils.dart';
import '../../../../core/logic/account_service.dart';
import '../../../../core/database/database_providers.dart';
import '../../../accounts/domain/models/account.dart' as dom;

class CardAlertBanner extends ConsumerWidget {
  final String cardId;
  final String cardName;
  final double amount;
  final DateTime dueDate;
  final DateTime closingDate;
  final bool isClosingSoon;

  const CardAlertBanner({
    super.key,
    required this.cardId,
    required this.cardName,
    required this.amount,
    required this.dueDate,
    required this.closingDate,
    this.isClosingSoon = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final now = DateTime.now();
    final daysToDue = dueDate.difference(now).inDays;
    final color = isClosingSoon
        ? AppTheme.colorWarning
        : (daysToDue <= 3 ? AppTheme.colorExpense : AppTheme.colorWarning);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Icon(Icons.credit_card_rounded, color: color, size: 24),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isClosingSoon
                      ? 'Cierre de tarjeta: $cardName'
                      : 'Vencimiento de pago: $cardName',
                  style: GoogleFonts.inter(
                    color: isClosingSoon
                        ? AppTheme.colorWarning
                        : (daysToDue < 0 ? AppTheme.colorExpense : AppTheme.colorWarning),
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                Text(
                  isClosingSoon
                      ? 'Cierra en ${closingDate.difference(now).inDays} días (${closingDate.day}/${closingDate.month})'
                      : daysToDue == 0
                          ? 'Vence HOY'
                          : daysToDue < 0
                              ? 'PAGO VENCIDO (${dueDate.day}/${dueDate.month})'
                              : 'Vence en $daysToDue días (${dueDate.day}/${dueDate.month})',
                  style: TextStyle(
                    color: color.withValues(alpha: 0.8),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                formatAmount(amount),
                style: GoogleFonts.inter(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                  fontSize: 16,
                ),
              ),
              // Botón "Pagar 💸" solo en alertas de vencimiento
              if (!isClosingSoon)
                GestureDetector(
                  onTap: () => _showPayDialog(context, ref),
                  child: Container(
                    margin: const EdgeInsets.only(top: 6),
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppTheme.colorIncome.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppTheme.colorIncome.withValues(alpha: 0.4)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.attach_money_rounded, size: 14, color: AppTheme.colorIncome),
                        const SizedBox(width: 4),
                        Text(
                          'Pagar',
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: AppTheme.colorIncome,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  void _showPayDialog(BuildContext context, WidgetRef ref) {
    final allAccounts = ref.read(accountsStreamProvider).value ?? [];
    final sources = allAccounts.where((a) => !a.isCreditCard).toList();
    dom.Account? selectedSource = sources.isNotEmpty ? sources.first : null;
    final amountController = TextEditingController(text: formatInitialAmount(amount));

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        final bottomPadding = MediaQuery.of(ctx).viewInsets.bottom;
        return StatefulBuilder(
          builder: (context, setState) => Container(
            padding: EdgeInsets.fromLTRB(24, 24, 24, bottomPadding + 32),
            decoration: const BoxDecoration(
              color: Color(0xFF18181F),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(32),
                topRight: Radius.circular(32),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.white12,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'Pagar resumen: $cardName',
                  style: GoogleFonts.inter(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: amountController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [ThousandsSeparatorFormatter()],
                  style: GoogleFonts.inter(
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                  decoration: const InputDecoration(
                    labelText: 'Monto a pagar',
                    labelStyle: TextStyle(color: AppTheme.colorTransfer, fontSize: 14),
                    prefixText: r'$ ',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                if (sources.isEmpty)
                  const Text(
                    'No tenés cuentas disponibles para pagar.',
                    style: TextStyle(color: AppTheme.colorExpense, fontSize: 13),
                  )
                else ...[
                  const Text(
                    'Pagar desde:',
                    style: TextStyle(color: Colors.white54, fontSize: 13),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white10),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: DropdownButton<dom.Account>(
                      value: selectedSource,
                      isExpanded: true,
                      dropdownColor: const Color(0xFF1E1E2C),
                      underline: const SizedBox(),
                      style: const TextStyle(color: Colors.white),
                      items: sources
                          .map((a) => DropdownMenuItem(
                                value: a,
                                child: Text(a.name),
                              ))
                          .toList(),
                      onChanged: (a) => setState(() => selectedSource = a),
                    ),
                  ),
                ],
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: FilledButton(
                    onPressed: selectedSource == null
                        ? null
                        : () async {
                            final payAmount = amountController.text.isNotEmpty
                                ? parseFormattedAmount(amountController.text)
                                : amount;
                            if (payAmount <= 0) return;
                            final srcId = selectedSource!.id;
                            final txId = await ref.read(accountServiceProvider).payCardStatement(
                                  sourceAccountId: srcId,
                                  cardAccountId: cardId,
                                  amount: payAmount,
                                );
                            if (ctx.mounted) {
                              Navigator.pop(ctx);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                      'Pago de ${formatAmount(payAmount)} registrado'),
                                  duration: const Duration(seconds: 6),
                                  action: SnackBarAction(
                                    label: 'DESHACER',
                                    textColor: AppTheme.colorWarning,
                                    onPressed: () async {
                                      await ref.read(accountServiceProvider).undoPayCardStatement(
                                        sourceAccountId: srcId,
                                        cardAccountId: cardId,
                                        amount: payAmount,
                                        transactionId: txId,
                                      );
                                    },
                                  ),
                                ),
                              );
                            }
                          },
                    style: FilledButton.styleFrom(
                      backgroundColor: AppTheme.colorIncome,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
                    ),
                    child: const Text(
                      'Confirmar pago 💸',
                      style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
